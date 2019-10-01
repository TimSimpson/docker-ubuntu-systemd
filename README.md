# Minimal ubuntu docker container running systemd

This docker container image is based on the upstream `Ubuntu 18.04 Bionic`
from the official docker library. It provides a minimal `systemd` configuration
to be able to use systemd as PID 1 within a docker container.


## How to use it

### Privileged mode

As systemd depends on cgroups, container needs to be started as `privileged` to
let systemd mount its cgroup system.

```bash
docker run \
	-it \
	--privileged \
	lionelnicolas/ubuntu-systemd \
```


### Unprivileged mode

This image can still be used in an unprivileged container, but you'll need to
mount bind your host's cgroup system.

```bash
docker run \
	-it \
	--volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
	lionelnicolas/ubuntu-systemd \
```


## Systemd services

Here is a dump of the `systemd` services currently started/handled by this
docker image:

```bash
root@679858b8bab4:/# systemctl --all --no-pager --no-legend
-.mount                            loaded active   mounted Root Mount
dev-mqueue.mount                   loaded active   mounted POSIX Message Queue File System
etc-hostname.mount                 loaded active   mounted /etc/hostname
etc-hosts.mount                    loaded active   mounted /etc/hosts
etc-resolv.conf.mount              loaded active   mounted /etc/resolv.conf
proc-acpi.mount                    loaded active   mounted /proc/acpi
proc-asound.mount                  loaded active   mounted /proc/asound
proc-bus.mount                     loaded active   mounted /proc/bus
proc-fs.mount                      loaded active   mounted /proc/fs
proc-irq.mount                     loaded active   mounted /proc/irq
proc-kcore.mount                   loaded active   mounted /proc/kcore
proc-keys.mount                    loaded active   mounted /proc/keys
proc-sched_debug.mount             loaded active   mounted /proc/sched_debug
proc-scsi.mount                    loaded active   mounted /proc/scsi
proc-sysrq\x2dtrigger.mount        loaded active   mounted /proc/sysrq-trigger
proc-timer_list.mount              loaded active   mounted /proc/timer_list
sys-firmware.mount                 loaded active   mounted /sys/firmware
init.scope                         loaded active   running System and Service Manager
emergency.service                  loaded inactive dead    Emergency Shell
rescue.service                     loaded inactive dead    Rescue Shell
systemd-journald.service           loaded active   running Journal Service
systemd-tmpfiles-clean.service     loaded inactive dead    Cleanup of Temporary Directories
systemd-tmpfiles-setup-dev.service loaded inactive dead    Create Static Device Nodes in /dev
systemd-tmpfiles-setup.service     loaded active   exited  Create Volatile Files and Directories
-.slice                            loaded active   active  Root Slice
system.slice                       loaded active   active  System Slice
systemd-journald-audit.socket      loaded inactive dead    Journal Audit Socket
systemd-journald-dev-log.socket    loaded active   running Journal Socket (/dev/log)
systemd-journald.socket            loaded active   running Journal Socket
basic.target                       loaded active   active  Basic System
emergency.target                   loaded inactive dead    Emergency Mode
local-fs-pre.target                loaded inactive dead    Local File Systems (Pre)
local-fs.target                    loaded active   active  Local File Systems
multi-user.target                  loaded active   active  Multi-User System
paths.target                       loaded active   active  Paths
rescue.target                      loaded inactive dead    Rescue Mode
shutdown.target                    loaded inactive dead    Shutdown
slices.target                      loaded active   active  Slices
sockets.target                     loaded active   active  Sockets
swap.target                        loaded active   active  Swap
sysinit.target                     loaded active   active  System Initialization
time-sync.target                   loaded inactive dead    System Time Synchronized
timers.target                      loaded active   active  Timers
umount.target                      loaded inactive dead    Unmount All Filesystems
systemd-tmpfiles-clean.timer       loaded active   waiting Daily Cleanup of Temporary Directories
```


## Build

In order to build this container image instead of using the one on the Docker Hub,
you can use the following command from the root directory of this repository:

```bash
docker build -t lionelnicolas/ubuntu-systemd .
```


## License

This is licensed under the Apache License, Version 2.0. Please see [LICENSE](https://github.com/lionelnicolas/docker-ubuntu-systemd/blob/master/LICENSE)
for the full license text.

Copyright 2016-2019 Lionel Nicolas
