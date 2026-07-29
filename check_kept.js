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
  
  if (line === '--' && lines[i+1] && /^-- (Data for )?Name:/i.test(lines[i+1]) && lines[i+1].includes('Schema:') && lines[i+2] === '--') {
    blocks.push({
      header: currentHeaderInfo,
      lines: currentBlockLines
    });
    
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
    i += 2;
  } else {
    currentBlockLines.push(line);
  }
}

blocks.push({
  header: currentHeaderInfo,
  lines: currentBlockLines
});

console.log("Kept Blocks:");
blocks.forEach((block, idx) => {
  if (idx === 0) return;
  const header = block.header;
  if (!header) return;
  
  const schema = header.schema ? header.schema.toLowerCase() : '';
  const type = header.type ? header.type.toUpperCase() : '';
  const name = header.name ? header.name : '';
  
  const systemSchemas = ['auth', 'extensions', 'graphql', 'graphql_public', 'realtime', 'storage', 'vault', 'pgbouncer', 'pg_catalog'];
  
  let discard = false;
  if (systemSchemas.includes(schema)) discard = true;
  else if (type === 'EVENT TRIGGER') discard = true;
  else if (type === 'EXTENSION') discard = true;
  else if (type === 'COMMENT' && name.toUpperCase().startsWith('EXTENSION ')) discard = true;
  else if (type === 'ACL' && name.toUpperCase().startsWith('SCHEMA ') && systemSchemas.some(s => name.toUpperCase().includes(s.toUpperCase()))) discard = true;
  
  if (!discard) {
    console.log(`Keep block ${idx}: Name="${name}", Type="${type}", Schema="${schema}", Lines=${block.lines.length}`);
  }
});
