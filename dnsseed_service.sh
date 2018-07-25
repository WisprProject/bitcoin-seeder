#!/bin/sh
### BEGIN INIT INFO
# Provides:          <SCRIPT_NAME>
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       Script to run dnsseed application in the background
### END INIT INFO


APPROOT=<PATH_TO_APPLICATION>
PIDFILE=$APPROOT/dnsseed.pid
RUNTIME=$APPROOT/dnsseed
PREFIX1=seed
PREFIX2=vps
URL=MYURL.com
EMAIL=admin.$URL
PORT=53
ARGS="-h $PREFIX1.$URL -n $PREFIX2.$URL -m $EMAIL -p $PORT"
LOGFILE=$APPROOT/debug.log

start() {
  if [ -f $PIDFILE ] && kill -0 $(cat $PIDFILE); then
    echo 'Service already running' >&2
    return 1
  fi
  echo 'Starting service...' >&2
  su -c "start-stop-daemon -SbmCv -x /usr/bin/nohup -p \"$PIDFILE\" -d \"$APPROOT\" -- \"$RUNTIME\" $ARGS > \"$LOGFILE\""
  echo 'Service started' >&2
}

stop() {
  if [ ! -f "$PIDFILE" ] || ! kill -0 $(cat "$PIDFILE"); then
    echo 'Service not running' >&2
    return 1
  fi
  echo 'Stopping service...' >&2
  start-stop-daemon -K -p "$PIDFILE"
  rm -f "$PIDFILE"
  echo 'Service stopped' >&2
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
esac

export runlevel=$TMP_SAVE_runlevel_VAR
