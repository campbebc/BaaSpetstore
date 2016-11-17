#!/bin/bash


# Change the following as appropriate
stty_orig=`stty -g` # save original terminal setting.

usage() {
    CMD=`basename $0`
    echo "Usage:"
    echo "$CMD [-u email] [-p password] [-o org-name] [-e env] [-d deployenv] [-r rev] [-x proxyhost] [-g baasorg] [-a baasapi] [-b baasapp]"
    echo "              username:       Pmail address of Edge user"
    echo "              password:       Password of Edge user"
    echo "              org-name:       Name of existing organization"
    echo "              env:            Management API URL as https://api.enterprise.apigee.com or https://api.e2e.apigee.net"
    echo "              deployenv:      The environment the proxies are deployed to"
    echo "              rev:            Data manager proxy current revision"
    echo "              proxyhost:      The host part of the URL to your API proxies"
    echo "              baasorg:        The API BaaS organization you want to use. Does not need to be the same as your Edge organization."
    echo "              baasapp:        The name of your API BaaS application"
    echo "              baasapi:        The API BaaS API URL; https://apibaas-trial.apigee.net for the cloud"
    exit 1
}

while getopts "u:p:o:e:d:r:x:h:g:a:b" opt; do
case $opt in
# variable options
    u)  username=$OPTARG ;;
    p)  password=$OPTARG ;;
    o)  org=$OPTARG ;;
    e)  env=$OPTARG ;;
    d)  deployenv=$OPTARG ;;
    r)  rev=$OPTARG ;;
    x)  proxyhost=$OPTARG ;;
    g)  baasorg=$OPTARG ;;
    a)  baasapp=$OPTARG ;;
    b)  baasapi=$OPTARG ;;
    h)  usage ;;

esac
done

# check to see

echo -e

echo -e " _______________     "
echo -e " |  |       |  |     "  
echo -e " |__|_______|_ |           Welcome to         " 
echo -e " |  PETSTORE!  |     "
echo -e " |_____________|     '  The Petstore API Project"  
echo -e "**************************************************"
echo -e "Provide some info so we can build and deploy"
echo -e "the StreetCarts project to your Edge org."
echo -e "There is a separate script for bootstrapping"
echo -e "sample data into your API BaaS application."
echo -e "See the project readme file for more information."
echo -e " "
echo -e "NOTE: When you first run the script, you'll see"
echo -e "a few 'not found' or 'doesn't exist' errors."
echo -e "Happily ignore those."
echo -e "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
echo -e

if [ -z "${username}" ]; then
    read -p "Apigee email: " username
fi

echo -e

if [ -z "${password}" ]; then
    read -sp "Password: " password
fi

echo -e
echo -e

if [ -z "${org}" ]; then
    read -p "Apigee organization name: " org
fi

echo -e

if [ -z "${env}" ]; then
    ENV_DEFAULT="https://api.enterprise.apigee.com"
    echo -e "The management API URL, such as https://api.enterprise.apigee.com or https://api.e2e.apigee.net."
    read -p "Default is [$ENV_DEFAULT]: " env
    env="${env:-$ENV_DEFAULT}"
fi

echo -e

if [ $env = "https://api.e2e.apigee.net" ]; then
        server=".e2e"
fi

echo -e

if [ -z "${deployenv}" ]; then
    DEPLOYENV_DEFAULT="test"
    echo -e "The environment to deploy to, such as test or prod."
    read -p "Default is [$DEPLOYENV_DEFAULT]: " deployenv
    deployenv="${deployenv:-$DEPLOYENV_DEFAULT}"
fi

echo -e

if [ -z "${rev}" ]; then
    REV_DEFAULT="1"
    echo -e "The current revision of the data-manager proxy. Accept the default if you haven't manually changed the revision."
    read -p "Default is [$REV_DEFAULT]: " rev
    rev="${rev:-$REV_DEFAULT}"
fi

echo -e

if [ -z "${proxyhost}" ]; then
    PROXYHOST_DEFAULT="$org-$deployenv$server.apigee.net"
    echo -e "The host for your API proxies, such as $org-$deployenv.apigee.net."
    read -p "Default is [$PROXYHOST_DEFAULT]: " proxyhost
    proxyhost="${proxyhost:-$PROXYHOST_DEFAULT}"
fi

echo -e

if [ -z "${baasorg}" ]; then
    BAASORG_DEFAULT="$org"
    echo -e "The API BaaS organization you want to use. This can be different than your Edge organization."
    read -p "Default is [$BAASORG_DEFAULT]: " baasorg
    baasorg="${baasorg:-$BAASORG_DEFAULT}"
fi

echo -e

if [ -z "${baasapp}" ]; then
    BAASAPP_DEFAULT="sandbox"
    echo -e "The API BaaS application you want to use."
    read -p "Default is [$BAASAPP_DEFAULT]: " baasapp
    baasapp="${baasapp:-$BAASAPP_DEFAULT}"
fi

echo -e

if [ -z "${baasapi}" ]; then
    BAASAPI_DEFAULT="https://apibaas-trial.apigee.net"
    echo -e "The API BaaS API URL. Select the default if you are using the cloud version."
    read -p "Default is [$BAASAPI_DEFAULT]: " baasapi
    baasapi="${baasapi:-$BAASAPI_DEFAULT}"
fi


# Verify Apigee admin credentials

source ./verify.sh


# Build the API proxies

echo -e "\n***************************************************************************"
echo -e "* Do you want to build and deploy the Petstore proxies?                   *"
echo -e "*                           NOTE                                          *"
echo -e "* When redeploying, the existing revision is overwritten.                 *"
echo -e "* If you want this script to create new revisions, exit this script,      *"
echo -e "* open petstore_build.sh for edit, and comment out the '=clean' lines. *"
echo -e "*                                                                         *"
echo -e "* Continue with build/deploy? ([y]/n)                                     *"
echo -e "***************************************************************************"
read build

if [ -z $build ] || [ "$build" = "y" ]; then
  source ./petstore_build.sh
fi


# Sample API products, developer, and apps


echo -e "\n***************************************************"
echo -e "*         Creating Petstore Entities              *"
echo -e "*         ----------------------------            *"
echo -e "* This step lets you create the required entities *"
echo -e "* to make StreetCarts API calls.                  *"
echo -e "*                  CAUTION                        *"
echo -e "* If you ran this step previously, the existing   *"
echo -e "* entities will be deleted and re-created,        *"
echo -e "* which means you'll need to replace the API keys *"
echo -e "* in the StreetCarts Postman collection with the  *"
echo -e "* new keys generated in this step.                *"
echo -e "***************************************************"
echo -e "\n[See the caution above.] Would you like to proceed with creating new entities? ([y]/n):"
read setup

if [ -z $setup ] || [ "$setup" = "y" ]; then
  source ./apps_setup.sh
fi
