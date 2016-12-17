# Minimal ubuntu docker container running systemd

This docker container image is based on the `Ubuntu 16.04 Xenial` one served
by the official docker library. It provides a minimal `systemd` configuration
to be able to use systemd as PID 1 within a docker container.


## How to use it

With this image, it is currently required to start the container using `privileged`
mode.

If you want to be able to properly shutdown the container with `docker stop`,
you will need to define a specific stop signal (`SIGRTMIN+3`).

```bash
docker run \
	-it \
	--privileged \
	--stop-signal=SIGRTMIN+3 \
	lionelnicolas/ubuntu-systemd \
```


## Systemd services

Here is a dump of the `systemd` service currently started/handled by this docker
image:

```bash
root@2d6c6a37c915:/# systemctl --all --no-pager --no-legend
dev-mapper-ssd\x2ddocker.device    loaded activating tentative dev-mapper-ssd\x2ddocker.device
-.mount                            loaded active     mounted   /
dev-mqueue.mount                   loaded active     mounted   POSIX Message Queue File System
etc-hostname.mount                 loaded active     mounted   /etc/hostname
etc-hosts.mount                    loaded active     mounted   /etc/hosts
etc-resolv.conf.mount              loaded active     mounted   /etc/resolv.conf
init.scope                         loaded active     running   System and Service Manager
emergency.service                  loaded inactive   dead      Emergency Shell
rc-local.service                   loaded active     exited    /etc/rc.local Compatibility
rescue.service                     loaded inactive   dead      Rescue Shell
systemd-journald.service           loaded active     running   Journal Service
systemd-tmpfiles-clean.service     loaded inactive   dead      Cleanup of Temporary Directories
systemd-tmpfiles-setup-dev.service loaded active     exited    Create Static Device Nodes in /dev
systemd-tmpfiles-setup.service     loaded active     exited    Create Volatile Files and Directories
-.slice                            loaded active     active    Root Slice
system.slice                       loaded active     active    System Slice
systemd-journald-audit.socket      loaded active     running   Journal Audit Socket
systemd-journald-dev-log.socket    loaded active     running   Journal Socket (/dev/log)
systemd-journald.socket            loaded active     running   Journal Socket
basic.target                       loaded active     active    Basic System
emergency.target                   loaded inactive   dead      Emergency Mode
local-fs-pre.target                loaded inactive   dead      Local File Systems (Pre)
local-fs.target                    loaded active     active    Local File Systems
multi-user.target                  loaded active     active    Multi-User System
network-online.target              loaded inactive   dead      Network is Online
network-pre.target                 loaded inactive   dead      Network (Pre)
network.target                     loaded inactive   dead      Network
paths.target                       loaded active     active    Paths
rescue.target                      loaded inactive   dead      Rescue Mode
shutdown.target                    loaded inactive   dead      Shutdown
slices.target                      loaded active     active    Slices
sockets.target                     loaded active     active    Sockets
swap.target                        loaded active     active    Swap
sysinit.target                     loaded active     active    System Initialization
time-sync.target                   loaded inactive   dead      System Time Synchronized
timers.target                      loaded active     active    Timers
umount.target                      loaded inactive   dead      Unmount All Filesystems
systemd-tmpfiles-clean.timer       loaded active     waiting   Daily Cleanup of Temporary Directories
root@2d6c6a37c915:/#
```

Note: my `/var/lib/docker` is mounted from `/dev/mapper/ssd/docker` on my host,
that's why the service `dev-mapper-ssd\x2ddocker.device` is shown here. This
should be the only difference between this dump and the one you may see on your
system.


## Why not using the latest Ubuntu version as `FROM` image

Due to an [Ubuntu patch](https://launchpad.net/ubuntu/+source/systemd/229-4ubuntu8) applied on the systemd package, stdin/out/err
descriptors are no longer available when systemd is running within containers
(they are mapped to /dev/null).

As this patch has been applied between ubuntu's systemd version `229-4ubuntu7`
and `229-4ubuntu8`, using docker tag xenial-20160818 reverts to `229-4ubuntu7`
(before the patch was applied).

With that patch removed, the current image will let you access to `systemd` output
like on a *real* system, using `docker logs`:

```bash
user@host:~# docker logs 2d6c6a37c915
systemd 229 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN)
Detected virtualization docker.
Detected architecture x86-64.

Welcome to Ubuntu 16.04.1 LTS!

Set hostname to <2d6c6a37c915>.
Initializing machine ID from random generator.
Failed to install release agent, ignoring: No such file or directory
[  OK  ] Reached target Swap.
[  OK  ] Listening on Journal Socket.
[  OK  ] Listening on Journal Audit Socket.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Local File Systems.
[  OK  ] Listening on Journal Socket (/dev/log).
[  OK  ] Reached target Sockets.
[  OK  ] Created slice System Slice.
         Starting Create Volatile Files and Directories...
         Starting Create Static Device Nodes in /dev...
[  OK  ] Reached target Slices.
         Starting Journal Service...
[  OK  ] Started Create Static Device Nodes in /dev.
[  OK  ] Started Create Volatile Files and Directories.
[  OK  ] Started Journal Service.
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target Timers.
[  OK  ] Reached target Basic System.
         Starting /etc/rc.local Compatibility...
[  OK  ] Started /etc/rc.local Compatibility.
[  OK  ] Reached target Multi-User System.
user@host:~#
```


I've not took the time to investigate but it seems that this patch has had a
side effect. Systemd within a container is a lot slower after that patch.

Before the patch (`229-4ubuntu7`) :

```bash
root@2d6c6a37c915:/# systemd-analyze blame
            39ms systemd-journald.service
            11ms systemd-tmpfiles-setup.service
             6ms systemd-tmpfiles-setup-dev.service
             1ms rc-local.service
root@2d6c6a37c915:/#
```

After the patch (`229-4ubuntu8`) :

```bash
root@93e0bd2a0c98:/# systemd-analyze blame
          3.033s rc-local.service
          2.061s systemd-tmpfiles-setup.service
          2.048s systemd-tmpfiles-setup-dev.service
          1.011s systemd-journald.service
root@93e0bd2a0c98:/#
```

It's `8s` vs `60ms` !

As I'm using this docker image only for development purposes, I may have a look
at this issue in the future (if I have some time)


## License

This is licensed under the Apache License, Version 2.0. Please see [LICENSE](https://github.com/lionelnicolas/docker-ubuntu-systemd/blob/master/LICENSE)
for the full license text.

Copyright 2016 Lionel Nicolas
