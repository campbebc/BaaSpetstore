# Petstore API application

Petstore is a full API application that integrates Apigee Edge with API BaaS to provide data about mobile food carts.

## Getting started

Learn how to install, set up, and use Petstore, on the [doc wiki](https://github.com/campbebc/BaaSpetstore/blob/master/wiki.wiki/Home.md).

## About Petstore

Petstore illustrates the following:

* Multiple client-facing proxies calling a single internal proxy (using proxy chaining) to share a connection with a backend resource.
* Authentication with Edge OAuth policies.
* Authorization with API BaaS user groups, roles, and permissions.
* Enforcing two distinct client access levels with the Quota policy.
* Suppressing traffic spikes with the Spike Arrest policy.
* Node.js modules to integrate an API BaaS data store with Edge proxies.
* Storing sensitive credential data in the Edge secure store (vault).

![Petstore diagram](https://github.com/campbebc/BaaSpetstore/blob/master/Petstore-Data-Flow.pdf).


## Learn more about what's in Petstore

Petstore integrates a set of Edge API proxies with an API BaaS data store. You might be interested in:

* Descriptions of the [Petstore API proxies](https://github.com/campbebc/BaaSpetstore/tree/master/petstore/proxies/src/gateway).
* [OpenAPI documentation on the Petstore API](https://github.com/campbebc/BaaSpetstore/tree/master/petstore/specs/openapi).
* [An explanation of how Petstore accesses the data store](https://github.com/campbebc/BaaSpetstore/tree/master/petstore/proxies/src/gateway/data-manager-pet).
* Using a client to call its APIs. The repository includes collections and environments for the Postman tool. For more on using these, see [Petstore Postman client](https://github.com/campbebc/BaaSpetstore/tree/master/petstore/clients/postman).

