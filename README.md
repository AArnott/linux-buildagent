# linux-buildagent

[![DockerHub pull count](https://img.shields.io/docker/pulls/andrewarnott/linux-buildagent.svg)](https://hub.docker.com/r/andrewarnott/linux-buildagent/)

Docker image is based on Ubuntu xenial (16.04) and includes:

* .NET Core 1.0 runtime
* .NET Core 1.1 runtime
* .NET Core 2.0 runtime
* .NET Core 2.1 runtime
* .NET Core 2.1 SDK (various versions)

To add more packages to this image, run `apt-get update` first in order to repopulate the package cache before running `apt-get install`.
