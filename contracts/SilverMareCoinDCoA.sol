// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./ERC2771Context.sol";
import "./KnowsBestPony.sol";
import "./interfaces/ISilverMareCoinDCoA.sol";
// import "./libraries/MetadataBuilder.sol";
import "./Ownable.sol";
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

/**
 * @title The implementation for the {ISilverMareCoinDCoA} interface
 * @author Twifag
 */
contract SilverMareCoinDCoA is EIP712, ERC2771Context, Ownable, ERC721Enumerable, KnowsBestPony, ISilverMareCoinDCoA {
	using ECDSA for bytes32;
	// using SafeCast for uint256;
	using SignatureChecker for address;
	using Strings for uint256;

	/// @dev The maximum possible token number to be minted; immutable and set at deploy time
	uint16 private immutable _CAP;
	/// @dev The `typeHash` used to create {certificateSigningHash}es.  See https://eips.ethereum.org/EIPS/eip-712#rationale-for-typehash
	bytes32 private constant _CERTIFICATE_TYPEHASH = keccak256("Certificate(uint16 number,uint16 cap)");
	/// @dev The minimum possible token number to be minted; this is typically 0 for most contracts, but it should be 1 for this one (unless we begin numbering at 0)
	uint16 private constant _FLOOR = 1;
	string private constant _NAME = "Silver Mare Coin Digital Certificate of Authenticity";
	// string private immutable _SYMBOL = unicode"🐎🪙📜 A‍g M‍A‍R‍E 2‍0‍2‍2";
	string private constant _VERSION = "1.0.0";
	string private /*immutable*/ CONTRACT_URI;
	/// @dev The address that will be used to sign the {certificateSigningHash}es; immutable and set at deploy time
	address public immutable SIGNER;
	string private /*immutable*/ TOKEN_URI_BASE;
	string private constant TOKEN_URI_EXTENSION = ".json";

	/**
	 * @param signer that will be assigned to {SIGNER} at deploy
	 * @param trustedForwarder will be the initial trusted forwarder, see {ERC2771Context}
	 */
	constructor(uint16 cap_, string memory contractUri_, address signer, string memory symbol, string memory tokenUriBase, address trustedForwarder)
		ERC721(_NAME, symbol)
		ERC2771Context(trustedForwarder)
		EIP712(_NAME, _VERSION)
	{
		_CAP = cap_;
		CONTRACT_URI = contractUri_;
		SIGNER = signer;
		TOKEN_URI_BASE = tokenUriBase;
	}

	/// @inheritdoc ISilverMareCoinDCoA
	function claimCertificates(ClaimDetails[] calldata claims) external {
		for (uint16 i = 0; i < claims.length; i++) {
			claimCertificate(claims[i].number, claims[i].signature);
		}
	}

	/// @inheritdoc ISilverMareCoinDCoA
	function floor() external pure returns (uint16) { return _FLOOR; }

	/// @inheritdoc ISilverMareCoinDCoA
	function cap() external view returns (uint16) { return _CAP; }

	/// @inheritdoc ISilverMareCoinDCoA
	function contractURI() external view returns (string memory) { return CONTRACT_URI; }

	/// @inheritdoc ISilverMareCoinDCoA
	function claimCertificate(uint16 number, bytes calldata signature) public {
		if (number > _CAP || number < _FLOOR) {
			revert CertificateNumberOutOfRange(number, _FLOOR, _CAP);
		} else if (isCertificateClaimed(number)) {
			revert CertificateAlreadyClaimed(number);
		} else if (!isValidSignature(number, signature)) {
			revert InvalidSignature(number, signature);
		}
		_safeMint(_msgSender(), uint256(number));
		emit CertificateClaimed(_msgSender(), number);
	}

	/// @inheritdoc ERC2771Context
	function setTrustedForwarder(address forwarder) public override onlyOwner { _trustedForwarder = forwarder; }

	/// @inheritdoc ISilverMareCoinDCoA
	function certificateSigningHash(uint16 number) public view returns (bytes32) { return _hashTypedDataV4(keccak256(abi.encode(_CERTIFICATE_TYPEHASH, number, _CAP))); }

	/// @inheritdoc ISilverMareCoinDCoA
	function isCertificateClaimed(uint16 number) public view returns (bool) { return _exists(uint256(number)); }

	/// @inheritdoc ISilverMareCoinDCoA
	function isValidSignature(uint16 number, bytes calldata signature) public view returns (bool) {
		return SIGNER.isValidSignatureNow(certificateSigningHash(number).toEthSignedMessageHash(), signature);
	}

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
	// function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) { return MetadataBuilder.tokenUri(tokenId.toUint16(), _CAP); }
	function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) { return string(abi.encodePacked(TOKEN_URI_BASE, tokenId.toString(), TOKEN_URI_EXTENSION)); }

	/// @inheritdoc ERC721
	function _safeMint(address to, uint256 tokenId) internal override {
		super._safeMint(to, tokenId);
		emit PermanentURI(tokenURI(tokenId), tokenId);
	}

	/// @inheritdoc ERC2771Context
	function _msgData() internal view override(Context, ERC2771Context) returns (bytes memory) { return ERC2771Context._msgData(); }

	/// @inheritdoc ERC2771Context
	function _msgSender() internal view override(Context, ERC2771Context) returns (address sender) { sender = ERC2771Context._msgSender(); }
}