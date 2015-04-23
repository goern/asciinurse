FROM fedora:21
MAINTAINER Christoph Görn <goern@b4mad.net>

LABEL Vendor="#B4mad.Net" License=GPLv2
LABEL Version=1.0.2

ENV container docker

RUN yum install -y gcc-c++ rubygem-asciidoctor asciidoc fop ditaa java-1.8.0-openjdk-devel ruby-devel && \
    yum group install -y "Development Tools" && \
    yum update -y && \
    yum clean all 

# we need this for some gem native extensions
ENV JAVA_HOME /etc/alternatives/java_sdk_1.8.0_openjdk

RUN gem install coderay rjb asciidoctor-diagram guard guard-shell guard-livereload rb-inotify rb-readline --no-rdoc --no-ri
RUN yum erase -y make && yum group remove -y "Development Tools" && \
    yum clean all 

RUN mkdir /etc/asciinurse.d
ADD Guardfile /etc/asciinurse.d/Guardfile

ENV PATH /usr/bin:/usr/local/bin:/etc/alternatives/java_sdk_1.8.0_openjdk

VOLUME /data
WORKDIR /data

CMD [ "guard", "-di", "--no-notify", "--watchdir", "/data", "--guardfile", "/etc/asciinurse.d/Guardfile" ]

