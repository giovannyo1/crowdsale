///SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";
 

    //address owner;: Almacena la dirección del propietario del contrato.
    //Token public Almacena la dirección del propietario del contrato.
    // price;: Almacena el precio de un token en ether.
    // maxTokens;: Almacena la cantidad máxima de tokens disponibles para la venta.
    // tokensSold;: Almacena la cantidad total de tokens vendidos.
contract Crowdsale {
    address owner;
    Token public token;
    uint256 public price;
    uint256 public maxTokens;
    uint256 public tokensSold;


    //buy event se emite a tokens. Registra la cantidad de tokens comprados y la dirección del comprador.
    // finalize Se emite al finalizar la venta, registrando la cantidad total de tokens vendidos y la cantidad de ether recaudada.
    event Buy(uint256 amount, address buyer);
    event Finalize(uint256 tokensSold, uint256 ethRaised);
 
    //constructor Inicializa el contrato con la dirección del token, el precio de un token en ether y la cantidad máxima de tokens disponibles para la venta.
    constructor(
        Token _token,
        uint256 _price,
        uint256 _maxTokens
    
    ) {
        owner = msg.sender;
        token = _token;
        price = _price;
        maxTokens = _maxTokens;
    
    }
    //Modifier Define un modificador que permite que solo el propietario ejecute ciertas funciones. En este caso, se utiliza para restringir el acceso a las funciones solo al propietario
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Buy tokens directly by sending Ether
    // --> https://docs.soliditylang.org/en/v0.8.15/contracts.html#receive-ether-function
    //Receive : Esta función es llamada cuando el contrato recibe ether directamente. Calcula la cantidad de tokens que el comprador obtendrá y llama a la función buyTokens
    
    receive() external payable {
        uint256 amount = msg.value / price;
        buyTokens(amount * 1e18);
    }

    //buyTokens Permite a los compradores adquirir tokens enviando ether. Verifica el monto de ether enviado, la disponibilidad de tokens y realiza la transferencia de tokens al comprador.
    
    function buyTokens(uint256 _amount) public payable {
        require(msg.value == (_amount / 1e18) * price);
        require(token.balanceOf(address(this)) >= _amount);
        require(token.transfer(msg.sender, _amount));

        tokensSold += _amount;

        emit Buy(_amount, msg.sender);
    }

    // setPrice Permite al propietario del contrato cambiar el precio de un token en ether.
    
    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    // Finalize Sale: Finaliza la venta, transfiriendo los tokens restantes al propietario y enviando el ether recaudado al propietario.
    
    function finalize() public onlyOwner {
        require(token.transfer(owner, token.balanceOf(address(this))));

        uint256 value = address(this).balance;
        (bool sent, ) = owner.call{value: value}("");
        require(sent);

        emit Finalize(tokensSold, value);
    }
}
