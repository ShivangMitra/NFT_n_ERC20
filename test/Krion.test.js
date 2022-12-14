const Krion = artifacts.require('Krion');

contract('Kroin', accounts => {

    let contract

    beforeEach(async() => {
        contract = await Krion.deployed()
    })

    describe('Deploys Token Contract', async () => {
        it('deploys successfuly', async() => {
            const address = contract.address

            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        })
        it('has the correct name', async () => {
            const name = await contract.name()
            assert.equal(name, 'Krion')
        })
        it('has the correct symbol', async () => {
            const symbol = await contract.symbol()
            assert.equal(symbol, 'KRI')
        })
    })

})