#!/bin/bash

function error_handle()
{
  echo "error @ line ${BASH_LINENO}. exit with status $?"
}

trap error_handle ERR
set -e

BASE=$(dirname $0)/..

. BASE/bin/env

function config()
{
  id=$1
  # jetty configuration
  JETTY_TMPDIR="$JETTY_SERVER_HOME/$id/tmp"
  JETTY_CONF="$JETTY_SERVER_HOME/$id/conf/jetty.conf"
  JETTY_WEBAPPS="$JETTY_SERVER_HOME/$id/webapps"
  START_INI="$JETTY_SERVER_HOME/$id/conf/start.ini"
  JETTY_ARGS="--ini=$START_INI"
  JETTY_LOGS="$JETTY_SERVER_HOME/$id/logs"
  JETTY_PID="$OUTPUT_HOME/$id/logs/jetty/jetty.pid"
  ## jvm configuration
  JAVA="$JAVA_HOME/bin/java"
  JAVA_OPTIONS="$JAVA_OPTS"
  export TMPDIR JETTY_CONF JETTY_WEBAPPS JETTY_ARGS START_INI JETTY_PID JETTY_LOGS JAVA_OPTIONS JAVA
}

function prepare()
{
  id=$1
  config $id

  # clean jetty server
  if [ -d "$JETTY_SERVER_HOME" ] ; then
    rm -rf  "$JETTY_SERVER_HOME"
  fi
  mkdir -p "$JETTY_SERVER_HOME"
  mkdir -p "$JETTY_WEBAPPS"
  mkdir -p "$JETTY_LOGS"
  mkdir -p "$JETTY_TMPDIR"
  mkdir -p "$OUTPUT_HOME/logs/jetty"

  # cp file to jetty server home.
  cp -r "$BASE/conf/jetty/conf" $JETTY_SERVER_HOME/
  # TODO: update vars by jetty instance id

  rm -rf  "$JETTY_WEBAPPS/root.war"
  cp  "$BASE/web.war"  "$JETTY_WEBAPPS/root.war"
}

function start()
{
  id=$1
  prepare $id
  $JETTY_HOME/bin/jetty.sh start &> $OUTPUT_HOME/logs/jetty/jetty_stdout.log
}

function stop()
{
  id=$1
  prepare $id
  $JETTY_HOME/bin/jetty.sh stop
}
