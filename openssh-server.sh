#!/bin/bash

set -e

REMOVE=false
INSTALL=false
PORT=22

while getopts "rip:" opt; do
    case $opt in
        r)
            REMOVE=true
            ;;
        i)
            INSTALL=true
            ;;
        p)
            PORT=$OPTARG
            ;;
        *)
            echo "Usage: $0 [-r] [-i] [-p port]"
            exit 1
            ;;
    esac
done

if $REMOVE; then
    sudo apt remove openssh-server --purge -y
fi

if $INSTALL; then
    sudo apt install openssh-server -y
    if [ "$PORT" != "22" ]; then
        sudo sed -i "s/^#Port 22/Port $PORT/" /etc/ssh/sshd_config
        sudo sed -i "s/^Port 22/Port $PORT/" /etc/ssh/sshd_config
    fi

    sudo systemctl restart sshd
fi

echo "Done."

