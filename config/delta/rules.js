export default [
  {
    match: {
      // form of element is {subject,predicate,object}
      // predicate: { type: "uri", value: "http://data.vlaanderen.be/ns/mandaat#einde" }
    },
    callback: {
      url: "http://resource/.mu/delta", method: "POST"
    },
    options: {
      resourceFormat: "v0.0.1",
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [ "http://redpencil.data.gift/id/concept/muScope/deltas/consumer/initialSync" ]
    }
  },
 {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
      },
      object: {
        type: 'uri',
        value: 'http://redpencil.data.gift/vocabularies/deltas/Error'
      }
    },
    callback: {
      url: 'http://delta-producer-report-generator/delta',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [ "http://redpencil.data.gift/id/concept/muScope/deltas/consumer/initialSync" ]
    }
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      }
    },
    callback: {
      url: 'http://delta-producer-report-generator/delta',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [ "http://redpencil.data.gift/id/concept/muScope/deltas/consumer/initialSync" ]
    }
  }
];
