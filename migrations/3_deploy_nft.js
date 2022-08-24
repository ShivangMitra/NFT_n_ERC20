const KrionNFT = artifacts.require("KrionNFT");

module.exports = function (deployer) {
  deployer.deploy(KrionNFT, "0x3051fAe4a4A28ff8Ee5233862FBAEdDF30225502");
};