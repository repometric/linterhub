Cmd="$1"
Path="$2"
Session="$3"
SharedInstance="rm-shared-$Session-instance"
HostShare="HOST_SHARE_$Session"
DockerShare="/DOCKER_SHARE_$Session"
# Build storage
sh storage.sh --mode build \
              --instance $SharedInstance \
              --dockshare $DockerShare \
              --hostshare $HostShare \
              --path $Path;
return 
# Enumerate array
IFS='+' read -ra linters <<< "$Cmd"
for linterPart in "${linters[@]}"; do
    IFS=':' read -ra linter <<< "$linterPart"
    Name=${linter[0]};
    # Build engine
    sh engine.sh --mode build \
                 --dock dockers/alpine/$Name/Dockerfile \
                 --image rm-$Name-$Session-image \
                 --workdir /shared;
    Command=${linter[1]};
    Output=${linter[2]};
    # Perform analysis
    sh engine.sh --mode analyze \
                 --instance rm-$Name-$Session-instance \
                 --image rm-$Name-$Session-image \
                 --share $SharedInstance \
                 --command $Command \
                 --output $Output;
done
# Destroy storage
sh storage.sh --mode destroy \
              --instance $SharedInstance \
              --dockshare $DockerShare \
              --hostshare $HostShare;