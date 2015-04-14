FROM fedora:21
MAINTAINER Christoph Görn <goern@redhat.com>

LABEL Vendor="Red Hat" License=GPLv2
LABEL Version=1.0

ENV container docker

RUN yum install -y rubygem-asciidoctor asciidoc fop ditaa java-1.8.0-openjdk-devel ruby-devel && \
    yum group install -y "Development Tools" && \
    yum update -y && \
    yum clean all 

# we need this for some gem native extensions
ENV JAVA_HOME /etc/alternatives/java_sdk_1.8.0_openjdk

RUN gem install coderay rjb asciidoctor-diagram guard guard-shell rb-inotify rb-readline --no-rdoc --no-ri
RUN yum erase -y make && yum group remove -y "Development Tools" && \
    yum clean all 

ENV PATH /usr/bin:/usr/local/bin:/etc/alternatives/java_sdk_1.8.0_openjdk

VOLUME /data
WORKDIR /data

CMD [ "guard", "-di", "--no-notify" ]
