# This Dockerfile is to build an image to install Zookeeper
# Version 3.4.5
# Author: Sa Li

FROM alecinvan/supervisor
MAINTAINER Sa Li "sa@pof.com"

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update

# Install curl
RUN apt-get install -y curl

# Adding webupd8team ppa
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main\ndeb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" >>  /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv EEA14886
RUN apt-get update

# Install Java 7
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# RUN apt-get install -y oracle-java7-installer
RUN apt-get install -y openjdk-7-jre
RUN apt-get install -y openjdk-7-jdk
RUN alias ll='ls -l'
RUN apt-get install nano
RUN apt-get update

# Set the environment variables
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64


# Zookeeper dir
# RUN mkdir -p /var/run/zookeeper
# RUN echo "1" > /var/run/zookeeper/myid
# RUN cat /var/run/zookeeper/myid

RUN locale-gen en_CA en_CA.UTF-8

# Downloading zookeeper 3.4.5
RUN apt-get update
RUN apt-get install -y zookeeper

ADD zoo.cfg /etc/zookeeper/conf/zoo.cfg
RUN chmod +x /usr/share/zookeeper/bin/zkServer.sh

EXPOSE 2181 2888 3888

# Run cron job
ADD cron.conf /etc/zookeeper/conf/cron.conf
RUN crontab /etc/zookeeper/conf/cron.conf

WORKDIR /usr/share/zookeeper
VOLUME ["/var/run/zookeeper"]

# Run supervisord to start zookeeper
#ADD zk-supervisor.conf /etc/supervisor/zk-supervisor.conf
#RUN cat /etc/supervisor/supervisord.conf /etc/supervisor/zk-supervisor.conf > /etc/supervisor/supervisord.conf1
#RUN rm -f /etc/supervisor/supervisord.conf && mv /etc/supervisor/supervisord.conf1 /etc/supervisor/supervisord.conf
#RUN supervisord
#ADD bin/zookeeper-run.sh /usr/local/bin/zookeeper-run.sh
#CMD ["/bin/sh", "-e", "/usr/local/bin/zookeeper-run.sh"]


# RUN zookeeper without supervisor 
ENTRYPOINT ["/usr/share/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]


 
