FROM registry.access.redhat.com/ubi8/ubi:8.3

LABEL description="A custom Apache container based on UBI 8"

RUN yum install -y httpd && \
    yum clean all

COPY ./index.html /var/www/html/

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]