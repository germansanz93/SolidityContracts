//imports
const { ethers } = require("hardhat") //hardhat viene con su ethers incorporado y debemos importarlo de ahi y no de ethers porque de esta manera hardhat entiende la estructura de carpetas que manejamos

//async main func
async function main() {
	const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
	console.log("Deploying contract...")
	const simpleStorage = await SimpleStorageFactory.deploy()
	await simpleStorage.deployed()
  console.log(`deployed contract to ${simpleStorage.address}`)
}

//main
main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error)
		process.exit(1)
	})
