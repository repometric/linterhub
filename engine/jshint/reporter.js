"use strict";
module.exports = {
	reporter(results, data, opts) {
        let files = {};
		opts = opts || {};
        results.forEach((record) => {
            let error = record.error;
            let severityString = "";
            if (!files[record.file]) {
                files[record.file] = [];
            }

            switch (error.code[0]) {
                case "I":
                    severityString = "info";
                    break;
                case "W":
                    severityString = "warning";
                    break;
                default:
                case "E":
                    severityString = "error";
                    break;
            }

            files[record.file].push({
                message: error.reason,
                severity: severityString,
                line: error.line,
                lineEnd: error.line,
                column: error.character,
                ruleId: "jshint:" + error.code,
                ruleName: error.id,
                ruleNamespace: error.scope,
            });
        });
        process.stdout.write(JSON.stringify(Object.keys(files).map(function (key) {
            return {
                path: key,
                messages: files[key],
            };
        })));
	},
};
