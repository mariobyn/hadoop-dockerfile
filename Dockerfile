#Docker file for hadoop
FROM mariobyn/debian:java8

MAINTAINER Baisan Marius baisan.marius@gmail.com

USER root

#Install ssh
RUN sudo apt-get -y install openssh-client
RUN sudo sudo apt-get -y install openssh-server
RUN mkdir /var/run/sshd

# passwordless ssh
RUN ssh-keygen -q -N  "" -t dsa -f /etc/ssh/ssh_host_dsa_key -y
RUN ssh-keygen -q -N  "" -t rsa -f /etc/ssh/ssh_host_rsa_key -y
RUN ssh-keygen -q -N  "" -t rsa -f /root/.ssh/id_rsa 
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys 

#Download Hadoop & unzip
RUN wget http://apache.mirrors.ionfish.org/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz && tar xvzf hadoop-2.6.0.tar.gz && sudo mv hadoop-2.6.0 /usr/lib/hadoop && cd /usr/lib  

ENV HADOOP_PREFIX /usr/lib/hadoop
ENV HADOOP_COMMON_HOME /usr/lib/hadoop
ENV HADOOP_HDFS_HOME /usr/lib/hadoop
ENV HADOOP_MAPRED_HOME /usr/lib/hadoop
ENV HADOOP_YARN_HOME /usr/lib/hadoop
ENV HADOOP_CONF_DIR /usr/lib/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

RUN export JAVA_HOME=/usr/lib/jvm/java-8-oracle && export HADOOP_INSTALL=/usr/lib/hadoop && export PATH=$PATH:$HADOOP_INSTALL/bin && export PATH=$PATH:$HADOOP_INSTALL/sbin
RUN export HADOOP_MAPRED_HOME=$HADOOP_INSTALL && export HADOOP_COMMON_HOME=$HADOOP_INSTALL && export HADOOP_HDFS_HOME=$HADOOP_INSTALL && export YARN_HOME=$HADOOP_INSTALL
RUN export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native && export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib" && export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native && export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

RUN mkdir $HADOOP_PREFIX/tmp

ADD core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
ADD mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

RUN mkdir -p /usr/lib/hadoop_store/hdfs/namenode
RUN mkdir -p /usr/lib/hadoop_store/hdfs/datanode

ADD hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml

ADD bootstrap.sh /etc/bootstrap.sh
ADD bash_profile /etc/bash_profile

RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

RUN chmod 777 $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh


ENV BOOTSTRAP /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh", "-bash"]

EXPOSE 50020 50090 50070 50010 50075 8031 8032 8033 8040 8042 49707 22 8088 8030 19888