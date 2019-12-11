#!/bin/bash

if [ -z "${CONFIG_GIST}" ]
then
    echo "Settings gist is not provided; exiting"
    exit 0;
fi

echo "Updating settings from gist ${CONFIG_GIST}"

GIST_URL="https://gist.github.com/${CONFIG_GIST}.git"
TEMP_DIR="/tmp/cloudSettings"
SETTINGS_DIR=$HOME"/.local/share/code-server"

git clone "https://gist.github.com/${CONFIG_GIST}.git" ${TEMP_DIR}
rm -rf ${TEMP_DIR}/.git

cp ${TEMP_DIR}/*  ${SETTINGS_DIR}/User/*

EXT_LIST=$(cat ${TEMP_DIR}/extensions.json | jq -r ".[].metadata.publisherId")

for line in $extensions; do
    echo "Installing $line using VSCode";
    code-server --install-extension $line
done

rm ${TEMP_DIR}
