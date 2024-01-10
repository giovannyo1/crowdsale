const { expect } = require ('chai');
const { ethers } = require ('hardhat');

const tokens = (n) => {
	return ethers.utils.parseUnits(n.toString(), 'ether')
} 

describe ('Crowdsale', () => {
	let crowdsale

	beforeEach(async () => {
		const Crowdsale = await ethers.getContractFactory('Crowdsale')
		crowdsale = await Crowdsale.deploy()

	})
	describe('Deployment', () => {
		it('has correct name', async () => {
			const Crowdsale = await ethers.getContractFactory('Crowdsale')
			let crowdsale = await Crowdsale.deploy()
			expect(await crowdsale.name()).to.eq('Crowdsale')
		})
	})
})