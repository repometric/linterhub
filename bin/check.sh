set -e
source bin/colors.sh

echo "${COL_GREEN}INFO: Check environment${COL_RESET}";
command -v VBoxManage >/dev/null 2>&1 || { echo "${COL_RED}ERROR: VirtualBox is not installed or not in the PATH.${COL_RESET}" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "${COL_RED}ERROR: Docker is not installed or not in the PATH.${COL_RESET}" >&2; exit 1; }
echo "${COL_GREEN}INFO: Docker init${COL_RESET}"
case "$(uname -s)" in
    Darwin)
        echo "${COL_GREEN}INFO: Platform MacOS${COL_RESET}"
        ;;
    Linux)
        echo "${COL_GREEN}INFO: Platform Linux${COL_RESET}"
        ;;
    CYGWIN*|MINGW*|MSYS*)
        echo "${COL_GREEN}INFO: Platform Windows${COL_RESET}"
        echo "${COL_YELLOW}WARNING: Microsoft-Hyper-V should be disabled.${COL_RESET}"
        echo "${COL_YELLOW}WARNING: Microsoft-Windows-Subsystem-Linux should be disabled.${COL_RESET}"
        echo "${COL_YELLOW}WARNING: GIT bash in the PATH may cause unexpected errors. Please make sure that you execute it under Cygwin bash.${COL_RESET}"
        ;;
    *)
        echo "${COL_GREEN}INFO: Platform Unknown${COL_RESET}"
        echo "${COL_RED}ERROR: Your OS is not supported right now.${COL_RESET}"
        exit 1
        ;;
esac

echo "${COL_GREEN}INFO: OK${COL_RESET}"