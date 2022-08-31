#!/bin/bash

# 初回立ち上げのみ実行
# コマンドごとに実行したいタイミングが異なるため, 以後何度かこの判定を行う
if [ -f .init_run_docker ]; then
  hdfs namenode -format
fi

# ssh
service ssh start

# hadoop
start-dfs.sh
start-yarn.sh

if [ -f .init_run_docker ]; then
  hdfs dfs -mkdir -p /user/root /tmp /user/hive/warehouse /apps/tez
  hdfs dfs -chmod g+w /tmp /user/hive/warehouse
  hdfs dfs -put $TEZ_HOME/share/tez.tar.gz /apps/tez
  $HIVE_HOME/bin/schematool -dbType postgres -initSchema
fi

# hive
hive --service metastore &

# hbase
$HBASE_HOME/bin/start-hbase.sh

# livy
$LIVY_HOME/bin/livy-server start

# 2回目以降実行されないようにフラグファイルを削除
if [ -f .init_run_docker ]; then
  rm .init_run_docker
fi

bash
