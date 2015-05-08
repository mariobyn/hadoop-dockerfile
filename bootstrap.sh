#!/bin/bash

service ssh start

: ${HADOOP_PREFIX:=/usr/lib/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

source /etc/bash_profile

start-dfs.sh
start-yarn.sh


if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
