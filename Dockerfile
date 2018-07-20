# Builds the Pester test runner image
# escape=\
FROM microsoft/powershell

ARG TERM=linux
ARG DEBIAN_FRONTEND=noninteractive

# Install docker
RUN apt-get update                                                                        \
    && apt-get install --assume-yes --no-install-recommends                               \
        apt-transport-https                                                               \
        ca-certificates                                                                   \
        curl                                                                              \
        software-properties-common                                                        \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -            \
    && add-apt-repository                                                                 \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"  \
    && apt-get update                                                                     \
    && apt-get install --assume-yes --no-install-recommends docker-ce                     \
    && rm -rf /var/lib/apt/lists/*

SHELL [ "pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

RUN Find-Module 'Pester' | Install-Module -Force

VOLUME [ "/test" ]
WORKDIR /test

ENTRYPOINT [ "pwsh", "-c", "Invoke-Pester", "-Strict", "-EnableExit" ]