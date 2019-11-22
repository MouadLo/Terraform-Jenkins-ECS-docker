#!/bin/bash

# volume setup
vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then 
  # wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done
  pvcreate ${DEVICE}
  vgcreate data ${DEVICE}
  lvcreate --name volume1 -l 100%FREE data
  mkfs.ext4 /dev/data/volume1
fi

mkdir -p /var/lib/jenkins
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
mount /var/lib/jenkins

# jenkins repository
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

# install dependencies
sudo yum update -y
sudo yum remove -y java
sudo yum install java-1.8.0 -y
sudo yum install java-1.8.0-openjdk -y

# install jenkins
sudo yum install jenkins unzip git -y

# Start jenkins
sudo service jenkins start
sudo chkconfig jenkins on

# install terraform
sudo wget -q https://releases.hashicorp.com/terraform/0.12.15/terraform_0.12.15_linux_amd64.zip \
&& sudo unzip -o terraform_0.12.15_linux_amd64.zip -d /usr/local/bin \
&& sudo rm terraform_0.12.15_linux_amd64.zip

# install packer
cd /usr/local/
sudo wget -q https://releases.hashicorp.com/packer/1.4.5/packer_1.4.5_linux_amd64.zip \
&& sudo unzip packer_1.4.5_linux_amd64.zip  \
&& sudo rm packer_1.4.5_linux_amd64.zip \
&& sudo ln -s /usr/local/packer /usr/bin/packer.io

# install docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user 
sudo usermod -a -G docker jenkins

# clean up
sudo yum clean all

