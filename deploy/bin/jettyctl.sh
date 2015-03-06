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

function sed()
{
  /usr/local/bin/gsed $*
}

function config()
{
  export JETTY_ID=$1
  let JETTY_PORT=$BASE_JETTY_PORT+$JETTY_ID-1
  # jetty configuration
  export JETTY_PORT
  export JETTY_TMPDIR="$JETTY_SERVER_HOME/$JETTY_ID/tmp"
  export JETTY_CONF="$JETTY_SERVER_HOME/$JETTY_ID/conf"
  export JETTY_WEBAPPS="$JETTY_SERVER_HOME/$JETTY_ID/webapps"
  export START_INI="$JETTY_SERVER_HOME/$JETTY_ID/conf/start.ini"
  export JETTY_ARGS="--ini=$START_INI"
  export JETTY_LOGS="$JETTY_SERVER_HOME/$JETTY_ID/logs"
  export JETTY_PID="$OUTPUT_HOME/$JETTY_ID/logs/jetty/jetty.pid"
  export OUTPUT_LOGS="$OUTPUT_HOME/$JETTY_ID/logs"
  # jvm configuration
  export JAVA="$JAVA_HOME/bin/java"
  export JAVA_OPTIONS="$JAVA_OPTS"
}

function prepare()
{
  # clean jetty server
  if [ -d "$JETTY_SERVER_HOME/$JETTY_ID" ] ; then
    rm -rf  "$JETTY_SERVER_HOME/$JETTY_ID"
  fi
  mkdir -p "$JETTY_SERVER_HOME"
  mkdir -p "$JETTY_WEBAPPS"
  mkdir -p "$JETTY_LOGS"
  mkdir -p "$JETTY_TMPDIR"
  mkdir -p "$OUTPUT_HOME/$JETTY_ID/logs/jetty"

  # cp file to jetty server home.
  cp -r "$BASE/conf/jetty/conf" $JETTY_CONF
  T_JETTY_CONF=$(echo $JETTY_CONF | sed 's/\//\\\//g')
  T_OUTPUT_LOGS=$(echo $OUTPUT_LOGS | sed 's/\//\\\//g')
  T_JETTY_WEBAPPS=$(echo $JETTY_WEBAPPS | sed 's/\//\\\//g')
  sed -i "s/#JETTY_CONF#/$T_JETTY_CONF/g" $JETTY_CONF/start.ini
  sed -i "s/#OUTPUT_LOGS#/$T_OUTPUT_LOGS/g" $JETTY_CONF/jetty-logging.xml
  sed -i "s/#JETTY_PORT#/$JETTY_PORT/g" $JETTY_CONF/jetty.xml
  sed -i "s/#JETTY_WEBAPPS#/$T_JETTY_WEBAPPS/g" $JETTY_CONF/jetty.xml

  rm -rf  "$JETTY_WEBAPPS/root.war"
  cp  "$BASE/web.war"  "$JETTY_WEBAPPS/root.war"
}

function start()
{
  config $1
  prepare $1
  $JETTY_HOME/bin/jetty.sh start &> $OUTPUT_HOME/logs/jetty/jetty_stdout.log
}

function stop()
{
  config $1
  $JETTY_HOME/bin/jetty.sh stop
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
