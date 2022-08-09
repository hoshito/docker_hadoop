# apache-impala-3.4.1のビルド

## ビルド手順

### 参考ページ

- [ダウンロードページ](https://impala.apache.org/downloads.html)にある[the wiki for build instructions](https://cwiki.apache.org/confluence/display/IMPALA/Building+Impala)
- [実行シェルのコメント](https://github.com/apache/impala/blob/master/bin/bootstrap_development.sh#L30-L38)
  - Dokcerコンテナ上で実行する際に必要

### コマンド

```
$ docker run --privileged -it [Docker Image Name] /bin/bash
$ apt-get update
$ apt-get install sudo
$ adduser --disabled-password --gecos '' impdev
$ echo 'impdev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
```

結果はエラー。詳細はbuild_fail.logを参照

## ビルドエラーになった原因

### 参考ページ

- https://en.javamana.com/2022/201/202207201102134606.html

> Is it maven Yes bug？ So I looked at what I used maven edition , It's really different . The environment in question is apache-maven-3.6.1, The environment that can compile normally is apache-maven-3.6.2. 

mavenのバグで古いバージョンだと正常にビルドできない可能性がある

## その他の懸念

- ビルドに時間がかかりすぎる
  - エラーまで少なくとも5時間以上はかかっている
  - 特に依存ライブラリのダウンロードに時間がかかっている（build_fail.logの下のあたりで2h30mかかっている）

```
2022-08-09 12:29:35,907 Thread-3 INFO: Extracting gcc-4.9.2-gcc-4.9.2-ec2-package-ubuntu-16-04.tar.gz
2022-08-09 12:29:39,508 Thread-3 INFO: Downloading https://native-toolchain.s3.amazonaws.com/build/cdh_components/1814051/tarballs/hadoop-3.0.0-cdh6.x-SNAPSHOT.tar.gz to /home/impdev/apache-impala-3.4.1/toolchain/cdh_components-1814051/hadoop-3.0.0-cdh6.x-SNAPSHOT.tar.gz (attempt 1)
2022-08-09 13:54:22,350 Thread-4 INFO: Extracting llvm-5.0.1-p2-gcc-4.9.2-ec2-package-ubuntu-16-04.tar.gz
2022-08-09 13:54:33,636 Thread-4 INFO: Downloading https://native-toolchain.s3.amazonaws.com/build/cdh_components/1814051/tarballs/hbase-2.1.0-cdh6.x-SNAPSHOT.tar.gz to /home/impdev/apache-impala-3.4.1/toolchain/cdh_components-1814051/hbase-2.1.0-cdh6.x-SNAPSHOT.tar.gz (attempt 1)
2022-08-09 14:11:56,450 Thread-3 INFO: Extracting hadoop-3.0.0-cdh6.x-SNAPSHOT.tar.gz
2022-08-09 14:12:00,435 Thread-3 INFO: Downloading https://native-toolchain.s3.amazonaws.com/build/cdh_components/1814051/tarballs/hive-2.1.1-cdh6.x-SNAPSHOT.tar.gz to /home/impdev/apache-impala-3.4.1/toolchain/cdh_components-1814051/hive-2.1.1-cdh6.x-SNAPSHOT.tar.gz (attempt 1)
2022-08-09 14:12:02,657 Thread-5 INFO: Extracting llvm-5.0.1-asserts-p2-gcc-4.9.2-ec2-package-ubuntu-16-04.tar.gz
2022-08-09 14:12:18,378 Thread-5 INFO: Downloading https://native-toolchain.s3.amazonaws.com/build/cdh_components/1814051/tarballs/sentry-2.1.0-cdh6.x-SNAPSHOT.tar.gz to /home/impdev/apache-impala-3.4.1/toolchain/cdh_components-1814051/sentry-2.1.0-cdh6.x-SNAPSHOT.tar.gz (attempt 1)
2022-08-09 15:00:48,497 Thread-3 INFO: Extracting hive-2.1.1-cdh6.x-SNAPSHOT.tar.gz
2022-08-09 15:00:54,613 Thread-3 INFO: Downloading https://native-toolchain.s3.amazonaws.com/build/cdp_components/1617729/tarballs/ranger-2.0.0.7.0.2.0-212-
```

- ビルド後のサイズが心配
  - 正確にサイズを測定したわけではないが、上記のように時間のかかるライブラリをダウンロードしているためサイズが大幅に増えている可能性がある
  - 他の環境でビルドしたものを移動させる際にも時間がかかったりサイズの制限を気にする必要がある

