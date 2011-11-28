#!/bin/bash

syntax() {
	echo "Usage: cleanup.sh [cluster root]"
}

CLUSTER_ROOT=$1

if [ -z "$CLUSTER_ROOT" ]; then
	CLUSTER_ROOT=$CR
	if [ -z "$CLUSTER_ROOT" ]; then
		syntax
		exit 1
	fi
fi

for ((a=1; a<10; a++)) do
	INSTANCE_DIR="$CLUSTER_ROOT/instance_${a}"
	if [ -d $INSTANCE_DIR ]; then
		echo "deleting instance $a logs"
		rm -f $INSTANCE_DIR/logs/*
		echo "deleting instance $a temp"
		rm -rf $INSTANCE_DIR/temp/*
		echo "deleting instance $a work"
		rm -rf $INSTANCE_DIR/work/*
	fi
done

echo "deleting shared logs"
rm -f $CLUSTER_ROOT/shared/logs/*

echo "deleting tomcat logs"
rm -f $CLUSTER_ROOT/tomcat/logs/*

