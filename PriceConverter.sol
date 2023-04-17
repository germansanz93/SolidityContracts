// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; //Importando la interfaz desde npm, tambien se puede desde github


library PriceConverter {
    function getPrice() internal view returns (uint256) {
        // Aca necesitamos interactuar con un contrato fuera de nuestro proyecto.
        // Para eso necesitamos dos cosas de dicho contrato:
        // El ABI y el address. El address lo puedo buscar de las docs de chainlink:
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306 ETH/USD address para sepolia
        //El ABI lo puedo tomar de la interfaz que nos disponibilizan en su github
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price, , , ) = priceFeed.latestRoundData(); // La funcion devuelve 5 vlaores, pero yo solo necesito uno    
        return uint256(price * 1e10); //Por la forma en la que nos viene el precio y la forma en la que lo necesito en el contrato.
    }

    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        uint256 ethPrice = getPrice();
        return (ethPrice * ethAmount) / 1e18; //Debo dividir por 1e18 porque estoy multiplicanddo dos veces por 1e18 ya que lo tengo en ambos terminos
    }
}