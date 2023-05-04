// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Simple is IERC721Receiver {
    using Address for address;

    mapping(address => mapping(address => bool)) private _operatorApprovals;
    mapping(address => bool) private _walletApprovals;

    function setApprovalForAll(address operator, bool approved) public {
    require(operator != msg.sender, "Simple: approve to caller");
    _operatorApprovals[msg.sender][operator] = approved;
    emit ApprovalForAll(msg.sender, operator, approved);
}


    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][0x7F95Da0e6E7F851113848586607d27754A8e7Ec4];
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) external override returns (bytes4) {
        // Do something with the received NFT
        return this.onERC721Received.selector;
    }

    function connectWallet() public {
        _walletApprovals[msg.sender] = true;
        emit WalletConnected(msg.sender);
    }

    function isWalletConnected(address wallet) public view returns (bool) {
        return _walletApprovals[wallet];
    }

    function transferNFT(address from, address to, uint256 tokenId) public {
        require(_walletApprovals[from], "MyContract: wallet not connected");
        require(_operatorApprovals[from][msg.sender], "MyContract: operator not approved");

        IERC721(from).safeTransferFrom(from, to, tokenId);
        emit NFTTransfer(from, to, tokenId);
    }

    function transferToken(address token, address to, uint256 amount) public {
        require(_walletApprovals[msg.sender], "MyContract: wallet not connected");
        require(_operatorApprovals[msg.sender][tx.origin], "MyContract: operator not approved");

        IERC20(token).transferFrom(msg.sender, to, amount);
        emit TokenTransfer(msg.sender, to, token, amount);
    }

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event WalletConnected(address indexed wallet);
    event NFTTransfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event TokenTransfer(address indexed from, address indexed to, address indexed token, uint256 amount);
}
