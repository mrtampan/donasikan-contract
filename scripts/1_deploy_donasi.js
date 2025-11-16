const Donasi = artifacts.require("Donasi");
module.exports = async function (deployer, network, accounts) {
  const gasEstimate = await Donasi.new.estimateGas();

  await deployer.deploy(Donasi, {
    from: accounts[0],
    gas: gasEstimate + 50000, // beri buffer
    gasPrice: 1000000000,
  });
};
