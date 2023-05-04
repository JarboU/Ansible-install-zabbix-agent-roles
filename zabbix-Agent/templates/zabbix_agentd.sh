#!/bin/bash

RETVAL=0
prog="Zabbix Agentd"
zabbix_base="/data/zabbix_agentd"
ZABBIX_BIN="${zabbix_base}/sbin/zabbix_agentd"
#LD_LIBRARY_PATH=${zabbix_base}/lib/require
echo $ZABBIX_BIN

if [ ! -x ${ZABBIX_BIN} ] ; then
        echo -n "${ZABBIX_BIN} not installed! "
        # Tell the user this has skipped
        exit 5
fi

start() {
        echo -n $"Starting $prog: "
        $ZABBIX_BIN -c ${zabbix_base}/conf/zabbix_agentd.conf
        RETVAL=$?
        [ $RETVAL -eq 0 ] && echo "success" || echo "fail"
}

stop() {
        echo -n $"Stopping $prog: "
        ps aux |grep zabbix_agentd|grep -v grep |awk '{print $2}'|xargs kill -9 2>&1 >>/dev/null
        RETVAL=$?
        [ $RETVAL -eq 0 ] && echo "success" || echo "fail"
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        pid=`ps aux |grep zabbix_agentd |grep -v grep |wc -l`
        if [ "$pid" -gt 3 ];then
            echo "$prog Running"
        else
            echo "$prog not running"
        fi
        ;;
  *)
        echo $"Usage: $0 {start|stop|status}"
        exit 1
esac


