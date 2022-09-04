#!/bin/bash

if [ -z "$(ls $NIFI_HOME)" ]; then
  tar zxf nifi-1.16.0-bin.tar.gz

  # replace host
  # volumeのアタッチ先だと権限問題でエラーになるため一度volume外にファイルを持ち出して置換する
  cp $NIFI_HOME/conf/nifi.properties .
  # nifi.web.https.host
  sed -i "151s/127.0.0.1/$NIFI_HOST/g" nifi.properties
  # nifi.web.proxy.host
  sed -i "158s/=/$NIFI_WEB_PROXY_HOST/g" nifi.properties
  mv nifi.properties $NIFI_HOME/conf/nifi.properties

  mv ./hive-site.xml $NIFI_HOME/conf/
fi

$NIFI_HOME/bin/nifi.sh start
