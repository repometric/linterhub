// Title: Validate schema files
// Usage: npm run schema-validate
const ec = require('exit-code');
const fs = require('fs');
const finder = require('fs-finder');
const validator = require('json-schema-remote');
const files = finder.from('schema').showSystemFiles().find('*.json');
const readSchema = (path) => JSON.parse(fs.readFileSync(path));
validator.setLoggingFunction(console.log);
const results = files.map((fileName) => {
    const schema = readSchema(fileName);
    validator.validate(schema, schema.$schema).then(() => {
        console.log(`OK: ${fileName}`);
    })
    .catch((error) => {
        console.log(`Fail: ${fileName}`);
        console.log(error.errors);
        process.exitCode = 1;
    });
});
