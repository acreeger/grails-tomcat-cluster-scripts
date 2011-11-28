#!/bin/bash

syntax() {
	echo "Usage: createCluster.sh appName [cluster root]"
}

if [ $# -eq 0 ] || [ $# -gt 2 ]; then
    syntax
    exit 1
fi

CLUSTER_ROOT=$2

if [ -z "$CLUSTER_ROOT" ]; then
	CLUSTER_ROOT=$CR
	if [ -z "$CLUSTER_ROOT" ]; then
		syntax
		exit 1
	fi
fi

ant -f clusterTasks.xml createCluster -Dcluster.root=$CLUSTER_ROOT -Dconfig=$1-config.groovy

