const DEPLOY_SIGNER = "0x3B80dEddcDa2eAF151B1402457450BCc98a25306"; // (await web3.eth.getAccounts())[1]
const SIGNERS = {
	development: "0xbaeb3bd505b6674bf44ede0f00e86c7172b40b39", 
	ganache: DEPLOY_SIGNER, 
	mumbai: DEPLOY_SIGNER, 
	polygon: DEPLOY_SIGNER
};
SIGNERS.develop = SIGNERS.development;
module.exports = globalThis.Object.freeze(SIGNERS);