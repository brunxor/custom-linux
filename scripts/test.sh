#!/bin/bash
PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

echo "Root password:"
su -c " echo '$USER  ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers" 

sudo su -

ll /root/.ssh
