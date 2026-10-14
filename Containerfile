FROM registry.fedoraproject.org/fedora-toolbox:45 AS base
LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="kde stuff" \
      maintainer="renner"

# Copy the setup scripts and package list
COPY ../setup.sh /
COPY ../packages.list /

RUN dnf config-manager setopt keepcache=1

RUN dnf config-manager disable fedora-cisco-openh264

RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    /setup.sh

RUN rm /setup.sh /packages.list
RUN dnf config-manager setopt keepcache=0

FROM quay.io/coreos/chunkah:dev AS chunkah
RUN --mount=type=bind,target=/run/src,rw \
    --mount=from=base,target=/chunkah,ro \
        chunkah build --max-layers 128 --output oci:/run/src/out

FROM oci:out
