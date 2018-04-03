// Title: Bundle engines into one json
// Usage: npm run engine-bundle
const ec = require('exit-code');
const fs = require('fs');
const path = require('path');
const finder = require('fs-finder');
const bundlePath = 'engine/bundle.json';
const requiredFiles = ['args', 'deps', 'meta'];
const folders = finder.from('engine').findDirectories();
const bundle =
{
    "$schema": "https://repometric.github.io/linterhub/schema/bundle.json"
};
const results = folders.map((folder) => {
    const fc = (file) => fs.readFileSync(path.join(folder, file + '.json'));
    const name = path.basename(folder);
    bundle[name] = {};
    requiredFiles.forEach((file) => {
        bundle[name][file] = JSON.parse(fc(file));
    });
});
const formatted = JSON.stringify(bundle, null, 4);
fs.writeFileSync(bundlePath, formatted + '\n');
console.log(`Done! Total ${Object.keys(bundle).length - 1} engines.`);
