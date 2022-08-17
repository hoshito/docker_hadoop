# Hadoop動作環境構築

1つのコンテナ上でHadoop関連のシステムを動かす。

## エコシステムのバージョン

- Hadoop 3.2.4
- Hive 3.1.3
- tez 0.9.2
- Impala 3.4.1

## apache-impala-3.4.1ビルド手順

impalaは自分でビルドする必要がある。

### host machine

```
docker run --cap-add SYS_TIME --interactive --tty --name impala-dev -p 25000:25000 -p 25010:25010 -p 25020:25020 ubuntu:16.04 bash
```

### Docker(user: root)

```
apt-get update
apt-get install sudo
adduser --disabled-password --gecos '' impdev
echo 'impdev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
su - impdev
```

### Docker(user: impdev)

```
sudo apt-get --yes install git
git clone https://git-wip-us.apache.org/repos/asf/impala.git ~/Impala
cd ~/Impala
git checkout 3.4.1
export IMPALA_HOME=`pwd`
$IMPALA_HOME/bin/bootstrap_system.sh
source $IMPALA_HOME/bin/impala-config.sh
exit
```

### Docker(user: root)

```
service ssh start
su - impdev
```

### Docker(user: impdev)

```
cd ~/Impala
export IMPALA_HOME=`pwd`
source $IMPALA_HOME/bin/impala-config.sh
$IMPALA_HOME/bin/create-test-configuration.sh -create_metastore -create_sentry_policy_db
$IMPALA_HOME/testdata/bin/run-all.sh
$IMPALA_HOME/bin/start-impala-cluster.py
```

### host machine

```
docker commit ubuntu_impala3.4.1
```

### 参考ページ
https://cwiki.apache.org/confluence/display/IMPALA/Impala+Development+Environment+inside+Docker

ページ内の"or"で区切られているコマンドのうちbootstrap_development.shの方を実行すると
検証用のテストデータをダウンロードするのでコンテナのサイズが大きく上がるうえにテストが途中で失敗してしまう

- 18.29GB → 55.41GBにコンテナのサイズが上がる

## Docker起動

impalaをビルドした後は以下の手順でDockerを起動。

### host machine

```
docker build -t hadoop_dev ./
docker run -it --name hadoop_dev hadoop_dev:latest /bin/bash
```
Dockerのイメージサイズは36.14GBになる。

### Docker(user: root)

```
cat init.txt
```
でてきたコマンドを手動でコピペして実行

#### impala-shellの起動
```
$IMPALA_HOME/shell/build/impala-shell-3.4.1-RELEASE/impala-shell
```