
**Usage:** `lh.sh args` 

**Example:**
`sh lh.sh --mode analyze --name jslint:"jslint *.js":output.txt --path /project/path --session true --clean true`

**Explanation:** 
Analyze project inside '/project/path' folder with 'jslint' engine and save results in 'output.txt' file. If output is not specified - results will be displayed in stdout. 
Container will be created from a scratch ('--clean true') and destroyed when analysis is finished ('--session true'). 
Please also note that argument 'jslint *.js' is specific for each engine and in this case it means 'execute jslint inside container and analyze all javascript files' (other words it's arguments for execution).

### Modes:
| Name            | Description                              |
| --------------- | ---------------------------------------- |
| analyze         | Perform analysis.                        |
| help            | List available commands.                 |
| help-dev        | Available commands for developers.       |
| version         | Display current version.                 |
| check           | Check environment and setup.             |
| info            | Output local configuration.              |

### Required args:
| Name            | Description                              |
| --------------- | ---------------------------------------- |
| --name FMT      | FMT: LINTER:"COMMAND":OUTPUT.            |
| --path PATH     | PATH: target file or folder.             |

### Optional args:
| Name            | Description                              |
| --------------- | ---------------------------------------- |
| --native true   | Run COMMAND locally (without container). |
| --clean true    | Build new (clean) image for LINTER.      |
| --session true  | Run COMMAND inside temporary container.  |
| --env true      | Initialize docker environment.           |
| --log LEVEL     | LEVEL: NO, TRACE, INFO, WARN, ERROR.     |

