var mods = {
  "blur": require("./kits/blur"),
  "spin": require("./kits/spin")
};

var types = {"blur":"blur","coin-h":"spin","coin-v":"spin","cycle":"spin","flip-h":"spin","flip-v":"spin","spin-fast":"spin","spin":"spin"};

module.exports = {mods: mods, types: types};