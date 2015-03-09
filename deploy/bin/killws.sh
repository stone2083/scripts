#!/bin/bash

BASE=$(dirname $0)
/home/admin/cai/bin/nginxctl stop
$BASE/jettyctl.sh stop
