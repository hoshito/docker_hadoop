#!/bin/bash
start-dfs.sh
start-yarn.sh
hdfs dfs -mkdir -p /user/root
hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse
hadoop fs -mkdir -p /apps/tez
hadoop fs -put $TEZ_HOME/share/tez.tar.gz /apps/tez

pg_ctlcluster 13 main start
sudo -u postgres psql -c "CREATE USER hive WITH PASSWORD 'hive';" 
sudo -u postgres createdb -O hive hive
#rm apache-hive-3.1.3-bin/lib/guava-*
#cp hadoop-3.2.4/share/hadoop/hdfs/lib/guava-27.0-jre.jar apache-hive-3.1.3-bin/lib/
$HIVE_HOME/bin/schematool -dbType postgres -initSchema


