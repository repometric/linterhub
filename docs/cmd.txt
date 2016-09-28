usage: linterhub.sh options

OPTIONS:
    check                         Check environment.
    analyze                       Perform analysis.
    help                          Display a list of available commands.
    version                       Display the current version of the CLI.

MODES:
    ______________________________ 
    storage:build                 Build storage image with shared volume.
    storage:destroy               Destroy storage image.
    ______________________________
    engine:images                 ToDo.
    engine:offline                ToDo.
    engine:online                 ToDo.
    ______________________________
    engine:build                  Build engine image.
    engine:analyze                Analyze the shared storage volume using engine.
    engine:save                   Save engine image.
    ______________________________
    engine:run                    Run engine image in interactive mode.
    engine:exec                   Execute command in the specified running engine.
    engine:destroy                Destroy engine instance.
    ______________________________ 

EXAMPLES:
    sh linterhub.sh --mode analyze --name eslint:"eslint *.js":output.txt --path /project/path

    Analyze all js files from --path using eslint linter and save report to output.txt
