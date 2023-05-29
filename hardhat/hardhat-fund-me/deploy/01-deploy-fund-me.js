// module.exports = async(hre) => { //hre is hardhat runtime environment
//   const {getNamedAccounts, deployments} = hre
// }
const { verify } = require("../hardhat.config")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { network } = require("hardhat")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
	const { deploy, log, get } = deployments
	const { deployer } = await getNamedAccounts() //Tomo la cuenta deployer de nuestro config
	const chainId = network.config.chainId

	// const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
	let ethUsdPriceFeedAddress
	if (developmentChains.includes(network.name)) {
		//Si estoy en una de las redes de desarrollo mockeo el priceFeed, sino lo tomo de donde corresponde
		const ethUsdAggregator = await get("MockV3Aggregator")
		ethUsdPriceFeedAddress = ethUsdAggregator.address
	} else {
		ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
	}

	//Creacion de un contrato de mock para hacer pruebas en redes donde no tenemos disponibles un feed, por ejemplo la red local
	//Si el contrato no existe, deployaremos una version minima de el para nuestro testing local
	const args = [ethUsdPriceFeedAddress]
  const fundMe = await deploy("FundMe", {
		from: deployer,
		args: args, //put price feed address
		log: true,
	})

	if (
		!developmentChains.includes(network.name) &&
		process.env.ETHERSCAN_API_KEY
	) {
		await verify(fundMe.address, args)
	}

	log("---------------------------------------")
}

module.exports.tags = ["all", "fundme"]
