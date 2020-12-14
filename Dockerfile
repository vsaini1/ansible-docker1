From centos
RUN yum -y install httpd
RUN yum clean all
COPY index.html /var/www/html/index.html
COPY run.sh run.sh
CMD ./run.sh
