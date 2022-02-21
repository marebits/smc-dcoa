# Silver Mare Coin Digital Certificate of Authenticity

This project is to create a Digital Certificate of Authenticity (DCoA) for the Silver Mare Coin Project thread on [/mlp/](https://4channel.org/mlp/).  This DCoA will be created using an [ERC-721](https://eips.ethereum.org/EIPS/eip-721) token contract on the [Polygon blockchain](https://polygon.technology/).

In order to claim a DCoA token, a claim code will need to be provided.  These claim codes will likely consist of a message and a signed hash of that message by a predetermined address (**TBD**); verifying the signature originated from the predetermined address will prevent tampering and prove the claimant was the original purchaser of the Silver Mare Coin.  Claim codes will be provided by a Silver Mare Coin Project manager to the purchasers.

Thus each token generated by this contract will only be claimable by a purchaser of a Silver Mare Coin, and each purchaser will be issued as many claim codes to match the number of Silver Mare Coins they purchased (if they so desire).  The token may contain metadata providing the serial number (**TBD**) of their coin(s).

## Deployment
Here is the contract address of the official Silver Mare Coin Digital Certificate of Authenticity (only the one on the Polygon counts; there may be deployments to test networks for testing purposes).  All of these contracts will be verified on Polygonscan in order to make interacting with them *very easy*.  Click the link below, then click on `Read Contract` to get data and `Write Contract` to execute functions that modify the block chain (you will need a wallet like [Metamask](https://metamask.io/) if you are using the `Write Contract` functions).

* Polygon: **[TBD](https://polygonscan.com/address/TBD#code "View on Polygonscan")**
* Mumbai (test network): **[TBD](https://polygonscan.com/address/TBD#code "View on Polygonscan")**

(If you need to claim your tokens and need a small amount of MATIC, please send your wallet address to <iwtcits@mare.biz> and I will send you some.)

## Using the deployed contract
### Functions
<ul>
<li>Custom functions <b>TBD</b>
<dl>
<dt><code>contractURI() returns (string)</code></dt>
<dd>Returns the Uniform Resource Indicator (URI) for this contract.  This is used by <a href="https://docs.opensea.io/docs/contract-level-metadata">OpenSea</a> (and possibly other online token marketplaces) to display overall collection metadata related to all the DCoA tokens issued by this contract.</dd>
</dl>
</li>
<li><a href="https://eips.ethereum.org/EIPS/eip-721">ERC-721</a> standard functions
<dl>
<dt><code>approve(address approved, uint256 tokenId)</code></dt>
<dd>Sets an approved address that is allowed to transfer the DCoA specified by the <code>tokenId</code>.  Only use this if you need to transfer your DCoA to another address using an external smart contract.  Set to the zero address to clear this approval when you are done.</dd>

<dt><code>balanceOf(address owner) returns (uint256)</code></dt>
<dd>Returns the number of DCoA tokens held by an owner address</dd>

<dt><code>getApproved(uint256 tokenId) returns (address)</code></dt>
<dd>Gets the approved address for a single DCoA specified by the <code>tokenId</code>.  Will return the zero address if there is no approved address.</dd>

<dt><code>isApprovedForAll(address owner, address operator) returns (bool)</code></dt>
<dd>Returns true if the given operator is approved to transfer all of owner's DCoA tokens.  Otherwise, returns false.</dd>

<dt><code>ownerOf(uint256 tokenId) returns (address)</code></dt>
<dd>Returns the address of the owner of the DCoA specified by the <code>tokenId</code></dd>

<dt><code>safeTransferFrom(address from, address to, uint256 tokenId, bytes data)</code></dt>
<dt><code>safeTransferFrom(address from, address to, uint256 tokenId)</code></dt>
<dd>Transfers the ownership of the DCoA specified by <code>tokenId</code> from one address to another, along with optional data in no specified format.</dd>

<dt><code>setApprovalForAll(address operator, bool approved)</code></dt>
<dd>Allows a third party operator to manage all of your Silver Mare Coin DCoA tokens.  This opeartor is added to a list of operators with such approval.  Be sure to call this function again with a <code>false</code> value for <code>approved</code> once your are done.  This should only be used when you need to transfer your DCoA to another address using an external smart contract.</dd>

<dt><code>transferFrom(address from, address to, uint256 tokenId)</code></dt>
<dd>Transfers the ownership of the DCoA specified by <code>tokenId</code> from one address to another, along with optional data in no specified format.  <b>Please note that if the recipient wallet is not able to receive ERC-721 tokens, the transfer may fail and the token may be lost.</b>  For this reason, it's <i>highly</i> recommended you use <code>safeTransferFrom()</code> instead.</dd>
</dl>
</li>
<li><a href="https://eips.ethereum.org/EIPS/eip-721">ERC-721</a> metadata extension
<dl>
<dt><code>name() returns (string)</code></dt>
<dd>Returns the name of this token; i.e., <q>Silver Mare Coin Digital Certificate of Authenticity</q>.</dd>

<dt><code>symbol() returns (string)</code></dt>
<dd>Returns the symbol of this token; i.e., <q>SMC DCoA</q> (<b>TBD</b>).</dd>

<dt><code>tokenURI(uint256 tokenId) returns (string)</code></dt>
<dd>Returns the Uniform Resource Indicator (URI) for the DCoA specified by the <code>tokenId</code>.  This is planned to consist of a URI-encoded JSON document containing a further URI-encoded SVG image depicting the coin in addition to other metadata (<b>TBD</b>, could also be a JSON file hosted on an immutable service like IPFS).  This is used by external sites to display the image and metadata for this token.</dd>
</dl>
</li>
<li><a href="https://eips.ethereum.org/EIPS/eip-721">ERC-721</a> enumeration extension
<dl>
<dt><code>tokenOfOwnerByIndex(address owner, uint256 index) returns (uint256)</code></dt>
<dd>Returns the token ID at the specified <code>index</code> of the given owner.  Allows for enumeration of all DCoAs held by an address.</dd>

<dt><code>tokenByIndex(uint256 index) returns (uint256)</code></dt>
<dd>Returns the token ID at the specified <code>index</code>.  Allows for enumeration of all DCoAs issued by this contract.</dd>

<dt><code>totalSupply() returns (uint256)</code></dt>
<dd>Returns the total number of valid DCoAs issued by this contract.</dd>
</dl>
</li>
<li><a href="https://eips.ethereum.org/EIPS/eip-165">ERC-165</a> (required by ERC-721)
<dl>
<dt><code>supportsInterface(bytes4 interfaceId) returns (bool)</code></dt>
<dd>Returns true if this contract supports the interface specified by <code>interfaceId</code> (as defined in ERC-165).  Otherwise, returns false.</dd>
</dl>
</li>
<li><a href="https://eips.ethereum.org/EIPS/eip-173">ERC-173</a> (<b>TBD</b>)
<dl>
<dt><code>owner() returns (address)</code></dt>
<dd>Returns the address that owns the Silver Mare Coin DCoA contract.</dd>

<dt><code>transferOwnership(address newOwner)</code></dt>
<dd>Sets the owner of this contract to the address specified by <code>newOwner</code>.</dd>
</dl>
</li>
</ul>

#### Events
<ul>
<li>Custom events <b>TBD</b>
<dl>
<dt><code>PermanentURI(string uri, uint256 indexed tokenId)</code></dt>
<dd>Emitted at DCoA creation to signal to <a href="https://docs.opensea.io/docs/metadata-standards#section-freezing-metadata">OpenSea</a> (and possibly other online token marketplaces) that the metadata for this token is frozen and can <i>never be changed</i>.</dd>
</dl>
</li>
<li>ERC-721 standard events
<dl>
<dt><code>Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)</code></dt>
<dd>Emitted when an approved address for a DCoA is changed or reaffirmed.  The zero address indicates there is no approved address.  When a <code>Transfer</code> event is emitted, it also indicates that the approved address for that DCoA has reset to the zero address.</dd>

<dt><code>ApprovalForAll(address indexed owner, address indexed operator, bool approved)</code></dt>
<dd>Emitted when an operator is enabled or disabled for an owner.</dd>

<dt><code>Transfer(address indexed from, address indexed to, uint256 indexed tokenId)</code></dt>
<dd>Emitted whenever the ownership of a DCoA changes by any mechanism, including creation and destruction.</dd>
</dl>
</li>
<li>ERC-173 standard events
<dl>
<dt><code>OwnershipTransferred(address indexed previousOwner, address indexed newOwner)</code></dt>
<dd>Emitted whenever ownership of this contract has changed.</dd>
</dl>
</ul>

#### Errors
**TBD**