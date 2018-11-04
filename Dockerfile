FROM microsoft/dotnet:2.1-sdk-bionic
LABEL maintainer andrewarnott@gmail.com

RUN apt-get update \
 && apt-get install -y \
# libgit2 dependency
        libcurl3 \
        libssl1.0.0 \
# everybody needs these
        sudo \
 && rm -rf /var/lib/apt/lists/*

ADD https://dot.net/v1/dotnet-install.sh /tmp/dotnet-install.sh

RUN chmod +x /tmp/dotnet-install.sh \
# .NET Core SDKs
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.1.202 \
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
 && /tmp/dotnet-install.sh --install-dir /usr/share/dotnet -v 2.0.7 --runtime dotnet \
 && rm /tmp/dotnet.*

# Prime the package caches
RUN dotnet new classlib -o /tmp/classlib \
 && rm -Rf /tmp/classlib

WORKDIR /root
