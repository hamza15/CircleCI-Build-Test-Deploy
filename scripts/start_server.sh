#!/bin/bash
touch /home/ubuntu/test.txt
pwd > /home/ubuntu/test.txt
cd /home/ubuntu/app/
sudo nohup python3 hello_world.py > /dev/null 2> /dev/null < /dev/null &
