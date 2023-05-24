# IP Monitor

    foreman start -f Procfile.dev

## Adding Manifests

* Save the Excel spreadsheets of the manifiests collected by institutions into `lib/manifests`.
* **Validate** the manifests (`rails import:validate`)
* **Import** the manifests into the database (`rails import:manifests`)
* Start the app container (`foreman start -f Procfile.dev`)

## Manual Testing

```
 curl -L -I -s <url>
```

## Backups

<https://www.postgresql.org/docs/8.1/backup.html#BACKUP-DUMP-RESTORE>

These should be added to Box.

    pg_dump ip_monitor_sidekiq_development | gzip > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql.gz

## Restore

    gunzip -c latest.sql.gz | psql ip_monitor_sidekiq_development

## SQL

### Find Duplicates

```sql
SELECT title, count(*)
from grants
group by title
having count(*) > 1;
```

## Clean HTML
```sql
UPDATE resources 
SET access_url = regexp_replace(access_url, '<[^>]*>', '', 'g')
WHERE grant_id = 95
AND access_url LIKE '<html>%';
```

## Sidekiq
<https://prabinpoudel.com.np/articles/setup-active-job-with-sidekiq-in-rails/>

- Add the items into the queue
- Run `be sidekiq` to start processing the queue

<https://www.ruby-toolbox.com/projects/faraday-follow_redirects>

<https://github.com/gmac/sidekiq-heroku-autoscale#environment-config>

# Faraday Timeout 

There are resources getting Faraday::ConnectionTimeout errors; these should be retried at least once
 
<https://github.com/sidekiq/sidekiq/issues/4558>