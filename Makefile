ingest:
	duckdb data/s3pricing.duckdb -c ".read sql/transform.sql"

clean:
	rm data/*.duckdb

