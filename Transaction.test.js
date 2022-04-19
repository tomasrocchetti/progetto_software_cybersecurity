const Transactions = artifacts.require('./Transactions.sol')


require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('Transactions', ([deployer, seller, buyer]) => {
  let marketplace

  before(async () => {
    marketplace = await Transactions.deployed()
  })
  
   describe('products', async () => {
    let result, productCount

    before(async () => {
      result = await marketplace.addMateriaPrima('Latte', '002', '3', '1')
    })
    it('creates products', async () => {
      // SUCCESS
      const event = result.logs[0].args
      assert.equal(event.name, 'Latte', 'name is correct')
      assert.equal(event.ID, '002', 'id is correct')
      assert.equal(event.gCO2, '3', 'owner is correct')
      assert.equal(event.quantity, 1, 'purchased is correct')

      // FAILURE: Product must have a name
      //await await marketplace.addMateriaPrima('', web3.utils.toWei('1', 'Ether'), { from: seller }).should.be.rejected;
      // FAILURE: Product must have a price
      //await await marketplace.addMateriaPrima('iPhone X', 0, { from: seller }).should.be.rejected;
    })

  })
   
    describe('redco2', async () => {
    let result, productCount

    before(async () => {
      result = await marketplace.getCO2ByID2('002')
    })
    it('read products', async () => {
      // SUCCESS
      const event = result.logs[0].args
      assert.equal(event.gCO2, '4', 'name is correct')

      // FAILURE: Product must have a name
      //await await marketplace.addMateriaPrima('', web3.utils.toWei('1', 'Ether'), { from: seller }).should.be.rejected;
      // FAILURE: Product must have a price
      //await await marketplace.addMateriaPrima('iPhone X', 0, { from: seller }).should.be.rejected;
    })

  })

})


