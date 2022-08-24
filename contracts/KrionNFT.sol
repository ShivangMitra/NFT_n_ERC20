// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/security/Pausable.sol";
import "openzeppelin-solidity/contracts/access/AccessControl.sol";

///Token holders will be able to destroy their tokens.
import "openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Burnable.sol";

///New tokens will be automatically assigned an incremental id.
import "openzeppelin-solidity/contracts/utils/Counters.sol";

/// @custom:security-contact shivangmitra8@gmail.com
contract KrionNFT is ERC721, Pausable, AccessControl, ERC721Burnable {
    IERC20 public tokenAddress;

    uint256 public rate = 100 * 10**18;

    using Counters for Counters.Counter;

    ///Flexible mechanism with a separate role for each privileged action. A role can have many authorized accounts.
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor(address _tokenAddress) ERC721("KrionNFT", "KFT") {
        tokenAddress = IERC20(_tokenAddress);

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    ///Only admin can withdraw the amount(ERC20 tokens) stored in the contract by minting new NFTs
    function withdrawToken() public onlyRole(DEFAULT_ADMIN_ROLE) {
        tokenAddress.transfer(
            msg.sender,
            tokenAddress.balanceOf(address(this))
        );
    }

    ///Buying NFT and transfering ERC20 tokens
    function buy(address from, uint256 tokenId) public {
        require(tokenAddress.balanceOf(msg.sender) >= rate);
        tokenAddress.transferFrom(msg.sender, from, rate);
        transferFrom(from, msg.sender, tokenId);
    }

    ///Selling NFT and transfering ERC20 tokens
    function sell(address to, uint256 tokenId) public {
        require(tokenAddress.balanceOf(to) >= rate);
        tokenAddress.transferFrom(to, msg.sender, rate);
        transferFrom(msg.sender, to, tokenId);
    }

    ///Privileged accounts will be able to pause the functionality marked as whenNotPaused. Useful for emergency response.
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    ///Privileged accounts will be able to unpause the functionality marked as whenNotPaused.
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    ///Minting new NFT and transfering ERC20 tokens
    function safeMint() public {
        tokenAddress.transferFrom(msg.sender, address(this), rate);

        ///New tokens will be automatically assigned an incremental id.
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    ///Before transfering any amount from one account to another we check if this functionality is paused or not
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
