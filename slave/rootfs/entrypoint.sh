#!/bin/bash
set -x

mkdir -p /var/log/supervisor/ 

_slaveService=${SLAVE_SERVICE:-jnlp}
_confFilePrefix=/etc/supervisor/conf.d/jenkins-

if [ -f ${_confFilePrefix}${_slaveService}.conf.disable ]; then
  mv ${_confFilePrefix}${_slaveService}.conf.disable ${_confFilePrefix}${_slaveService}.conf
fi

_cleanupPeriodic=${CLEANUP_PERIODIC:-weekly}

if [ -f "/etc/cron.${_cleanupPeriodic}/jenkins-clean-data.sh" ]; then
  ln -s /usr/local/bin/jenkins-clean-data.sh /etc/cron.${_cleanupPeriodic}/jenkins-clean-data.sh
fi

# start superviosrd
supervisord --nodaemon --configuration /etc/supervisord.conf
