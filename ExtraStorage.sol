// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage{ //La herencia en Solidity se lleva a cabo mediante la palabra is
    //Obviamente al estar usando herencia podemos overridear los metodos de la clase padres en nuestra nueva impl
    function store(uint256 _favouriteNumer) public override { //Overridea la funcion store en el contrato padre
        favouriteNumber = _favouriteNumer + 5;
    }
}