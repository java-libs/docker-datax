FROM ubuntu:18.04

LABEL maintainer="wjchang <447491480@qq.com>"

COPY src/install.sh /tmp/
COPY src/docker-jvm-opts.sh /

RUN /tmp/install.sh

VOLUME [ "/opt/datax/script" ]
