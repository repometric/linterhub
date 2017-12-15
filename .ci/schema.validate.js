const ec = require('exit-code');
const cp = require('child_process');
const finder = require('fs-finder');
const files = finder.from('hub').showSystemFiles().find('*.json');
const results = files.map((fileName) => {
    const result = cp.spawnSync(`z-schema`, [`${fileName}`]);
    console.log(`Validate: ${fileName}`);
    if (result.status) {
        console.log(`Fail`);
        console.log(result.stderr.toString() + result.output.toString());
        process.exitCode = 1;
    } else {
        console.log(`Ok`);
    }
});
