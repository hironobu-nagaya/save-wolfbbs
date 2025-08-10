save-wolfbbs
============

概要
----

`save-wolfbbs` は [人狼BBS](http://ninjinix.com/) のログを  
[JinArchiver](https://github.com/olyutorskii/JinArchiver)形式の XML ファイルとして保存し  
その XML ファイルからログ閲覧用の HTML ファイルを生成します

生成された HTML ファイルは閲覧しやすいよう整形されており  
発言内の参照(`1d12:00` など)をマウスオーバーで参照する機能を追加しています

注意
----

このスクリプトは [人狼BBS](http://ninjinix.com/) の作者 [ninjin](https://ninjin.hatenadiary.jp/) 氏及び  
[JinArchiver](https://github.com/olyutorskii/JinArchiver) の作者 [Olyutorskii](https://github.com/olyutorskii) 氏は一切関与していません

**このスクリプト及びその出力に関する問い合わせを**  
**両氏に対して絶対行わないで下さい！**

依存関係
--------

このスクリプトは以下のパッケージに依存しています

* [GNU Bash](https://www.gnu.org/software/bash/)
* [GNU sed](https://www.gnu.org/software/sed/)
* [GNU grep](https://www.gnu.org/software/grep/)
* [gawk](https://www.gnu.org/software/gawk/)
* [curl](https://curl.se/)
* [Java](https://www.java.com/) ([JinArchiver](https://github.com/olyutorskii/JinArchiver)実行に必要)

使い方
------

`bin` ディレクトリに [save-wolfbbs](https://github.com/hironobu-nagaya/save-wolfbbs/blob/main/bin/save-wolfbbs) スクリプトがあります  
このスクリプトを実行して下さい

```bash
bin/save-wolfbbs [オプション]... [村番号]...
```

### オプション

オプション     | 説明
:------------- | :---
`-d DIRECTORY` | 全生成物の出力先ディレクトリを指定します(デフォルトは `save-wolfbbs/dest`)
`-w DIRECTORY` | WWW 生成物の出力先ディレクトリを指定します(デフォルトは `save-wolfbbs/dest/www`)
`-f`           | 生成しようとしているファイルが既に存在する場合、取得や生成をし直します
`-q`           | エラー以外の出力を抑制します(デフォルト)
`-v`           | 詳細な出力を行います
`-h`           | ヘルプを表示して終了します

### 村番号

村番号は国名を表すプレフィックスに半角英数字を続けた番号です

公式の呼称  | まとめサイトでの呼称 | プレフィックス | 範囲          | 欠番
:---------- | :------------------- | :------------- | ------------- | ----
人狼BBS:G   | G国                  | G              | G001 ～ G2087 | -
人狼BBS:F   | F国                  | F              | F100 ～ F2232 | F1945, F1973
人狼BBS:E   | E国                  | E              | E100 ～ E199  | -
人狼BBS:D   | D国                  | D              | D100 ～ D703  | -
人狼BBS:C   | C国                  | C              | C100 ～ 1435  | -
人狼BBS:B   | B国                  | B              | B100 ～ B182  | B149
人狼BBS:A   | A国                  | A              | A100 ～ A366  | -
人狼BBS     | 本国                 | 0(ゼロ)        | 0100 ～ 0366  | -
旧人狼BBS 2 | 前の国               | (なし)         | 1 ～ 94       | -

以下の国は対応していません

* [旧人狼BBS 1](http://ninjinix.x0.com/wolf_old/)
* [人狼BBS:Z](https://ninjinix.x0.com/wolfz/)

村番号を指定しない場合、取得可能なすべての村のログを取得します

### 実行例

コマンド                                       | 動作
:--------------------------------------------- | :---
`bin/save-wolfbbs -v`                          | `save-wolfbbs/dest` 配下に取得可能なすべての村のログを動作経過を表示しながら保存します
`bin/save-wolfbbs F2181`                       | `save-wolfbbs/dest` 配下に F2181 村のログを保存します
`bin/save-wolfbbs -d /srv/wolfbbs F2209 F2223` | `/srv/wolfbbs` 配下に F2209, F2223 村のログを保存します

### 変数

`save-wolfbbs` スクリプト内の多くの変数は  
実行時に上書きできるようにしてあります

```bash
変数名=値... bin/save-wolfbbs [オプション]... [村番号]...
```

詳細は `save-wolfbbs` 冒頭の変数宣言をご確認下さい

FAQ
----

### ブラウザ閲覧時の表示の幅が広すぎます

CSS の body セレクタの内容を修正して下さい  
CSS ファイルは `$WWW_DIR/plugin_wolf/css/wolfbbs.css` です

オリジナルと同じように幅を 500px で固定したい場合  
以下のように設定すると良いでしょう

```css
body {
  margin: auto;
  width: 500px;
  background: #000000;
}
```

### macOS で正しく動作しません

このスクリプトは GNU 版 `grep`, `sed`, `awk` に依存しています

macOS にデフォルトでインストールされているこれらのコマンドは  
GNU 版と動作が一部異なっているためスクリプトは正しく動作しません  
macOS に GNU 版 `grep`, `sed`, `awk` をインストールし  
スクリプトでそれらを使うよう指定することで正しく動作します

[Homebrew](https://brew.sh/ja/) から GNU 版 `grep`, `sed`, `awk` をインストールします  
それぞれ `ggrep`, `gsed`, `gawk` というコマンド名で呼び出せるようになります

```bash
brew install grep gnu-sed gawk
```

`GREP`, `SED`, `AWK` 変数にそれぞれ `ggrep`, `gsed`, `gawk` を指定してスクリプトを実行します

```bash
GREP=ggrep SED=gsed AWK=gawk bin/save-wolfbbs [オプション]... [村番号]...
```

ライセンス
----------

このスクリプトは [MIT ライセンス](https://github.com/hironobu-nagaya/save-wolfbbs/blob/main/LICENSE) で提供されています

参照
----

* [人狼BBS](http://ninjinix.com/)
* ~~[人狼BBS まとめサイト](https://wolfbbs.jp/)~~ 閉鎖
* [Jindolf repositories list](https://github.com/olyutorskii/Jindolf/wiki/Jindolf-repositories-list)
* [JinArchiver](https://github.com/olyutorskii/JinArchiver/)

