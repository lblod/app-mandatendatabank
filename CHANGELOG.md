# Changelog
## 1.13.2 (2024-12-17)
### General
 - flush data and re-init consumer. It has never been properly deployed
### Deploy notes
```
drc down;
```
Update `docker-compose.override.yml` to:

```
  mandatendatabank-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://loket.lokaalbestuur.vlaanderen.be"
      DCR_DISABLE_DELTA_INGEST: "false"
      DCR_DISABLE_INITIAL_SYNC: "false"
```
Then:
```
drc up -d migrations
drc up -d database mandatendatabank-consumer
# Wait until success
drc up -d
```
## 1.13.1 (2024-09-06)
### General
 - flush data and re-init consumer. It has never been properly deployed
### Deploy notes
```
drc down;
```
Update `docker-compose.override.yml` to:

```
  mandatendatabank-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://loket.lokaalbestuur.vlaanderen.be"
      DCR_DISABLE_DELTA_INGEST: "false"
      DCR_DISABLE_INITIAL_SYNC: "false"
```
Then:
```
drc up -d migrations
drc up -d database mandatendatabank-consumer
# Wait until success
drc up -d
```

## 1.13.0 (2024-09-06)
### Changes
- Frontend (`v0.14.0`)[https://github.com/lblod/frontend-mandatendatabank/blob/master/CHANGELOG.md#v0140-2024-06-27]
- Update the dispatcher config for the new frontend (DL-6037)
### Deploy notes
#### Environment variable changes
The new dispatcher setup expects a different flow of microservices. Instead of entering the frontend microservice, which then calls the backend, we need to enter the identifier first.

In the `docker-compose.override.yml` file, move the `VIRTUAL_HOST`, `LETSENCRYPT_HOST` and `LETSENCRYPT_EMAIL` environment variables from the `mandaten` (frontend) service to the `identifier` service.

### Docker commands
- `drc up -d`

## 1.12.0 (2024-09-03)
- prepare LMB cutover, taking the opportunity to bump the consumer [DL-6144]
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
After that ensure in `docker-compose.override.yml`:
```
  mandatendatabank-consumer:
    environment:
      DCR_SYNC_BASE_URL: 'https://loket.lokaalbestuur.vlaanderen.be'
      DCR_DISABLE_INITIAL_SYNC: 'false'
      DCR_DISABLE_DELTA_INGEST: 'false'
      BYPASS_MU_AUTH_FOR_EXPENSIVE_QUERIES: 'false'
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