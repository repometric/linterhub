#!/bin/bash
#set -e

source bin/colors.sh
echo "${COL_BLUE}TRACE: Start $0${COL_RESET}"
echo "${COL_BLUE}TRACE: $@${COL_RESET}"

# Constants
Version="0.4"
Prefix="rm"
Start="/bin/sh"
Workdir="/shared"
# Script
Engine="bin/engine.sh"
Storage="bin/storage.sh"
Check="bin/check.sh"

main() {
    # Mode
    if [ -z "$Mode" ]; then
        Mode=$1
    fi
    case $Mode in
        # Storage commands
        -sb|storage:build)    sh $Storage \
                                --mode build \
                                --instance $Volume \
                                --dockshare $DockShare \
                                --hostshare $HostShare \
                                --path "$Path" \
                              ;;
        -sd|storage:destroy)  sh $Storage \
                                --mode destroy \
                                --instance $Volume \
                                --dockshare $DockShare \
                                --hostshare $HostShare \
                              ;;
        # Engine commands
        -eb|engine:build)     sh $Engine \
                                --mode build \
                                --image $Image \
                                --dock $Dock \
                                --workdir "$Workdir" \
                              ;;
        -ea|engine:analyze)   sh $Engine \
                                --mode analyze \
                                --image $Image \
                                --instance $Instance \
                                --share $Volume \
                                --command "$Command" \
                                --output "$Output" \
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
                                --share $Volume \
                                --start $Start \
                              ;;
        -ee|engine:exec)      sh $Engine \
                                --mode exec \
                                --instance $Instance \
                                --command "$Command" \
                              ;;
        -ed|engine:destroy)   sh $Engine \
                                --mode destroy \
                                --instance $Instance \
                              ;;
        # General commands
        -a|analyze)           analyze;;
        -c|check)             sh $Check;;
        -v|--version|version) echo $Version;;
        -h|--help|help|?|-?)  cat docs/usage.md;;
        *)                    echo "${COL_RED}Unknown command. Try '$0 -help'${COL_RESET}";;
    esac
}

function parse_args() {
    # VM
    Volume="$Prefix-storage-instance"
    HostShare="HOST_SHARE"
    DockShare="/DOCKER_SHARE"
    while [[ $# -gt 1 ]] 
    do
        key="$1"
        case $key in
            --mode)      Mode="$2";;
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
            --clean)     Clean="true";;
            --session)   Session="true";;
            *)           echo "${COL_RED}ERROR: Unknown command $1${COL_RESET}"
        esac
        shift
        shift
    done
}

# General functions
function analyze()
{
    if [ -n "$Session" ]; then
        # Storage session
        Session=$RANDOM
        # Not cross platform - Session=$(date +%s|md5|base64|head -c 8)
        Volume="$Prefix-storage-instance-$Session"
        HostShare="HOST_SHARE_$Session"
        DockShare="/DOCKER_SHARE_$Session"
    fi
    if [ -n "$Clean" ] || [ -n "$Session" ] ; then
        # Storage build
        Mode="storage:build"
        main
    fi
    # Linters
    IFS='+' read -ra linters <<< "$Name"
    for linterPart in "${linters[@]}"; do
        IFS=':' read -ra linter <<< "$linterPart"
        # Linter session
        Name=${linter[0]}
        Dock="dockers/alpine/$Name/Dockerfile"
        Image="$Prefix-$Name-image"
        Instance="$Prefix-$Name-instance-$Session"
        if [ -n "$Clean" ]; then
            # Linter build
            Mode="engine:build"
            main
        fi
        # Linter analyze
        Command="${linter[1]}"
        Output="${linter[2]}"
        Mode="engine:analyze"
        main
    done
    if [ -n "$Clean" ] || [ -n "$Session" ]; then
        # Storage destroy
        Mode="storage:destroy"
        main
    fi
}

parse_args "$@"
main "$@"
exit $?