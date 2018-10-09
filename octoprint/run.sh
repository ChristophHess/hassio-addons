#!/bin/sh
set -e

copy_data() {
    if [ ! -d /data/python ]; then
        cp -R /root/python /data/
    fi
}

create_config() {
    if [ ! -f /config/octoprint/config.yaml ]; then
        mkdir -p /config/octoprint/
        cd /config/octoprint
        touch config.yaml
        echo "server:" >> config.yaml
        echo "  commands:" >> config.yaml
        echo "    serverRestartCommand: supervisorctl reload" >> config.yaml
        echo "devel:" >> config.yaml
        echo "  virtualPrinter:" >> config.yaml
        echo "    enabled: true" >> config.yaml
        echo "folder:" >> config.yaml
        echo "  timelapse: /config/timelapse" >> config.yaml
        echo "  uploads: /config/uploads" >> config.yaml
        echo "  watched: /config/watched" >> config.yaml
        echo "plugins:" >> config.yaml
        echo "  cura:" >> config.yaml
        echo "    cura_engine: /sbin/CuraEngine" >> config.yaml
        echo "    debug_logging: false" >> config.yaml
        echo "  pluginmanager:" >> config.yaml
        echo "    pip_force_user: true" >> config.yaml
        echo "webcam:" >> config.yaml
        echo "  ffmpeg: /usr/bin/ffmpeg" >> config.yaml
    fi
}

copy_data
create_config
/usr/bin/supervisord -c /etc/supervisord.conf
