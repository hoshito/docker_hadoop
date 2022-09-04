FROM ubuntu_impala4.0.0

ARG IMPALA_HOME
RUN ln -s /home/impdev/Impala $IMPALA_HOME

RUN mkdir $IMPALA_HOME/conf
COPY set-classpath.sh $IMPALA_HOME/bin
COPY hdfs-site.xml core-site.xml hive-site.xml $IMPALA_HOME/conf/

CMD /bin/bash
