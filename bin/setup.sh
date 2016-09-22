# Perform simple checks and setup

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