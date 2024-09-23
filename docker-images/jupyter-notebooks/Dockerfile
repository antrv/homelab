FROM quay.io/jupyter/minimal-notebook AS base

USER root

ENV \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    NUGET_XMLDOC_MODE=skip \
    DOTNET_TRY_CLI_TELEMETRY_OPTOUT=true \
    DEBIAN_FRONTEND=noninteractive \
    USER=jovyan \
    HOME=/home/jovyan

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y curl dotnet-sdk-8.0

USER ${USER}

RUN pip install nteract_on_jupyter \
    && dotnet tool install -g Microsoft.dotnet-interactive

ENV PATH="${PATH}:${HOME}/.dotnet/tools"

# Install kernel specs
RUN dotnet interactive jupyter install

WORKDIR ${HOME}/Notebooks/
