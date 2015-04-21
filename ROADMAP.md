* Device Sync
  * Use websockets to sync device state and actions.
  * Similar to virtual device feature
* Auth?
  * How and where does authentication play into ZettaKit?
* Peer API Support
  * No concept of consuming the peering API. Going forward it'll be nice to have full API support.
* Refactor methods to use a ZIKSignal instead of RACSignal
  * We are coupled to RACSignal. Refactor everything to use ZIKSignal.
* Request / Response pipeline?
  * We should have a generic concept of request / response pipeline. This may be a good point of extension for Auth, and accessing server extensions.
* Smart response caching & other techniques for reducing number of requests
  * We make quite a bit of API requests. Would be nice to reduce where possible.
