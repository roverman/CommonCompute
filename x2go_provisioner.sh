#!/bin/bash -x

# Update centos
yum update

# Install x2goserver and sessions
yum install --enablerepo=epel x2goserver
yum install --enablerepo=epel x2goserver-xsession

# Install GNOME desktop components
yum -y groupinstall "Desktop" "Desktop Platform" "X Window System" "Fonts"

# You can also install the following optional GUI packages.
yum -y groupinstall "Graphical Administration Tools"
yum -y groupinstall "Internet Browser"
yum -y groupinstall "General Purpose Desktop"
yum -y groupinstall "Office Suite and Productivity"
yum -y groupinstall "Graphics Creation Tools"

# Finally, if you want to add the K Desktop Environment (KDE).
yum -y groupinstall kde-desktop
