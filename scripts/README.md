# Silver Mare Coin Digital Certificate of Authenticity Scripts
These scripts are used to help generate claim codes, generate metadata files, and during migration of contracts to the blockchain.

Due to the fact Truffle does not support ECMAScript modules, there is an unfortunate mix of `js` and `mjs` files.

- [`Collection.mjs`](./Collection.mjs) - Contains the `Collection` class used as a base class for `FileGeneratorCollection`; utilizes a `WeakMap` and custom methods to access data stored therein as `CollectionItem`s
- [`CollectionItem.mjs`](./CollectionItem.mjs) - Simple base class defining an immutable `key`/`value` pair
- [`ContractMetadata.mjs`](./ContractMetadata.mjs) - Class used to generate the JSON metadata describing the contract
- [`ContractMetadataFiles.mjs`](./ContractMetadataFiles.mjs) - Class used to generate and upload to IPFS files containing the JSON metadata and image describing the contract
- [`FileGeneratorCollection.mjs`](./FileGeneratorCollection.mjs) - A `Collection` of objects that can be used to generate files; base class for `TokenGenericCollection`
- [`Files.js`](./Files.js) - CommonJS module used to import the ECMAScript modules `ContractMetadataFiles` and `TokenMetadataFiles` to Truffle scripts
- [`generateClaimCodes.js`](./generateClaimCodes.js) - Utility script (executable from main project dir with `npx truffle exec scripts/generateClaimCodes.js --network NETWORKNAME`) that generates certificate claim codes and stores them in a `claimCodes-NETWORKNAME.json` file; uses the appropriate signer defined in `signers.js` and requires the `SilverMareCoinDCoA` contract be deployed already to `NETWORKNAME`
- [`MultiLineSentence.mjs`](./MultiLineSentence.mjs) - Class that will split a sentence up into multiple lines so that each line will not exceed a given line length; this is used by `TokenImage.mjs` to print multiple lines of `text` in the output SVG
- [`signers.js`](./signers.js) - Defines the certificate signing addresses used for different networks
- [`TokenGenericCollection.mjs`](./TokenGenericCollection.mjs) - Class containing common properties to token-related `FileGeneratorCollection`s; base class for `TokenImageCollection` and `TokenMetadataCollection`
- [`TokenImage.mjs`](./TokenImage.mjs) - CLass defining the image for each token; currently this generates a SVG image, but may change in the future depending on the final image to be included with token metadata
- [`TokenImageCollection.mjs`](./TokenImageCollection.mjs) - A `Collection` of `TokenImage`s
- [`TokenMetadata.mjs`](./TokenMetadata.mjs) - Class defining the JSON metadata for each token
- [`TokenMetadataCollection.mjs`](./TokenMetadataCollection.mjs) - A `Collection` of `TokenMetadata`
- [`TokenMetadataFiles.mjs`](./TokenMetadataFiles.mjs) - Class which constructs and uploads all files defined by `TokenImageCollection` and `TokenMetadataCollection` to IPFS and provides the resultant URIs
- [`utils.js`](./utils.js) - Provides helper utility functions used by scripts in this directory and Truffle migration scripts
	- `getNetworkName(config)` - Returns the network name; `config` is an optional object that contains a `network` property that may already have a potentially valid network name
	- `prepareTemplate(strings, ...args)` - Intended to be used as a tagged template function, used to prepare template strings containing `Symbol`s to be processed by `processTemplate`.  Returns an array.  Easiest way to use this is to call it as a tagged template: ``prepareTemplate`String with a ${Symbol("iwtcits")} symbol in it` ``.  In practice, you will want to use a variable to store your `Symbol` since each time `Symbol()` is called it creates a brand new `Symbol` regardless of the value you pass to it!
	- `processTemplate(template, replacements)` - Returns a processed template string.  Intended to be called on a template string prepared by `prepareTemplate`; processes `template` array and makes the replacements defined by `replacements`, which is an object containing the `Symbol`s and their corresponding values that should replace the string.  For example: `processTemplate(template, { [symbolVariable]: "I want to cum inside Twilight Sparkle" })`