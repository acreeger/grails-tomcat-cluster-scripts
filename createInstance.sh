#!/bin/bash

syntax() {
	echo "Usage:"
	echo "createInstance.sh [server number] [instance number] [cluster root dir]"
}

SERVER=$1
INSTANCE=$2
CLUSTER_ROOT=$3

if [ -z "$SERVER" ]; then
	echo "1st arg must be the server number"
	syntax
	exit 1
elif [ -z "$INSTANCE" ]; then
	echo "2nd arg must be the instance number"
	syntax
	exit 1
elif [ -z "$CLUSTER_ROOT" ]; then
	CLUSTER_ROOT=$CR
	if [ -z "$CLUSTER_ROOT" ]; then
		echo "3rd arg must be the cluster root dir"
		syntax
		exit 1
	fi
fi

ant -f clusterTasks.xml createInstance -Dserver.number=$SERVER -Dinstance.number=$INSTANCE -Dcluster.root=$CLUSTER_ROOT

