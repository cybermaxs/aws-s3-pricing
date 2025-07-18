.PHONY: install  transform clean dashboard

install:
	cd dashboard && npm install

ingest:
	duckdb data/s3pricing.duckdb -c ".read sql/transform.sql"

dashboard:
	cd dashboard && npm run sources && npm run build
	
clean:
	rm data/*.duckdb

