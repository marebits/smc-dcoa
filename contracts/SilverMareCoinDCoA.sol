// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./KnowsBestPony.sol";
import "./interfaces/ISilverMareCoinDCoA.sol";
import "./libraries/MetadataBuilder.sol";
import "./Ownable.sol";
import "@opengsn/contracts/src/BaseRelayRecipient.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

//https://github.com/OpenZeppelin/openzeppelin-contracts/blob/1488d4f6782f76f74f3652e44da9b9e241146ccb/test/utils/cryptography/SignatureChecker.test.js
// use nft.storage for uploading metadata to ipfs???

/**
 * @title The implementation for the {ISilverMareCoinDCoA} interface
 * @author Twifag
 */
contract SilverMareCoinDCoA is EIP712, Ownable, BaseRelayRecipient, ERC721Enumerable, KnowsBestPony, ISilverMareCoinDCoA {
	using ECDSA for bytes32;
	using MetadataBuilder for MetadataBuilder.TokenParams;
	using SafeCast for uint256;
	using SignatureChecker for address;
	using Strings for uint256;

	/// @dev The maximum possible token number to be minted; immutable and set at deploy time
	uint16 private immutable _CAP;

	/// @dev The `typeHash` used to create {certificateSigningHash}es.  See https://eips.ethereum.org/EIPS/eip-712#rationale-for-typehash
	bytes32 private constant _CERTIFICATE_TYPEHASH = keccak256("Certificate(uint16 number,uint16 cap)");

	/// @dev The minimum possible token number to be minted; this is typically 0 for most contracts, but it should be 1 for this one (unless we begin numbering at 0)
	uint16 private constant _FLOOR = 1;

	/// @dev The address that will be used to sign the {certificateSigningHash}es; immutable and set at deploy time
	address public immutable SIGNER;

	/// @inheritdoc IRelayRecipient
	string public constant override versionRecipient = "2.2.6";

	/**
	 * @param name_ of this token
	 * @param symbol_ of this token
	 * @param cap_ maximum number of tokens allowed to be minted by this contract
	 * @param signer_ address that signs the claim hashes
	 */
	constructor(string memory name_, string memory symbol_, uint16 cap_, address signer_) ERC721(name_, symbol_) EIP712(name_, "1") {
		_CAP = cap_;
		SIGNER = signer_;
	}

	/// @inheritdoc ISilverMareCoinDCoA
	function claimCertificate(uint16 number, bytes calldata signature) external {
		if (number > _CAP || number < _FLOOR) {
			revert CertificateNumberOutOfRange(number, _FLOOR, _CAP);
		} else if (isCertificateClaimed(number)) {
			revert CertificateAlreadyClaimed(number);
		} else if (SIGNER.isValidSignatureNow(certificateSigningHash(number).toEthSignedMessageHash(), signature)) {
			revert InvalidSignature(number, signature);
		}
		_safeMint(_msgSender(), uint256(number));
		emit CertificateClaimed(_msgSender(), number);
	}

	/// @inheritdoc ISilverMareCoinDCoA
	function cap() external view returns (uint16) { return _CAP; }

	/// @inheritdoc ISilverMareCoinDCoA
	function contractURI() external view returns (string memory) { return MetadataBuilder.contractUri(_CAP); }

	/// @inheritdoc ISilverMareCoinDCoA
	function floor() external pure returns (uint16) { return _FLOOR; }

	/// @inheritdoc ISilverMareCoinDCoA
	function certificateSigningHash(uint16 number) public view returns (bytes32) { return _hashTypedDataV4(keccak256(abi.encode(_CERTIFICATE_TYPEHASH, number, _CAP))); }

	/// @inheritdoc ISilverMareCoinDCoA
	function isCertificateClaimed(uint16 number) public view returns (bool) { return _exists(uint256(number)); }

	/**
	* @dev Implementation of the {IERC165} interface.
	* @inheritdoc ERC165
	*/
	function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable, Ownable) returns (bool) {
		return interfaceId == type(ISilverMareCoinDCoA).interfaceId || 
			interfaceId == type(KnowsBestPony).interfaceId || 
			ERC721Enumerable.supportsInterface(interfaceId) || 
			Ownable.supportsInterface(interfaceId);
	}

	/// @inheritdoc ERC721
	function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) { return MetadataBuilder.TokenParams({number: tokenId.toUint16(), cap: _CAP}).tokenUri(); }

	/// @inheritdoc ERC721
	function _safeMint(address to, uint256 tokenId) internal override {
		super._safeMint(to, tokenId);
		emit PermanentURI(tokenURI(tokenId), tokenId);
	}

	/// @inheritdoc BaseRelayRecipient
	function _msgData() internal view override(BaseRelayRecipient, Context) returns (bytes memory) { return BaseRelayRecipient._msgData(); }

	/// @inheritdoc BaseRelayRecipient
	function _msgSender() internal view override(BaseRelayRecipient, Context) returns (address sender) { sender = BaseRelayRecipient._msgSender(); }
}