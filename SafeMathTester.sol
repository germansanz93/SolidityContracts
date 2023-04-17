// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeMathTestesr {
    uint8 public bigNumber = 255; //255 es el maximo valor que se puede representar con 8bits

    function add() public {
        //bigNumber = bigNumber + 1; //Al sumarle uno a 255 automaticamente vuelvo a cero.
        //Esto pasa porque hasta antes de la version 0.8 los uint y los int eran unchecked
        // Lo que significa que si se sobrepasa el limite, volvemos a cero.
        //SafeMath lo que hace es que la transaccion falle si se va a pasar el limite de la variable
        //A partir de pragma solidity 0.8 esto ya esta integrado de forma nativa en solidity
        //Los valores ahora sun checked y por lo tanto no pueden sufrir ni overflow ni underflow
        //Si por alguna razon quisiera que se comporten como unchecked debo indicarlo explicitamente
        unchecked{bigNumber = bigNumber + 1;}
        //A tener en cuenta.. unchecked es algo mas eficiente a nivel de gas
    }
}