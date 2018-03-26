// Title: Validate engine files
// Usage: npm run engine-validate
const ec = require('exit-code');
const fs = require('fs');
const path = require('path');
const finder = require('fs-finder');
const requiredFiles = ['args.json', 'deps.json', 'meta.json'];
const folders = finder.from('engine').findDirectories();
const results = folders.map((folder) => {
    const ex = (file) => fs.existsSync(path.join(folder, file));
    console.log(`Check: ${folder}`);
    requiredFiles.forEach((file) => {
        if (!ex(file)) {
            console.log(`Missing: ${file}`);
            process.exitCode = 1;
        }
    });
});
