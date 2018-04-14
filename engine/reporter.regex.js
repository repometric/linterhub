let template = require('./reporter.template');

module.exports = {
    run: function(regex, convertMatch) {
        let results = [];

        template.run(function(lines) {
            lines.forEach(processLine);
            console.log(JSON.stringify(results));
        });

        /**
         * Generates standard model form each line
         * @param {*} line Line to parse
         */
        function processLine(line) {
            let match = new RegExp(regex).exec(line);

            if (match === null) {
                return;
            }

            let objParsed = convertMatch(match);

            let obj = results.find(function(element) {
                return objParsed.path === element.path;
            });

            if (obj === undefined) {
                obj = {
                    path: objParsed.path,
                    messages: [],
                };
                results.push(obj);
            }

            obj.messages.push(objParsed.message);
        }
    },
};
