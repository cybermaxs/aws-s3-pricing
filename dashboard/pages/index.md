---
title: Welcome to Evidence
---

<Details title='How to edit this page'>

  This page can be found in your project at `/pages/index.md`. Make a change to the markdown file and save it to see the change take effect in your browser.
</Details>

```sql regions
  select
      region, location as location
  from s3pricing.products
  where region is not null and region != ''
  group by 1, 2
  order by region, location
```

<Dropdown data={regions} name=region value=region defaultValue="us-east-1">
</Dropdown>




