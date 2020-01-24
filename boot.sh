#!/bin/sh


if [ "$START_SSH" == "true" ]
then
  # start ssh server
  echo "ssh server is starting"
  /usr/sbin/sshd
fi


if [ "$START_RSTUDIO" == "true" ]
then
  # start rstudio server
  echo "rstudio server is starting"
  rstudio-server start
fi


if [ "$START_SHINY" == "true" ]
then
  # start shiny server
  echo "shiny server is starting"
  if [ "$APPLICATION_LOGS_TO_STDOUT" != "false" ]
  then
      # push the "real" application logs to stdout with xtail in detached mode
      exec xtail /var/log/shiny-server/ &
  fi
  exec shiny-server 2>&1
else
  # Infinite loop for container never stop when not shiny
  tail -f /dev/null
fi
