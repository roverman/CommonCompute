#!/bin/bash -x

## Install Rstudio server
wget https://download2.rstudio.org/rstudio-server-rhel-0.99.878-x86_64.rpm
yum install --nogpgcheck rstudio-server-rhel-0.99.878-x86_64.rpm

## Copy Rstudio configuration file
cp /home/ec2-user/rserver.conf /etc/rstudio/rserver.conf

## Restart Rstudio server
rstudio-server restart


