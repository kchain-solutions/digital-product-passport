addresses-list:
	sui client addresses

new-address:
	sui client new-address ed25519

objects-list:
	sui client objects

faucet:
	sui client faucet

build-contract:
	cd ./dpp && sui move build -d

upgrade-contract:
	cd ./dpp && sui client upgrade

publish-contract:
	cd ./dpp && sui client publish

get-objects:
	sui client objects

grant-admin-cap:
	sui client call --package 0x9f62bf2c8a39952f30bc900f339fd2bab351d3aaf9441e9f7be5ff96e1f0ba3b --module dpp --function grant_admin_capability --args <<ADMIN_CAP_ID>> <RECIPIENT_ADDR> --gas-budget 10000000

grant-dids-issuer-cap:
	sui client call --package 0x9f62bf2c8a39952f30bc900f339fd2bab351d3aaf9441e9f7be5ff96e1f0ba3b --module dpp --function grant_dids_issuer_capability --args <<ADMIN_CAP_ID>> <RECIPIENT_ADDR> --gas-budget 10000000

grant-trace-cap:
	sui client call --package 0x9f62bf2c8a39952f30bc900f339fd2bab351d3aaf9441e9f7be5ff96e1f0ba3b --module dpp --function grant_trace_capability --args <<DIDS_ISSUER_CAP_ID>> <RECIPIENT_ADDR> manufacturer --gas-budget 10000000

trace_event:
	sui client call --package 0x9f62bf2c8a39952f30bc900f339fd2bab351d3aaf9441e9f7be5ff96e1f0ba3b --module dpp --function trace_event --args <<TRACE_CAP_ID>> <<product_id>> <<uri>> <<proof>> <<optional_data>>  <<previous_tx>> --gas-budget 10000000

convert-key:
	sui keytool convert <keystore key>