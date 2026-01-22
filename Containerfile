FROM registry.fedoraproject.org/fedora-toolbox:43

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="kde stuff" \
      maintainer="renner"

# Copy the setup scripts and package list
COPY ../setup.sh /
COPY ../packages.list /

# Run the setup scripts
RUN sed -i "s/enabled=1/enabled=0/" /etc/yum.repos.d/fedora-cisco-openh264.repo
RUN chmod +x setup.sh && /setup.sh
RUN rm /setup.sh /packages.list
