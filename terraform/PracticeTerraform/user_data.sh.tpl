#!/bin/bash
sudo yum update
sudo amazon-linux-extras install nginx1 -y

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /usr/share/nginx/html/index.html
<html>
<body bgcolor="black">
<h2><font color="green">${ENV} with Ip: $myip</h2><br>
</body>
</html>
EOF

sudo service nginx start
chkconfig nginx on
