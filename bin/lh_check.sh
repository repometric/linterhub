#!/bin/bash

set -e
source bin/lh_utils.sh

log INFO "Check environment"
command -v VBoxManage >/dev/null 2>&1 || { log ERROR "VirtualBox is not installed or not in the PATH." >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { log ERROR "Docker is not installed or not in the PATH." >&2; exit 1; }
log INFO "Docker init"
case "$(uname -s)" in
    Darwin)
        log INFO "Platform MacOS"
        ;;
    Linux)
        log INFO "Platform Linux"
        ;;
    CYGWIN*|MINGW*|MSYS*)
        log INFO "Platform Windows"
        log WARN "Microsoft-Hyper-V should be disabled."
        log WARN "Microsoft-Windows-Subsystem-Linux should be disabled."
        log WARN "GIT bash in the PATH may cause unexpected errors. Please make sure that you execute it under Cygwin bash."
        ;;
    *)
        log INFO "Platform Unknown"
        log ERROR "Your OS is not supported right now."
        exit 1
        ;;
esac

log INFO "OK"