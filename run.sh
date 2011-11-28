#!/bin/bash

syntax() {
	echo "Usage:"
	echo "run.sh [start|stop|run] [instance number] [cluster root dir]"
}

ACTION=$1
INSTANCE=$2
CLUSTER_ROOT=$3

if [ -z "$ACTION" ]; then
	echo "1st arg must be the command (start/stop/run)"
	syntax
	exit 1
elif [ -z "$INSTANCE" ]; then
	echo "2nd arg must be an instance number"
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

if [ ! -r "$CLUSTER_ROOT/instance_$INSTANCE" ]; then
	echo "Instance directory $CLUSTER_ROOT/instance_$INSTANCE does not exist."
	exit 1
fi

#cd $CLUSTER_ROOT

export CATALINA_HOME="$CLUSTER_ROOT/tomcat"
export JAVA_OPTS="$JAVA_OPTS -Dcatalina.instance=$INSTANCE -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager"
export CATALINA_BASE="$CLUSTER_ROOT/instance_$INSTANCE"
export CATALINA_PID="$CLUSTER_ROOT/shared/logs/instance_$INSTANCE.pid"
export LOGGING_CONFIG="-Djava.util.logging.config.file=$CLUSTER_ROOT/shared/conf/logging.properties"

echo "CATALINA_HOME: $CATALINA_HOME"
echo "CATALINA_BASE: $CATALINA_BASE"
echo "CATALINA_PID: $CATALINA_PID"
echo "LOGGING_CONFIG: $LOGGING_CONFIG"
echo "JAVA_OPTS: $JAVA_OPTS"

if [ -r $CATALINA_BASE/conf/server.xml ] ; then
	SERVER_CONFIG=$CATALINA_BASE/conf/server.xml
else
	SERVER_CONFIG=$CLUSTER_ROOT/shared/conf/server.xml
fi

SCRIPT=$CATALINA_HOME/bin/catalina.sh

if [ "$ACTION" = "start" ] ; then
	$SCRIPT start -config $SERVER_CONFIG
elif [ "$ACTION" = "run" ] ; then
	$SCRIPT run -config $SERVER_CONFIG
elif [ "$ACTION" = "stop" ] ; then

	if [ -e $CATALINA_PID ]; then

		current_pid=`cat $CATALINA_PID`
		if [ -z "$current_pid" ]; then
			echo "instance $INSTANCE isn't running"
			exit 0
		else
			echo "Shutting down $current_pid"
			$SCRIPT stop -config $SERVER_CONFIG

			for ((a=1; a<6; a++)) do
				echo "waiting for shutdown..."
				sleep 5
				ps_output=`ps -h -p $current_pid`
				if [ -z "$ps_output" ]; then
					echo "instance $INSTANCE successfully shutdown"
					rm -f $CATALINA_PID
					exit 0
				fi
			done
		fi

		echo "could not shutdown normally, going to execute kill $current_pid"
		kill $current_pid

		for ((a=1; a<6; a++)) do
			echo "waiting for shutdown..."
			sleep 5
			ps_output=`ps -h -p $current_pid`
			if [ -z "$ps_output" ]; then
				echo "instance $INSTANCE successfully shutdown"
				rm -f $CATALINA_PID
				exit 0
			fi
		done

		echo "could not kill normally, going to kill -9"
		kill -9 $current_pid
		rm -f $CATALINA_PID
		exit 0

	else
		echo "instance $INSTANCE isn't running"
	fi
else
	echo "Invalid first parameter"
	syntax
	exit 1
fi

