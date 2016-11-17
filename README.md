# StreetCarts API application

StreetCarts is a full API application that integrates Apigee Edge with API BaaS to provide data about mobile food carts.

## Getting started

Learn how to install, set up, and use StreetCarts, on the [doc wiki](https://github.com/apigee/streetcarts/wiki).

## About StreetCarts

StreetCarts illustrates the following:

* Multiple client-facing proxies calling a single internal proxy (using proxy chaining) to share a connection with a backend resource.
* Authentication with Edge OAuth policies.
* Authorization with API BaaS user groups, roles, and permissions.
* Enforcing two distinct client access levels with the Quota policy.
* Suppressing traffic spikes with the Spike Arrest policy.
* Node.js modules to integrate an API BaaS data store with Edge proxies.
* Storing sensitive credential data in the Edge secure store (vault).

![StreetCarts diagram](https://github.com/apigee/streetcarts/blob/master/streetcarts-diagram.png).


## Learn more about what's in StreetCarts

StreetCarts integrates a set of Edge API proxies with an API BaaS data store. You might be interested in:

* Descriptions of the [StreetCarts API proxies](https://github.com/apigee/streetcarts/tree/master/streetcarts/proxies/src/gateway).
* [OpenAPI documentation on the StreetCarts API](https://github.com/apigee/streetcarts/tree/master/streetcarts/specs/openapi).
* [An explanation of how StreetCarts accesses the data store](https://github.com/apigee/streetcarts/tree/master/streetcarts/proxies/src/gateway/data-manager).
* Using a client to call its APIs. The repository includes collections and environments for the Postman tool. For more on using these, see [StreetCarts Postman client](https://github.com/apigee/streetcarts/tree/master/streetcarts/clients/postman).

