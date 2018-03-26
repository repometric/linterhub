// Title: Reformat schema files
// Usage: npm run schema-format
const fs = require('fs');
const finder = require('fs-finder');
const files = finder.from('schema').showSystemFiles().find('*.json');
const results = files.map((fileName) => {
    const content = fs.readFileSync(fileName).toString();
    const json = JSON.parse(content);
    const formatted = JSON.stringify(json, null, 4);
    console.log(`Format: ${fileName}`);
    fs.writeFileSync(fileName, formatted + '\n');
});
