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
#  sample_name=`mkr hosts --service ${service} -role ${role} | jq '.[0].name' -r`;
#  echo "<tr><td>${service}:${role}</td><td>${count}</td><td>${sample_name}</td></tr>";
    echo -e "${service}.${role}.${status}\t${count}\t$(date -u +%s)"
  done
done 
#echo "</table>"


#mkr hosts -v | jq '.[] | {"platform" : (.meta | .kernel | .platform_name), "version": (.meta | .kernel | .platform_version)}' -c > $RESULT_FILE

#for platform in $(cat $RESULT_FILE | jq .platform -r | sort | uniq | awk '!/null/{print $1}'); do
#  for version in $(cat $RESULT_FILE | grep $platform | jq .version -r | sort | uniq ); do
#    count=`cat $RESULT_FILE | grep ${platform} | jq .version -r | grep -E "^${version}$" | wc -l`
#    display_version=`echo $version | sed -e 's/\./-/g'`
#    echo -e "os.${platform}.${display_version}\t${count}\t$(date -u +%s)"
#  done
#done
