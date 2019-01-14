var mods = {
  "blur": require("./kits/blur"),
  "rubber": require("./kits/rubber"),
  "spin": require("./kits/spin")
};

var types = {"blur":"blur","jingle":"rubber","rubber-v":"rubber","rubber":"rubber","shake-v":"rubber","shake":"rubber","tick":"rubber","smash":"rubber","jelly-alt":"rubber","jelly":"rubber","damage":"rubber","coin-h":"spin","coin-v":"spin","cycle":"spin","flip-h":"spin","flip-v":"spin","spin-fast":"spin","spin":"spin"};

module.exports = {mods: mods, types: types};