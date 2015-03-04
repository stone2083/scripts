#!/bin/sh
curl -s -d "q=$1" "http://fanyi.youdao.com/openapi.do?keyfrom=stone2083&key=1576383390&type=data&doctype=json&version=1.1" | jq .basic
