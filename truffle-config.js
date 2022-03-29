const fs = require("fs");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const SECRETS = JSON.parse(fs.readFileSync("secrets.json"));
const TRUFFLE_CONFIG = {
	api_keys: { polygonscan: SECRETS.POLYGONSCAN_API_KEY }, 
	license: "LicenseRef-DSPL AND LicenseRef-NIGGER", 
	networks: {
		development: {
			host: "127.0.0.1", 
			network_id: "*", 
			port: 9545
		}, 
		ganache: {
			host: "127.0.0.1", 
			network_id: 1337, 
			provider: () => new HDWalletProvider({ mnemonic: { phrase: SECRETS.WALLET_MNEMONIC }, providerOrUrl: "http://127.0.0.1:7545" }), 
			port: 7545
		}, 
		mumbai: {
			network_id: 80001, 
			provider: () => new HDWalletProvider({ mnemonic: { phrase: SECRETS.WALLET_MNEMONIC }, providerOrUrl: SECRETS.ALCHEMY_API_KEY_MUMBAI }), 
		}, 
		polygon: {
			network_id: 137, 
			provider: () => new HDWalletProvider({ mnemonic: { phrase: SECRETS.WALLET_MNEMONIC }, providerOrUrl: SECRETS.ALCHEMY_API_KEY_POLYGON }), 
		}
	},
	mocha: {
		// timeout: 100000
	},
	compilers: {
		solc: {
			settings: {
				optimizer: {
					details: {
						constantOptimizer: true, 
						cse: true, 
						deduplicate: true, 
						jumpdestRemover: true, 
						peephole: true, 
						yul: true
					}, 
					runs: 200
				}, 
				viaIR: true
			}, 
			version: "0.8.13"
		}
	}
};
TRUFFLE_CONFIG.networks.develop = TRUFFLE_CONFIG.networks.development;
module.exports = TRUFFLE_CONFIG;