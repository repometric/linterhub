const template = module.exports = {
    run: (onFinish) => {
        process.stdin.resume();
        process.stdin.setEncoding("utf8");

        let lingeringLine = "";
        let lines = [];

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

const parseLines = module.exports = {
    run: (lines) => {
        const jsonLines = JSON.parse(lines);
        const result = jsonLines.map((current) => {
            return {
                path: current.file,
                messages: current.messages.map((problem) => {
                    return {
                        message: problem.message,
                        severity: problem.type,
                        source: problem.evidence.trim(),
                        line: problem.line - 1,
                        lineEnd: problem.line - 1,
                        column: problem.col - 1,
                        ruleId: problem.rule.id,
                    };
                }),
            };
        });
        return JSON.stringify(result, "", "   ");
    }
};

template.run((lines) => {
    const result = parseLines.run(lines);
    console.log(result);
});
