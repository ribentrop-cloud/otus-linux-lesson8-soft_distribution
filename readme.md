## Описание решения.
### Cоздать свой RPM
Был собран nginx с поддержкой ssl по методичке.  
Был написан скрипт для provision секции для Vagrant _build-nginx-with-ssl.sh_
```sh
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
```
__Проверка__
1. Vagrant up
2. Как поднимется машина, для проверки можно набрать:
```sh
sudo systemctl status nginx
```
А так же 
```sh
sudo cat /root/rpmbuild/SPECS/nginx.spec | grep with-openssl
```
### Cоздать свой репо и разместить там свой RPM
Был реализован репозиторий по методичке.  
Был написан скрипт для provision секции для Vagrant _make-your-own-local-repo.sh_
```sh
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
```
__Проверка__
1. Vagrant up
2. Как поднимется машина, для проверки можно набрать:
```sh
curl -a http://localhost/repo/
```
