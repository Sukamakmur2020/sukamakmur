const fs = require('fs');
const path = require('path');

const inputFile = path.join(__dirname, 'database_backup.sql');
const content = fs.readFileSync(inputFile, 'utf-8');
const lines = content.split(/\r?\n/);

const blocks = [];
let currentHeaderInfo = null;
let currentBlockLines = [];

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  
  if (line === '--' && lines[i+1] && lines[i+1].startsWith('-- Name:') && lines[i+1].includes('Schema:') && lines[i+2] === '--') {
    // Flush current block
    blocks.push({
      header: currentHeaderInfo,
      lines: currentBlockLines
    });
    
    // Parse new header
    const headerLine = lines[i+1];
    const parts = headerLine.substring(8).split(';').map(p => p.trim());
    const info = {};
    parts.forEach(part => {
      const [key, val] = part.split(':').map(v => v ? v.trim() : '');
      if (key && val) {
        info[key.toLowerCase()] = val;
      }
    });
    
    currentHeaderInfo = info;
    currentBlockLines = [line, headerLine, lines[i+2]];
    i += 2;
  } else {
    currentBlockLines.push(line);
  }
}

blocks.push({
  header: currentHeaderInfo,
  lines: currentBlockLines
});

console.log(`Total blocks parsed: ${blocks.length}`);

// Let's analyze what will be kept and what will be discarded
const systemSchemas = ['auth', 'extensions', 'graphql', 'graphql_public', 'realtime', 'storage', 'vault', 'pgbouncer', 'pg_catalog'];

let keepCount = 0;
let discardCount = 0;

const discardReasons = {};

blocks.forEach((block, idx) => {
  if (idx === 0) {
    console.log(`Block 0 (Global Setup) - Keep (Lines: ${block.lines.length})`);
    keepCount++;
    return;
  }
  
  const header = block.header;
  if (!header) {
    keepCount++;
    return;
  }
  
  const schema = header.schema ? header.schema.toLowerCase() : '';
  const type = header.type ? header.type.toUpperCase() : '';
  const name = header.name ? header.name.toUpperCase() : '';
  
  let discard = false;
  let reason = '';
  
  if (systemSchemas.includes(schema)) {
    discard = true;
    reason = `System Schema (${schema})`;
  } else if (type === 'EVENT TRIGGER') {
    discard = true;
    reason = `Event Trigger`;
  } else if (type === 'EXTENSION') {
    discard = true;
    reason = `Extension (${name})`;
  } else if (type === 'COMMENT' && name.startsWith('EXTENSION ')) {
    discard = true;
    reason = `Comment on Extension`;
  } else if (type === 'ACL' && name.startsWith('SCHEMA ') && systemSchemas.some(s => name.includes(s.toUpperCase()))) {
    discard = true;
    reason = `ACL on System Schema`;
  }
  
  if (discard) {
    discardCount++;
    discardReasons[reason] = (discardReasons[reason] || 0) + 1;
    // Log the first few non-empty lines of the discarded block for verification
    const codeLines = block.lines.filter(l => l.trim() && !l.startsWith('--')).slice(0, 2);
    if (discardCount <= 10) {
      console.log(`Discarded block ${idx}: Reason=${reason}, Name=${header.name}, Type=${header.type}`);
      console.log(`  Sample SQL:`, codeLines);
    }
  } else {
    keepCount++;
  }
});

console.log(`\nTotals: Keep = ${keepCount}, Discard = ${discardCount}`);
console.log(`Discard reasons:`, discardReasons);
