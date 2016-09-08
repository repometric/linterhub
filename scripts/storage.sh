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
    docker run --name $Instance -v $DockerShare:$SharedVolume $SharedDock true
}

function storage_destroy()
{
    storage_unmount
    docker rm -f $Instance
}

parse_args "$@"
main "$@"