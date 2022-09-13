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
export DECIMAL_24=000000000000000000000000

echo "################### DEPLOY CONTRACT ###################"
near deploy $ORACLE_ID --accountId $ACCOUNT_ID --wasmFile ./res/price_oracle.wasm

near create-account $ORACLE_ID --masterAccount $MAIN_ACCOUNT --initialBalance 10

#echo "################### INIT CONTRACT ###################"
#near call $ORACLE_ID  new '{"recency_duration_sec": 90, "owner_id": "'$ACCOUNT_ID'", "near_claim_amount": "100'$DECIMAL_24'"}'  --accountId=$CONTRACT_ID
#echo "################### UPDATE CLAIM AMOUT ###################"
#near call $ORACLE_ID update_near_claim_amount '{"near_claim_amount": "10'$DECIMAL_24'"}' --accountId $ACCOUNT_ID --depositYocto 1

near call $ORACLE_ID add_oracle '{"account_id": "priceo-racle.nearlog.testnet"}' --accountId $ACCOUNT_ID --depositYocto 1
near call $ORACLE_ID add_oracle '{"account_id": "bot1.nearlog.testnet"}' --accountId $ACCOUNT_ID --depositYocto 1
near call $ORACLE_ID add_oracle '{"account_id": "bot2.nearlog.testnet"}' --accountId $ACCOUNT_ID --depositYocto 1


echo "################### ADD ASSET ###################"
near call $ORACLE_ID add_asset '{"asset_id": "wrap.testnet"}' --accountId $ACCOUNT_ID --depositYocto 1
near call $ORACLE_ID add_asset '{"asset_id": "weth.fakes.testnet"}' --accountId $ACCOUNT_ID --depositYocto 1


near view $ORACLE_ID get_oracles '{"from_index": 0, "limit": 10}'
near view $ORACLE_ID get_assets '{"from_index": 0, "limit": 10}'
near view $ORACLE_ID get_price_data '{"asset_ids": ["'$DAI_TOKEN_ID'", "'$USDT_TOKEN_ID'"]}'
