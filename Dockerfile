FROM ubuntu:xenial

ENV container=docker

ENTRYPOINT ["/lib/systemd/systemd"]
