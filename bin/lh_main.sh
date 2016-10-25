#!/bin/bash
# Disable "set -e" because some linters returns non 0 result

source bin/lh_utils.sh

# Constants
Version="0.6"
Prefix="rm"
Start="/bin/sh"
Workdir="/shared"

# Scripts
Engine="bin/lh_engine.sh"
Storage="bin/lh_storage.sh"
Check="bin/lh_check.sh"

main() {
    # Mode
    if [ -z "$Mode" ]; then
        Mode=$1
    fi
	if [ -n "$Env" ]; then
	    log INFO "Configure environment"
        eval $(docker-machine.exe env --shell sh)
		# Do it once per instance
		Env=
	fi
    case $Mode in
        # Storage commands
        -sb|storage:build)    sh $Storage \
                                --mode build \
                                --instance $Volume \
                                --dockshare $DockShare \
                                --hostshare $HostShare \
                                --path "$Path" \
                                --log $LOG_LEVEL \
                              ;;
        -sd|storage:destroy)  sh $Storage \
                                --mode destroy \
                                --instance $Volume \
                                --dockshare $DockShare \
                                --hostshare $HostShare \
                                --log $LOG_LEVEL \
                              ;;
        # Engine commands
        -eb|engine:build)     sh $Engine \
                                --mode build \
                                --image $Image \
                                --dock $Dock \
                                --workdir "$Workdir" \
                                --log $LOG_LEVEL \
                              ;;
        -ea|engine:analyze)   sh $Engine \
                                --mode analyze \
                                --image $Image \
                                --instance $Instance \
                                --share $Volume \
                                --command "$Command" \
                                --output "$Output" \
                                --log $LOG_LEVEL \
                              ;;
        -es|engine:export)    sh $Engine \
                                --mode export \
                                --image $Image \
                                --log $LOG_LEVEL \
                              ;;
        -es|engine:import)    sh $Engine \
                                --mode import \
                                --image $Image \
                                --log $LOG_LEVEL \
                              ;;
        # Engine image commands
        -ei|engine:images)    sh $Engine \
                                --mode images \
                                --prefix $Prefix \
                                --log $LOG_LEVEL \
                              ;;
        -eo|engine:online)    sh $Engine \
                                --mode online \
                                --log $LOG_LEVEL \
                              ;;
        -ef|engine:offline)   sh $Engine \
                                --mode offline \
                                --log $LOG_LEVEL \
                              ;;
        -ef|engine:mirror)    sh $Engine \
                                --mode mirror \
                                --log $LOG_LEVEL \
                              ;;
        # Engine debug commands
        -er|engine:start)     sh $Engine \
                                --mode start \
                                --image $Image \
                                --instance $Instance \
                                --share $Volume \
                                --start $Start \
                                --log $LOG_LEVEL \
                              ;;
        -ee|engine:exec)      sh $Engine \
                                --mode exec \
                                --instance $Instance \
                                --command "$Command" \
                                --log $LOG_LEVEL \
                              ;;
        -ed|engine:stop)      sh $Engine \
                                --mode stop \
                                --instance $Instance \
                                --log $LOG_LEVEL \
                              ;;
        # General commands
        -a|analyze)           analyze;;
        -c|check)             sh $Check;;
        -v|--version|version) echo $Version;;
        -h|--help|help|?|-?)  cat docs/usage.md;;
        *)                    log ERROR "Unknown command. Try '$0 -help'";;
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
            --native)    Native="true";;
			--env)       Env="true";;
            --log)       setLogLevel $2;;
            *)           log ERROR "Unknown command $1"
        esac
        shift
        shift
    done
}

# General functions
function analyze()
{
    if [ -n "$Native" ]; then
        log INFO "Native mode"
        Current=$PWD
        cd $Path
        IFS='+' read -ra linters <<< "$Name"
        for linterPart in "${linters[@]}"; do
            IFS=':' read -ra linter <<< "$linterPart"
            Name=${linter[0]}
            Command="\"${linter[1]}"\"
            Output="${linter[2]}"
            log INFO "Run analysis"
            if [ ! "$Output" ];
                then ${Command//[\"]}
                else ${Command//[\"]} > "$Current/$Output"
            fi
        done
        cd $Current
        return 0
    fi
    if [ -n "$Session" ]; then
        # Storage session
        Session=$RANDOM
        # Not cross platform - Session=$(date +%s|md5|base64|head -c 8)
        Volume="$Prefix-storage-instance-$Session"
        HostShare="HOST_SHARE_$Session"
        DockShare="/DOCKER_SHARE_$Session"
    fi
    if [ -n "$Clean" ] || [ -n "$Session" ]; then
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
        Command="\"${linter[1]}"\"
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
log RUN "$@"
main "$@"
exit $?