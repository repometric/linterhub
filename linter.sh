#!/bin/bash

# Arguments
Mode="$1"
Name="$2"
Path="$2"
Command="$3"
Output=""
Session=$(date +%s|md5|base64|head -c 8)
# Constants
Version="0.3"
Dockerfile="Dockerfile"
Startup="/bin/sh"
Prefix=rm
# VM
HostShare="HOST_SHARE_$Session"
DockerShare="/DOCKER_SHARE_$Session"
# Shared Variables
SharedVolume=""
SharedDock=""
SharedInstance=""
# Engine Variables
EngineDock=""
EngineImage=""
EngineInstance=""

main() {
    storage_name;
    engine_name $Name;
    # Mode
    case $Mode in
        # Storage commands
        -sb|storage:build)   storage_build;;
        -sd|storage:destroy) storage_destroy;;
        # Engine commands
        -eb|engine:build)    engine_build;;
        -ea|engine:analyze)  engine_analyze;;
        # Engine image commands
        -ei|engine:images)   engine_images;;
        -eo|engine:online)   engine_online;;
        -ef|engine:offline)  engine_offline;;
        # Engine debug commands
        -er|engine:run)      engine_run;;
        -ee|engine:exec)     engine_exec;;
        -ed|engine:destroy)  engine_destroy;;
        # General commands
        -a|analyze)          analyze;;
        -s|setup)            setup;;
        -v|-version|version) echo $Version;;
        -h|-help|help|?|-?)  usage;;
        *)                   unknown;;
    esac
}

# Storage functions
function storage_name()
{
    local Name="shared"
    SharedVolume="/shared"
    SharedDock="busybox"
    SharedInstance=$Prefix-$Name-instance
}

function storage_mount()
{
    VBoxManage sharedfolder add default --name $HostShare --hostpath $Path --transient
    docker-machine ssh default "sudo mkdir $DockerShare"
    docker-machine ssh default "sudo mount -t vboxsf $HostShare $DockerShare"
}

function storage_unmount()
{
    VBoxManage sharedfolder remove default --name $HostShare --transient
    docker-machine ssh default "sudo umount $DockerShare -v"
    docker-machine ssh default "sudo rmdir $DockerShare"
}

function storage_build()
{
    storage_mount
    docker run --name $SharedInstance -v $DockerShare:$SharedVolume $SharedDock true
}

function storage_destroy()
{
    storage_unmount
    docker rm -f $SharedInstance
}

# Engine functions
function engine_name()
{
    local Name=$1
    EngineDock=linters/alpine/$Name/$Dockerfile
    EngineImage=$Prefix-$Name-image
    EngineInstance=$Prefix-$Name-instance 
}

function engine_build()
{
    docker build --build-arg WORKDIR=$SharedVolume --no-cache=true -t $EngineImage -f $EngineDock . 
}

function engine_analyze()
{
    if [ ! "$Output" ];
        then docker run -i --rm --name $EngineInstance --volumes-from=$SharedInstance $EngineImage $Command
        else docker run -i --rm --name $EngineInstance --volumes-from=$SharedInstance $EngineImage $Command > "$Output"
    fi
}

# Engine image functions
function engine_images()
{
    docker images | grep $Prefix
}

function engine_online()
{
    # docker search
}

function engine_offline()
{
    ls -d */ | sed 's#/##'
}

# Engine debug functions
function engine_run()
{
    docker run -i -d --name $EngineInstance --volumes-from=$SharedInstance $EngineImage $Startup
}

function engine_exec()
{
    docker exec -it $EngineInstance $Command
}

function engine_destroy()
{
    docker rm -f $EngineInstance
}

# General functions
function analyze()
{
    Path="$Command"
    storage_build;
    IFS='+' read -ra linters <<< "$Name"
    for linterPart in "${linters[@]}"; do
        IFS=':' read -ra linter <<< "$linterPart"
        engine_name ${linter[0]};
        engine_build;
        Output="";
        Command=${linter[1]};
        Output=${linter[2]};
        engine_analyze;
    done
    storage_destroy;
}

function usage()
{
cat << EOF
usage: $0 options

OPTIONS:
    help                          Display a list of available commands.
    version                       Display the current version of the CLI.
    setup                         Setup current environment.
    analyze                       Perform analysis.
    ______________________________ 
    storage:build path            Build storage image with shared volume.
    storage:destroy               Destroy storage image.
    ______________________________
    engine:images                 List all built engines.
    engine:offline                List all installed engines.
    engine:online                 ToDo
    ______________________________
    engine:build name             Build engine image.
    engine:analyze name command   Analyze the shared storage volume using engine.
    ______________________________
    engine:run engine             Run engine image in interactive mode.
    engine:exec name command      Execute command in the specified running engine.
    engine:destroy name           Destroy engine instance.
EOF
}

function unknown()
{
cat << EOF
Unknown command. Try "$0 -help".
EOF
}

function setup()
{
    local isWindows=false
    echo '-- [0] Check environment --';
    command -v VBoxManage >/dev/null 2>&1 || { echo "ERROR: VirtualBox is not installed or not in the PATH." >&2; exit 1; }
    command -v docker-machine >/dev/null 2>&1 || { echo "ERROR: Docker Toolbox is not installed or not in the PATH." >&2; exit 1; }
    echo "INFO: OK."
    echo '-- [1] Docker init --'
    case "$(uname -s)" in
        Darwin)
            echo "-- [Platform] MacOS --"
            echo exit | sh "/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh";
            #open -a "Docker Quickstart Terminal" -W;  
            ;;
        Linux)
            echo "-- [Platform] Linux --"
            echo "WARNING: TODO."
            ;;
        CYGWIN*|MINGW*|MSYS*)
            isWindows=true
            echo "-- [Platform] Windows --"
            echo "WARNING: Microsoft-Hyper-V should be disabled."
            echo "WARNING: Microsoft-Windows-Subsystem-Linux should be disabled."
            echo "WARNING: GIT bash in the PATH may cause unexpected errors. Please make sure that you execute it under Cygwin bash."
            pushd "C:/Program Files/Docker Toolbox"
            echo exit | sh "C:/Program Files/Docker Toolbox/start.sh"
            popd
            ;;
        *)
            echo "-- [Platform] Unknown --" 
            exit 1
            ;;
    esac    
    
    echo '-- [2] Start machine --'
    docker-machine start default
    echo '-- [3] Set env --'
    docker-machine env
    echo '-- [4] Config shell --'
    eval $(docker-machine env default --shell bash)
}
eval $(docker-machine env default --shell bash)
main "$@"
