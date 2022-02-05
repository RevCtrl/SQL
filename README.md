# SQL

目的「SQLでデータ処理」<br>
<br>
今回はSQL使われるデータベースソフトのうちサーバーを立てる必要がないSQLiteを使います．<br>
SQLite	#64-bit DLL (x64) for SQLite version 3.37.2.<br>
OS: Windows 11 64bit<br>
<br>
データソースはオープンデータの中で世界銀行の<br>
<br>
「GDP per capita, PPP (current international $)」#各国の一人当たり実質GDP (国際ドル)<br>
URL: https://data.worldbank.org/indicator/NY.GDP.PCAP.PP.CD?view=chart<br>
Updated: 2021-12-17<br>
<br>
を使ってみました<br>
<br>
csvをダウンロードすると3種類あり<br>
API_NY.GDP.PCAP.PP.CD_DS2_en_csv_v2_3469401.csv<br>
Metadata_Country_API_NY.GDP.PCAP.PP.CD_DS2_en_csv_v2_3469401.csv<br>
Metadata_Indicator_API_NY.GDP.PCAP.PP.CD_DS2_en_csv_v2_3469401.csv<br>
とあります．<br>
<br>
1番目は国名，国コード，年ごとの所得が入った表があり<br>
2番目は国名(国コード)に対する所得グループが割り当てられた表があり<br>
3番目は注釈<br>
<br>
という形式です．<br>
<br>
今回は所得のグループ分けが示されたファイルがあるので↓<br>
目標「グループごとの平均値で元々の値を置き換えるのを窓関数で行う」<br>
とします．<br>
<br>
## 作業 <br>
今回はダウンロードしたcsvのうち1番目と2番目を使ってみます．<br>
