const KrionNFT = artifacts.require('KrionNFT');
const Krion = artifacts.require('Krion');

contract('KroinNFT', accounts => {

    let contract
    let token_contract

    let NFT_tokenId

    beforeEach(async() => {
        contract = await KrionNFT.deployed()
        token_contract = await Krion.deployed()
    })

    describe('Deploys NFT Contract', async () => {

        it('deploys successfuly', async() => {
            const address = contract.address

            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        })

        it('has the correct name', async () => {
            const name = await contract.name()
            assert.equal(name, 'KrionNFT')
        })

        it('has the correct symbol', async () => {
            const symbol = await contract.symbol()
            assert.equal(symbol, 'KFT')
        })

        it('gets allowance from the owner to transact with ERC20 contract', async() => {
            const allowance = '100000000000000000000'
            await token_contract.approve(contract.address, allowance)
            const allowed = await token_contract.allowance(accounts[0], contract.address)
            assert.equal(allowance, allowed)
        })

        it('mints a NFT by transacting ERC20 tokens', async() => {

            const Token_balance_before_mint = await token_contract.balanceOf(accounts[0])
            const NFT_balance_before_mint = await contract.balanceOf(accounts[0])

            NFT_tokenId = await contract.safeMint()

            const NFT_balance = await contract.balanceOf(accounts[0])
            const Token_balance = await token_contract.balanceOf(accounts[0])

            assert.equal(Token_balance_before_mint, '100000000000000000000000')
            assert.equal(NFT_balance_before_mint, '0')
            assert.equal(NFT_balance, '1')
            assert.equal(Token_balance, '99900000000000000000000')
        })
    })

})