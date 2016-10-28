# Getting started
  - **How to prepare:**
    - Install [Docker Engine] or [Docker Toolbox] + [Oracle Virtual Box].
    - It's recommented to have bash installed ([Cygwin] for Windows).
  - **How to start for developers:**
    - Clone the repository `git clone https://github.com/repometric/linterhub.git`.
    - Cd to the project directory.
    - If running linterhub in docker, exec `docker build -t linterhub .` (then use `lhd.sh` instead of `lh.sh` below).
    - Validate environment: `sh lh.sh check`.
    - Pay attention to *Warnings* and *Errors*.
    - In case of any errors: make sure that docker, virtualbox and cygwin are available from terminal. Otherwise update envinorement variable PATH with pathes to the installed software.
  - **How to start for users:**
    - Pull linterhub image from Docker Hub: `docker pull repometric/linterhub`.
  - **How to test:**
    - Optional: clone repository with tests `git clone https://github.com/repometric/linterhub-tests.git`.
    - If running linterhub in docker: download [snippet for Linux and MacOS](./../lhd.sh) or [snippet for Windows](./../lhd.bat).
    - List available commands: `sh lh.sh --help` (`lh.bat --help` for Windows)
    - Analyze the project: `sh lh.sh analyze --name "jslint":"jslint *.js" --path "/path/to/project" --session true --clean true`.
  - **How to add a new linter:**
    - Right now you need to create a new issue with: *name*, *description*, *url*, *supported languages*, *license* of linter.

   [Docker Toolbox]: <https://www.docker.com/products/docker-toolbox>
   [Docker Engine]: <https://docs.docker.com/engine/installation>
   [Oracle Virtual Box]: <https://www.virtualbox.org>
   [Cygwin]: <https://www.cygwin.com>
