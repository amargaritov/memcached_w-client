#!/bin/bash -x

ps aux | grep redis- | awk '{print $2}' | sudo xargs kill -9 

#sleep 30
