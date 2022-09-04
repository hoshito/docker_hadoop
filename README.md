# Hadoop動作環境構築

Dockerコンテナ上でHadoop関連のシステムを動かす。

## エコシステムのバージョン

- Hadoop 3.1.1
- Hive 3.1.3
- tez 0.9.1
- Impala 4.0.0
- HBase 2.4.6
- Spark 2.4.8
- Livy 0.6.0
- NiFi 1.16.0

バージョンは
[Cloudera Runtime 7.1.8 component versions](https://docs.cloudera.com/cdp-private-cloud-base/7.1.8/runtime-release-notes/topics/rt-pvc-runtime-component-versions.html) に合わせた。

## apache-impalaのビルド

impalaは自分でビルドする必要がある。Wikiのページ [apache impala 4.0.0ビルド手順](https://github.com/hoshito/docker_hadoop/wiki/apache-impala-4.0.0%E3%83%93%E3%83%AB%E3%83%89%E6%89%8B%E9%A0%86) を参考にすること。

## Docker起動

```
$ docker-compose up --build -d

# コンテナにログイン
$ docker-compose exec (main-container or impalad or nifi) bash
```

## エコシステムの実行

PATHが通っているためほとんどそのままコマンドを打てば良い。

### main-container

#### Hive

```
$ hive
hive> (hive command)
```

#### HBase

```
$ hbase shell
hbase(main):001:0> (hbase command)
```

#### Spark

```
$ spark-shell
scala>
```

サンプルプログラムの実行
```
$SPARK_HOME/bin/run-example SparkPi 10
```

#### Livy

host machineで http://localhost:8998 にアクセスするとUIが見られる。

Livyサーバの実行方法は以下。
```
$ $LIVY_HOME/bin/livy-server start
```

APIは https://livy.apache.org/docs/latest/rest-api.html を参考にすること。

### nifi

host machineで http://localhost:8080 にアクセスするとUIが見られる。

初期ユーザとパスワードはNiFiサーバ実行時に $NIFI_HOME/logs/nifi-app.log に表示される（"Generated"で検索）

#### NiFiのパスワード変更

変更後はNiFiサーバの再起動が必要。
```
$ $NIFI_HOME/bin/nifi.sh set-single-user-credentials <username> <password>
```

### impala

#### impala-shell

impaladを実行しているコンテナにログインして以下を実行。

```
$IMPALA_HOME/shell/build/impala-shell-3.4.1-RELEASE/impala-shell
[impalad:21000] default> (impala command)
```

hiveのmetastoreを利用しているためhiveで格納したデータも扱える。データが無いように見える場合はimpala-shell内で `INVALIDATE METADATA` を実行すること。
