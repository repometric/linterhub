FROM debian:jessie
MAINTAINER Repometric <docker@repometric.com>
COPY . /linterhub
WORKDIR /linterhub
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
RUN find . -name "*.sh" -exec chmod +x {} \;
RUN /bin/bash