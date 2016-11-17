#!/bin/sh

echo -e "\n********** Forcing cleanup **********"

echo -e "\n**** Deleting Apps"

curl -u $username:$password $env/v1/o/$org/developers/petstore@example.com/apps/PS-APP-TRIAL -X DELETE
curl -u $username:$password $env/v1/o/$org/developers/petstore@example.com/apps/PS-APP-UNLIMITED -X DELETE
curl -u $username:$password $env/v1/o/$org/developers/petstore@example.com/apps/PS-DATA-MANAGER-APP -X DELETE

echo -e "\n**** Deleting Data Manager App KeyValueMap"

curl -u $username:$password $env/v1/o/$org/environments/$deployenv/keyvaluemaps/DATA-MANAGER-PET-API-KEY -X DELETE

echo -e "\n**** Deleting Developers"

curl -u $username:$password $env/v1/o/$org/developers/petstore@example.com -X DELETE


echo -e "\n**** Deleting Products"

curl -u $username:$password $env/v1/o/$org/apiproducts/PS-PRODUCT-TRIAL -X DELETE
curl -u $username:$password $env/v1/o/$org/apiproducts/PS-PRODUCT-UNLIMITED -X DELETE
curl -u $username:$password $env/v1/o/$org/apiproducts/PS-DATA-MANAGER-PRODUCT -X DELETE


echo -e "\n**** Cleanup Completed"

echo -e "\n********** Creating new developers, products, apps, and KVM **********"

# Create a Developer

echo  -e "\n**** CREATING DEVELOPER"
curl -u $username:$password $env/v1/o/$org/developers \
  -H "Content-Type: application/xml" -X POST -T ./entities/PS-DEVELOPER.xml

# Create API Products

echo  -e "\n**** CREATING PS-PRODUCT-TRIAL"
curl -u $username:$password $env/v1/o/$org/apiproducts \
  -H "Content-Type: application/json" -X POST -T ./entities/PS-PRODUCT-TRIAL.json

echo  -e "\n**** CREATING PS-PRODUCT-UNLIMITED"
curl -u $username:$password $env/v1/o/$org/apiproducts \
  -H "Content-Type: application/json" -X POST -T ./entities/PS-PRODUCT-UNLIMITED.json

  echo  -e "\n**** CREATING PS-DATA-MANAGER-PRODUCT"
curl -u $username:$password $env/v1/o/$org/apiproducts \
  -H "Content-Type: application/json" -X POST -T ./entities/PS-DATA-MANAGER-PRODUCT.json


# Create Developer Apps

echo  -e "\n**** CREATING PS-APP-TRIAL"
curl -u $username:$password \
  $env/v1/o/$org/developers/petstore@example.com/apps \
  -H "Content-Type: application/json" -X POST -T ./entities/PS-APP-TRIAL.json

echo  -e "\n**** CREATING PS-APP-UNLIMITED"
curl -u $username:$password \
  $env/v1/o/$org/developers/petstore@example.com/apps \
  -H "Content-Type: application/json" -X POST -T ./entities/PS-APP-UNLIMITED.json

 echo  -e "\n**** CREATING PS-DATA-MANAGER-APP"
curl -u $username:$password \
  $env/v1/o/$org/developers/petstore@example.com/apps \
  -H "Content-Type: application/json" -X POST -T ./entities/PS-DATA-MANAGER-APP.json


echo -e "\n**** GET KEY AND SECRET FROM PS-APP-TRIAL"

ks=`curl -u "$username:$password" "$env/v1/o/$org/developers/petstore@example.com/apps/PS-APP-TRIAL" 2>/dev/null | egrep "consumer(Key|Secret)"`
key=`echo $ks | awk -F '\"' '{ print $4 }'`
secret=`echo $ks | awk -F '\"' '{ print $8 }'`


echo -e "\n**** Got Consumer Key for Trial App: $key ****"
echo -e "\n**** Got Consumer Secret for Trial: $secret ****"

echo -e "\n**** BASE64 ENCODE THE KEY:SECRET FOR THE TRIAL APP"

auth=$(echo -ne "$key:$secret" | base64);
echo -e "\n**** Base64 encoded credentials:  $auth ****"



echo -e "\n**** GET KEY AND SECRET FROM PS-APP-UNLIMITED"

ks=`curl -u "$username:$password" "$env/v1/o/$org/developers/petstore@example.com/apps/PS-APP-UNLIMITED" 2>/dev/null | egrep "consumer(Key|Secret)"`
key=`echo $ks | awk -F '\"' '{ print $4 }'`
secret=`echo $ks | awk -F '\"' '{ print $8 }'`


echo -e "\n**** Got Consumer Key for Unlimited App: $key ****"
echo -e "\n**** Got Consumer Secret for Unlimited: $secret ****"


echo -e "\n**** BASE64 ENCODE THE KEY:SECRET FOR THE TRIAL APP"

auth=$(echo -ne "$key:$secret" | base64);
echo -e "\n**** Base64 encoded credentials:  $auth ****"



echo -e "\n**** GET KEYS FROM THE DATA-MANAGER APP"

ks=`curl -u "$username:$password" "$env/v1/o/$org/developers/petstore@example.com/apps/PS-DATA-MANAGER-APP" 2>/dev/null | egrep "consumer(Key|Secret)"`
key=`echo $ks | awk -F '\"' '{ print $4 }'`
secret=`echo $ks | awk -F '\"' '{ print $8 }'`


echo -e "\n**** Got Consumer Key for Data Manager App: $key ****"
echo -e "\n**** Got Consumer Secret for Data Manager App: $secret ****"


echo -e "\n**** CREATE A KVM AND ADD THE DATA MANAGER APP KEY TO IT"
curl -u $username:$password \
  $env/v1/o/$org/environments/$deployenv/keyvaluemaps \
  -H "Content-Type: application/json" -X POST -d \
'{   
"name" : "DATA-MANAGER-PET-API-KEY",
"entry" : [ { "name" : "X-DATA-MANAGER-KEY", "value" : "'$key'" }]
}'

echo -e "\n**** BASE64 ENCODE THE KEY:SECRET FOR THE DATA-MANAGER APP"
auth=$(echo -ne "$key:$secret" | base64);
echo -e "\n**** Base64 encoded credentials:  $auth ****"


echo -e "\nDONE CREATING ENTITIES"
echo -e "\n"


