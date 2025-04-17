# Changelog
## Unreleased
- Change database from mu-auth to sparql-parser [DL-6562]
- Bump virtuoso (required for the sparql-parser)

### Deploy notes
#### For upgrading virtuoso
[This README](https://github.com/Riadabd/upgrade-virtuoso) provides the necessary steps for upgrading the database. **NOTE**: This will involve shutting down the app for small period of time (around 30 minutes).
#### For the database
```
drc up -d database
```
## 1.14.0 (2025-03-24)
- Sync from OP public [DL-6394]
- Update op consumer config to avoid accidental deletes
- Frontend [v0.14.1](https://github.com/lblod/frontend-mandatendatabank/blob/1ed37a9357269cb360561468e583548da1d7419a/CHANGELOG.md#v0141-2025-03-20)

### Deploy notes

WARNING The sync should be deployed after https://github.com/lblod/app-digitaal-loket/pull/638

```
drc down;
```
Update `docker-compose.override.yml` to remove the config of `op-public-consumer` and replace it by:
```
  op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be" # or another endpoint
      DCR_LANDING_ZONE_DATABASE: "virtuoso" # for the initial sync, we go directly to virtuoso
      DCR_REMAPPING_DATABASE: "virtuoso" # for the initial sync, we go directly to virtuoso
      DCR_DISABLE_INITIAL_SYNC: "false"
      DCR_DISABLE_DELTA_INGEST: "true"
```
Then:
```
drc up -d virtuoso migrations
drc up -d database op-public-consumer
# Wait until success of the previous step
```
Then, update `docker-compose.override.yml` to:
```
  op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be" # or another endpoint
      DCR_LANDING_ZONE_DATABASE: "database"
      DCR_REMAPPING_DATABASE: "database"
      DCR_DISABLE_DELTA_INGEST: "false"
      DCR_DISABLE_INITIAL_SYNC: "false"
```
```
drc up -d
```
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
