#!/bin/bash

# ===========================
# jetty ctl start/stop
# ===========================

function error_handle()
{
  echo "error @ line ${BASH_LINENO}. exit with status $?"
}

trap error_handle ERR
set -e

BASE=$(dirname $0)/..

. $BASE/bin/env

function config()
{
  ID=$1
  # jetty configuration
  JETTY_TMPDIR="$JETTY_SERVER_HOME/$ID/tmp"
  JETTY_CONF="$JETTY_SERVER_HOME/$ID/conf"
  JETTY_WEBAPPS="$JETTY_SERVER_HOME/$ID/webapps"
  START_INI="$JETTY_SERVER_HOME/$ID/conf/start.ini"
  JETTY_ARGS="--ini=$START_INI"
  JETTY_LOGS="$JETTY_SERVER_HOME/$ID/logs"
  JETTY_PID="$OUTPUT_HOME/$ID/logs/jetty/jetty.pid"
  # jvm configuration
  export JAVA="$JAVA_HOME/bin/java"
  export JAVA_OPTIONS="$JAVA_OPTS"
}

function prepare()
{
  # clean jetty server
  if [ -d "$JETTY_SERVER_HOME/$ID" ] ; then
    rm -rf  "$JETTY_SERVER_HOME/$ID"
  fi
  mkdir -p "$JETTY_SERVER_HOME"
  mkdir -p "$JETTY_WEBAPPS"
  mkdir -p "$JETTY_LOGS"
  mkdir -p "$JETTY_TMPDIR"
  mkdir -p "$OUTPUT_HOME/logs/jetty"

  # cp file to jetty server home.
  cp -r "$BASE/conf/jetty/conf" $JETTY_CONF
  # TODO: update vars by jetty instance id

  rm -rf  "$JETTY_WEBAPPS/root.war"
  cp  "$BASE/web.war"  "$JETTY_WEBAPPS/root.war"
}

function start()
{
  config $1
  prepare $1
  #$JETTY_HOME/bin/jetty.sh start &> $OUTPUT_HOME/logs/jetty/jetty_stdout.log
  echo "start $ID"
}

function stop()
{
  config $1
  #$JETTY_HOME/bin/jetty.sh stop
  echo "stop $ID"
}

function start_all()
{
  for((i=0;i<$JETTY_INSTANCE_NUM;i++))
  {
    let id=$i+1
    start $id
  }
}

function stop_all()
{
  for((i=0;i<$JETTY_INSTANCE_NUM;i++))
  {
    let id=$i+1
    stop $id
  }
}

case $1 in
  start)
    start_all
    ;;
  stop)
    stop_all
    ;;
  *)
    echo "Usage: jettyctl.sh start"
    echo "       jettyctl.sh stop"
    echo "       jettyctl.sh -h"
    ;;
esac
