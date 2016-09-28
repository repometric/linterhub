set -e

source bin/colors.sh
echo "${COL_BLUE}TRACE: Start $0${COL_RESET}"
echo "${COL_BLUE}TRACE: $@${COL_RESET}"

# Shared Consts
SharedVolume="/shared"
SharedDock="busybox"

# Entry point
function main() {
    case $Mode in
        # Storage commands
        -b|build)   storage_build;;
        -d|destroy) storage_destroy;;
    esac
}

function parse_args() {
    while [[ $# -gt 1 ]] 
    do
        key="$1"
        case $key in
            --mode)      Mode="$2";;
            --instance)  Instance="$2";;
            --hostshare) HostShare="$2";;
            --dockshare) DockerShare="$2";;
            --path)      Path="$2";;
        esac
        shift
        shift
    done
}

# Storage functions
function storage_mount()
{
    echo "${COL_GREEN}INFO: Map host folder to VM${COL_RESET}"
    VBoxManage sharedfolder add default --name $HostShare --hostpath $Path --transient
    echo "${COL_GREEN}INFO: Create folder in VM${COL_RESET}"
    docker-machine ssh default "sudo mkdir $DockerShare"
    echo "${COL_GREEN}INFO: Mount VM folder in dock${COL_RESET}"
    docker-machine ssh default "sudo mount -t vboxsf $HostShare $DockerShare"
}

function storage_unmount()
{
    echo "${COL_GREEN}INFO: Unmount VM folder in dock${COL_RESET}"
    docker-machine ssh default "sudo umount $DockerShare -v"
    echo "${COL_GREEN}INFO: Delete folder in VM${COL_RESET}"
    docker-machine ssh default "sudo rmdir $DockerShare"
}

function storage_build()
{
    storage_mount
    echo "${COL_GREEN}INFO: Run storage dock${COL_RESET}"
    docker run --name $Instance -v $Path:$SharedVolume $SharedDock true
}

function storage_destroy()
{
    storage_unmount
    echo "${COL_GREEN}INFO: Destroy storage dock${COL_RESET}"
    docker rm -f $Instance
}

parse_args "$@"
main "$@"
exit $?