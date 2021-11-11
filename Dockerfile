FROM ubuntu:18.04

LABEL maintainer="wjchang <447491480@qq.com>"

COPY src/install.sh /tmp/
COPY src/docker-jvm-opts.sh /

RUN /tmp/install.sh

ADD src/datax-web-2.1.2.tar.gz /opt/

VOLUME [ "/opt/datax/script" ]

#ENTRYPOINT ["sh","/opt/datax-web-2.1.2/bin/start-all.sh"]
