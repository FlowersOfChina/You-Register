#!/bin/sh
# Author LeeMaster
# Date 2018-3-22
#
# 部署的时候需要修改一下 对应的 jar 包名称 和 远程服务器应该部署的文件位置
#

APP_DIR=/home/deploy/youmoney-register
APP_NAME=You-Register-0.0.1-SNAPSHOT
APP_CONF=$APP_DIR/application.yml

#set java home
export JAVA_HOME=/opt/jdk1.8.0_111

usage() {
    echo "Usage: sh deploy.sh [start|stop|deploy]"
    exit 1
}

kills(){
    tpid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
    if [[ $tpid ]]; then
        echo 'Kill Process!'
        kill -9 $tpid
    fi
}

start(){
    rm -f $APP_DIR/tpid
    #nohup java -jar myapp.jar --spring.config.location=application.yml > /dev/null 2>&1 &
    #默认的启动的是主节点配置
    nohup java -jar $APP_DIR/"$APP_NAME".jar --spring.profiles.active=master > /dev/null 2>&1 &
    echo $! > $APP_DIR/tpid
    echo Start Success!
}

stop(){
        tpid1=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
    echo tpid1-$tpid1
        if [[ $tpid1 ]]; then
        echo 'Stop Process...'
        kill -15 $tpid1
    fi
    sleep 5
    tpid2=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
        echo tpid2-$tpid2
    if [[ $tpid2 ]]; then
        echo 'Kill Process!'
        kill -9 $tpid2
    else
        echo 'Stop Success!'
    fi

}

check(){
    tpid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
    if [[ tpid ]]; then
        echo 'App is running.'
    else
        echo 'App is NOT running.'
    fi
}

deploy() {
    kills
    rm -rf $APP_DIR/"$APPNAME".jar
    cp "$APP_NAME".jar $APP_DIR
}

case "$1" in
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    "kill")
        kills
        ;;
    "deploy")
        deploy
        ;;
    *)
        usage
        ;;
esac