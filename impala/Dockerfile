FROM ubuntu_impala3.4.1

ARG IMPALA_HOME
RUN ln -s /home/impdev/Impala $IMPALA_HOME

RUN mkdir $IMPALA_HOME/conf
COPY ./set-classpath.sh $IMPALA_HOME/bin
COPY ./hdfs-site.xml $IMPALA_HOME/conf
COPY ./core-site.xml $IMPALA_HOME/conf
COPY ./mapred-site.xml $IMPALA_HOME/conf
COPY ./yarn-site.xml $IMPALA_HOME/conf
COPY ./hive-site.xml $IMPALA_HOME/conf
COPY ./tez-site.xml $IMPALA_HOME/conf

CMD /bin/bash

