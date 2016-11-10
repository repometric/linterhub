FROM openjdk:8-jre-alpine
MAINTAINER Repometric <docker@repometric.com>
ARG WORKDIR
ADD sonar.tar .
ENV PATH=$PATH:/sonar/bin
WORKDIR $WORKDIR