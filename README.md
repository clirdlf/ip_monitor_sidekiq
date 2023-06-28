# IP Monitor

This is a reimplementation of the IP Monitor [CLIR](https://www.clir.org) uses to validate and study access to online resources digitized in its various programs ([Digitizing Hidden Collections](https://www.clir.org/hiddencollections/) and [Recordings at Risk](https://www.clir.org/recordings-at-risk/)). The approach is to collect information about where the objects can be viewed online (along with other useful technical metadata) to check the server header response (and not download the response body) to check the "health" of the online resources.

This application uses [Ruby on Rails](https://rubyonrails.org/) as a web frontend with [Bootstrap](https://getbootstrap.com/) providing the front-end tooling; [Postgresql](https://www.postgresql.org/) as a data persistence layer; [SideKiq](https://github.com/sidekiq/sidekiq) as its queuing system on top of the in-memory data store [Redis](https://redis.io/). Manifests are converted rom Excel spreadsheets using `rake` tasks and `Resources` are loaded into the queue in random order to ensure no single server sustains a high number of requests (and helps with throttling).

This migrates away from [Resque](https://github.com/resque/resque) for two main reasons: 1) Performance and 2) Development intertia. Sidekiq is multi-threaded (compared to Resque's single-threaded fork processes). When running checks on hundreds of thousands of URLs, this allows a much lower memory footprint when parallelizing jobs (Sidekiq doesn't require 20 processes for 20 jobs; just one process with 20 threads). Secondly, the WebUI for SideKiq is supported without another gem (which had dependencies that are no longer shipping with Rails and made more difficult to maintain).

## Interface

    foreman start

## Adding Manifests

* Save the Excel spreadsheets of the manifiests collected by institutions into `lib/manifests`.
* **Validate** the manifests (`rails import:validate`)
* **Import** the manifests into the database (`rails import:manifests`)
* Start the app container (`foreman start`)

## Adding IIIF Manifests

* Add entry to `lib/manifests-iiif/manifests.csv`

There is a separate set of rake tasks (`rake -T iiif`) for managing IIIF manifests.

## Manual Testing

```bash
curl -L -I -s <url>
```

## Backups

<https://www.postgresql.org/docs/8.1/backup.html#BACKUP-DUMP-RESTORE>

These should be added to Box.

    pg_dump ip_monitor_sidekiq_development | gzip > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql.gz

## Restore

    gunzip -c latest.sql.gz | psql ip_monitor_sidekiq_development
 
## Data 

These are stored in Box after being submitted <https://clir-dlf.box.com/s/lbl1nd7v3wd1ijam16zg37wc5b7tjg1y>

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

* Add the items into the queue
* Run `be sidekiq` to start processing the queue

<https://www.ruby-toolbox.com/projects/faraday-follow_redirects>

<https://github.com/gmac/sidekiq-heroku-autoscale#environment-config>

## Faraday Timeout

There are resources getting Faraday::ConnectionTimeout errors; these should be retried at least once

<https://github.com/sidekiq/sidekiq/issues/4558>

## Notes

- Update startup in `Procfile`