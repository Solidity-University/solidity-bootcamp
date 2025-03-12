// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Example {

    uint8 public READ = 1;   //00000001
    uint8 public WRITE = 2;  //00000010
    uint8 public DELETE = 4; //00000100
    uint8 public ADMIN = 8;  //00001000

    mapping(address => uint8) public roles;

    constructor() {
        roles[msg.sender] = READ | WRITE | DELETE | ADMIN; //ALL_ROLES = 00001111 = 15
    }

    function setRole(address _user, uint8 _role) public {
        require((roles[msg.sender] & ADMIN) != 0, "Caller should be admin");
        roles[_user] = _role;
    }

    function read() public view {
        require((roles[msg.sender] & READ) != 0, "Caller should be reader");
    }

    function write() public view {
        require((roles[msg.sender] & WRITE) != 0, "Caller should be writer");
    }

    function deletesmth() public view {
        require((roles[msg.sender] & DELETE) != 0, "Caller should be deleter");
    }

    // Побитовое И (&)
    // Возвращает 1, если оба бита равны 1.
    // Пример: 5 & 3 == 1 (0101 & 0011 == 0001)
    function bitwiseAND(uint8 a, uint8 b) public pure returns(uint8) {
        return a & b;
    }

    // Побитовое ИЛИ (|)
    // Возвращает 1, если хотя бы один бит равен 1.
    // Пример: 5 | 3 == 7 (0101 | 0011 == 0111)
    function bitwiseOR(uint8 a, uint8 b) public pure returns(uint8) {
        return a | b;
    }

    // Побитовое XOR (^)
    // Возвращает 1, если биты различаются.
    // Пример: 5 ^ 3 == 6 (0101 ^ 0011 == 0110)
    function bitwiseXOR(uint8 a, uint8 b) public pure returns(uint8) {
        return a ^ b;
    }

    // Побитовое НЕ (~)
    // Инвертирует все биты.
    // Пример: ~5 == 250 (для uint8: ~00000101 == 11111010)
    function bitwiseNOT(uint8 a) public pure returns(uint8) {
        return ~a;
    }

    // Сдвиг влево (<<)
    // Сдвигает биты влево, добавляя нули справа.
    // Пример: 5 << 1 == 10 (00000101 << 1 == 00001010)
    function shiftLeft(uint8 a, uint8 bits) public pure returns(uint8) {
        return a << bits;
    }

    // Сдвиг вправо (>>)
    // Сдвигает биты вправо, добавляя нули слева.
    // Пример: 20 >> 2 == 5 (00010100 >> 2 == 00000101)
    function shiftRight(uint8 a, uint8 bits) public pure returns(uint8) {
        return a >> bits;
    }
    
}

