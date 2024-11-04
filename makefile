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

test-contract:
	cd ./dpp && sui move test

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
	sui client call --package 0x0d087311f002d3204e364b1c5e3159ff1f0c975edb8df367d78e28d1716a9c67 \
    --module dpp \
    --function trace_event \
    --args 0x36d3d90f4a48c917c345f798b5232fce484b76d35ba6e11136029cb80b8b560a "product123" \
    '[ "https://example.com/uri1", "https://example.com/uri2" ]' \
    '[ "proof1", "proof2" ]' \
    "optional data" "previous transaction hash" \
    --gas-budget 100000000

convert-key:
	sui keytool convert <keystore key>