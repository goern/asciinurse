FROM fedora:22

MAINTAINER Christoph Görn <goern@b4mad.net>

LABEL Vendor="#B4mad.Net" License=GPLv2
LABEL Version=1.2.0

LABEL Build docker build --rm --tag goern/asciinurse:1.2.0 .

ENV container docker

RUN dnf install -y --setopt=tsflags=nodocs gcc-c++ rubygem-asciidoctor asciidoc fop docbook-xsl ditaa java-1.8.0-openjdk-devel ruby-devel && \
    dnf group install -y --setopt=tsflags=nodocs "Development Tools" && \
    dnf update -y --setopt=tsflags=nodocs && \
    dnf clean all

# we need this for some gem native extensions
ENV JAVA_HOME /etc/alternatives/java_sdk_1.8.0_openjdk

RUN gem install rjb coderay pygments.rb guard guard-shell guard-livereload rb-inotify rb-readline --no-rdoc --no-ri && \
    gem install --pre asciidoctor-diagram asciidoctor-pdf --no-ri --no-rdoc
RUN dnf group remove -y "Development Tools" && \
    dnf clean all 

RUN mkdir /etc/asciinurse.d
ADD Guardfile /etc/asciinurse.d/Guardfile
ADD asciidoc.conf /etc/asciidoc/asciidoc.conf

ENV PATH /usr/bin:/usr/local/bin:/etc/alternatives/java_sdk_1.8.0_openjdk

VOLUME /data
WORKDIR /data

EXPOSE 35729

CMD [ "guard", "-di", "--no-notify", "--watchdir", "/data", "--guardfile", "/etc/asciinurse.d/Guardfile" ]
