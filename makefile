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
	sui client call --package 0x9f62bf2c8a39952f30bc900f339fd2bab351d3aaf9441e9f7be5ff96e1f0ba3b --module dpp --function grant_admin_capability --args 0x1f4253ff93303d60da6e13bb89585eb0d5dccc07bd4395ec72159f82f80b53d1 0x2b80f43474f594057365b7cc055b61e8108a6d31ac668317054928951bf5998c --gas-budget 10000000

grant-dids-issuer-cap:
	sui client call --package 0x9f62bf2c8a39952f30bc900f339fd2bab351d3aaf9441e9f7be5ff96e1f0ba3b --module dpp --function grant_dids_issuer_capability --args 0x1f4253ff93303d60da6e13bb89585eb0d5dccc07bd4395ec72159f82f80b53d1 0x56f48f8da40818f1ae138e5bfe48a5b922076af9360a4346843ad2c96187737e --gas-budget 10000000

grant-trace-cap:
	sui client call --package 0x9f62bf2c8a39952f30bc900f339fd2bab351d3aaf9441e9f7be5ff96e1f0ba3b --module dpp --function grant_trace_capability --args 0x37db66b17726663d0178db82aca6cc6514add7527ddb61bb1201d7d5ac278423 0x56f48f8da40818f1ae138e5bfe48a5b922076af9360a4346843ad2c96187737e manufacturer --gas-budget 10000000

trace_event:
	sui client call --package 0x9f62bf2c8a39952f30bc900f339fd2bab351d3aaf9441e9f7be5ff96e1f0ba3b --module dpp --function trace_event --args 0x1f4253ff93303d60da6e13bb89585eb0d5dccc07bd4395ec72159f82f80b53d1 0x2b80f43474f594057365b7cc055b61e8108a6d31ac668317054928951bf5998c --gas-budget 10000000


convert-key:
	sui keytool convert <keystore>