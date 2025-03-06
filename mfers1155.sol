// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC1155} from "@openzeppelin/contracts@5.2.0/token/ERC1155/ERC1155.sol";
import {ERC1155Burnable} from "@openzeppelin/contracts@5.2.0/token/ERC1155/extensions/ERC1155Burnable.sol";
import {ERC1155Supply} from "@openzeppelin/contracts@5.2.0/token/ERC1155/extensions/ERC1155Supply.sol";
import {Ownable} from "@openzeppelin/contracts@5.2.0/access/Ownable.sol";

contract MFERS1155 is ERC1155, ERC1155Burnable, Ownable, ERC1155Supply {
    constructor()
        ERC1155("ipfs://QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/")
        Ownable(msg.sender)
    {}

    error InvalidTime();
    error OutsideMintingTimeframe();
    error MintingPhaseStopped();
    error InsufficientFunds();
    error MintingPhaseSupplyReached();

    event MintPhaseCreated(
        uint256 phaseId,
        uint256 startTime,
        uint256 endTime,
        uint256 tokenId,
        uint256 price,
        uint256 maxSupply);

    struct MintPhase {
        uint256 startTime;
        uint256 endTime;
        uint256 tokenId;
        uint256 price;
        uint256 mintedDuringPhase;
        uint256 maxSupply;
        bool stoped;
    }

    uint256 public lastPhase;

    mapping(uint256 => MintPhase) private mintPhases;

    function getMintPhaseInfo(uint256 _phaseId) external view returns(MintPhase memory) {
        return mintPhases[_phaseId];
    }

    function isMintPhaseStoped(uint256 _phaseId) external view returns(bool) {
        return mintPhases[_phaseId].stoped;
    }

    function mint(
        uint256 _amount,
        uint256 _phaseId
    ) external payable {
        MintPhase storage phase = mintPhases[_phaseId];
        require(block.timestamp >= phase.startTime && block.timestamp <= phase.endTime, OutsideMintingTimeframe());
        require(!phase.stoped, MintingPhaseStopped());
        require(msg.value >= _amount * phase.price, InsufficientFunds());
        require(phase.mintedDuringPhase + _amount <= phase.maxSupply, MintingPhaseSupplyReached());

        phase.mintedDuringPhase += _amount;

        _mint(msg.sender, phase.tokenId, _amount, "");
    }

    function mintForOwner(
        uint256[] memory ids,
        uint256[] memory amounts
    ) public onlyOwner {
        _mintBatch(msg.sender, ids, amounts, "");
    }

    function createMintPhase(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _tokenId,
        uint256 _price,
        uint256 _maxSupply
    ) external onlyOwner {
        require(_endTime > _startTime, InvalidTime());

        lastPhase++;
        uint256 phaseId = lastPhase;

        mintPhases[phaseId] = MintPhase({
            startTime: _startTime,
            endTime: _endTime,
            tokenId: _tokenId,
            price: _price,
            mintedDuringPhase: 0,
            maxSupply: _maxSupply,
            stoped: false
        });

        emit MintPhaseCreated(phaseId, _startTime, _endTime, _tokenId, _price, _maxSupply);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Supply) {
        super._update(from, to, ids, values);
    }
}

//HOMEWORK:

//1. Funds goes to contract owner automaticly
//2. Add MAX_TOKENS_PER_WALLET functionality
//3. Add stop mechanics (event, function)
