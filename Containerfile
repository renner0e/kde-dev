FROM registry.fedoraproject.org/fedora-toolbox:43 AS builder

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="kde stuff" \
      maintainer="renner"

# Copy the setup scripts and package list
COPY ../setup.sh /
COPY ../packages.list /

# Run the setup scripts
RUN dnf config-manager setopt keepcache=1

RUN sed -i "s/enabled=1/enabled=0/" /etc/yum.repos.d/fedora-cisco-openh264.repo

RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    /setup.sh

RUN rm /setup.sh /packages.list
RUN dnf config-manager setopt keepcache=0
