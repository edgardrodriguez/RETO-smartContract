//SPDX-License-Identifier:  MIT
pragma solidity ^0.8.17;

contract Desafio {
    uint private pin;
    address owner;
    mapping(address => uint) balances;

    constructor(uint ownerPin){
        pin = ownerPin;
    }

    function min(uint ownerPin, uint amount) public {
        require(pin == ownerPin, "El pin no es correcto");
        balances[msg.sender] += amount;
        owner = msg.sender;
    }
    // Este contrato sólo define un modificador pero no lo usa, se va a utilizar en un contrato derivado.
    // El cuerpo de la función se inserta donde aparece el símbolo especial "_;" en la definición del modificador.
    // Esto significa que si el propietario llama a esta función, la función se ejecuta, pero en otros casos devolverá una excepción.

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function depositar() public payable{
        balances[msg.sender] += msg.value;
    }

    //eliminar los errores de reingreso (intentar retirar varias veces)
    function retirar() public {
        require(balances[msg.sender] > 0);
        balances[msg.sender] = 0;
        (bool success, )= msg.sender.call{value:balances[msg.sender]}("");
        require(success, "Transferencia fallida.");
    }
}  

