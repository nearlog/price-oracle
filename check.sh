#!/bin/bash
export MAIN_ACCOUNT=nearlog.testnet
export NEAR_ENV=testnet
export OWNER_ID=$MAIN_ACCOUNT
export ORACLE_ID=price-oracle.$MAIN_ACCOUNT
export ACCOUNT_ID=$MAIN_ACCOUNT
export CONTRACT_ID=main.$MAIN_ACCOUNT
export WETH_TOKEN_ID=weth.fakes.testnet
export WNEAR_TOKEN_ID=wrap.testnet
export ONE_YOCTO=0.000000000000000000000001
export GAS=200000000000000
export DECIMAL_18=000000000000000000


./build.sh

echo "################### DELETE ACCOUNT ###################"
near delete $ORACLE_ID $ACCOUNT_ID

echo "################### CREATE ACCOUNT ###################"

near create-account $ORACLE_ID --masterAccount $ACCOUNT_ID --initialBalance 10
# near create-account $CONTRACT_ID --masterAccount $ACCOUNT_ID --initialBalance 10

echo "################### CREATE CONTRACT ###################"
near deploy $ORACLE_ID --accountId $ACCOUNT_ID --wasmFile ./res/price_oracle.wasm 



near call $ORACLE_ID  new '{"recency_duration_sec": 5000}'  --accountId=$CONTRACT_ID
# #########################

near call $ORACLE_ID  add_oracle '{"account_id": "'$CONTRACT_ID'"}'  --accountId=$ORACLE_ID

near call $ORACLE_ID add_asset '{"asset_id": "'$WETH_TOKEN_ID'"}' --accountId=$ORACLE_ID
near call $ORACLE_ID add_asset '{"asset_id": "'$WNEAR_TOKEN_ID'"}' --accountId=$ORACLE_ID


near call $ORACLE_ID  report_prices '{
    "prices": 
    [{
        "asset_id": "'$WETH_TOKEN_ID'", 
        "price": {
            "multiplier": "10", 
            "decimals": 0
        }
    }, {
        "asset_id": "'$WNEAR_TOKEN_ID'", 
        "price": {
            "multiplier": "10", 
            "decimals": 12
        }
    }]
}'  --accountId=$CONTRACT_ID


near view $ORACLE_ID get_oracles '{"from_index": 0, "limit": 10}'
near view $ORACLE_ID get_assets '{"from_index": 0, "limit": 10}'
near view $ORACLE_ID get_price_data '{"asset_ids": ["'$WETH_TOKEN_ID'", "'$WNEAR_TOKEN_ID'"]}'

