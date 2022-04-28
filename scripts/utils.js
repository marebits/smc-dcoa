const CHAIN_IDS = { 1337: "ganache", 80001: "mumbai", 137: "polygon" };

async function getNetworkName(config) {
	if (typeof(config) === "undefined" || config.network === "dashboard") {
		const thisWeb3 = web3 ?? artifacts.require("Migrations").interfaceAdapter.web3;
		const chainId = await thisWeb3.eth.getChainId();

		return CHAIN_IDS[chainId] ?? "development";
	}
	return config.network;
}

function prepareTemplate(strings, ...args) {
	const result = args.reduce((result, arg, i) => {
		const j = i << 1;
		[result[j], result[j + 1]] = [strings[i], arg];
		return result;
	}, new globalThis.Array(strings.length + args.length));
	result[result.length - 1] = strings[strings.length - 1];
	return result;
}

function processTemplate(template, replacements) { return template.map(item => (typeof replacements[item] === "undefined") ? item.toString() : replacements[item]).join(""); }

module.exports = { getNetworkName, prepareTemplate, processTemplate };