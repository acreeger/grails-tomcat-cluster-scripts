#!/bin/bash

syntax() {
	echo "Usage:"
	echo "deploy.sh [war name] [cluster root dir]"
}

WAR=$1
CLUSTER_ROOT=$2

if [ -z "$WAR" ]; then
	echo "1st arg must be the war name"
	syntax
	exit 1
elif [ -z "$CLUSTER_ROOT" ]; then
	CLUSTER_ROOT=$CR
	if [ -z "$CLUSTER_ROOT" ]; then
		echo "2nd arg must be the cluster root dir"
		syntax
		exit 1
	fi
fi

if [ -z "$CC" ]; then
    CLUSTER_CONTEXT=ROOT
else
    CLUSTER_CONTEXT=$CC    
fi

WEB_APP_DIR=$CLUSTER_ROOT/shared/webapps/$CLUSTER_CONTEXT

rm -rf $WEB_APP_DIR

mkdir $WEB_APP_DIR

unzip $WAR -d $WEB_APP_DIR

