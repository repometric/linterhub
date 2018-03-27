// Title: Convert schema with licenses
// Usage: npm run license-import
const fs = require('fs');
const path = require('path');
const listPath = 'ext/spdx/license-list-data/json/licenses.json';
const list = JSON.parse(fs.readFileSync(listPath));

console.log(JSON.stringify(list, null, 4));
