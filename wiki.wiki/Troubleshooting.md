This page describes some of the things you can check if your installation isn't successful.



<a name="updates" />
## Git the latest API proxy updates

The script does an automatic pull to get the latest from the repo. Your local changes should remain intact.

If git prompts you for credentials, you can configure it to either use SSH or set up a credential keychain. For info and troubleshooting, see the following topics:

* https://help.github.com/articles/caching-your-github-password-in-git/
* http://olivierlacan.com/posts/why-is-git-https-not-working-on-github/



<a name="httptargetconnection" />
## Check HTTPTargetConnection in TargetEndpoints

In all proxies *other than* ```accesstoken``` and ```data-manager```:

1. In the proxy editor, on the Develop tab, in the Navigator, click **default** under Target Endpoints.

2. In the editor pane, scroll to the bottom of the file and make sure the HTTPTargetConnection URL base path is correct. The URL should be of the following form:

 ```
 https://{org}-{env}.{host}/{version}/streetcarts/data-manager
 ```


<a name="plugins" />
## Ensure you have the required Node.js plugins

> Note: The ```main.sh``` script is designed to do the following automatically.

If this is the first time that you have uploaded the proxies, you have to ensure that you have all of the required Node.js plugins used by the data-manager API proxy.

1. After running maven to deploy this proxy, call [this Edge API](http://apigee.com/docs/management/apis/post/organizations/%7Borg_name%7D/apis/%7Bapi_name%7D/revisions/%7Brevision_num%7D/npm-0) to run npm install on Edge. This is the API called "Manage Node Packaged Modules" under the SmartDocs->API Proxies menu. 

   - Ensure that you specify "data-manager" as the name of the API proxy.
   - Ensure that you set the Request Body to: command=install   

   Note: Be sure to specify the correct revision for your deployed instance of data-manager.

   OR, use the following cURL. For e2e, change the URL host to https://api.e2e.apigee.net.

   `curl -X POST --header "Content-Type: application/x-www-form-urlencoded" -u {you@apigee.com} -d "command=install" "https://api.enterprise.apigee.com/v1/organizations/{org}/apis/data-manager/revisions/{version_num}/npm"`
   
2. Undeploy and then redeploy the data-manager proxy in the Edge UI. 

<a name="manual" />
## Manually configuring Edge and API BaaS

You can use the Edge management API and API BaaS admin console to make the config changes you need to get StreetCarts running.

> These are alternatives to the [batched changes](#batch_scripts) made by included config scripts.

<a name="configure_edge_manual" />
### Adding a vault with the management API

1. Go to the API BaaS admin console and note the client ID and client secret for the application's organization. These should be on the Org Administration page.
2. Use the Edge management API to [add a vault](http://docs.apigee.com/management/apis/post/organizations/%7Borg_name%7D/environments/%7Benv_name%7D/vaults) and [add vault entries](http://docs.apigee.com/management/apis/post/organizations/%7Borg_name%7D/environments/%7Benv_name%7D/vaults/%7Bvault_name_in_env%7D/entries), as listed in the following table:

 | Vault Name | Scope | Entry | Value |
 | --- | --- | --- | --- | --- |
 | streetcarts | environment | datastore-client-id | \<API BaaS client ID> |
 |  |  | datastore-client-secret | \<API BaaS client secret> |
 |  |  | datastore-client-token | None. |
 
 For example, to create a vault called "streetcarts" in the test environment of myorg, you could use the following endpoint and JSON body:
 
 Endpoint: `POST https://api.enterprise.apigee.com/v1/organizations/myorg/environments/test/vaults`
 
 
 Body: `{"name":"streetcarts"}`

<a name="configure_baas_manual" />
### Manually configuring API BaaS in the admin console

1. Open the API BaaS admin console to the organization and application you'll use with StreetCarts.
2. Under **Data**, create three new collections: `foodcarts`, `menus`, and `items`. Don't add entities to the collections.
3. Under **Users**, to the Default and Guest roles that come with a new application, add a role with the title `Foodcart Owners` and role name `owners`.
4. Make permissions settings for the three roles as described in the following table:

 | Role | Path | GET | POST | PUT | DELETE |
 | --- | --- | --- | --- | --- |--- |
 | Default | /groups/owners/users/* | no | yes | yes | no | 
 | Guest | /foodcarts | yes | no | no | no | 
 |  | /foodcarts | yes | no | no | no | 
 |  | /foodcarts/* | yes | no | no | no | 
 |  | /foodcarts/\*/offers/* | yes | no | no | no | 
 |  | /foodcarts/\*publishes/* | yes | no | no | no | 
 |  | /items | yes | no | no | no | 
 |  | /items/* | yes | no | no | no | 
 |  | /menus | yes | no | no | no | 
 |  | /menus/* | yes | no | no | no | 
 |  | /menus/\*/includes/* | yes | no | no | no | 
 |  | /devices | no | yes | no | no | 
 |  | /groups/\*/users/* | no | yes | no | no | 
 |  | /users | no | yes | no | no | 
 |  | /users/* | no | yes | no | no | 
 |  | /devices/* | no | no | yes | no | 
 | Foodcart Owners | /foodcarts | no | yes | no | no |
 |  | /foodcarts/* | no | yes | no | no |

5. Add a new user group with the title `Foodcart Owners` and path `/owners`.
6. Under Roles & Permissions, assign the `Foodcart Owners` role you created to the `Foodcart Owners` group.
