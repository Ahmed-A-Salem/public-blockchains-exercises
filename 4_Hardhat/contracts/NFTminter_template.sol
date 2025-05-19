// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BaseAssignment.sol";
import "./INFTminter.sol";

contract NFTminter_template is ERC721URIStorage, BaseAssignment, INFTminter {
    using Strings for uint256;
    using Strings for address;

    uint256 private _nextTokenId;
    bool public isSaleActive = true;
    uint256 public totalSupply = 0;
    uint256 public currentPrice = 0.0001 ether;

    // ✅ Raw IPFS hash as required (no ipfs://)
    string private _ipfsHash = "bafkreicpgjx6iayrygvvckilqi3rijrim6h4cayyj2zx5vlqizxczn7rhy";

    constructor(address validator_)
        ERC721("Token", "TKN")
        BaseAssignment(validator_)
    {}

    function mint(address _address) public payable override returns (uint256) {
        require(isSaleActive, "Sale is not active");
        require(msg.value >= currentPrice, "Insufficient payment");

        uint256 tokenId = _nextTokenId;
        _nextTokenId++;

        _mint(_address, tokenId);

        string memory metadataURI = getTokenURI(tokenId, _address);
        _setTokenURI(tokenId, metadataURI);

        totalSupply++;
        currentPrice *= 2;

        return tokenId;
    }

    function burn(uint256 tokenId) public payable override {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner of the token");
        require(msg.value == 0.0001 ether, "Burn fee is 0.0001 ETH");

        _burn(tokenId);
        totalSupply--;
        currentPrice = 0.0001 ether;
    }

    function getTotalSupply() external view override returns (uint256) {
        return totalSupply;
    }

    function getPrice() external view override returns (uint256) {
        return currentPrice;
    }

    function getSaleStatus() external view override returns (bool) {
        return isSaleActive;
    }

    function pauseSale() public override {
        require(msg.sender == getOwner() || isValidator(msg.sender), "Not authorized");
        isSaleActive = false;
    }

    function activateSale() public override {
        require(msg.sender == getOwner() || isValidator(msg.sender), "Not authorized");
        isSaleActive = true;
    }   

    function getIPFSHash() public view override returns (string memory) {
        return _ipfsHash;
    }

    function withdraw(uint256 amount) public override {
        require(
            msg.sender == getOwner() || isValidator(msg.sender),
            "Not authorized"
        );
        require(address(this).balance >= amount, "Insufficient contract balance");

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }


    function getTokenURI(uint256 tokenId, address newOwner)
        public
        view
        returns (string memory)
    {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "My beautiful artwork #', tokenId.toString(), '",',
            '"hash": "', _ipfsHash, '",',
            '"by": "', getOwner(), '",',
            '"new_owner": "', newOwner, '"',
            "}"
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }    
}
