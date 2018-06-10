ARG BUILD_FROM
FROM $BUILD_FROM
# as builder
ENV LANG C.UTF-8
COPY tmp/ /home/octoprint/

RUN apk add --update --no-cache \
    python \
    python-dev \
    build-base \
    linux-headers \
    avahi-compat-libdns_sd \
    avahi \
    && \
    sed -i 's/#enable-dbus=yes/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf \
    && \
    python -m ensurepip --default-pip \
    && \
    pip install virtualenv
RUN addgroup -S octoprint && \
    adduser -G octoprint -g "octoprint user" -s /bin/sh -D octoprint
# Compile OctoPrint
# RUN cd /home/octoprint/OctoPrint && \
#     virtualenv venv && \
#     ./venv/bin/pip install https://goo.gl/SxQZ06 && \
#     ./venv/bin/pip install . --quiet
# Compile Cura
# FROM $BUILD_FROM as builder_cura
# ENV LANG C.UTF-8
# RUN mkdir -p /data/Cura

# # Setup final stage for running.
# FROM $BUILD_FROM
# ENV LANG C.UTF-8
# RUN apk add --update --no-cache python \
#     && \
#     addgroup -S octoprint && \
#     adduser -G octoprint -g "octoprint user" -s /bin/sh -D octoprint
#     # && \
#     # echo "octoprint ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# COPY --from=builder --chown=octoprint:octoprint /home/octoprint/OctoPrint/venv /home/octoprint/OctoPrint/venv
# COPY --from=builder --chown=octoprint:octoprint /home/octoprint/OctoPrint/run /home/octoprint/OctoPrint/run

# USER octoprint
# WORKDIR /home/octoprint

# COPY --chown=octoprint:octoprint run.sh .
# RUN ["chmod", "a+x", "run.sh"]

# ENTRYPOINT [ "run.sh" ]

# # CMD ["tini", "-s", "--", "/run.sh"]
