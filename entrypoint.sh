#!/bin/bash

if [ -z "${CONFIG}" ]; then
    echo "CONFIG environment variable not set. Using defaults."
else
    echo "Downloading config from ${CONFIG}"
    curl --insecure -L -o spyserver.config $CONFIG
fi
exec "$@"



