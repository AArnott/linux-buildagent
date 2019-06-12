FROM ubuntu:xenial
LABEL maintainer andrewarnott@gmail.com

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
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
# libgit2 dependency
        libcurl3-gnutls \
# everybody needs these
        sudo \
 && rm -rf /var/lib/apt/lists/*

ADD https://dot.net/v1/dotnet-install.sh /tmp/dotnet-install.sh

RUN chmod +x /tmp/dotnet-install.sh \
# .NET Core SDKs
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.202 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.302 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.403 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.507 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.604 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.700 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.2.107 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.2.204 \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.2.300 \
# ASP.NET Core runtimes
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.11 --runtime aspnetcore \
# .NET Core Runtimes
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 1.0.16 --runtime dotnet \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 1.1.13 --runtime dotnet \
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.0.9 --runtime dotnet \
 && rm /tmp/dotnet.* \
 && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Prime the package caches
RUN dotnet new classlib -o /tmp/classlib \
 && rm -Rf /tmp/classlib

# Configure Kestrel web server to bind to port 80 when present
ENV ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 \
    DOTNET_CLI_TELEMETRY_OPTOUT=1

WORKDIR /root
