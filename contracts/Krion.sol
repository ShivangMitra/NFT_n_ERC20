// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

///Token holders will be able to destroy their tokens.
import "openzeppelin-solidity/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/security/Pausable.sol";
import "openzeppelin-solidity/contracts/access/AccessControl.sol";

///Without paying gas, token holders will be able to allow third parties to transfer from their account.
import "openzeppelin-solidity/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

/// @custom:security-contact shivangmitra8@gmail.com
contract Krion is ERC20, ERC20Burnable, Pausable, AccessControl, ERC20Permit {
    ///Flexible mechanism with a separate role for each privileged action. A role can have many authorized accounts.
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    ///Grant all the roles to the deployer and create an initial amount of tokens for the deployer.
    constructor() ERC20("Krion", "KRI") ERC20Permit("Krion") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _mint(msg.sender, 100000 * 10**decimals());
        _grantRole(MINTER_ROLE, msg.sender);
    }

    ///Privileged accounts will be able to pause the functionality marked as whenNotPaused. Useful for emergency response.
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    ///Privileged accounts will be able to unpause the functionality marked as whenNotPaused.
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    ///Privileged accounts will be able to create more supply.
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    ///Before transfering any amount from one account to another we check if this functionality is paused or not.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }
}
