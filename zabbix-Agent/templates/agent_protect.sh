#!/bin/bash
#version 1.0
#modified 2022-11-21

#判断执行者是root立即退出
if [ `whoami` == root ];then
    exit 1
fi

#[ -e ~/.profile ] && . ~/.profile
#[ -e ~/.bash_profile ] && . ~/.bash_profile

run_user=`whoami`

zabbix_agent_dir=$1
agents_dir=`cd $zabbix_agent_dir/&&pwd`
log=$agents_dir/cron-log
zabbix_base_dir=$agents_dir

############如果agents_dir目录不存在，直接退出
if [ ! -e ${agents_dir} ]
    then echo "$agents_dir is not exist,exit now";
    exit 1
fi

if [ ! -e ${log} ]
    then
                mkdir ${log}
                echo "${log} is not exist,create a new one";
fi

cdate=`date +%F" "%T`
log_put=${log}/cron_`date +%F`.log
touch ${log_put}

if [ `echo $?` -eq 0 ]
        then echo "logfile touch ok"
else
        touch ${log_put}
fi

############ part 1. 检查zabbix_agentd进程是否存在，若不存在立即启动并输出启动信息
if [ -e ${zabbix_base_dir} ]
    then
    if [ `ps -ef | grep ${run_user}| grep $zabbix_base_dir/conf/zabbix_agentd.conf | grep -v grep | wc -l` -eq 0 ]
        then $zabbix_base_dir/sbin/zabbix_agentd -c $zabbix_base_dir/conf/zabbix_agentd.conf
        echo "$cdate zabbix-agent restart">>${log_put};
    fi
fi

############ part 2. 清理cron日志，保留最近3天的日志文件
find ${log} -type f -name "cron*.log" -mtime +3 |xargs rm -f
