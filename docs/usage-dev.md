
**Usage:** `lh.sh args` 

### Developer modes:
| Name            | Description                              |
| --------------- | ---------------------------------------- |
| storage:build   | Build storage container.                 |
| storage:destroy | Destroy storage container.               |
| engine:build    | Build engine cointainer.                 |
| engine:analyze  | Analyze the storage using engine.        |
| engine:start    | Run engine in interactive mode.          |
| engine:exec     | Execute command inside container.        |
| engine:stop     | Stop engine container.                   |
| engine:images   | List built containers.                   |
| engine:offline  | List available configs (offline).        |
| engine:online   | List available configs (online).         |
| engine:mirror   | List pre-build containers.               |
| engine:export   | Export container.                        |
| engine:import   | Import container.                        |

### Extra args:
| Name            | Description                              |
| --------------- | ---------------------------------------- |
| --name NAME     | NAME: the name of linter.                |
| --command CMD   | CMD: command to execute in container.    |
| --start RUN     | RUN: startup command for container.      |
| --output PATH   | PATH: path for output results.           |
| --workdir WD    | WD: workdir argument for container.      |

