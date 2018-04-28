module.exports = class Reporter

    constructor: (@errorReport, options = {}) ->
        { @quiet } = options

    print: (message) ->
        # coffeelint: disable=no_debugger
        console.log message
        # coffeelint: enable=no_debugger

    publish: () ->
        filesResult = []
        for path, errors of @errorReport.paths
            fileResult = {
                path: path
                messages: []
            }
            for e in errors when not @quiet or e.level is 'error'
                fileResult.messages.push({
                    message: e.message
                    description: e.description
                    severity: if e.level == 'warn' then 'warning' else if e.level == 'ignore' then 'hint' else e.level
                    context: e.context
                    source: e.line
                    line: e.lineNumber - 1,
                    lineEnd: if e.lineNumberEnd then e.lineNumberEnd - 1 else e.lineNumber - 1
                    column: 0,
                    ruleName: e.name,
                    ruleNamespace: e.rule
                })
            if Object.keys(fileResult.messages).length > 0
                filesResult.push(fileResult)

        @print JSON.stringify(filesResult, undefined, 0)
