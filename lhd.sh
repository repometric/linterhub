#!/bin/bash
# docker build -t linterhub .
docker run -i -v /var/run/docker.sock:/var/run/docker.sock linterhub /bin/bash lh.sh "$@"