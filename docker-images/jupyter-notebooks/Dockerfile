FROM quay.io/jupyter/minimal-notebook AS base

USER root

ENV \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # Opt out of telemetry until after we install jupyter when building the image, this prevents caching of machine id
    DOTNET_TRY_CLI_TELEMETRY_OPTOUT=true

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y curl dotnet-sdk-8.0

USER jovyan

RUN pip install nteract_on_jupyter \
    && dotnet tool install -g Microsoft.dotnet-interactive

ENV PATH="${PATH}:/home/jovyan/.dotnet/tools"

# Install kernel specs
RUN dotnet interactive jupyter install

WORKDIR /home/jovyan/Notebooks/
