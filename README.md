# SQL

目的「SQLでデータ処理」<br>

今回はSQL使われるデータベースソフトのうちサーバーを立てる必要がないSQLiteを使います．<br>
SQLite	#64-bit DLL (x64) for SQLite version 3.37.2.<br>
OS: Windows 11 64bit<br>
<br>
データソースはオープンデータの中で世界銀行の<br>
<br>
「GDP per capita, PPP (current international $)」#各国の一人当たり実質GDP (国際ドル)
URL: https://data.worldbank.org/indicator/NY.GDP.PCAP.PP.CD?view=chart
Updated: 2021-12-17

を使ってみました

csvをダウンロードすると3種類あり
API_NY.GDP.PCAP.PP.CD_DS2_en_csv_v2_3469401.csv
Metadata_Country_API_NY.GDP.PCAP.PP.CD_DS2_en_csv_v2_3469401.csv
Metadata_Indicator_API_NY.GDP.PCAP.PP.CD_DS2_en_csv_v2_3469401.csv
とあります．

1番目は国名，国コード，年ごとの所得が入った表があり
2番目は国名(国コード)に対する所得グループが割り当てられた表があり
3番目は注釈

という形式です．

今回は所得のグループ分けが示されたファイルがあるので↓
目標「グループごとの平均値で元々の値を置き換えるのを窓関数で行う」
とします．

---作業---
今回はダウンロードしたcsvのうち1番目と2番目を使ってみます．
先頭行をカラム名にすると扱いやすいため，1番目は5行目がカラム名で6行目以降がデータ行でしたので4行目まで削除しました (2番目はそのままでOKでした)
分かりやすさ記述のしやすさから編集した1番目のファイル名を"t1.csv", そのままの2番目を"t2.csv"と名前をつけて処理します．

SQLiteを起動させつつデータベース(db.db)作ります
sqlite3.exe db.db

SQLiteを使ってcsvを読み込みます．

.mode csv
.import t1.csv t1
.import t2.csv t2

使う列としては
t1の列のうち，Country Name, Coundry Code, 2020を使います (2020なのは単純に最新年だからです)．
t2の列のうちはCoundry Code incomeGroupを使います．
そして共通したCoundry Codeで結合して1つのテーブルを作ります

/* 列名に空白があるとブラケット([])をつける必要があって大変なので新しいテーブルではパスカルケースにしてます */
/* 数字で始まるのもアポストロフィ('')が必要なのでy(year)を頭につけました． */
/* ちなみにt1とt2では国・地域の数が1つ違って前者にだけ「Not classified (INX)」が入ってます */

CREATE TABLE mod
AS
SELECT t1.[Country Name] AS CountryName,t1.[Country Code] AS CountryCode,t1.'2020' AS y2020, t2.IncomeGroup
FROM t1
INNER JOIN t2
ON t1.[Country Code] = t2.[Country Code];

/* y2020，IncomeGroupのどちらが空欄の国・地域は省いて処理します */
/* 元のcsvファイルではすべての値に二重引用符""がついてるので条件はNULLについては扱っていません */
SELECT  CountryName, CountryCode, IncomeGroup, AVG(y2020) OVER (PARTITION BY IncomeGroup)
FROM mod WHERE y2020!="" AND IncomeGroup!="" ORDER BY CountryCode;

/* SELECTしたものでテーブルを作る場合です*/
CREATE TABLE ex
AS
SELECT  CountryName, CountryCode, IncomeGroup, AVG(y2020) OVER (PARTITION BY IncomeGroup)
FROM mod WHERE y2020!="" AND IncomeGroup!="" ORDER BY CountryCode;

SQLiteのコマンドでエクスポートします

.headers on
.mode csv
.once ex.csv
select * from ex;

ex.csvが完成ファイルです

db.dbとex.csvについてはフォルダ内のものは上書きされないように「_」を頭につけてます
t1t2.dbはt1とt2を読み込んだだけのデータベースです
使ったSQL文はsql.sqlファイルに入れてます．
