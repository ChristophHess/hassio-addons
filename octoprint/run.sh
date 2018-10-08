#!/bin/sh
set -e

setup() {
    sudo mkdir -p /config/octoprint
    sudo chown -R octoprint:octoprint /config/octoprint
    if [ ! -f /config/octoprint/config.yaml ]; then
        sudo cp -a $HOME/.octoprint/config.yaml /config/octoprint/config.yaml
        echo "Copy .octoprint/config.yaml"
    fi
    sudo chown -R octoprint:octoprint /data/
    if [ ! -d /data/CuraEngine ]; then
        sudo cp -a $HOME/CuraEngine /data/
        echo "Copied CuraEngine"
    fi
    if [ ! -d /data/OctoPrint ]; then
        sudo cp -a $HOME/OctoPrint /data/
        echo "Copied OctoPrint"
    fi
    if [ ! -d /data/libArcus ]; then
        sudo cp -a $HOME/libArcus /data/
        echo "Copied libArcus"
    fi
}

create_config() {
    if [ ! -f /config/octoprint/config.yaml ]; then
        mkdir -p /config/octoprint/
        cd /config/octoprint
        touch config.yaml
        echo "server:" >> config.yaml
        echo "  commands:" >> config.yaml
        echo "    serverRestartCommand: supervisorctl restart octoprint" >> config.yaml
        echo "devel:" >> config.yaml
        echo "  virtualPrinter:" >> config.yaml
        echo "    enabled: true" >> config.yaml
        echo "plugins:" >> config.yaml
        echo "  cura:" >> config.yaml
        echo "    cura_engine: /sbin/CuraEngine" >> config.yaml
        echo "    debug_logging: false" >> config.yaml
        echo "webcam:" >> config.yaml
        echo "  ffmpeg: /usr/bin/ffmpeg" >> config.yaml
    fi
}

create_config

# setup
/usr/bin/supervisord -c /etc/supervisord.conf
# /data/OctoPrint/venv/bin/octoprint daemon restart --basedir /config/octoprint >> /home/octoprint/log_octo.txt
