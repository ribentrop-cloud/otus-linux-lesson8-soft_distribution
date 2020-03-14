#!/bin/bash
sudo yum install -y   redhat-lsb-core   wget   rpmdevtools   rpm-build   createrepo   yum-utils gcc
sudo wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
sudo rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
sudo wget https://www.openssl.org/source/latest.tar.gz
sudo tar -xvf latest.tar.gz
sudo yum-builddep -y /root/rpmbuild/SPECS/nginx.spec
sudo sed  -i -E  "s/--with-debug/--with-openssl=\/home\/vagrant\/openssl-1.1.1d \\\\\n    --with-debug/" /root/rpmbuild/SPECS/nginx.spec
sudo rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
sudo yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
sudo systemctl start nginx
sudo systemctl status nginx
