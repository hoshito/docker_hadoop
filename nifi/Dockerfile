FROM ubuntu:16.04

# download
RUN apt-get update && apt-get install -y \
  openjdk-8-jdk \
  vim \
  wget \
  && apt-get clean

ARG USER_HOME
RUN mkdir -p $USER_HOME
WORKDIR $USER_HOME

# RUN wget https://archive.apache.org/dist/nifi/1.16.0/nifi-1.16.0-bin.tar.gz
COPY nifi-1.16.0-bin.tar.gz $USER_HOME

# symbolic link
ARG USER_HOME
ARG NIFI_HOME
RUN ln -s $USER_HOME/nifi-1.16.0 $NIFI_HOME

COPY hive-site.xml init.sh $USER_HOME

CMD /bin/bash
