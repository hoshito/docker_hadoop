# apache-impala-3.4.1ビルド手順

Dockerfileで構築したhive_on_tez環境でビルドを実行すると失敗したが、素のubuntu:16.04からビルドすると成功する。
ImpalaをビルドするとHadoopやHiveなどもついてくる。
そのためImpalaを先にビルドしてコンテナをcommitしたあとに、HadoopやHiveなどのエコシステムを新しいバージョンに置き換えた方が良さそう。

## 手順

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
IMPALA_HOME/bin/bootstrap_system.sh
source IMPALA_HOME/bin/impala-config.sh
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
source IMPALA_HOME/bin/impala-config.sh
IMPALA_HOME/bin/create-test-configuration.sh -create_metastore -create_sentry_policy_db
IMPALA_HOME/bin/start-impala-cluster.py
```

### host machine

```
docker commit impala-dev
```

## 参考ページ
https://cwiki.apache.org/confluence/display/IMPALA/Impala+Development+Environment+inside+Docker

ページ内の"or"で区切られているコマンドのうちbootstrap_development.shの方を実行すると
検証用のテストデータをダウンロードするのでコンテナのサイズが大きく上がるうえにテストが途中で失敗してしまう

- 18.29GB → 55.41GBにコンテナのサイズが上がる

