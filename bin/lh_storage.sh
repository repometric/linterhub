set -e

source bin/lh_utils.sh

log START "$@"

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
    log INFO "Map host folder to VM"
    VBoxManage sharedfolder add default --name $HostShare --hostpath $Path --transient
    log INFO "Create folder in VM"
    docker-machine ssh default "sudo mkdir $DockerShare"
    log INFO "Mount VM folder in dock"
    docker-machine ssh default "sudo mount -t vboxsf $HostShare $DockerShare"
}

function storage_unmount()
{
    log INFO "Unmount VM folder in dock"
    docker-machine ssh default "sudo umount $DockerShare -v"
    log INFO "INFO: Delete folder in VM"
    docker-machine ssh default "sudo rmdir $DockerShare"
}

function storage_build()
{
    storage_mount
    log INFO "Run storage dock"
	Folder=$Path
	if docker info | grep -q "provider=virtualbox"; then 
		log INFO "Use VirtualBox driver"
		Folder=$DockerShare
	fi
    docker run --name $Instance -v $Folder:$SharedVolume $SharedDock true
}

function storage_destroy()
{
    storage_unmount
    log INFO "Destroy storage dock"
    docker rm -f $Instance
}

parse_args "$@"
main "$@"
exit $?