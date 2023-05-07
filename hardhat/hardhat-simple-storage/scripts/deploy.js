//imports
const { ethers, run, network } = require("hardhat") //hardhat viene con su ethers incorporado y debemos importarlo de ahi y no de ethers porque de esta manera hardhat entiende la estructura de carpetas que manejamos

//async main func
async function main() {
	const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
	console.log("Deploying contract...")
	const simpleStorage = await SimpleStorageFactory.deploy()
	await simpleStorage.deployed()
	console.log(`deployed contract to ${simpleStorage.address}`)
	console.log(network.config)
	if (network.config.chainId === 11155111 && process.env.ETHERSCAN_API_KEY) { //Pongo el condicional para que solo verifique si deploye en seplia (No en la red de hardat ya que no hay verificacion ahi) y si tengo la api key de etherscan
		await simpleStorage.deployTransaction.wait(6) //Esperamos 6 confirmaciones de bloque antes de hacer la verificacion porque a veces etherscan tarda un poquito en procesar y disponer de la info. Con esto nos ahorramos problemas.
    await verify(simpleStorage.address, [])
	}
}

async function verify(contractAddress, args) {
	console.log("verifying contract.. ")
	try {
		await run("verify:verify", {
			address: contractAddress,
			constructorArguments: args,
		}) //Run nos permite ejecutar cualquier tarea de hardhat desde codigo js
	} catch (e) {
		if (e.message.toLowerCase().includes("already verified")) {
			console.log("Already Verified!")
		} else {
			console.log(e)
		}
	}
}

//main
main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error)
		process.exit(1)
	})
