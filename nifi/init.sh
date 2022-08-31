#!/bin/bash

tar zxf nifi-1.13.2-bin.tar.gz
sed -i "143s/127.0.0.1/$NIFI_HOST/g" $NIFI_HOME/conf/nifi.properties
cp ./hive-site.xml $NIFI_HOME/conf/
