build-contract:
	cd ./dpp && sui move build -d

publish-contract:
	cd ./dpp && sui client publish

get-objects:
	sui client objects

grant-admin-cap:
	sui client call --package 0xf2d0c7bdbeca586e86b1d4340209dbd6674cdda4f757a2aeac6e5208fe190434 --module dpp --function add_admin_capability --args 0xbf701b2a32ec9a16c96cf9b157c795df8f4670419fd23fe8f96f0401194fe4de 0x95f89c26df39e703fc36f608e5d461dffbb50d7e7eba16618d67e4dbef9c7b80  

grant-dids-issuer-cap:
	cd .

grant-

convert-key:
	sui keytool convert <keystore>