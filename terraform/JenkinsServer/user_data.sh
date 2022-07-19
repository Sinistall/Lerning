#!/bin/bash
apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin 
apt install docker.io curl

#If you need to terminate instance and after start, you should create new image and push it to dockerhub, after run container with this image
docker run -p 8080:8080 --name=jenkins-master -d jenkins/jenkins # jenkins/jenkins -> your image if you pushed it

# Run container after reboot
cat <<EOF > /home/ubuntu/run_container.sh
#!/bin/bash
docker start jenkins-master
EOF
chmod +x /home/ubuntu/run_container.sh
echo "@reboot /home/ubuntu/run_container.sh" >> /var/spool/cron/crontabs/root