You can experiment with the Petstore API by deploying its proxies to Edge and setting up an API BaaS application for its data. Once it's set up, you can use a client to try out the API.

> Before beginning  the steps here, you should have created an Edge organization and environment, as well as an API BaaS organization and application. See the [Getting Started](https://github.com/campbebc/BaaSpetstore/wiki/Getting-Started) page for more information.

  
4. **[Build and deploy the proxies](#deploy)**.

 Use the steps below to deploy Petstore to your Edge organization with Maven.

5. **[Configure Petstore](#configure)**. 

 Once you've got the proxies deployed, you'll make a few configuration settings to your Edge org and API BaaS app.

6. **[Add data](#add-data)**.

 Add a few users and some food cart data you can play with.

7. **[Make calls to Petstore](#calls)**.

 Use the HTTP client of your choice to call the Petstore API.

<a name="deploy" />
# Build and deploy the proxies

Use scripts in the repository to deploy Petstore to your Edge organization with Maven. 

> This setup is based on the Apigee Maven plugin: https://github.com/apigee/apigee-deploy-maven-plugin.

To deploy Petstore, follow these steps:

1. [Download and install software](#download) for Java, Maven, git, and Node.js.

2. [Run the build script](#runscript).

<a name="download" />
## Download and install software

1. Make sure you have Java 1.7 or later. 

 Type `java -version` in the terminal to find out your version. [Upgrade to the latest version of Java](https://java.com/) if needed.
2. [Download and install Maven 3.x](http://maven.apache.org/download.cgi).
   
   Then add Maven to your ~/.bash\_profile so that the `mvn` command is recognized. For example, in `~/.bash_profile`, add: 
   
   ```bash
   export PATH=/Users/me/development/apache-maven-3.3.3/bin:$PATH
   ```

   pointing to wherever you've stashed Maven.

3. Make sure you have the `git` command-line tool installed. 

  In a terminal window, run `which git` or `git --version`. If you don't have it, [install it](https://git-scm.com/).

4. Make sure you have the latest Node.js installed.

   In a terminal window, run `which node` or `node -v` to see if you already have it. If you don't have it, [install it](https://nodejs.org/en/download/).

<a name="runscript" />
## Run the build script

1. cd to **petstore/proxies/src/gateway/bin**

2. Run the shell script: ```./main.sh```

   The script should pull the latest from the repository and install (on your Edge server) Node.js plugins required by the data-manager proxy. 

   You will be prompted to enter your Edge email, password, org name, and deployment environment. The deployment environment is typically either the Edge Cloud, https://api.enterprise.apigee.com. 

   If you want to pass options on the command line:

   ```bash
   ./main.sh  -u sfoo@apigee.com -p PWORD -o myorg -e https://api.enterprise.apigee.com
   ```

   Use the -h option for help:

   ```bash
   ./main.sh  -h
   ```

3. In the Edge UI, check your org to make sure the following were created and deployed:
   * The following API proxies: `data-manager-pet`, `accesstoken`, `users`, `pets`, `collars`. In Develop view, the data-manager should also have `node-modules-*` resources in the Scripts pane.
   * An environment-scoped KVM: In APIs > Environment Configuration > Key Value Maps, you should see a `DATA-MANAGER-PET-API-KEY` map containing a `X-DATA-MANAGER-KEY` key and value.
   * One developer: `Petstore Developer`.
   * Three apps: `PS-DATA-MANAGER-APP`, `PS-APP-UNLIMITED`, `PS-APP-TRIAL`.
   * Three API products, each with an associated app: `PS-DATA-MANAGER-PRODUCT`, `PS-PRODUCT-UNLIMITED`, `PS-PRODUCT-TRIAL`.

If you don't see any or all of these resources, try running the script again and look for fundamental errors, such as command-line commands that aren't recognized, which means you need to double-check your installations of Maven, Java, and git. You can also see [Troubleshooting](https://github.com/campbebc/BaaSpetstore/wiki/Troubleshooting) for tips.

<a name="configure" />
# Configure Petstore

You'll need to make a couple of configuration settings to Edge and API BaaS to set up integration between the proxies and the backend data store. You'll need to:

1. **[Capture information about your Edge and API BaaS orgs](#settings)** in a config file. 

 The batch configuration scripts read this file for information about your Edge and API BaaS organizations.
2. **[Add a vault and vault entries](#configure_edge_manual)** to the Edge environment. 

 Petstore uses these entries to hold values for authenticating proxies with API BaaS.
3. **[Add user groups, roles, and permissions](#configure_baas_script)** to API BaaS. 

 These are needed to provide initial role-based security.
 
> The steps here use scripts to batch the changes. You can also make the changes [manually](https://github.com/campbebc/BaaSpetstore/wiki/Troubleshooting#user-content-manually-configuring-edge-and-api-baas) by using the Edge APIs and the API BaaS admin console.

<a name="settings" />
###Capture information about your Edge and API BaaS organizations

> Before you modify files locally, we recommend you create a Git branch for your changes by running `git branch your_branch_name`, then `git checkout your_branch_name`. That way, if you ever need to pull from origin/master (the main.sh script does a pull before deploying the Petstore proxies), you can do so without merge conflicts.

Edit the file at `petstore/proxies/src/gateway/bin/seed/petstore-config.json` to include information about Edge and API BaaS. The configuration scripts read this config file. 

Replace the placeholder values for the keys listed in the following table:

| Key | Description |
| --- | --- |
| mgmtApiHost | Host for access to Edge management API, such as `api.enterprise.apigee.com`. |
| appApiHost | Host for access to Petstore API, such as `apigee.net`. |
| orgName | Name of the Edge organization where Petstore is deployed. |
| envName | Name of the Edge environment where Petstore is deployed, such as `prod` or `test`. |
| consumerKey (for PS-APP-TRIAL) | Consumer key from Petstore dev app PS-APP-TRIAL. Go to Publish > Developer Apps > app_name in the management UI. |
| consumerSecret (for PS-APP-TRIAL) | Consumer secret from Petstore dev app PS-APP-TRIAL. |
| consumerKey (for PS-APP-UNLIMITED) | Consumer key from Petstore dev app PS-APP-UNLIMITED. |
| consumerSecret (for PS-APP-UNLIMITED) | Consumer secret from Petstore dev app PS-APP-UNLIMITE.D |
| datastore-client-id | Client ID from API BaaS org where Petstore data will be hosted. Petstore proxies use this when authenticating to create permissions in API BaaS. You can find this on the "Org Administration" page of API BaaS. |
| datastore-client-secret | Client secret from API BaaS org where Petstore data will be hosted.  Petstore proxies use this when authenticating to create permissions in API BaaS. |
| datastore-client-token | Leave this empty, with empty quotes -- for example, `""`. Petstore proxies use this when authenticating to create permissions in API BaaS. |
| API BaaS orgName | Name of the API BaaS org where Petstore data will be hosted. |
| API BaaS appName | Name of the API BaaS app where Petstore data will be hosted. |
| API BaaS apiHost | Host for access to the API BaaS API, such as `api.usergrid.com`. |
| API BaaS clientId | Client ID from the API BaaS org where Petstore data will be hosted. Used for authenticating API proxies with API BaaS. |
| API BaaS clientSecret | Client secret from the API BaaS org where Petstore data will be hosted. |

<a name="configure_edge_manual" />
### Adding a vault with the management API

Petstore uses [application client](http://docs.apigee.com/app-services/content/user-authentication-types#adminauthenticationlevels) credentials to make permissions changes in API BaaS. It stores these credentials in the secure Edge vault because they grant full access to the API BaaS data store.

Use the following steps to add a vault and vault entries to your Edge organization.

1. Go to the API BaaS admin console and note the client ID and client secret for the application's organization. These should be on the Org Administration page.
2. Use the Edge management API to [add a vault](http://docs.apigee.com/management/apis/post/organizations/%7Borg_name%7D/environments/%7Benv_name%7D/vaults) and [add vault entries](http://docs.apigee.com/management/apis/post/organizations/%7Borg_name%7D/environments/%7Benv_name%7D/vaults/%7Bvault_name_in_env%7D/entries), as listed in the following table:

 | Vault Name | Scope | Entry | Value |
 | --- | --- | --- | --- | --- |
 | Petstore | environment | datastore-client-id | \<API BaaS client ID> |
 |  |  | datastore-client-secret | \<API BaaS client secret> |
 |  |  | datastore-client-token | No value (`"value": ""`) |
 
 For example, to create a vault called "petstore" in the test environment of myorg, you could use the following endpoint and JSON body:
 
 Endpoint: `POST https://api.enterprise.apigee.com/v1/organizations/myorg/environments/test/vaults`
 
 
 Body: `{"name":"petstore"}`

 Then create three entries based on the three in the table above. For each, you could use the following endpoint and JSON (just have empty quotes for `datastore-client-token`, which has no value):

 Endpoint: `POST https://api.enterprise.apigee.com/v1/organizations/myorg/environments/test/vaults/petstore/entries`
 
 Body: 
 
 ```
 {
     "name": "datastore-client-id",
     "value": "<API BaaS client ID>"
 }
```
You can confirm that the vault and entries were created with the [Get List of Entries API](http://docs.apigee.com/management/apis/get/organizations/%7Borg_name%7D/environments/%7Benv_name%7D/vaults/%7Bvault_name_in_env%7D), using `petstore` as the vault name. There should be a petstore vault with three entries. The API response should look something like this:
```
{
  "entries": [
    {
      "name": "datastore-client-secret",
      "value": "*****"
    },
    {
      "name": "datastore-client-token",
      "value": "*****"
    },
    {
      "name": "datastore-client-id",
      "value": "*****"
    }
  ],
  "name": "petstore"
}
```
<a name="configure_baas_script" />
### Add user groups, roles, and permissions

Before running Petstore, you'll need to make a few general permissions settings in API BaaS. These changes will set data store permissions so that you can add new data with the API.

If you've previously created these groups, roles, and permissions, this script will delete and re-create them.

> Note: This is an alternative to the [manual process](https://github.com/campbebc/BaaSpetstore/wiki/Troubleshooting#user-content-manually-configuring-api-baas-in-the-admin-console) using the API BaaS admin console.

Add user groups, roles, and permissions by running the following command in the `seed` directory. 

1. cd to `petstore/proxies/src/gateway/bin/seed`.
2. Run the following (be sure to use the name of your petstore-config.json file if it's different):

  `node petstore-config-seed configure-baas ./petstore-config.json`

  > If you get any `cannot find module <module_name>` errors, install those by running `npm install <module_name>`.

You can confirm that the changes were made by going to the API BaaS admin console for your organization and application, then looking in the Users section for **Pet Owners** groups and roles. See the [troubleshooting page](https://github.com/campbebc/BaaSpetstore/wiki/Troubleshooting#user-content-manually-configuring-api-baas-in-the-admin-console) for information on how permissions should be set up.

<a name="add-data" />
# Add data to Petstore

After you've configured Edge and API BaaS as described above, you can try out the API you've set up by adding data. You can do this in one of the following ways: 

* **[Seed the data store with a script](#seed)**.

 The script uses the Petsotre API to add user, pet, and collar data.
* **[Add data one call at a time](#curl)** using a client such as cURL.

 You can use a client to register a user, authenticate as that user, then start adding pet and collars.

<a name="seed" />
## Seeding the data store with a batch script

You can use the included Node.js scripts to add several pets and collars to the data store in a batch. The script uses the StreetCarts API to add the data.

> The data in `combined-seed-data.json` includes all the pet and collar data for convenience (associating collars with the correct pet). To import data one pet or collar at a time, copy data from the JSON seed files named for the type of entity they contain (such as items.json).

1. In a console window, cd to `/petstore/proxies/src/gateway/bin/seed`.

2. **Add user data** by running the following with the users.json file in the `data` directory.

  `node petstore-config-seed register-users ./petstore-config.json ./data/users.json`


3. **Add pet data** by running the following with the combined-seed-data.json and users.json files in the `data` directory. 

 You're including user.json here so that the script can authenticate as each user, then POST the food cart data as that user.

(Right-scroll to see the full command.)
  ```
  node petstore-config-seed create-foodcarts ./petstore-config.json ./data/combined-seed-data.json ./data/users.json
  ```

Now that you've got data in the app, test it! Use a client to [make a call to the Petstore API](#calls).

<a name="curl" />
## Adding data one API call at a time

As an alternative to seeding data with the previous batch script, you can add data by making one API call at a time, as a client app might. The order of these calls is generally like this:

1. POST to /users to register a user.
2. POST to /accesstoken to authenticate as the new user. POSTing pets and collars requires that you have authenticated and have an access token. 
3. POST with your access token to /pets to create a food cart and retrieve its cart UUID.
4. POST with your access token to /pets/{petUUID}/collar to create a collar.

> The following uses the sample data included at `/petstore/proxies/src/gateway/bin/seed/data`.
> 

**Example:**

1. In the `data` directory, open users.json and copy out the first stanza of user data, such as this:

 ```json
  {
      "firstName": "Liz",
      "lastName": "Lynch",
      "address": "Ap #614-3294 Arcu Street",
      "city": "Grand Island",
      "region": "NE",
      "postalCode": "69010",
      "email": "lizzie@example.com",
      "username": "Liz456",
      "password": "Password1"
  }
 ```

2. Using cURL, POST the user data JSON to the `/petstore/users` endpoint to add the data about this user. Keep in mind the following:
 * Include an `x-api-key` header with the consumer key value from either of your Petstore developer apps. (To get this, in the management console, click Publish > Developer Apps, then click either PS-APP-UNLIMITED or PS-APP-TRIAL to see the consumer key.)
 * The username, email, and password are required in the JSON.

 For example, you might have the following:
 
 ```
 curl -H "Content-Type: application/json" -H "x-api-key: n7reKkaYWiMVQopc2AG1jGB8yywGk8gV" -X POST -d '{"firstName": "Liz","lastName": "Lynch","address": "Ap #614-3294 Arcu Street","city": "Grand Island","region": "NE","postalCode": "69010","email": "lizzie@example.com","username": "Liz456","password": "Password1"}' https://myorg-myenv.apigee.net/v1/petstore/users
 ```
 The response from a successful post should be JSON representing the user entity that was created in the data store. You can also check for the user in the API BaaS admin console.
3. Get the Base64 value of your developer app's consumer key and secret.

 You'll need this when authenticating as the user you just created. You'll create a food cart as that user.
 
 Get the consumer key and secret from the Edge developer app details page, then paste them (separated by a colon) into the form at [Base64](https://www.base64encode.org/enc/curl/).
 
 For example, `n7reKkaYWiMVQopc2AG1jGB8yywGk8gV:wU3fimXrjQU8RfU3` encodes to `bjdyZUtrYVlXaU1WUW9wYzJBRzFqR0I4eXl3R2s4Z1Y6d1UzZmltWHJqUVU4UmZVMw==`

4. Using cURL, authenticate with Petstore by POSTing the username and password from the user you created to the `/petstore/accesstoken` endpoint. 

 The request should include:
 * A consumer key value as an `x-api-key` header, as when you posted the user data.
 * The Base64-encoded consumer key and secret as an `Authorization:Basic` header.
 * The username and password as the POST body.
 
 Here's an example:

 ```
 curl -i -H "Content-Type: application/x-www-form-urlencoded" -H "x-api-key: n7reKkaYWiMVQopc2AG1jGB8yywGk8gV" -H "Authorization:Basic bjdyZUtrYVlXaU1WUW9wYzJBRzFqR0I4eXl3R2s4Z1Y6d1UzZmltWHJqUVU4UmZVMw==" -X POST -d "grant_type=password&username=Liz456&password=Password1" https://myorg-myenv.apigee.net/v1/petstore/accesstoken
 ```
 The successful authentication request will return JSON representing the OAuth token, with an `access_token` property.
 
5. From the JSON returned by the API call, copy the `access_token` value.

6. In the `petstore/proxies/src/gateway/bin/seed/data` directory, open pets.json and copy out the first stanza of foodcart data, such as this:

 ```
{
    "petName": "Tasha",
    "breed": "Husky",
    "age": 15
}
```

7. Use cURL to POST to the `/petstore/pets` endpoint, passing the `access_token` value in an `Authorization:Bearer` header. Here's an example:

 ```
 curl -i -H "Content-Type: application/json" -H "Authorization:Bearer q2DU2VNN54Lgy0WxXr5IlLYld6cn" -X POST -d '{"petName": "Tasha","breed": "Husky","age": 15}' https://myorg-myenv.apigee.net/v1/petstore/pets
 ```

 The post's response will be JSON representing the pet data as it is in the data store, including the UUID to identify it.
 
8. Test the POST with a GET to retrieve the pet data, including the pet's UUID after `pets/`, as in this example:

 ```
curl -i -H "x-api-key: n7reKkaYWiMVQopc2AG1jGB8yywGk8gV" -H "Authorization:Bearer q2DU2VNN54Lgy0WxXr5IlLYld6cn" https://myorg-myenv.apigee.net/v1/petstore/pets/6dc152ea-df1d-11e5-8360-275a9243b227
```
 
With additional requests, you can post collars to the pet. Remember that each POST has to be made as a registered user -- in other words, with a user's OAuth token as the value for an `Authorization:Bearer` header

Here's a suggested sequence:

* Add a collar item (from collars.json) to the pet you created:

 ```
POST https://myorg-myenv.apigee.net/v1/petstore/pets/{petUUID}/collars -d {collar-json}
```

<a name="calls" />
# Make calls to Petstore

Once you've set up Petstore, you can use a client to try out its APIs. 

## Quick cURL test

In the Edge management console, grab the consumer key from Petstore' PS-APP-TRIAL or PS-APP-UNLIMITED developer app. Use the consumer key as an API key when making a call that *doesn't* require an OAuth token, such as this GET call:

```
curl https://<your_org>-test.apigee.net/v1/petstore/pets -H 'x-api-key: <your api key>'
```

## Postman

You can use [included collection and environment files](https://github.com/campbebc/BaaSpetstore/tree/master/petstore/clients/postman) for the [Postman application](https://www.getpostman.com/) to call Petstore APIs.