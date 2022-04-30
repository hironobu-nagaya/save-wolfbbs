save-wolfbbs
============

概要
----

[人狼BBS](http://ninjinix.com/) の過去ログを HTML ファイルとしてローカルに保存します。

注意
----

このスクリプトは [人狼BBS](http://ninjinix.com/) の作者 ninjin 氏及び、  
[JinArchiver](https://ja.osdn.net/projects/jindolf/scm/git/JinArchiver/) の作者 Olyutorskii 氏は一切関与していません。  
**このスクリプト及びその出力に関する問い合わせを両氏に対して絶対行わないで下さい！**

依存関係
--------

このスクリプトは、以下のパッケージに依存しています。

* [Java](https://www.java.com/) （ [JinArchiver](https://ja.osdn.net/projects/jindolf/scm/git/JinArchiver/) 実行に必要）
* [GNU Wget](https://www.gnu.org/software/wget/) ※
* [curl](https://curl.se/) ※

※ どちらか一方があれば十分です

使い方
------

```sh
./save-wolfbbs [村番号]...
```

### 村番号

村番号は、国名を表すプレフィックスに半角英数字を続けた番号です。

公式の呼称  | まとめサイトでの呼称 | プレフィックス
:---------- | :------------------- | :-------------
人狼BBS:G   | G国                  | G
人狼BBS:F   | F国                  | F
人狼BBS:E   | E国                  | E
人狼BBS:D   | D国                  | D
人狼BBS:C   | C国                  | C
人狼BBS:B   | B国                  | B
人狼BBS:A   | A国                  | A
人狼BBS     | 本国                 | 0（ゼロ）
旧人狼BBS 2 | 前の国               | （なし）

※ [旧人狼BBS 1](http://ninjinix.x0.com/wolf_old/), [人狼BBS:Z](https://ninjinix.x0.com/wolfz/) は対応していません

### 環境変数

環境変数名 | 説明                                                     | デフォルト値
:--------- | :------------------------------------------------------- | :-----------
WORK_DIR   | 作業ディレクトリ                                         | `.`
JAR_DIR    | JinArchiver の jar ファイル格納先ディレクトリ            | `$WORK_DIR/jar`
XML_DIR    | JinArchiver が出力する XML ファイル格納先ディレクトリ    | `$WORK_DIR/xml`
WWW_DIR    | XML ファイルから生成する HTML ファイル格納先ディレクトリ | `$WORK_DIR/www`

代表的な環境変数のみを記載しています。  
詳細はスクリプト冒頭をご確認下さい。

### 実行例

コマンド                                           | 動作
:------------------------------------------------- | :---
`./save-wolfbbs F2181`                             | カレントディレクトリ配下に F2181 村のログを保存します。
`WORK_DIR=/srv/wolfbbs ./save-wolfbbs F2209 F2223` | /srv/wolfbbs 配下に F2209, F2223 村のログを保存します。

FAQ
----

### ブラウザ閲覧時の表示の幅が広すぎます

CSS の body セレクタの内容を修正して下さい。  
CSS ファイルは `$WWW_DIR/plugin_wolf/css/wolfbbs.css` です。

オリジナルと同じように幅を 500px で固定したい場合、  
以下のように設定すると良いでしょう。

```css
body {
  margin: auto;
  width: 500px;
  background: #000000;
}
```

### ログを一括で取得したい

以下のコマンドで各国の村のログを一括で取得できます。   
多少なりともサーバの負担になるかと思いますので、  
ピーク時は避けるなど負荷分散にご協力下さい。

```sh
./save-wolfbbs `seq 2087 | awk '{printf("G%03d ",$0)}'`                # G国（ G001 ～ G2087 ）
./save-wolfbbs `seq 100 2232 | awk '{if (!/1945|1973/) print "F" $0}'` # F国（ F100 ～ F2232、 F1945, F1973 は欠番）
./save-wolfbbs `seq 100 199 | sed 's/^/E/'`                            # E国（ E100 ～ E199 ）
./save-wolfbbs `seq 100 703 | sed 's/^/D/'`                            # D国（ D100 ～ D703 ）
./save-wolfbbs `seq 100 1435 | sed 's/^/C/'`                           # C国（ C100 ～ C1435 ）
./save-wolfbbs `seq 100 182 | awk '{if (!/149/) print "B" $0}'`        # B国（ B100 ～ B182、 B149 は欠番）
./save-wolfbbs `seq 100 366 | sed 's/^/A/'`                            # A国（ A100 ～ A366 ）
./save-wolfbbs `seq 100 744 | sed 's/^/0/'`                            # 本国（ 0100 ～ 0366 ）
./save-wolfbbs `seq 94`                                                # 前の国（ 1 ～ 94 ）
```

参照
----

* [人狼BBS](http://ninjinix.com/)
* [人狼BBS まとめサイト](https://wolfbbs.jp/)
* [Jindolf ポータルサイト](http://jindolf.osdn.jp/)
* [JinArchiver(git)](https://ja.osdn.net/projects/jindolf/scm/git/JinArchiver/)
