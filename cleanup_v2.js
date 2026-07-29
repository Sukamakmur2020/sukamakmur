const fs = require('fs');
const path = require('path');

const inputFile = path.join(__dirname, 'database_backup.sql');
const outputFile = path.join(__dirname, 'database_backup_cleaned.sql');

if (!fs.existsSync(inputFile)) {
  console.error(`Input file not found at: ${inputFile}`);
  process.exit(1);
}

console.log(`Reading: ${inputFile}`);
const content = fs.readFileSync(inputFile, 'utf-8');
const lines = content.split(/\r?\n/);
console.log(`Total lines read: ${lines.length}`);

// Step 1: Parse the SQL file into blocks based on pg_dump object comment headers
const blocks = [];
let currentHeaderInfo = null;
let currentBlockLines = [];

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  
  // A pg_dump block header can start with '-- Name:' or '-- Data for Name:'
  if (line === '--' && lines[i+1] && /^-- (Data for )?Name:/i.test(lines[i+1]) && lines[i+1].includes('Schema:') && lines[i+2] === '--') {
    // Flush current block
    blocks.push({
      header: currentHeaderInfo,
      lines: currentBlockLines
    });
    
    // Parse new header
    const headerLine = lines[i+1];
    const cleanLine = headerLine.replace(/^--\s*(Data for\s+)?/, '');
    const parts = cleanLine.split(';').map(p => p.trim());
    const info = {};
    parts.forEach(part => {
      const idx = part.indexOf(':');
      if (idx !== -1) {
        const key = part.substring(0, idx).trim().toLowerCase();
        const val = part.substring(idx + 1).trim();
        info[key] = val;
      }
    });
    
    currentHeaderInfo = info;
    currentBlockLines = [line, headerLine, lines[i+2]];
    i += 2; // Skip the next two header lines
  } else {
    currentBlockLines.push(line);
  }
}

// Push the final block
blocks.push({
  header: currentHeaderInfo,
  lines: currentBlockLines
});

console.log(`Total blocks parsed: ${blocks.length}`);

// Step 2: Process blocks according to cleanup rules
const systemSchemas = ['auth', 'extensions', 'graphql', 'graphql_public', 'realtime', 'storage', 'vault', 'pgbouncer', 'pg_catalog'];

// Regular expressions for cleanups inside kept blocks
const alterSchemaOwnerRegex = new RegExp(`ALTER\\s+SCHEMA\\s+("?)(${systemSchemas.join('|')})\\1\\s+OWNER`, 'i');
const restrictRegex = /\\(restrict|unrestrict)\s+qLcUzqPaSElUwf4qFsuc43J3AipDBVIefDDwOp01qhTPJgjWJGkgmptv4kxlM9J/i;
const createSchemaGeneralRegex = /^\s*CREATE\s+SCHEMA\s+(?!IF\s+NOT\s+EXISTS)/i;

const finalLines = [];
let stats = {
  discardedBlocks: 0,
  commentedSchemaBlocks: 0,
  keptBlocks: 0,
  deletedLinesRule2: 0,
  deletedLinesRule3: 0,
  replacedSchemaRule4: 0
};

const discardBreakdown = {};

blocks.forEach((block, idx) => {
  if (idx === 0) {
    // Global Setup lines at the top of the file - always keep but clean lines
    const cleaned = [];
    block.lines.forEach(line => {
      if (restrictRegex.test(line)) {
        stats.deletedLinesRule3++;
        console.log(`[Rule 3] Deleted restrict line from Global Setup: ${line}`);
      } else {
        cleaned.push(line);
      }
    });
    finalLines.push(...cleaned);
    stats.keptBlocks++;
    return;
  }
  
  const header = block.header;
  if (!header) {
    // Blocks without metadata headers (e.g. at the end of the file) - keep but clean lines
    const cleaned = [];
    block.lines.forEach(line => {
      if (restrictRegex.test(line)) {
        stats.deletedLinesRule3++;
        console.log(`[Rule 3] Deleted unrestrict line from end block: ${line}`);
      } else {
        cleaned.push(line);
      }
    });
    finalLines.push(...cleaned);
    stats.keptBlocks++;
    return;
  }
  
  const schema = header.schema ? header.schema.toLowerCase() : '';
  const type = header.type ? header.type.toUpperCase() : '';
  const name = header.name ? header.name : '';
  
  // Rule 1: Comment OUT the schema creation block if it's a system schema
  if (type === 'SCHEMA' && systemSchemas.includes(name.toLowerCase())) {
    stats.commentedSchemaBlocks++;
    // Comment out all lines of this block
    const commented = block.lines.map(line => {
      if (line.trim().startsWith('--') || line.trim() === '') {
        return line; // keep existing comments and empty lines as they are
      }
      return '-- ' + line;
    });
    finalLines.push(...commented);
    console.log(`[Rule 1] Commented out CREATE SCHEMA block for: ${name}`);
    return;
  }
  
  // Decide whether to discard the block entirely
  let discard = false;
  let discardReason = '';
  
  if (systemSchemas.includes(schema)) {
    discard = true;
    discardReason = `Object in System Schema (${schema})`;
  } else if (type === 'EVENT TRIGGER') {
    discard = true;
    discardReason = `Event Trigger (${name})`;
  } else if (type === 'EXTENSION') {
    discard = true;
    discardReason = `Extension (${name})`;
  } else if (type === 'COMMENT' && name.toUpperCase().startsWith('EXTENSION ')) {
    discard = true;
    discardReason = `Comment on Extension (${name})`;
  } else if (type === 'PUBLICATION') {
    discard = true;
    discardReason = `Publication (${name})`;
  } else if (type === 'ACL' && name.toUpperCase().startsWith('SCHEMA ') && systemSchemas.some(s => name.toUpperCase().includes(s.toUpperCase()))) {
    discard = true;
    discardReason = `ACL on System Schema (${name})`;
  }
  
  if (discard) {
    stats.discardedBlocks++;
    discardBreakdown[discardReason] = (discardBreakdown[discardReason] || 0) + 1;
    return;
  }
  
  // Keep the block but process individual lines for Rule 2, 3, and 4
  stats.keptBlocks++;
  const cleaned = [];
  
  block.lines.forEach(line => {
    // Rule 3: Delete restrict/unrestrict
    if (restrictRegex.test(line)) {
      stats.deletedLinesRule3++;
      console.log(`[Rule 3] Deleted line: ${line}`);
      return;
    }
    
    // Rule 2: Delete ALTER SCHEMA <schema> OWNER
    if (alterSchemaOwnerRegex.test(line)) {
      stats.deletedLinesRule2++;
      console.log(`[Rule 2] Deleted line: ${line}`);
      return;
    }
    
    // Rule 4: Replace CREATE SCHEMA with CREATE SCHEMA IF NOT EXISTS
    if (createSchemaGeneralRegex.test(line)) {
      stats.replacedSchemaRule4++;
      const newLine = line.replace(/CREATE\s+SCHEMA/i, 'CREATE SCHEMA IF NOT EXISTS');
      console.log(`[Rule 4] Replaced line: "${line}" -> "${newLine}"`);
      cleaned.push(newLine);
      return;
    }
    
    cleaned.push(line);
  });
  
  finalLines.push(...cleaned);
});

console.log(`\nProcessing Stats:`);
console.log(`- Kept Blocks: ${stats.keptBlocks}`);
console.log(`- Commented Schema Blocks (Rule 1): ${stats.commentedSchemaBlocks}`);
console.log(`- Discarded Blocks (System objects/configs): ${stats.discardedBlocks}`);
console.log(`- Deleted Lines (Rule 2 Owner alter): ${stats.deletedLinesRule2}`);
console.log(`- Deleted Lines (Rule 3 Restrict/unrestrict): ${stats.deletedLinesRule3}`);
console.log(`- Replaced CREATE SCHEMA (Rule 4): ${stats.replacedSchemaRule4}`);

console.log(`\nDiscard Breakdown:`);
console.log(JSON.stringify(discardBreakdown, null, 2));

// Step 3: Write cleaned SQL to file
fs.writeFileSync(outputFile, finalLines.join('\n'), 'utf-8');
console.log(`\nCleaned SQL written to: ${outputFile}`);
