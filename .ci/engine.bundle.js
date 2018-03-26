// Title: Bundle engine data
// Usage: npm run engine-bundle
const ec = require('exit-code');
const fs = require('fs');
const path = require('path');
const finder = require('fs-finder');
const requiredFiles = ['args', 'deps', 'meta'];
const folders = finder.from('engine').findDirectories();
const bundle = {};
const results = folders.map((folder) => {
    const fc = (file) => fs.readFileSync(path.join(folder, file + '.json'));
    bundle[path.dirname(folder)] = {};
    requiredFiles.forEach((file) => {
        bundle[path.dirname(folder)][file] = fc(file);
    });
});
console.log(JSON.stringify(bundle));
