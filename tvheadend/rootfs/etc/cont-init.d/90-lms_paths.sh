#!/usr/bin/with-contenv bashio

function path {
  local path
  path=${1}
  if [ ! -d ${path} ]; then
	mkdir -p ${path}
	chown ${USER:-"1000"} ${path}
  fi
}
exit

path "${LMS_PREFS}"
path "${LMS_PREFS}/plugin"
path "${LMS_CACHE}"
path "${LMS_PLUGS}"
path "${LMS_LOGDIR}"

: > ${LMS_LOGDIR}/${LMS_LOGFIlE:-"server.log"}
chown ${LMS_USER} ${LMS_LOGDIR}/${LMS_LOGFIlE:-"server.log"}
: > ${LMS_LOGDIR}/"perfmon.log"
chown ${LMS_USER} ${LMS_LOGDIR}/"perfmon.log"
