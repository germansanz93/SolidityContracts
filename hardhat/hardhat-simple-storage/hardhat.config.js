const { task } = require("hardhat/config")

require("@nomicfoundation/hardhat-toolbox")
require("dotenv").config()
require("@nomiclabs/hardhat-etherscan")
require("./tasks/block-number")

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
	const accounts = await hre.ethers.getSigners()

	for (const account of accounts) {
		console.log(await account.getAddress())
	}
})

const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL
const SEPOLIA_PRIVATE_KEY = process.env.SEPOLIA_PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	defaultNetwork: "hardhat", //Hardhat viene con una red similar a ganache y si no especifico una red al deployar un contrato, lo hara en la red por defecto que es la de hardhat tambien tomara por defecto clave privada y todo lo necesario para hacer el dpeloy
	networks: {
		sepolia: {
			url: SEPOLIA_RPC_URL,
			accounts: [SEPOLIA_PRIVATE_KEY],
			chainId: 11155111,
		},
	},
	solidity: "0.8.8",
	etherscan: {
		apiKey: ETHERSCAN_API_KEY,
	},
}
