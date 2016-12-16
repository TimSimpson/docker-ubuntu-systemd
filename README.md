# Minimal ubuntu docker container running systemd

This docker container image is based on the `Ubuntu 16.04 Xenial` one served
by the official docker library. It provides a minimal `systemd` configuration
to be able to use systemd as PID 1 within a docker container.


## How to use it

With this image, it is currently required to run the container with `privileged`
mode.

```bash
docker run \
	-it \
	--privileged \
	lionelnicolas/ubuntu-systemd \
```

## License

This is licensed under the Apache License, Version 2.0. Please see [LICENSE](https://github.com/lionelnicolas/docker-ubuntu-systemd/blob/master/LICENSE)
for the full license text.

Copyright 2016 Lionel Nicolas
