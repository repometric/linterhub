
Usage: `linterhub.sh args` 

Example:
`sh linterhub.sh --mode analyze --name jslint:"jslint *.js":output.txt --path /project/path --session true --clean true`

Explanation: 
Analyze project inside '/project/path' folder with 'jslint' engine and save results in 'output.txt' file. 
Container will be created from a scratch ('--clean true') and destroyed when analysis is finished ('--session true'). 
Please also note that argument 'jslint *.js' is specific for each engine and in this case it means 'execute jslint inside container and analyze all javascript files' (other words it's arguments for execution).

### Modes:
| Name            | Description                        |
| --------------- | ---------------------------------- |
| analyze         | Perform analysis.                  |
| help            | List available commands.           |
| version         | Display current version.           |
| check           | Check environment and setup.       |

### Developer modes:
| Name            | Description                        |
| --------------- | ---------------------------------- |
| storage:build   | Build storage container.           |
| storage:destroy | Destroy storage container.         |
| engine:images   | List built containers.             |
| engine:offline  | List available configs (offline).  |
| engine:online   | List available configs (online).   |
| engine:mirror   | List pre-build mirrors.            |
| engine:build    | Build engine cointainer.           |
| engine:analyze  | Analyze the storage using engine.  |
| engine:save     | Export container.                  |
| engine:load     | Import container.                  |
| engine:start    | Run container in interactive mode. |
| engine:exec     | Execute command inside container.  |
| engine:stop     | Stop engine container.             |

