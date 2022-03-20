// SPDX-License-Identifier: LicenseRef-DSPL AND LicenseRef-NIGGER
pragma solidity 0.8.13;

import "./ContextMixin.sol";
import "./KnowsBestPony.sol";
import "./libraries/MetadataBuilder.sol";
import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

//https://github.com/OpenZeppelin/openzeppelin-contracts/blob/1488d4f6782f76f74f3652e44da9b9e241146ccb/test/utils/cryptography/SignatureChecker.test.js
// use nft.storage for uploading metadata to ipfs???

interface ISilverMareCoinDCoA {
	/**
	 * @notice Emitted when the address `by` claims the token with the given `id`.
	 * @param by whom the token is claimed
	 * @param id of the token claimed
	 */
	event Claimed(address indexed by, uint16 indexed id);

	/**
	 * @notice Emitted whenever a DCoA is minted as a signal to online token marketlplaces that the metadata for this token is immutable and frozen.
	 * @param uri to be marked as permanent
	 * @param tokenId that has the permanent URI
	 */
	event PermanentURI(string uri, uint256 indexed tokenId);

	error CertificateAlreadyClaimed(uint16 number);

	error CertificateNumberOutOfRange(uint16 number, uint16 floor, uint16 cap);

	error InvalidSignature(bytes signature);

	function cap() external view returns (uint256);

	function certificateSigningHash(uint16 number) external view returns (bytes32);

	/**
	 * @notice Verifies message and signature and then issues a token claim if everything is correct.
	 * @param number of your certificate to claim
	 * @param signature provided to claim your certificate
	 */
	function claimCertificate(uint16 number, bytes calldata signature) external;

	/// @return the Uniform Resource Indicator (URI) for this contract
	// function contractURI() external view returns (string memory);

	function FLOOR() external pure returns (uint16);

	function isCertificateClaimed(uint16 number) external view returns (bool);

	function SIGNER() external view returns (address);
}

/**
 * @title The implementation for the ISilverMareCoinDCoA
 * @author Twifag
 */
contract SilverMareCoinDCoA is EIP712, ERC721Enumerable, ContextMixin, KnowsBestPony, ISilverMareCoinDCoA {
	using MetadataBuilder for MetadataBuilder.TokenParams;
	using SafeCast for uint256;
	using SignatureChecker for address;
	using Strings for uint256;

	uint16 private immutable _CAP;
	bytes32 private constant _CERTIFICATE_TYPEHASH = keccak256("Certificate(uint16 number,uint16 cap)");
	uint16 public constant FLOOR = 1;
	address public immutable SIGNER;

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

	/**
	 * @dev Enables gasless transactions on MATIC.  See https://github.com/ProjectOpenSea/meta-transactions/tree/main/contracts
	 * @return sender of the message
	 */
	// function _msgSender() internal override view returns (address sender) { return ContextMixin.msgSender(); }

	/// @inheritdoc ERC721
	function _safeMint(address to, uint256 tokenId) internal override {
		super._safeMint(to, tokenId);
		emit PermanentURI(tokenURI(tokenId), tokenId);
	}

	function cap() external view returns (uint256) { return uint256(_CAP); }

	function certificateSigningHash(uint16 number) public view returns (bytes32) { return _hashTypedDataV4(keccak256(abi.encode(_CERTIFICATE_TYPEHASH, number, _CAP))); }

	function claimCertificate(uint16 number, bytes calldata signature) external {
		if (number > _CAP || number < FLOOR) {
			revert CertificateNumberOutOfRange(number, FLOOR, _CAP);
		} else if (isCertificateClaimed(number)) {
			revert CertificateAlreadyClaimed(number);
		} else if (SIGNER.isValidSignatureNow(ECDSA.toEthSignedMessageHash(certificateSigningHash(number)), signature)) {
			revert InvalidSignature(signature);
		}
		_safeMint(_msgSender(), uint256(number));
		emit Claimed(_msgSender(), number);
	}

	function isCertificateClaimed(uint16 number) public view returns (bool) { return _exists(uint256(number)); }

	/**
	* @dev Implementation of the {IERC165} interface.
	* @inheritdoc ERC165
	*/
	function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable) returns (bool) {
		return interfaceId == type(ISilverMareCoinDCoA).interfaceId || 
			interfaceId == type(KnowsBestPony).interfaceId || 
			interfaceId == type(Ownable).interfaceId || 
			super.supportsInterface(interfaceId);
	}

	/// @inheritdoc ERC721
	function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) { return MetadataBuilder.TokenParams({ number: tokenId.toUint16(), cap: _CAP }).tokenUri(); }
}