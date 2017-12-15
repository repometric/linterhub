const ec = require('exit-code');
const fs = require('fs');
const path = require('path');
const finder = require('fs-finder');
const requiredFiles = ['args.json', 'deps.json', 'engine.json'];
const folders = finder.from('hub').findDirectories();
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
