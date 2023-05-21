const {ethers} = require("hardhat")
const {expect, assert} = require("chai")

describe("SimpleStorage", () => {
  let simpleStorageFactory, simpleStorage
	beforeEach(async () => {
    simpleStorageFactory = await ethers.getContractFactory(
      "SimpleStorage"
    )
    simpleStorage = await simpleStorageFactory.deploy()
  })
  it("Should start with a favourite number of 0", async () => {
    const currentValue = await simpleStorage.retrieve()
    const expectedValue = "0"
    assert.equal(currentValue.toString(), expectedValue)
  })

  it("Should update when we call store", async () => {
    const transactionResponse = await simpleStorage.store(10)
    await transactionResponse.wait(1)
    const currentValue = await simpleStorage.retrieve()
    const expectedValue = "10"
    assert.equal(currentValue.toString(), expectedValue)
  })
})
