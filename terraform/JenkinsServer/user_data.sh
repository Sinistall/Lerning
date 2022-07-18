#!/bin/bash
apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin 
apt install docker.io curl
docker run -p 8080:8080 --name=jenkins-master -d jenkins/jenkins