// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract CallerContract {

    address public lotteryContract;

    event Response(bool success, bytes data);

    constructor(address _lotteryContract) {
        lotteryContract = _lotteryContract;
    }

    /*
    Вызов CALL через encodeWithSelector:
    
    (bool success, bytes memory data) = address.call(
        abi.encodeWithSelector(Contract.function.selector, arg1, arg2, ...)
    );
    */

    /*
    Вызов CALL через encodeWithSignature:

    (bool success, bytes memory data) = address.call(
        abi.encodeWithSignature("functionName(type1,type2,...)", arg1, arg2, ...)
    );
    */

    // Вызов с использованием encodeWithSignature (без передачи Ether)
    function registerToLottery(uint256 _number) external {
        (bool success, bytes memory data) = lotteryContract.call(
            abi.encodeWithSignature("registerToLottery(uint256)", _number)
        );

        require(success, "registration failed");
        emit Response(success, data);
    }

    // Вызов с использованием encodeWithSignature (с передачей Ether)
    function paidRegisterToLottery(uint256 _number) external payable {
        (bool success, bytes memory data) = lotteryContract.call{value: msg.value}(
            abi.encodeWithSignature("registerToLottery(uint256)", _number)
        );

        require(success, "registration failed");
        emit Response(success, data);
    }

    // Вызов с использованием encodeWithSelector (без передачи Ether)
    function registerToLotteryWithSelector(uint256 _number) external {
        (bool success, bytes memory data) = lotteryContract.call(
            abi.encodeWithSelector(Lottery.registerToLottery.selector, _number)
        );

        require(success, "registration failed");
        emit Response(success, data);
    }

    // Вызов с использованием encodeWithSelector (с передачей Ether)
    function registerToLotteryWithSelectorSendingValue(uint256 _number) external payable {
        (bool success, bytes memory data) = lotteryContract.call{value: msg.value}(
            abi.encodeWithSelector(Lottery.registerToLottery.selector, _number)
        );

        require(success, "registration failed");
        emit Response(success, data);
    }

    // Пример вызова функции без аргументов
    function callPlay() external {
        (bool success, bytes memory data) = lotteryContract.call(
            abi.encodeWithSelector(Lottery.play.selector)
        );

        require(success, "callPlay failed");
        emit Response(success, data);
    }

    // Пример вызова функции с несколькими аргументами
    function callComplexFunc(address _user, uint256 _amount, bool _flag) external {
        (bool success, bytes memory data) = lotteryContract.call(
            abi.encodeWithSelector(
                Lottery.complexFunc.selector,
                _user,
                _amount,
                _flag
            )
        );

        require(success, "callComplexFunc failed");
        emit Response(success, data);
    }

}

contract Lottery {

    mapping(address => uint256) public registeredUsers;
    mapping(address => uint256) public payments;

    event Registered(address user, uint256 number, uint256 value);

    function registerToLottery(uint256 _number) external payable {
        require(registeredUsers[msg.sender] == 0, "Address already registered");
        
        registeredUsers[msg.sender] = _number;
        payments[msg.sender] = msg.value;

        emit Registered(msg.sender, _number, msg.value);
    }

    function play() external {}

    function complexFunc(address _usr, uint256 _age, bool isPlayer) external {}

}
