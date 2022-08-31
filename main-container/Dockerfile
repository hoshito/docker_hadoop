FROM ubuntu:16.04

# apt-get
RUN apt-get update && apt-get install -y \
  openjdk-8-jdk \
  ssh \
  unzip \
  vim \
  wget \
  && apt-get clean

ARG USER_HOME
RUN mkdir -p $USER_HOME
WORKDIR $USER_HOME

# download
# RUN wget -O - https://archive.apache.org/dist/hadoop/core/hadoop-3.1.4/hadoop-3.1.4.tar.gz | tar zxf - && \
#     wget -O - https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz | tar zxf - && \
#     wget -O - https://dlcdn.apache.org/tez/0.9.2/apache-tez-0.9.2-bin.tar.gz | tar zxf - && \
#     wget -O - https://archive.apache.org/dist/hbase/2.2.7/hbase-2.2.7-bin.tar.gz | tar zxf - && \
#     wget -O - https://archive.apache.org/dist/spark/spark-2.4.8/spark-2.4.8-bin-without-hadoop.tgz | tar zxf -
#     wget -O - https://archive.apache.org/dist/incubator/livy/0.6.0-incubating/apache-livy-0.6.0-incubating-bin.zip | unzip -
COPY hadoop-3.1.4.tar.gz \
  apache-hive-3.1.3-bin.tar.gz \
  apache-tez-0.9.2-bin.tar.gz \
  hbase-2.2.7-bin.tar.gz \
  spark-2.4.8-bin-without-hadoop.tgz \
  apache-livy-0.6.0-incubating-bin.zip \
  $USER_HOME
RUN find -maxdepth 1 \( -name "*.tar.gz" -or -name "*.tgz" \) -exec tar zxf {} \; && \
  find -maxdepth 1 -name "*.zip" -exec unzip {} \; && \
  rm -f *.tar.gz *.tgz *.zip

# ssh
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys && \
  ssh-keyscan -t rsa localhost >> ~/.ssh/known_hosts

# args
ARG JAVA_HOME
ARG HADOOP_HOME
ARG HIVE_HOME
ARG TEZ_HOME
ARG HBASE_HOME
ARG SPARK_HOME
ARG LIVY_HOME

# symbolic link
RUN ln -s $USER_HOME/hadoop-3.1.4 $HADOOP_HOME && \
  ln -s $USER_HOME/apache-hive-3.1.3-bin $HIVE_HOME && \
  ln -s $USER_HOME/apache-tez-0.9.2-bin $TEZ_HOME && \
  ln -s $USER_HOME/hbase-2.2.7 $HBASE_HOME && \
  ln -s $USER_HOME/spark-2.4.8-bin-without-hadoop $SPARK_HOME && \
  ln -s $USER_HOME/apache-livy-0.6.0-incubating-bin $LIVY_HOME

# fix guava version conflict
RUN rm $HIVE_HOME/lib/guava-* && \
  cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar $HIVE_HOME/lib/

# config file
COPY hdfs-site.xml core-site.xml mapred-site.xml yarn-site.xml hadoop-env.sh $HADOOP_HOME/etc/hadoop/
COPY hive-site.xml $HIVE_HOME/conf/
COPY tez-site.xml $TEZ_HOME/conf/
COPY hbase-env.sh hbase-site.xml $HBASE_HOME/conf/
COPY spark-env.sh $SPARK_HOME/conf/

CMD /bin/bash
