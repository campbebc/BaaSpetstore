
#!/bin/sh


# clone the GitHub repo
echo -e "\n***** Pull from GitHub"
sc_bin=$(pwd)
cd ../../../../../
git pull https://github.com/campbebc/BaaSpetstore
cd $sc_bin
cd ..

# Deploy the API proxies with Maven
# The -Doptions=clean undeploys and deletes the existing revision
# -Dproxyhost contains a value that is used by Maven to auto-replace URLs in the proxy config files.

echo -e "\n***** Deploying the API proxies"

cd collars
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Doptions=clean
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Dproxyhost=$proxyhost
rm -r target
cd ..

cd pets
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Doptions=clean
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Dproxyhost=$proxyhost
rm -r target
cd ..

cd users
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Doptions=clean
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Dproxyhost=$proxyhost
rm -r target
cd ..

cd accesstoken
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Doptions=clean
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Dproxyhost=$proxyhost
rm -r target
cd ..

cd data-manager-pet
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Doptions=clean
mvn install -P test -Dusername=$username -Dpassword=$password -Dorg=$org -Denv=$env -Dproxyhost=$proxyhost -Dbaasorg=$baasorg -Dbaasapp=$baasapp -Dbaasapi=$baasapi
rm -r target
cd ..


# Install the Node.js dependencies for the data-manager proxy, then redeploy the proxy
echo -e "\n***** Installing the Node.js dependencies in the data-manager-pet API proxy"

curl -v -X POST --header "Content-Type: application/x-www-form-urlencoded" -u $username:$password -d "command=install" "$env/v1/organizations/$org/apis/data-manager-pet/revisions/$rev/npm"

curl -v -X DELETE -u $username:$password "$env/v1/organizations/$org/environments/$deployenv/apis/data-manager-pet/revisions/$rev/deployments"

curl -v -X POST -u $username:$password "$env/v1/organizations/$org/environments/$deployenv/apis/data-manager-pet/revisions/$rev/deployments?override=true"

cd bin

