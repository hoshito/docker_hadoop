FROM ubuntu:xenial

RUN apt update
RUN apt install -y wget

# postgre
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt update
RUN apt install -y openjdk-8-jdk ssh vim sudo postgresql 

RUN mkdir /root/work
WORKDIR /root/work

# ssh
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys
RUN service ssh start && ssh-keyscan -t rsa localhost >> ~/.ssh/known_hosts

# ENV
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"
ENV HADOOP_HOME="/opt/hadoop-3.2.4"
ENV HIVE_HOME="/opt/apache-hive-3.1.3-bin"
ENV TEZ_HOME="/opt/apache-tez-0.9.2-bin"
ENV TEZ_CONF_DIR="${TEZ_HOME}/conf"
ENV TEZ_JARS="${TEZ_HOME}/*:${TEZ_HOME}/lib/*"
ENV HADOOP_CLASSPATH="${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*:${HADOOP_CLASSPATH}"
ENV CLASSPATH="$CLASSPATH:${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*"
ENV PATH="$PATH:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${HIVE_HOME}/bin"

# hadoop
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.4/hadoop-3.2.4.tar.gz
RUN tar -zxf hadoop-3.2.4.tar.gz
RUN ln -s /root/work/hadoop-3.2.4 $HADOOP_HOME
COPY ./hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY ./core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY ./mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY ./yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY ./hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN hdfs namenode -format

# hive
RUN wget https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
RUN tar -zxf apache-hive-3.1.3-bin.tar.gz
RUN ln -s /root/work/apache-hive-3.1.3-bin $HIVE_HOME
COPY ./hive-site.xml $HIVE_HOME/conf/hive-site.xml

# tez
RUN wget https://dlcdn.apache.org/tez/0.9.2/apache-tez-0.9.2-bin.tar.gz
RUN tar -zxf apache-tez-0.9.2-bin.tar.gz
RUN ln -s /root/work/apache-tez-0.9.2-bin $TEZ_HOME
COPY ./tez-site.xml $TEZ_HOME/conf/tez-site.xml

# fix guava version conflict
RUN rm $HIVE_HOME/lib/guava-*
RUN cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar $HIVE_HOME/lib/

RUN wget https://dlcdn.apache.org/impala/3.4.1/apache-impala-3.4.1.tar.gz
RUN tar -zxf apache-impala-3.4.1.tar.gz

RUN apt install -y lsb-release
COPY ./bootstrap_system.sh /root/work/apache-impala-3.4.1/./bin/bootstrap_system.sh


COPY ./init.sh /root/work/init.sh
CMD service ssh start && /bin/bash

