//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Greeter is ERC20 {
    uint256 public totalSupply = 1000000;
    uint256 private mintedSupply = 0;

    event TokenBurned(address indexed from, uint256 amount);

    bytes32 merkleTreeRoot =
        0x12b1013fe853dea282b3440a70e5d739b7ef75e135122659fe5408bde23a4cc1;

    constructor(string memory name, string memory symbol, uint256 _totalSupply) ERC20(name, symbol) {
        totalSupply = _totalSupply;
    }

    function mint(bytes32[] calldata _proof, uint256 _amount) external payable {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(_proof, merkleTreeRoot, leaf),
            "Sorry, you're not whitelisted. Please try Public Sale"
        );

        require(_amount + mintedSupply <= totalSupply, "Sorry, invalid amount");
        _mint(msg.sender, _amount);
        mintedSupply += _amount;
    }

    function burn(uint256 _amount) external {
        _burn(msg.sender, _amount);
        emit TokenBurned(msg.sender, _amount);
    }

    function setTotalSupply(uint256 _amount) external onlyOwner {
        require(mintedSupply <= _amount, "Sorry, invalid amount");
        totalSupply = _amount;
    }
}
