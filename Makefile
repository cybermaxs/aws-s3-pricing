ingest:
	curl -o data/pricing.json https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonS3/current/index.json

clean:
	rm data/*.json
	rm data/*.duckdb

