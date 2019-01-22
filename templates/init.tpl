#!/bin/sh

# chkconfig: 2345 60 20
# description: {{name}}

. /etc/rc.d/init.d/functions

{% block variables %}
NAME={{name}}
USER=prometheus
SCRIPT="/usr/bin/${NAME}"
PIDFILE="/var/run/${NAME}.pid"
LOGFILE="/var/log/${NAME}.log"
ENVFILE="/etc/default/${NAME}"
{% endblock variables %}

start() {
    echo -n "Starting $PROGNAME: "
    . $ENVFILE
    daemon --user $USER --pidfile="$PIDFILE" "$SCRIPT $ARGS &> $LOGFILE &"
    echo $(pidofproc $PROGNAME) >$PIDFILE
    echo
}

stop() {
    echo -n "Shutting down $NAME: "
    killproc $NAME
    rm -f $PIDFILE
    echo
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
  status)
    status $NAME
    ;;
  reload)
    echo "Sending SIGHUP to $NAME"
    kill -SIGHUP $(pidofproc $NAME)
    ;;
  *)
    echo "Usage: $0 {start|stop|reload|restart|status}"
esac
