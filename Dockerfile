FROM ubuntu:xenial
LABEL maintainer andrewarnott@gmail.com

RUN apt-get update \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        \
# .NET Core dependencies
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu55 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        zlib1g \
        wget \
# Mono
 && echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
 && apt update \
 && apt install -y mono-devel \
# Clean up apt package cache so it doesn't bloat the image with (eventually) stale data
 && rm -rf /var/lib/apt/lists/*

ADD https://dot.net/v1/dotnet-install.sh /tmp/dotnet-install.sh

RUN chmod +x /tmp/dotnet-install.sh
RUN \
# .NET Core SDKs
 /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.202 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.300 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.301 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.302 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.400 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.401 \
# ASP.NET Core runtimes
 #&& /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.0 --runtime aspnetcore \ # already installed
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.1 --runtime aspnetcore \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.2 --runtime aspnetcore \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.3 --runtime aspnetcore \
# .NET Core Runtimes
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 1.0.11 --runtime dotnet \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 1.1.8 --runtime dotnet \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.0.7 --runtime dotnet \
 && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Prime the package caches
RUN dotnet new classlib -o /tmp/classlib \
 && rm -Rf /tmp/classlib

# Install mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && apt install apt-transport-https \
 && echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
 && apt update \
 && apt install mono-devel

# Configure Kestrel web server to bind to port 80 when present
ENV ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 \
    DOTNET_CLI_TELEMETRY_OPTOUT=1

WORKDIR /root
