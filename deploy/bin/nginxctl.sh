#!/bin/bash

# ===========================
# nginx ctl start/stop
# ===========================

function error_handle()
{
  echo "error @ line ${BASH_LINENO}. exit with status $?"
}

trap error_handle ERR
set -e

BASE=$(dirname $0)/..
. $BASE/bin/env

function start() {
    $NGINX_HOME/bin/nginxctl start
}

function stop() {
    $NGINX_HOME/bin/nginxctl stop
}

case $1 in
  start)
    start
    ;;
  stop)
    stop
    ;;
  *)
    echo "Usage: nginxctl.sh start"
    echo "       nginxctl.sh stop"
    echo "       nginxctl.sh -h"
    ;;
esac