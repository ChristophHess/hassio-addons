ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install requirements
RUN apk add --update --no-cache sudo python openrc \
    && \
    addgroup -S octoprint && \
    adduser -G octoprint -g "octoprint user" -s /bin/sh -D octoprint && \
    echo "octoprint ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && \
    mkdir -p /data && chown -R octoprint:octoprint /data
USER octoprint

# Setup and install OctoPrint
WORKDIR /data
RUN sudo apk add --update --no-cache --virtual build-dependencies \
    git \
    python-dev \
    build-base \
    linux-headers \
    && \
    sudo -H python -m ensurepip --default-pip \
    && \
    sudo -H pip install virtualenv \
    && \
    # Install
    git clone https://github.com/foosel/OctoPrint.git /data/OctoPrint && \
    cd /data/OctoPrint && \
    virtualenv venv && \
    ./venv/bin/pip install .

# Copy data for add-on
COPY octoprint /etc/init.d/octoprint
RUN sudo chmod +x /etc/init.d/octoprint

COPY --chown=octoprint:octoprint run.sh /run.sh
RUN ["chmod", "a+x", "/run.sh"]

# CMD ["tini", "-s", "--", "/run.sh"]
