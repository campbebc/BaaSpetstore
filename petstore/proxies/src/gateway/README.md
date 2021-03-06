# Petstore API Proxies

Petstore is made up of several proxies that integrate with a backend data store.

> For information about deploying Petstore, see the [Deploying and Running Petstore](https://github.com/campbebc/BaaSpetstore/wiki/Deploying-and-Running) in the repository wiki.

| Proxy | Description | 
| --- | --- |
| accesstoken | Receives requests to authenticate users |
| data-manager | Not client-facing. Between client-facing proxies and data store to translate requests from clients into requests to the backend data store. |
| pets | Receives requests to GET/POST/PUT/DELETE requests about pets. Also receives requests to POST requests about collars. |
| collars | Receives requests to GET/PUT/DELETE collars. |
| users | Receives requests to GET/POST/PUT/DELETE requests about users. |

## Proxy features 

### Authentication and authorization

Petstore uses OAuthV2 for authentication. Authorization logic is shared between scopes defined in Edge and role-based permissions defined in API BaaS.

1. Users request authenticate via the accesstoken proxy.
2. Their credentials are passed to API BaaS for authentication.
3. On successful authentication, API BaaS responds with its own OAuth token, which is included in the Edge-generated token.
4. The Edge-generated token is passed back to the client.

### Traffic management

* The Quota policy is used to limit the number of monthly requests based on whether the client developer has a trial or unlimited license.
* The Spike Arrest policy limits the number of requests that can be made per second.

### Integration with a backend data store

* Public-facing proxies pass requests to data-manager, a non-public-facing proxy.
* data-manager communicates with an API BaaS data store using Node.js modules.
