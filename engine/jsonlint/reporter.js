const template = module.exports = {
    run: function(onFinish) {
        process.stdin.resume();
        process.stdin.setEncoding("utf8");

        let lingeringLine = "";
        let lines = [];
        
        process.stdin.on("data", function(chunk) {
            let linesParsed = chunk.split('\n');
            linesParsed[0] = lingeringLine + linesParsed[0];
            lingeringLine = linesParsed.pop();
            linesParsed.forEach((line) => {
                if (line !== null) {
                    lines.push(line);
                }
            });
        });

        process.stdin.on("end", function() {
            onFinish(lines);
        });
      
    },
};

const reporter = module.exports = {
    run: function(regex, convertMatch) {
        let results = [];

         /**
         * Generates standard model form each line
         * @param {*} line Line to parse
         */
        function processLine(line) {
            //console.log(line);
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

        template.run(function(lines) {
            lines.forEach(processLine);
            console.log(JSON.stringify(results));
        });
    },
};
let regex = /(.*): line ([0-9]+), col ([0-9]+), (.*)/g;

reporter.run(regex, function(match) {
    return {
        path: match[1].trim(),
        message: {
            message: match[4],
            severity: "warning",
            line: match[2] - 1,
            lineEnd: match[2] - 1,
            column: match[3] - 1
        },
    };
});
