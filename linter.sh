#!/bin/bash

# Constants
Version="0.3"
Prefix="rm"
Start="/bin/sh"
# Script
Engine="scripts/engine.sh"
Storage="scripts/storage.sh"

main() {
    # Mode
    case $Mode in
        # Storage commands
        -sb|storage:build)    sh $Storage \
                                --mode build \
                                --instance $Storage \
                                --dockshare $DockShare \
                                --hostshare $HostShare \
                                --path $Path \
                              ;;
        -sd|storage:destroy)  sh $Storage \
                                --mode destroy \
                                --instance $Storage \
                                --dockshare $DockShare \
                                --hostshare $HostShare \
                              ;;
        # Engine commands
        -eb|engine:build)     sh $Engine \
                                --mode build \
                                --image $Image \
                                --dock $Dock \
                                --workdir $Workdir \
                              ;;
        -ea|engine:analyze)   sh $Engine \
                                --mode analyze \
                                --image $Image \
                                --instance $Instance \
                                --share $Storage \
                                --command $Command \
                                --output $Output \
                              ;;
        -es|engine:export)    sh $Engine \
                                --mode export \
                                --image $Image \
                              ;;
        # Engine image commands
        -ei|engine:images)    echo "TODO";;
        -eo|engine:online)    echo "TODO";;
        -ef|engine:offline)   echo "TODO";;
        # Engine debug commands
        -er|engine:run)       sh $Engine \
                                --mode run \
                                --image $Image \
                                --instance $Instance \
                                --share rm-Storage \
                                --start $Start \
                              ;;
        -ee|engine:exec)      sh $Engine \
                                --mode exec \
                                --instance $Instance \
                                --command $Command \
                              ;;
        -ed|engine:destroy)   sh $Engine \
                                --mode destroy \
                                --instance $Instance \
                              ;;
        # General commands
        -a|analyze)           analyze;;
        -s|setup)             sh scripts/setup.sh;;
        -v|--version|version) echo $Version;;
        -h|--help|help|?|-?)  usage;;
        *)                    echo Unknown command. Try "$0 -help".;;
    esac
}

function parse_args() {
    # VM
    Storage="$Prefix-storage-instance"
    HostShare="HOST_SHARE_$Session"
    DockShare="/DOCKER_SHARE_$Session"
    Session=$(date +%s|md5|base64|head -c 8)
    while [[ $# -gt 1 ]] 
    do
        key="$1"
        case $key in
            --name)      Name="$2"
                         Dock="dockers/alpine/$Name/Dockerfile"
                         Image="$Prefix-$Name-image"
                         Instance="$Prefix-$Name-instance"
                         ;;
            --command)   Command="$2";;
            --start)     Start="$2";;
            --share)     Share="$2";;
            --output)    Output="$2";;
            --workdir)   Workdir="$2";;
            --path)      Path="$2";;
        esac
        shift
        shift
    done
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
    engine:save name              Save engine image.
    ______________________________
    engine:run engine             Run engine image in interactive mode.
    engine:exec name command      Execute command in the specified running engine.
    engine:destroy name           Destroy engine instance.
EOF
}

eval $(docker-machine env default --shell bash)

parse_args "$@"
main "$@"