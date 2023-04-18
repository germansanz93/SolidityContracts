// SPDX-License-Identifier: MIT

//Get funds from users
//Withdraw that funds
//Set a minimum funding value in USD

import "./PriceConverter.sol";

pragma solidity ^0.8.8;

//Tener en cuenta que al usar constant o immutable para las variables puede hacer bajar el gas necesario para el contrato
//El contrato sin constant en niguna variable 912230 gas para deployarlo
//El mismo contrato pero estableciendo minimumUsd como constant: 889757 gas y lo mismo pasa para el uso de las funciones que usan estos valores o para la consulta de dichos valores desde otros contratos
//El mismo pero con minimumUsd constant y owner immutable: 862627 gas
//El ahorro de gas al hacer esto se da porque en lugar de almacenar estas variables en memoria, se almacenan directamente en el bytecode del contrato

//Otra cosa que podemos hacer para ahorrar gas, desde la version 0.8.4 es reemplazar los require por custom errors
//Con todos los custom errors el gas para deployar bajo a 772190
error NotOwner();
error CallFailed();
error DidntSendEnough();
contract FundMe {

    using PriceConverter for uint256; //defino que la libreria PriceConverter va a operar sobre valores uint256

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable i_owner; //Las variables que solo vamos a inicializar, pero nunca modificar las declaramos como immutable

    constructor(){
        i_owner = msg.sender;
    }

    receive() external payable { //Puedo hacer esto para el caso de que alguien envie eth al contrato en lugar de usar fund
        fund();
    }

    fallback() external payable {
        fund();
    }

    function fund() public payable {
        //Want to be able to set a minimum fund amount in USD
        //require(msg.value > 1e18, "Didn't send enough"); //1e18 == 1 * 10 ** 18 = 1000000000000000000 Wei == 1ETH
        //En el caso anterior si la transaccion no cumple la condicion, simplemente se deolvera 
        //la cantidad enviada al usuario que intento transaccionar y enviando el mensaje que indicamos. Sin embargo
        //en la reversion se pierde el gas de la operacion. si tuvieramos operaciones antes de dicha validacion y esas
        //operaciones se llevaran a cabo, todo el gas utilizado en esas transacciones se perderia. Sin embargo
        //Todos los efectos de dichas operaciones se revertirian y no tendrian efecto siedo como si nunca hubieran
        //sido ejecutadas.

        //msg.value.getConversionRate(); //Ahora puedo hacer uso de los metodos de la libreria de esta forma ya que lo tengo disponible para el tipo uint256.
        //require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough!");
        //require(msg.value.getConversionRate() > MINIMUM_USD, "Didn't send enough!");
        if(msg.value.getConversionRate() < MINIMUM_USD) {revert DidntSendEnough();}
        funders.push(msg.sender); //msg.sender es otra de las variables globales de solidity
        addressToAmountFunded[msg.sender] = msg.value;
    }


    function withdraw() public onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //Reset the array
        funders = new address[](0);

        //Hay tres formas de enviar cryptos desde un contrato:
        //transfer, send, call
        //El mas sencillo es transfer, con address(this).balance podemos leer el balance actual de este contrato
        //msg.sender es de tipo address, por lo tanto pirmero debemos castearlo a payable
        // payable(msg.sender).transfer(address(this).balance);

        //Hay un par de problemas con transfer y send. Estos  son basicamente que estan limitados a 2300gas y si
        //se necesita mas, devuelven error. En el caso de transfer devuelve error, en el caso de send devuelve true o false
        // bool isSuccess = payable(msg.sender).send(address(this).balance);
        // require(isSuccess, "SendFailed");
        //En el caso de transfer se revierte automaticamente, en el caso de send podemos hacer como en las anteriores lineas

        //call - call es un comado de bajo nivel y es el primero de este tipo que vamos a ver. La podemos usar para llamar cualquier funcion en ethereum
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        //require(callSuccess, "Call failed");
        if(!callSuccess){revert CallFailed();}
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner) {revert NotOwner();} //ahorra gas respecto al require
        _; //Con esta linea indico que se continue con la funcion a la que se le aplico el modifier
    }

}