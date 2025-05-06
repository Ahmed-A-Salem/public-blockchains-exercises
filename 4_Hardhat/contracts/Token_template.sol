// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./BaseAssignment.sol";

contract CensorableToken is ERC20Capped, Ownable, BaseAssignment {
    mapping(address => bool) public isBlacklisted;
    bool public validated;

    event Blacklisted(address indexed adrs);
    event Unblacklisted(address indexed adrs);

    constructor(address initialOwner, address _validator)
        ERC20("CensorableToken", "CEN")
        ERC20Capped(100 ether)
        Ownable(initialOwner)
        BaseAssignment(_validator)
    {
        // Mint: 90 to owner, 10 to validator
        _mint(initialOwner, 90 ether);
        _mint(_validator, 10 ether);

        // Approve validator to spend owner's 90
        _approve(initialOwner, _validator, 90 ether);
    }

    modifier onlyOwnerOrValidator() {
        require(msg.sender == owner() || isValidator(msg.sender), "Not authorized");
        _;
    }

    modifier onlyValidator() {
        require(isValidator(msg.sender), "Not authorized");
        _;
    }

    function blacklistAddress(address adrs) public onlyOwnerOrValidator {
        require(!isBlacklisted[adrs], "Already blacklisted");
        isBlacklisted[adrs] = true;
        emit Blacklisted(adrs); // ✅ Emitting required event
    }

    function unblacklistAddress(address adrs) public onlyOwnerOrValidator {
        require(isBlacklisted[adrs], "Not blacklisted");
        isBlacklisted[adrs] = false;
        emit Unblacklisted(adrs); // ✅ Emitting required event
    }

    function _update(address from, address to, uint256 value) internal override {
        require(!isBlacklisted[from], "Sender is blacklisted");
        require(!isBlacklisted[to], "Recipient is blacklisted");
        super._update(from, to, value);
    }

    function validate() public onlyValidator {
        validated = true;
    }
}
