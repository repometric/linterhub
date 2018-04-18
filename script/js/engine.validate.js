// Title: Validate engine files
// Usage: npm run engine-validate
const ec = require('exit-code');
const fs = require('fs');
const path = require('path');
const finder = require('fs-finder');
const validator = require('json-schema-remote');
const requiredFiles = ['args.json', 'deps.json', 'meta.json'];
const folders = finder.from('engine').findDirectories();
const readSchema = (path) => JSON.parse(fs.readFileSync(path));
const validate = (fileName) => {
    const schema = readSchema(fileName);
    validator.validate(schema, schema.$schema).then(() => {
        console.log(`OK: ${fileName}`);
    })
    .catch((error) => {
        console.log(`Fail: ${fileName}`);
        console.log(error.errors || error);
        process.exitCode = 1;
    });
};
validator.preload(readSchema('schema/args.json'));
validator.preload(readSchema('schema/deps.json'));
validator.preload(readSchema('schema/language.json'));
validator.preload(readSchema('schema/language.custom.json'));
validator.preload(readSchema('schema/language.linguist.json'));
validator.preload(readSchema('schema/license.json'));
validator.preload(readSchema('schema/platform.json'));
validator.preload(readSchema('schema/meta.json'));
validator.preload(readSchema('schema/bundle.json'));
const results = folders.map((folder) => {
    const ex = (file) => fs.existsSync(path.join(folder, file));
    console.log(`Check: ${folder}`);
    requiredFiles.forEach((file) => {
        if (!ex(file)) {
            console.log(`Missing: ${file}`);
            process.exitCode = 1;
        }
        validate(path.join(folder, file));
    });
});


