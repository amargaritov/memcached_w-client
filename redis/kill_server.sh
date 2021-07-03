#!/bin/bash -x

ps aux | grep redis- | awk '{print $2}' | sudo xargs kill -9 
sudo service redis stop

#sleep 30
