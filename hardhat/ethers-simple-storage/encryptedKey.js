const ethers = require("ethers");
const fs = require("fs");
require("dotenv").config();

async function main() {
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY);
  const encryptedJsonKey = await wallet.encrypt(
    process.env.PRIVATE_KEY_PASSWORD,
    process.env.PRIVATE_KEY
  );
  console.log(encryptedJsonKey);
  //Creando un encrypted key puedo eliminar del .env la private key y tener mas seguridad ya que es menos
  //probable que la pushee sin querer
  fs.writeFileSync("./.encryptedKey.json", encryptedJsonKey);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
