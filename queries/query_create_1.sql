CREATE TABLE minio.crypto.vwap(
datetime varchar,
qty double,
vwap double,
quote_qty double,
low double,
high double,
open double,
close double,
price_mean double,
price_std double,
price_skew double,
price_kurt double,
price_median double,
qty_mean double,
qty_std double,
qty_skew double,
qty_kurt double,
qty_median double,
amplitude double,
count double,
time double,
dt varchar,
coin varchar,
date varchar
)
WITH (
   partitioned_by = ARRAY['coin', 'date'],
   external_location = 's3a://oncolos/temp-data/crypto/vwap/',
   format = 'PARQUET'
);
CALL system.sync_partition_metadata('crypto', 'vwap', 'ADD');
CALL system.sync_partition_metadata('crypto', 'vwap', 'DROP');
CALL system.sync_partition_metadata('crypto', 'vwap', 'FULL');
datetime(String)	qty(Double)	vwap(Double)	quote_qty(Double)	low(Double)	high(Double)	open(Double)	close(Double)	price_mean(Double)	price_std(Double)	price_skew(Double)	price_kurt(Double)	price_median(Double)	qty_mean(Double)	qty_std(Double)	qty_skew(Double)	qty_kurt(Double)	qty_median(Double)	amplitude(Double)	count(Double)	time(Double)	dt(String)	__index_level_0__(Int64)

datetime(String)	qty(Double)	vwap(Double)	quote_qty(Double)	low(Double)	high(Double)	open(Double)	close(Double)	price_mean(Double)	price_std(Double)	price_skew(Double)	price_kurt(Double)	price_median(Double)	qty_mean(Double)	qty_std(Double)	qty_skew(Double)	qty_kurt(Double)	qty_median(Double)	amplitude(Double)	count(Double)	time(Double)

CREATE TABLE trades(
trade_id bigint, 
price double,
qty double,
quote_qty double,
time bigint, 
is_buyer_maker boolean,
is_best_match boolean,
datetime bigint, 
upload_time varchar,
coin varchar,
date varchar
)
WITH (
   partitioned_by = ARRAY['coin', 'date'],
   
   external_location = 's3a://oncolos/temp-data/crypto/trades/',
   format = 'PARQUET'
);
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3a://oncolos/temp-data/crypto/trades/';



trade_id(Int64)
price(Double)
qty(Double)
quote_qty(Double)
time(Int64)
is_buyer_maker(Boolean)
is_best_match(Boolean)
datetime(Int64)
upload_time(String)
coin(String)
dt(String)

