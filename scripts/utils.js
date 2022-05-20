const CHAIN_IDS = { 1337: "ganache", 80001: "mumbai", 137: "polygon" };

function asyncDelay(delayTimeMs) { return new Promise(resolve => setTimeout(resolve, delayTimeMs)); }

async function getNetworkName(config, web3 = globalThis.web3) {
	if (typeof(config) === "undefined" || config.network === "dashboard") {
		const thisWeb3 = (typeof web3 === "undefined") ? artifacts.require("Migrations").interfaceAdapter.web3 : web3;
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

module.exports = { asyncDelay, getNetworkName, prepareTemplate, processTemplate };