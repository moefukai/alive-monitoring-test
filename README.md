# このアプリについて
みんなが書くところ。
# 環境について
## 概要
### dockerとは
dockerとはコンテナを動かすためのサービス。
コンテナとはちっちゃいサーバーみたいなやつで、（今回は）中でlinuxが起動している。
### 考え方
dockerは実行環境として用いる。ローカルにあるコードをコンテナの中にマウントして実行する。
### 今回のコンテナ構成
3つのコンテナで構成する。
- appコンテナ -- phpを実行する
- webコンテナ -- webサーバー（nginx）を実行する、javascriptのビルドを行う
- dbコンテナ -- mysqlを実行する

これらをdocker-composeを使って連携している。
（今回は特にdocker-composeについては意識しなくて大丈夫だと思う。）
### 余裕があれば
- ちょっとアレンジしてるので全く同じではないけど、こちらが今回参考にしたものなので読んでおくといいかも。（[最強のLaravel開発環境をDockerを使って構築する【新編集版】](https://qiita.com/ucan-lab/items/5fc1281cd8076c8ac9f4)）
- Makefileについてちょっと勉強して目を通しておくと良いかも？（`make ~`コマンドの秘密が解ける。でもdocker-composeのコマンドの壁がある。）
- なにか不具合やわかんないことがあったら木之村まで。
### DBにリモート接続するとき
<img width="438" alt="スクリーンショット 2020-12-11 14 49 45" src="https://user-images.githubusercontent.com/50652793/101868180-1e1e6480-3bc0-11eb-81c0-9f70cfbdbf3e.png">

password: laravel


## 使い方
既にプロジェクトを作った状態（＝`composer create-project`した状態）になっているので、下の手順を踏んで⑤まで終了すればlaravelのトップページが見れます。
### 初回構築時
①docker, docker-composeをインストールする。
確認
```bash
docker --version
docker-compose --version
```
※Dockerが立ち上がっているか確認(Windows)(タスクバー下の「隠れているインジゲーターを表示」→Dockerのマークが"Docker is running..."になっていることを確認)
![image](https://user-images.githubusercontent.com/58587065/101975639-62256e00-3c81-11eb-95ef-2be3a1f7d469.png)


②おまじない
```bash
echo "export DOCKER_CONTENT_TRUST=1" >> ~/.bashrc
```
(zsh使ってる人は./zshrc)

③clone
```bash
git clone git@github.com:sdb-interns/your-project-name.git
```
このyour-project-nameには自分のプロジェクトを指定してね。

④環境変数
```
cd your-project-name
cp ./laravel/.env.example ./laravel/.env # 必要なものを設定
```
ここも自分のプロジェクトのディレクトリへ移動。環境変数は特に変更したりする必要はないと思う。ポート番号も競合しなさそうな番号に変えておいた。

⑤実行環境
※ここで、Windowsの人は[こちらのサイト](https://bluebirdofoz.hatenablog.com/entry/2019/10/24/221517)を見てGNUをインストールする
※Windowsの人は原因不明だけどpowershellだとうまくいかなかったのでcmdで実行
```bash(Winはcmd)
make init
```
全てのコンテナが立ち上がって、開発用のデータベースのcreate、migrate、seedまで完了する。
[127.0.0.1:48080](http://127.0.0.1:48080)これで表示されるはず。(`php artisan serve`はもう使わない。)

### 作業終了時
```bash
make down
```

### 作業再開時
```bash
make up
```

### その他のコマンド
全部Makefile見れば書いてある。もし「このコマンドいつも使うけど長くて打つの面倒くさい」とか「毎回このコマンド組み合わせて打ってるな」とかあったら追加すると便利になるよ〜。
```bash
# コンテナが起動中かどうか確認する。「state」が「up」になってたら起動中。docker勉強するとわかる
make ps

# php artisan migrate
make migrate

# php artisan migrate:fresh --seed
make fresh

# php artisan tinker
make tinker

# npm install
make npm

# npm run watch
make npm-watch

# appコンテナに入る
make app
```
