// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract ERC20Claimer {
    IERC20 public token;
    bytes32 public merkleRoot;
    address public treasury;

    mapping(address => bool) public hasClaimed;

    event TokenClaimed(address claimer, uint256 amount, uint256 timestamp);
    error AlreadyClaimed();
    error InvalidProof();
    error TransferFailed();

    constructor(address _tokenAddress, bytes32 _merkleRoot, address _treasury) {
        token = IERC20(_tokenAddress);
        merkleRoot = _merkleRoot;
        treasury = _treasury;
    }

    function claim(uint256 _amount, bytes32[] calldata _proof) external {
        require(!hasClaimed[msg.sender], AlreadyClaimed());

        bytes32 leaf = keccak256(
            bytes.concat(
                keccak256(
                    abi.encode(msg.sender, _amount)
                )
            )
        );

        bool valid = MerkleProof.verify(_proof, merkleRoot, leaf);

        require(valid, InvalidProof());

        hasClaimed[msg.sender] = true;

        require(token.transferFrom(treasury, msg.sender, _amount), TransferFailed());
        emit TokenClaimed(msg.sender, _amount, block.timestamp);
    }

    //Внедрить totalClaimed
    //Верификация без клейма canClaim() view
    //Добавить возможность установить временные рамки клейма
    //Добавить функцию recoverUnclaimed, чтобы склеймить все оставшиеся средства на аккаунт овнера
}

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyToken is ERC20, ERC20Permit {
    constructor(address recipient)
        ERC20("MyToken", "MTK")
        ERC20Permit("MyToken")
    {
        _mint(recipient, 10000 * 10 ** decimals());
    }
}