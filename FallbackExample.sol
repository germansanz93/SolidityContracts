// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FallbackExample {
    uint256 public result;

    receive() external payable { //Notar que no tenemos la palabra clave function aca, esto es porque receive es una funcion especial para solidity
        //Esta funcion receive es la que se ejecutara cuando alguien envie eth a este contrato
        result = 1;
        //Esta funcion se ejecutara cada vez que se reciba una transaccion hacia el contrato sin especificar una funcion y dejando la data en blanco
        //La funcion receive() NO existe por defecto en un contrato. Debo declararla
    }

    fallback() external payable {
        result = 2;
    } //La funcion flalback es lo mismo que la funcion receive pero es llamada cuando se envia data
}

//Ether is sent to contract
//      is msg.data empty?
//           /      \
//         yes       no
//         /          \
//     receive()?   fallback()
//       /   \
//     yes   no
//     /       \
// receive() fallback()