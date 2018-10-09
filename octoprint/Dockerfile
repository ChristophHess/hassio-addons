ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

ENV OCTOPRINT_VERSION=1.3.9
ENV CURA_VERSION=15.04.6
# To have Python packages persistently installed.
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

# Change to tmp folder for all installs, easier to clean
WORKDIR /tmp

# Install requirements for add-on
RUN apk add --no-cache jq supervisor ffmpeg py-pip \
    && \
    # Get code for installation, install.
    wget -qO- https://github.com/foosel/OctoPrint/archive/${OCTOPRINT_VERSION}.tar.gz | tar xz && \
    wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz && \
    wget -qO- https://github.com/Ultimaker/CuraEngine/archive/${CURA_VERSION}.tar.gz | tar xz \
    && \
    # Compile and install
    apk add --no-cache --virtual build-dependencies \
    build-base cmake linux-headers libjpeg-turbo-dev python-dev libexecinfo-dev avahi-compat-libdns_sd \
    && \
    # mjpeg-streamer
    cd /tmp/mjpg-streamer-master/mjpg-streamer-experimental/ \
    && make \
    && make install \
    && \
    # Cura
    cd /tmp/CuraEngine-${CURA_VERSION} \
    && mkdir -p build \
    && make \
    && cp build/CuraEngine /sbin/CuraEngine \
    && \
    # Octoprint
    cd /tmp/OctoPrint-${OCTOPRINT_VERSION} \
    && pip install --upgrade pip --user \
    && pip install --user https://goo.gl/SxQZ06 \
    && pip install -r requirements.txt --user \
    && python setup.py install --user \
    && ls /data \
    && cp -R /data/python /root/ \
    && \
    # Cleanup
    apk del --no-cache build-dependencies \
    && rm -rf /tmp

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 5000
WORKDIR /
CMD [ "/run.sh" ]

# # Add user with sudo access.
# # RUN apk add --no-cache sudo && \
# #     addgroup -S octoprint && \
# #     adduser -G octoprint -g "octoprint user" -s /bin/sh -D octoprint && \
# #     addgroup octoprint dialout && \
# #     addgroup octoprint tty && \
# #     echo "octoprint ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# # USER octoprint
# # WORKDIR /home/octoprint
