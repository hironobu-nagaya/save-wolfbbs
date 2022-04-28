save-wolfbbs
============

概要
----

[人狼BBS](http://ninjinix.com/)の過去ログを HTML ファイルとしてローカルに保存します。

注意
----

このスクリプトは[人狼BBS](http://ninjinix.com/)の作者 ninjin 氏及び、  
[JinArchiver](https://ja.osdn.net/projects/jindolf/scm/git/JinArchiver/)の作者 Olyutorskii 氏は一切関与していません。  
**このスクリプト及びその出力に関する問い合わせを両氏に対して絶対行わないで下さい！**

依存関係
--------

このスクリプトは、以下のパッケージに依存しています。

* [GNU Bash](https://www.gnu.org/software/bash/)
* [GNU Awk](https://www.gnu.org/software/gawk/)
* [GNU Wget](https://www.gnu.org/software/wget/) ※
* [curl](https://curl.se/) ※
* [Java](https://www.java.com/)

※ どちらか一方があれば十分です

使い方
------

```
./save-wolfbbs [村番号]...
```

### 村番号

村番号は、国名を表すプレフィックスに数字を続けた番号です。

公式の呼称  | まとめサイトでの呼称 | プレフィックス
----------- | -------------------- | --------------
旧人狼BBS 2 | 前の国               | （なし）
人狼BBS     | 本国                 | 0（ゼロ）
人狼BBS:A   | A国                  | A
人狼BBS:B   | B国                  | B
人狼BBS:C   | C国                  | C
人狼BBS:D   | D国                  | D
人狼BBS:E   | E国                  | E
人狼BBS:F   | F国                  | F
人狼BBS:G   | G国                  | G
人狼BBS:Z   | Z国                  | Z

※ [旧人狼BBS 1](http://ninjinix.x0.com/wolf_old/)は対応していません

### 環境変数

環境変数名 | 説明                                                     | デフォルト値
---------- | -------------------------------------------------------- | ------------
WORK_DIR   | 作業ディレクトリ                                         | `.`
JAR_DIR    | JinArchiver の jar ファイル格納先ディレクトリ            | `$WORK_DIR/jar`
XML_DIR    | JinArchiver が出力する XML ファイル格納先ディレクトリ    | `$WORK_DIR/xml`
WWW_DIR    | XML ファイルから生成する HTML ファイル格納先ディレクトリ | `$WORK_DIR/www`

代表的な環境変数のみを記載しています。  
詳細はスクリプト冒頭をご確認下さい。

### 実行例

コマンド                                           | 動作
-------------------------------------------------- | ----
`./save-wolfbbs F2181`                             | カレントディレクトリ配下に F2181 村のログを保存します。
`WORK_DIR=/srv/wolfbbs ./save-wolfbbs F2209 F2223` | /srv/wolfbbs 配下に F2209, F2223 村のログを保存します。

FAQ
----

### 表示の幅が広すぎます

CSS の body セレクタの内容を修正して下さい。  
CSS ファイルは `$WWW_DIR/plugin_wolf/css/wolfbbs.css` です。

オリジナルと同じように幅の最大値を 500px としたい場合、  
以下のように設定すると良いでしょう。

```css
body {
  margin: auto;
  max-width: 500px;
  background: #000000;
}
```

参照
----

* [人狼BBS](http://ninjinix.com/)
* [人狼BBS まとめサイト](https://wolfbbs.jp/)
* [Jindolf ポータルサイト](http://jindolf.osdn.jp/)
* [JinArchiver(git)](https://ja.osdn.net/projects/jindolf/scm/git/JinArchiver/)

