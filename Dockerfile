FROM ubuntu:xenial

ENV container=docker

ADD configure-systemd /tmp/
RUN /tmp/configure-systemd

ENTRYPOINT ["/lib/systemd/systemd"]
