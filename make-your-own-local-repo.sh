#!/bin/bash
sudo mkdir /usr/share/nginx/html/repo
sudo cp /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
sudo wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
sudo createrepo /usr/share/nginx/html/repo/
sudo sed -i -E "s/index.+index.html.+index.htm;/index index.html index.htm;\n        autoindex on;/"  /etc/nginx/conf.d/default.conf
sudo nginx -t
sudo nginx -s reload
sudo bash -c "echo -e \"[otus]\nname=otus-linux\nbaseurl=http://localhost/repo\ngpgcheck=0\nenabled=1\" >> /etc/yum.repos.d/otus.repo"
sudo yum install percona-release -y

