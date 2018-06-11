const template = module.exports = {
    run: (onFinish) => {
        process.stdin.resume();
        process.stdin.setEncoding("utf8");

        let lingeringLine = "";
        let lines = [];

        process.stdin.on("data", (chunk) => {
            var linesParsed = chunk.split("\n");
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

const parseLines = module.exports = {
    run: (lines) => {
        const jsonLines = JSON.parse(lines);
        const result = jsonLines.map((current, index) => {
            if (typeof current === "string" && current !== null){
                return {
                    path: current,
                    messages: jsonLines[index + 1].map((problem) => {
                        if (problem !== null) {
                            return {
                                message: problem.reason,
                                severity: problem.id === "(error)" ? "error" : "warning",
                                source: problem.evidence === "undefined" ? "" : problem.evidence,
                                line: problem.line - 1,
                                lineEnd: problem.line - 1,
                                column: problem.character - 1,
                                ruleId: problem.code,
                            };
                        }
                    }),
                };
            }
           
        });
        return JSON.stringify(result, "", "   ");
    }
};

template.run((lines) => {
    const result = parseLines.run(lines);
    console.log(result);
});
