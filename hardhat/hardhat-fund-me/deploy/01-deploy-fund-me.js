// module.exports = async(hre) => { //hre is hardhat runtime environment
//   const {getNamedAccounts, deployments} = hre
// }

module.exports = async({getNamedAccounts, deployments}) => {
  const {deploy, log} = deployments
  const {deployer} = await getNamedAccounts() //Tomo la cuenta deployer de nuestro config
  const chainId = network.chainId

  
}