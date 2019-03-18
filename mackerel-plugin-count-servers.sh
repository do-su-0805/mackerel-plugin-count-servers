#!/bin/bash

## settings

TMP_RESULT="/tmp/mackerel-plugin-count-servers.tmp"

## functions

usage_exit() {
	echo "Usage: $0 [-s Service] [-h]" 1>&2
	exit 1
}

## args

while getopts s:h OPT
do
	case $OPT in
		s)  service=${OPTARG}
		    ;;
		h)  usage_exit
		    ;;
		*)  usage_exit
		    ;;
	esac
done

if [ "X$service" == "X" ]; then
	echo "Error: Empty Service!" 1>&2
	usage_exit
fi

## get hosts
mkr hosts -s ${service} > $TMP_RESULT 

## get roles
for role in $(mkr services | jq ".[] | select(.name == \"${service}\") | .roles[]" -r); do
  for status in working standby maintenance poweroff; do
    count=`cat $TMP_RESULT | jq "[.[] | select(.roleFullnames[] == \"${service}:${role}\") | select(.status == \"${status}\") | .id] | length"`;
    echo -e "${service}.${role}.${status}\t${count}\t$(date -u +%s)"
  done
done
