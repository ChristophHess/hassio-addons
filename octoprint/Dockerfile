ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

ENV OCTOPRINT_VERSION=1.3.9
ENV CURA_VERSION=15.04.6

# Install requirements for add-on
RUN apk add --no-cache jq

WORKDIR /tmp

# Get packages
RUN wget -qO- https://github.com/foosel/OctoPrint/archive/${OCTOPRINT_VERSION}.tar.gz | tar xz
RUN wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz
RUN wget -qO- https://github.com/Ultimaker/CuraEngine/archive/${CURA_VERSION}.tar.gz | tar xz

# Compile and install
RUN apk add --no-cache build-base cmake linux-headers libjpeg-turbo-dev py-pip python-dev libexecinfo-dev supervisor ffmpeg
RUN cd /tmp/mjpg-streamer-master/mjpg-streamer-experimental/ \
    && make \
    && make install
RUN cd /tmp/OctoPrint-${OCTOPRINT_VERSION} \
    && pip install -r requirements.txt \
    && python setup.py install
RUN cd /tmp/CuraEngine-${CURA_VERSION} \
    && mkdir -p build \
    && make \
    && cp build/CuraEngine /sbin/CuraEngine \
    && rm -rf /tmp/CuraEngine-${CURA_VERSION}

COPY supervisord.conf /etc/supervisor/supervisord.conf
# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

EXPOSE 5000

CMD [ "/run.sh" ]



# ARG BUILD_FROM
# FROM $BUILD_FROM
# # Add env
# ENV LANG C.UTF-8
# # Setup
# RUN apk add --update --no-cache sudo python && \
#     # Add user, and make sure to have sudo access.
#     addgroup -S octoprint && \
#     adduser -G octoprint -g "octoprint user" -s /bin/sh -D octoprint && \
#     addgroup octoprint dialout && \
#     addgroup octoprint tty && \
#     echo "octoprint ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# USER octoprint
# # Make sure all files are built for the path /data. Will copy files away from there, and back when running.
# RUN sudo mkdir -p /data && sudo chown -R octoprint:octoprint /data
# WORKDIR /data
# RUN sudo apk add --update --no-cache --virtual build-dependencies \
#     build-base alpine-sdk python-dev linux-headers cmake protobuf-dev curl git python3-dev py3-sip-dev py3-sip libexecinfo-dev && \
#     curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
#     sudo python get-pip.py && sudo pip install virtualenv && \
#     cd /data && git clone https://github.com/foosel/OctoPrint.git && \
#     cd /data && git clone https://github.com/Ultimaker/libArcus.git && \
#     cd /data && git clone -b legacy https://github.com/Ultimaker/CuraEngine.git && \
#     # Install OctoPrint
#     cd /data/OctoPrint && \
#     virtualenv venv --quiet && \
#     ./venv/bin/python setup.py install --quiet && \
#     ./venv/bin/python setup.py clean --all --quiet && \
#     rm -rf .git && \
#     find . -not -name 'venv' -not -name '.' -not -name '..' -not -name 'run' -maxdepth 1 -exec rm -rf {} + && \
#     # Install CuraEngine dependencies
#     cd /data/libArcus && mkdir -p build && cd build && cmake .. && make && sudo make install && \
#     cd /data/libArcus && rm -rf .git && \
#     cd /data/libArcus/build && make clean && \
#     # Install CuraEngine <= 15.0.4 (for OctoPrint integration).
#     cd /data && make -C CuraEngine --quiet && \
#     rm -rf CuraEngine/.git && \
#     cd CuraEngine/ && find . -not -name 'build' -not -name '.' -not -name '..' -maxdepth 1 -exec rm -rf {} + && \
# #     # Setup configuration file for octoprint.
#     mkdir -p /home/octoprint/.octoprint && cd /home/octoprint && \
#     echo "server:" >> .octoprint/config.yaml && \
#     echo "  commands:" >> .octoprint/config.yaml && \
#     echo "    serverRestartCommand: /home/octoprint/octoprint.sh" >> .octoprint/config.yaml && \
#     echo "devel:" >> .octoprint/config.yaml && \
#     echo "  virtualPrinter:" >> .octoprint/config.yaml && \
#     echo "    enabled: true" >> .octoprint/config.yaml && \
#     echo "plugins:" >> .octoprint/config.yaml && \
#     echo "  cura:" >> .octoprint/config.yaml && \
#     echo "    cura_engine: /data/CuraEngine/build/CuraEngine" >> .octoprint/config.yaml && \
#     echo "    debug_logging: false" >> .octoprint/config.yaml && \
#     sudo apk del build-dependencies && \
#     sudo apk add --update --no-cache --virtual run-dependencies \
#     python && \
#     mv /data/* /home/octoprint/

# # Copy data
# COPY run.sh /home/octoprint/octoprint.sh
# # Make script have correct permissions and is executable.
# RUN sudo chown -R octoprint:octoprint /home/octoprint/octoprint.sh && \
#     sudo chmod +x /home/octoprint/octoprint.sh

# EXPOSE 5000
# WORKDIR /home/octoprint
# ENTRYPOINT /home/octoprint/octoprint.sh && tail -f /dev/null
