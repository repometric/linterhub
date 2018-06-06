
const template = module.exports = {
    run: (onFinish) => {
        process.stdin.resume();
        process.stdin.setEncoding("utf8");

        var lingeringLine = "";
        var lines = [];

        process.stdin.on("data", (chunk) => {
            let linesParsed = chunk.split("\n");
            linesParsed[0] = lingeringLine + linesParsed[0];
            lingeringLine = linesParsed.pop();
            linesParsed.forEach((line) => {
                if (line !== null) {
                    lines.push(line);
                }
            });
        });

        process.stdin.on("end", () => {
            onFinish(lines);
        });
    },
};

const regex = /(.*): line ([0-9]+), col ([0-9]+), (.*) - (.*) \((.*)\)/g;

const reporter = module.exports = {
    run: (regex, convertMatch) => {

        const results = [];

        /**
         * Generates standard model form each line
         * @param {*} line Line to parse
         */
        function processLine(line) {
            const match = new RegExp(regex).exec(line);

            if (match === null) {
                return;
            }

            const objParsed = convertMatch(match);

            let obj = results.find((element) => {
                return objParsed.path === element.path;
            });

            if (obj === "undefined") {
                obj = {
                    path: objParsed.path,
                    messages: [],
                };
                results.push(obj);
            }

            obj.messages.push(objParsed.message);
        }

        template.run((lines) => {
            lines.forEach(processLine);
            console.log(JSON.stringify(results));
        });
    },
};

reporter.run(regex, (match) => {
    return {
        path: match[1],
        message: {
            message: match[5],
            severity: match[4].toLowerCase(),
            line: match[2],
            lineEnd: match[2],
            column: match[3],
            ruleName: match[6],
        },
    };
});
