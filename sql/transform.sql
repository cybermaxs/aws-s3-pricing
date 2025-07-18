CREATE OR REPLACE TABLE offers AS 
SELECT * FROM read_json_auto('https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonS3/current/index.json');

CREATE OR REPLACE TABLE products AS
WITH products_map AS (
  SELECT json_extract(offers, '$.products') AS products_json
  FROM offers
)
SELECT 
  key AS sku,
  json_extract_string(value, '$.productFamily')::TEXT AS product_family,
  json_extract_string(value, '$.attributes.location')::TEXT AS location,
  json_extract_string(value, '$.attributes.regionCode')::TEXT AS region,
  json_extract_string(value, '$.attributes.group')::TEXT AS group,
  json_extract_string(value, '$.attributes.groupDescription')::TEXT AS group_description,
  json_extract_string(value, '$.attributes.storageClass')::TEXT AS storage_class,
  json_extract_string(value, '$.attributes.usagetype')::TEXT AS usage_type,
  json_extract_string(value, '$.attributes.volumeType')::TEXT AS volume_type
FROM products_map, json_each(products_json);


CREATE OR REPLACE TABLE terms AS
WITH terms_map AS (
  SELECT json_extract(offers, '$.terms.OnDemand') AS terms_json
  FROM offers
)
SELECT 
  sku.key AS sku,
  pd.value ->> 'rateCode' AS rate_code,
  pd.value ->> 'description' AS description,
  pd.value ->> 'unit' AS unit,
  pd.value ->> 'beginRange' AS begin_range,
  pd.value ->> 'endRange' AS end_range,
  CAST(pd.value -> 'pricePerUnit' ->> 'USD' AS DOUBLE) AS price_per_unit_usd
FROM terms_map,
     json_each(terms_json) AS sku,                     -- SKUs
     json_each(sku.value) AS offer,                    -- Offer IDs
     json_each(offer.value -> 'priceDimensions') AS pd; -- ✅ Extract and immediately iterate