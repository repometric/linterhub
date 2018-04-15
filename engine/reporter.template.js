module.exports = {
    run: function(onFinish) {
        process.stdin.resume();
        process.stdin.setEncoding('utf8');

        let lingeringLine = '';
        let lines = [];

        process.stdin.on('data', function(chunk) {
            let linesParsed = chunk.split('\n');
            linesParsed[0] = lingeringLine + linesParsed[0];
            lingeringLine = linesParsed.pop();
            linesParsed.forEach((line) => {
                if (line !== null) {
                    lines.push(line);
                }
            });
        });

        process.stdin.on('end', function() {
            onFinish(lines);
        });
    },
};
