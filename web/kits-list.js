var mods = {
  "blink": require("./kits/blink"),
  "blur": require("./kits/blur"),
  "bounce-rigid": require("./kits/bounce-rigid"),
  "patrol": require("./kits/patrol"),
  "rubber": require("./kits/rubber"),
  "slide": require("./kits/slide"),
  "spin": require("./kits/spin"),
  "tremble": require("./kits/tremble")
};

var types = {"blink":"blink","blur":"blur","beat":"bounce-rigid","bounceAlt":"bounce-rigid","pulse":"bounce-rigid","tick-alt":"bounce-rigid","jump":"bounce-rigid","breath":"patrol","dim":"patrol","metronome":"patrol","swing":"patrol","wander-v":"patrol","wander":"patrol","jingle":"rubber","rubber-v":"rubber","rubber":"rubber","shake-v":"rubber","shake":"rubber","tick":"rubber","smash":"rubber","jelly-alt":"rubber","jelly":"rubber","damage":"rubber","slide-ltr":"slide","slide-rtl":"slide","slide-btt":"slide","slide-ttb":"slide","coin-h":"spin","coin-v":"spin","cycle":"spin","flip-h":"spin","flip-v":"spin","spin-fast":"spin","spin":"spin","measure":"tremble","shiver":"tremble","swim":"tremble","tremble":"tremble"};

module.exports = {mods: mods, types: types};