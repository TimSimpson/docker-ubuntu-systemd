FROM ubuntu:bionic-20190912.1 as final

ENV container=docker

ADD configure-systemd /tmp/
RUN /tmp/configure-systemd

ENTRYPOINT ["/lib/systemd/systemd"]
