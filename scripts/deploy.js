// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.

 //Importa la biblioteca Hardhat para el desarrollo y prueba de contratos inteligentes.
const hre = require("hardhat");

//Define la función principal del script como una función asíncrona, ya que las operaciones de despliegue y transferencia pueden llevar tiempo.
async function main() {
  const NAME = 'Dapp University'
  const SYMBOL = 'DAPP'
  const MAX_SUPPLY = '1000000'

// Precio de un token en ether, convertido a una representación numérica adecuada.
  const PRICE = ethers.utils.parseUnits('0.025', 'ether')

  // Deploy Token
  const Token = await hre.ethers.getContractFactory("Token")
  const token = await Token.deploy(NAME, SYMBOL, MAX_SUPPLY)
  await token.deployed()

  console.log(`Token deployed to: ${token.address}\n`)

  // Deploy Crowdsale
  const Crowdsale = await hre.ethers.getContractFactory("Crowdsale")
  const crowdsale = await Crowdsale.deploy(token.address, PRICE, ethers.utils.parseUnits(MAX_SUPPLY, 'ether'))
  await crowdsale.deployed();

  console.log(`Crowdsale deployed to: ${crowdsale.address}\n`)

  const transaction = await token.transfer(crowdsale.address, ethers.utils.parseUnits(MAX_SUPPLY, 'ether'))
  await transaction.wait()

  console.log(`Tokens transferred to Crowdsale\n`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

//En resumen, este script utiliza Hardhat para desplegar un contrato de token (Token)
// y un contrato de venta de tokens (Crowdsale) en una red local de Ethereum. Luego, realiza
// la transferencia de una cantidad específica de tokens al contrato de venta de tokens. 
//Este script puede ser útil para simular y probar interacciones entre contratos inteligentes
// durante el desarrollo

