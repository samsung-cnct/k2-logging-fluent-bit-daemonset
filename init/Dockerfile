FROM ubuntu
ENV DEBIAN_FRONTEND noninteractive

# Fluent Bit version
ENV FLB_MAJOR 0
ENV FLB_MINOR 12
ENV FLB_PATCH 1
ENV FLB_VERSION 0.12.1
ENV GOPATH /go
ENV GOBIN $GOPATH/bin
ENV PATH $GOBIN:$PATH

MAINTAINER Leah Petersen <leahnpetersen@gmail.com>
LABEL Description="Fluent Bit docker image" Vendor="Fluent Organization" Version="1.1"
USER root

# Install build tools
RUN apt-get -qq update && \
    apt-get install -y -qq curl ca-certificates build-essential cmake iputils-ping dnsutils make bash sudo wget unzip nano vim valgrind golang git  && \
    apt-get install -y -qq --reinstall lsb-base lsb-release && \
    wget -O "/tmp/fluent-bit-$FLB_VERSION-dev.zip" "https://github.com/fluent/fluent-bit/archive/v$FLB_VERSION.zip" && \
    cd /tmp && \
    unzip "fluent-bit-$FLB_VERSION-dev.zip" && \
    cd "fluent-bit-$FLB_VERSION/build/" && \
    cmake -DCMAKE_INSTALL_PREFIX=/fluent-bit/ .. && \
    make && make install && \
    cd / && \
    git clone https://github.com/samsung-cnct/fluent-bit-kafka-output-plugin && \
    cd fluent-bit-kafka-output-plugin && \
    make && \
    rm -rf /tmp/* /fluent-bit/include /fluent-bit/lib* && \
    apt-get install systemd

COPY fluent-bit.conf /fluent-bit/etc/
COPY parsers.conf /fluent-bit/etc/
COPY start.sh /
RUN ["chmod", "+x", "/start.sh"]

CMD ["/fluent-bit/bin/fluent-bit", "-e", "/fluent-bit-kafka-output-plugin/out_kafka.so", "-c", "/fluent-bit/etc/fluent-bit.conf"]
