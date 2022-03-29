const CHAIN_IDS = { 1337: "ganache", 80001: "mumbai", 137: "polygon" };

async function getNetworkName(config) {
	if (typeof(config) === "undefined" || config.network === "dashboard") {
		const thisWeb3 = web3 ?? artifacts.require("Migrations").interfaceAdapter.web3;
		const chainId = await thisWeb3.eth.getChainId();

		return CHAIN_IDS[chainId] ?? "development";
	}
	return config.network;
}

module.exports = { getNetworkName };