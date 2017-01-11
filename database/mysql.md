# MySQL

## Adds tzinfo to your MySQL database schema

### `$ mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql`

This is particularly useful when zones are misconfigured.

## Benchmarking

The command below runs a benchmark test in a given query. Note the `flush tables` and the `sql_no_cache` between calls.

### `$ mysqlslap --user=root --password --host=localhost --concurrency=100 --iterations=500 --verbose --create-schema=dbname --query="flush tables; select sql_no_cache * from users"`

### UTF-8 done right

UTF-8 should be the default charset for every string field, but that's not always truth.

Also, the most suitable collate for this charset is `utf8_unicode_ci`.

If your database is not using those yet, then you'll have to:

```sql
ALTER TABLE `table` CONVERT TO CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci';

ALTER DATABASE `dbname` CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci';
```

This will convert every [var]char/text field into that charset/collation. It might take some time if you're handling with a huge table, so beware.
