# Changelog
- prepare LMB cutover, taking the opportunity to bump the consumer
### deploy notes
Take a backup before deploying.
```
drc down
rm -rf data
```
Ensure first `docker-compose.override.yml`
```
  mandatendatabank-consumer:
    environment:
      DCR_SYNC_BASE_URL: 'https://loket.lokaalbestuur.vlaanderen.be'
      DCR_DISABLE_INITIAL_SYNC: 'false'
      DCR_DISABLE_DELTA_INGEST: 'false'
```
```
drc up -d migrations
```
```
drc up -d 
```
## 1.11.1 (2024-08-12)
 - Add missing `restart`, `labels` and `logging` keys. [DL-6095]
### Deploy Notes
#### Docker Commands
 - `drc up -d delta-producer-report-generator`
## 1.11.0 (2022-03-09)
### :house: Internal
- maintenance frontend packages
### :rocket: Enhancement
- change contact email
