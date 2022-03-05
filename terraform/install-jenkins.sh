#!/bin/bash

sudo yum update -y \
&& sudo yum install docker -y \
&& sudo usermod -aG docker ec2-user \
&& sudo systemctl enable docker \
&& sudo systemctl start docker

sudo chmod 666 /var/run/docker.sock

docker run --name jenkins -d -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker jenkins/jenkins:lts