const fs = require('fs');
const finder = require('fs-finder');
const files = finder.findFiles('hub/**/*.json');
const results = files.map(function(fileName) {
    const content = fs.readFileSync(fileName).toString();
    const json = JSON.parse(content);
    const formatted = JSON.stringify(json, null, 4);
    console.log(`Format: ${fileName}`);
    fs.writeFileSync(fileName, formatted + '\n');
});
