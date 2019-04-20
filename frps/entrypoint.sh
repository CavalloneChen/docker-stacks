#!/bin/bash
__readINI() {
 INIFILE=$1; SECTION=$2; ITEM=$3
 _readIni=`awk -F '=' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$ITEM'/{print $2;exit}' $INIFILE`
echo ${_readIni}
}

set -e
FRPS_BIN="/usr/local/frps/frps"
FRPS_CONF="/usr/local/frps/frps.ini"
FRPS_LOG=$(__readINI ${FRPS_CONF} common log_file)
str_log_level=${str_log_level:-info}   # set log level: debug, info, warn, error

echo "+---------------------------------------------+"
echo "|              Frps On Docker                 |"
echo "+---------------------------------------------+"
echo ""
if [ ! -r ${FRPS_CONF} ]; then
    echo "config file ${FRPS_CONF} not found"
    exit 1
fi
[ -z ${FRPS_LOG} ] && echo "Log file not setting,exit!" && exit 1
touch ${FRPS_LOG} > /dev/null 2>&1
echo "Starting frps $(${FRPS_BIN} -v) ..."
${FRPS_BIN} -c ${FRPS_CONF} &
exec "tail" -f ${FRPS_LOG}
