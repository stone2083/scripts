#!/bin/bash

if [ $(id -u) = 0 ]
then
  echo "****************************************************"
  echo "*Error: root (the superuser) can't run this script.*"
  echo "****************************************************"
  exit 1
fi

error_handle()
{
  echo "error @ line ${BASH_LINENO}. exit with status $?"
}

trap error_handle ERR
set -e

BASE=$(dirname $0)
$BASE/jettyctl.sh start
