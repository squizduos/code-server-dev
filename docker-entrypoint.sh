#!/bin/bash
PUBLIC_IP=$(curl ifconfig.me)

if [ -z "${CONFIG_GIST}" ]
then
    export CONFIG_GIST="85d9611ed9a7330e49a5ef4650c842e4";
fi

bash sync-extensions.sh

if [ -z "${PASSWORD}" ]
then
    export PASSWORD="changeme";
fi


code-server --host 0.0.0.0 --port 8000 --auth "password" --base-path ${VIRTUAL_HOST:-PUBLIC_IP} --disable-telemetry
