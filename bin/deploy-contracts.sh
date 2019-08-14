#!/bin/bash

. .setup_env

# // TODO key generation
# KEY_FILES=$CONTRACT_KEY_FILES
# .load_keys
#
# mkdir -p contracts/contracts/keys/
# cp -f $KEY_DIR/*.sol contracts/contracts/keys/

echo redeploying for the db $DATABASE_URL
cd contracts
yarn deploy  | tee ../deploy.log
cd ..

CONTRACT_ADDR_NEW_VALUE=`grep "CONTRACT_ADDR" deploy.log`
if [[ ! -z "$CONTRACT_ADDR_NEW_VALUE" ]]
then
    export LABEL=$FRANKLIN_ENV-Contract_deploy-`date +%Y-%m-%d-%H%M%S`
    mkdir -p logs/$LABEL/
    cp ./$ENV_FILE logs/$LABEL/$FRANKLIN_ENV.bak
    cp deploy.log logs/$LABEL/
    echo $CONTRACT_ADDR_NEW_VALUE
    python3 bin/replace-env-variable.py ./$ENV_FILE $CONTRACT_ADDR_NEW_VALUE
else
    echo "Contract deployment failed"
    exit 1
fi