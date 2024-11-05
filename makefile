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
	sui client call --package <<PACKAGE ID>> --module dpp --function grant_admin_capability --args <<ADMIN_CAP_ID>> <RECIPIENT_ADDR> --gas-budget 10000000

grant-vc-issuer-cap:
	sui client call --package <<PACKAGE ID>> --module dpp --function grant_vc_issuer_capability --args <<ADMIN_CAP_ID>> <RECIPIENT_ADDR> --gas-budget 10000000

grant-trace-cap:
	sui client call --package <<PACKAGE ID>> --module dpp --function grant_trace_capability --args <<DIDS_ISSUER_CAP_ID>> <RECIPIENT_ADDR> manufacturer --gas-budget 10000000

trace_event:
	sui client call --package <<PACKAGE ID>>  \
    --module dpp \
    --function trace_event \
    --args <<VC_CAP_ID>> \
	"product123" \
    '[ "https://example.com/uri1", "https://example.com/uri2" ]' \
    '[ "proof1", "proof2" ]' \
    "{}" \
	"previous transaction digest" \
    --gas-budget 100000000

convert-key:
	sui keytool convert <<keystore key>>