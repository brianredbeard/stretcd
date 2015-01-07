#!/bin/bash
# This script reads in a series of environment variables and uses them to
# stress test an etcd server.  The idea is to run this container in parallel
# on a number of hosts concurrently to determine performance and overall health
#
# This script expects the following environment variables to be set:
#
#   ETCD_SERVER     The server to which to connect
#   ETCD_ACTION     The action to perform (populate|destroy)
#   STRETCD_KEYS    The total number of keys to populate
#   STRETCD_SIZE    The size of each individual key in bytes
#
# This script will read a number of bytes from /dev/random and convert it to
# RFC4648 compliant base64 data and then create a key populated with that data
#


ETCD_SERVER="${ETCD_SERVER:-127.0.0.1:4001}"

operation=${ETCD_ACTION}

if   [ "$operation" == "populate" ]; then
    keys=${STRETCD_KEYS:-1}
    size=${STRETCD_SIZE:-1024}
    if [ $size -gt 90000 ]; then
        infile="true"
        temp=$(mktemp  -d)
            echo "temp=$temp"
    fi

    kchar=${#keys}
    cmd="PUT"
    args=""

elif [ "$operation" == "destroy" ]; then
    cmd="DELETE"
    args="?recursive=true&directory=true"

else 
    echo "Unknown operation"
    exit 1
fi

for x  in $(seq 1 ${keys}); do
    
    xpad=$(printf "%0${kchar}d" $x)
    if [ -n "$keys" ]; then
        # Encode data from urandom following rules from RFC4648
        if [ $infile ]; then
            echo -n "value=" > ${temp}/${xpad}
            dd if=/dev/urandom count=1 bs=$size 2>/dev/null | base64 -w0  | sed -e 's/+/-/g' -e 's/\//_/g' >> ${temp}/${xpad}
            payload="-d @${temp}/${xpad}"
        else
            payload="-d value=$(dd if=/dev/urandom count=1 bs=$size 2>/dev/null | base64 -w0  | sed -e 's/+/-/g' -e 's/\//_/g' )"
        fi

        args="$xpad"
    fi
    
    curl -X $cmd -L  "http://${ETCD_SERVER}/v2/keys/stretcd/${args}" "${payload}"
    echo curl -X $cmd -L  \"http://${ETCD_SERVER}/v2/keys/stretcd/${args}\" \"${payload}\"
done


if [ $infile ]; then
    #rm -rf ${temp}
    echo "in file"
fi

