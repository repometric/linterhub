#!/bin/bash

set -e

source bin/lh_utils.sh

# Entry point
main () 
{
    case $Mode in
        # Engine commands
        -b|build)    engine_build;;
        -a|analyze)  engine_analyze;;
        -s|export)   engine_export;;
        -l|import)   engine_import;;
        # Engine debug commands
        -r|start)    engine_run;;
        -e|exec)     engine_exec;;
        -d|stop)     engine_destroy;;
        # Engine images
        -i|images)   engine_images;;
        -o|online)   engine_online;;
        -f|offline)  engine_offline;;
        -m|mirror)   engine_mirror;;
    esac
}

parse_args ()
{
    while [[ $# -gt 1 ]] 
    do
        key="$1"
        case $key in
            --mode)      Mode="$2";;
            --dock)      EngineDock="$2";;
            --image)     EngineImage="$2";;
            --instance)  EngineInstance="$2";;
            --path)      Path="$2";;
            --output)    Output="$2";;
            --command)   Command="$2";;
            --workdir)   Workdir="$2";;
            --share)     Share="$2";;
            --prefix)    Prefix="$2";;
            --start)     Startup="$2";;
            --log)       setLogLevel $2;;
        esac
        shift
        shift
    done
}

# Engine functions
engine_build ()
{
    log INFO "Build linter dock"
    if [ $LOG_LEVEL -le $TRACE ]; 
        then docker build --build-arg WORKDIR=$Workdir -t $EngineImage -f $EngineDock . 
        else docker build --build-arg WORKDIR=$Workdir -t $EngineImage -f $EngineDock . &>/dev/null
    fi
}

engine_analyze ()
{
    log INFO "Run analysis"
    if [ ! "$Output" ];
        then docker run -i --rm --name $EngineInstance --volumes-from=$Share $EngineImage ${Command//[\"]}
        else docker run -i --rm --name $EngineInstance --volumes-from=$Share $EngineImage ${Command//[\"]} > "$Output"
    fi
}

engine_export ()
{
    log INFO "Save dock"
    docker save $EngineImage | gzip -c
}

engine_import ()
{
    log INFO "Load dock"
    echo "ToDo"
}

# Engine debug functions
engine_run ()
{
    log INFO "Run linter dock"
    docker run -i -d --name $EngineInstance --volumes-from=$Share $EngineImage $Startup
}

engine_exec ()
{
    log INFO "Execute command in linter dock"
    docker exec -it $EngineInstance $Command
}

engine_destroy ()
{
    log INFO "Destroy linter dock"
    if [ $LOG_LEVEL -le $TRACE ]; 
        then docker rm -f $EngineInstance
        else docker rm -f $EngineInstance &>/dev/null
    fi
}

# Engine image functions
engine_images ()
{
    log INFO "Docker containers"
    docker images | grep $Prefix
}

engine_online ()
{
    log INFO "Docker online images"
    echo "docker search"
}

engine_offline ()
{
    log INFO "Docker offline images"
    ls -d dockers/alpine/*/ | cut -f3 -d'/'
}

engine_mirror ()
{
    log INFO "Docker mirror images"
    echo "ToDo"
}

parse_args "$@"
log RUN "$@"
main "$@"
exit $?