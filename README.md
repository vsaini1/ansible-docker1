# ansible-docker1
There are 3 servers, 1#Ansible control node, 2#docker host and 3#Jenkins
On Dockerhost(2#), install python-docker-pycreds and python-docker-py rpms
2# rpm -qa|grep -i docker-py
1# vi pull-image.yml
- name: pull centos image
  hosts: dockerhost
  tasks:
  - name: pull
    docker_image:
      name: centos

1# ansible-playbook pull_image.yml
2# docker images
1# vi create-image.yml
- name: Create web image
  hosts: dockerhost
  tasks:
  - name: Build image
    docker_image:
	path: /root/dockers
	name: webimage

2# cd /root/dockers
cat Dockerfile
From centos
RUN yum -y install httpd
RUN yum clean all
COPY index.html /var/www/html/index.html
COPY run.sh run.sh
CMD ./run.sh

cat index.html
Looks Good
cat run.sh
exec /usr/sbin/apachectl -D FOREGROUND

1# ansible-playbook create_image.yml
2# docker images
1# vi create_container.yml
- name: Create container
  hosts: dockerhost
  tasks:
  - name: web container
    docker_container
      name: web
      image: webimage
      state: started
      ports:
      - "8080:80"
      tty: true
      detach: true

1# ansible-playbook create_container.yml
2# docker ps

Check http://localhost:8080

1# vi dockerhost_validator.yml
- name: validator
  hosts: localhost
  connection: local
  tasks:
  - name: validate docker container
    uri:
      url: http://dockerhost:8080
      return_content: yes
    register: returnitem
    failed_when: "'Look Good' not in returnvalue.content"

1# ansible-playbook dockerhost_validator.yml
2# Clean dockerhost, docker rmi cenos webimage; docker stop id; docker rm id;
3# On Jenkins GUI, setup pipeline and run pipeline
