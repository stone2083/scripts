#!/bin/bash

BASE=$(dirname $0)
$BASE/nginxctl.sh stop
$BASE/jettyctl.sh stop
