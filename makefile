addresses-list:
	iota client addresses

new-address:
	iota client new-address ed25519

objects-list:
	iota client objects

faucet:
	iota client faucet

build-contract:
	cd ./dpp && iota move build

upgrade-contract:
	cd ./dpp && iota client upgrade

test-contract:
	cd ./dpp && iota move test

publish-contract:
	cd ./dpp && iota client publish --gas-budget 1000000000 --skip-dependency-verification

upgrade-contract:
	cd ./dpp && iota client upgrade --upgrade-capability <<VC_ISSUER_CAP_ID>> --skip-dependency-verification

get-objects:
	iota client objects

grant-admin-cap:
	iota client call --package <<PACKAGE ID>> --module dpp --function grant_admin_capability --args <<ADMIN_CAP_ID>> <RECIPIENT_ADDR> --gas-budget 10000000

grant-vc-issuer-cap:
	iota client call --package <<PACKAGE ID>> --module dpp --function grant_vc_issuer_capability --args <<ADMIN_CAP_ID>> <RECIPIENT_ADDR> --gas-budget 10000000

grant-trace-cap:
	iota client call --package <<PACKAGE ID>> --module dpp --function grant_trace_capability --args <<VC_ISSUER_CAP_ID>> <RECIPIENT_ADDR> manufacturer --gas-budget 10000000

trace_event:
	iota client call --package <<PACKAGE ID>>  \
    --module dpp \
    --function trace_event \
    --args <<TRACE_CAP_ID>> \
    '[ "https://example.com/uri1", "https://example.com/uri2" ]' \
    '[ "proof1", "proof2" ]' \
    "" \
	"previous transaction digest" \
    --gas-budget 100000000

convert-key:
	iota keytool convert <<keystore key>>