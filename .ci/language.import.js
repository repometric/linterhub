// Title: Convert schema with languages
// Usage: npm run language-import
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');
const listPath = 'ext/github/linguist/lib/linguist/languages.yml';
const schemaPath = 'schema/language.linguist.json'
const list = yaml.safeLoad(fs.readFileSync(listPath));
const template = 
{
    "id": "https://repometric.github.io/linterhub/schema/language.linguist.json",
    "$schema": "http://json-schema.org/draft-04/schema",
    "languages": []
};
template.languages = Object.keys(list).map(name =>
{
    let item = list[name];
    let language =
    {
        "enum": [name]
    };
    if (item.extensions && item.extensions.length) language.extensions = item.extensions;
    if (item.filenames && item.filenames.length) language.filenames = item.filenames;
    return language;
});
const formatted = JSON.stringify(template, null, 4);
fs.writeFileSync(schemaPath, formatted + '\n');
console.log(`Done! Total ${template.languages.length} languages.`);
