source bin/colors.sh

echo "${COL_YELLOW}1. Check environment${COL_RESET}";
command -v VBoxManage >/dev/null 2>&1 || { echo "${COL_RED}ERROR: VirtualBox is not installed or not in the PATH.${COL_RESET}" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "${COL_RED}ERROR: Docker is not installed or not in the PATH.${COL_RESET}" >&2; exit 1; }
echo "${COL_YELLOW}2. Docker init${COL_RESET}"
case "$(uname -s)" in
    Darwin)
        echo "INFO: Platform MacOS"
        ;;
    Linux)
        echo "INFO: Platform Linux"
        ;;
    CYGWIN*|MINGW*|MSYS*)
        echo "INFO: Platform Windows"
        echo "WARNING: Microsoft-Hyper-V should be disabled."
        echo "WARNING: Microsoft-Windows-Subsystem-Linux should be disabled."
        echo "WARNING: GIT bash in the PATH may cause unexpected errors. Please make sure that you execute it under Cygwin bash."
        ;;
    *)
        echo "INFO: Platform Unknown"
        echo "${COL_RED}ERROR: Your OS is not supported right now.${COL_RESET}"
        exit 1
        ;;
esac

echo "${COL_GREEN}OK${COL_RESET}"