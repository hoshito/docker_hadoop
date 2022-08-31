FROM ubuntu:16.04

# download
RUN apt-get update && apt-get install -y \
  openjdk-8-jdk \
  ssh \
  sudo \
  vim \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG USER_HOME
RUN mkdir -p $USER_HOME
WORKDIR $USER_HOME

# RUN wget -O - https://archive.apache.org/dist/hadoop/core/hadoop-3.1.4/hadoop-3.1.4.tar.gz | tar zxf - && \
#     wget -O - https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz | tar zxf - && \
#     wget -O - https://dlcdn.apache.org/tez/0.9.2/apache-tez-0.9.2-bin.tar.gz | tar zxf - && \
#     wget -O - https://archive.apache.org/dist/hbase/2.2.7/hbase-2.2.7-bin.tar.gz | tar zxf - && \
#     wget -O - https://archive.apache.org/dist/spark/spark-2.4.8/spark-2.4.8-bin-without-hadoop.tgz | tar zxf -
COPY ./hadoop-3.1.4.tar.gz ./apache-hive-3.1.3-bin.tar.gz ./apache-tez-0.9.2-bin.tar.gz ./hbase-2.2.7-bin.tar.gz ./spark-2.4.8-bin-without-hadoop.tgz $USER_HOME
RUN find . \( -name "*.tar.gz" -or -name "*.tgz" \) -exec tar zxf {} \;

# ssh
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys && \
  ssh-keyscan -t rsa localhost >> ~/.ssh/known_hosts

ARG JAVA_HOME
ARG HADOOP_HOME
ARG HIVE_HOME
ARG TEZ_HOME
ARG HBASE_HOME
ARG SPARK_HOME

# symbolic link
RUN ln -s $USER_HOME/hadoop-3.1.4 $HADOOP_HOME && \
  ln -s $USER_HOME/apache-hive-3.1.3-bin $HIVE_HOME && \
  ln -s $USER_HOME/apache-tez-0.9.2-bin $TEZ_HOME && \
  ln -s $USER_HOME/hbase-2.2.7 $HBASE_HOME && \
  ln -s $USER_HOME/spark-2.4.8-bin-without-hadoop $SPARK_HOME

# fix guava version conflict
RUN rm $HIVE_HOME/lib/guava-* && \
  cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar $HIVE_HOME/lib/

# config file
COPY ./hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY ./core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY ./mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY ./yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY ./hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY ./hive-site.xml $HIVE_HOME/conf/hive-site.xml
COPY ./tez-site.xml $TEZ_HOME/conf/tez-site.xml
COPY ./hbase-env.sh $HBASE_HOME/conf
COPY ./hbase-site.xml $HBASE_HOME/conf
COPY ./spark-env.sh $SPARK_HOME/conf

CMD /bin/bash
