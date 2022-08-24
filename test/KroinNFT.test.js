const KrionNFT = artifacts.require('KrionNFT');

contract('KroinNFT', accounts => {

    let contract

    beforeEach(async() => {
        contract = await KrionNFT.deployed()
    })

    describe('Deploys NFT Contract', async () => {
        it('deploys successfuly', async() => {
            const address = contract.address

            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        })
        it('has the coreect name', async () => {
            const name = await contract.name()
            assert.equal(name, 'KrionNFT')
        })
        it('has the coreect symbol', async () => {
            const symbol = await contract.symbol()
            assert.equal(symbol, 'KFT')
        })
    })

})