# Mandatendatabank

APIs on top of the Mandaat model and application profile as defined on:
* http://data.vlaanderen.be/ns/mandaat
* http://data.vlaanderen.be/doc/applicatieprofiel/mandatendatabank

## Running the application
```
docker-compose up
```
### Ingesting data
The app comes with no data, because it depends on external datasources.
At the time of writing, for production, the datasource will be [loket.lokaalbestuur.vlaanderen.be](https://loket.lokaalbestuur.vlaanderen.be/).
The ingestion should be a one time operation per deployment, and is currenlty semi-automatic for various reasons (mainly related to performance)
The ingestion is disabled by default.

To proceed:
1. make sure the app is up and running. And the migrations have run.
2. In docker-compose.override.yml (preferably) override the following parameters for mandatendatabank-consumer
```
# (...)
  mandatendatabank-consumer:
    environment:
      SYNC_BASE_URL: 'https://loket.lblod.info' # The endpoint of your choice (see later what to choose)
      DISABLE_INITIAL_SYNC: 'false'
```
3. `docker-compose up -d mandatendatabank-consumer` should start the ingestion.
  This might take a while if yoh ingest production data.
4. Check the logs, at some point this message should show up
  `Initial sync was success, proceeding in Normal operation mode: ingest deltas`
   or execute in the database:
   ```
   PREFIX adms: <http://www.w3.org/ns/adms#>
   PREFIX task: <http://redpencil.data.gift/vocabularies/tasks/>
   PREFIX dct: <http://purl.org/dc/terms/>
   PREFIX cogs: <http://vocab.deri.ie/cogs#>

   SELECT ?s ?status ?created WHERE {
     ?s a <http://vocab.deri.ie/cogs#Job> ;
       adms:status ?status ;
       task:operation <http://redpencil.data.gift/id/jobs/concept/JobOperation/deltas/consumer/initialSync/mandatarissen> ;
       dct:created ?created ;
       dct:creator <http://data.lblod.info/services/id/mandatendatabank-consumer> .
    }
    ORDER BY DESC(?created)
   ```
5. `drc restart resource cache` is still needed after the intial sync.

### Additional notes:
#### Endpoints to choose for ingestion.
On abstract level, all applications which produce deltas provided `delta-producer-*` services set, and talk about the AP-model defined in [mandatendatabank](http://data.vlaanderen.be/doc/applicatieprofiel/mandatendatabank)
In practice, it is going to be loket and their dev and QA variations.
#### Performance
- The default virtuoso settings might be too weak if you need to ingest the production data. Hence, there is better config, you can take over in your `docker-compose.override.yml`
```
  virtuoso:
    volumes:
      - ./data/db:/data
      - ./config/virtuoso/virtuoso-production.ini:/data/virtuoso.ini
      - ./config/virtuoso/:/opt/virtuoso-scripts
```
#### delta-producer-report-generator
Not all required parameters are provided, since deploy specific, see [report-generator](https://github.com/lblod/delta-producer-report-generator)
#### deliver-email-service
Should have credentials provided, see [deliver-email-service](https://github.com/redpencilio/deliver-email-service)

## Further info
The stack is built starting from [mu-project](https://github.com/mu-semtech/mu-project).

OpenAPI documentation can be generated using [cl-resources-openapi-generator](https://github.com/mu-semtech/cl-resources-openapi-generator).
