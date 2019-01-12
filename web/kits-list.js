var mods = {
  "patrol": require("./kits/patrol"),
  "rubber": require("./kits/rubber"),
  "slide": require("./kits/slide"),
  "tremble": require("./kits/tremble")
};

var types = {"breath":"patrol","dim":"patrol","metronome":"patrol","swing":"patrol","wander-v":"patrol","wander":"patrol","jingle":"rubber","rubber-v":"rubber","rubber":"rubber","shake-v":"rubber","shake":"rubber","tick":"rubber","smash":"rubber","jelly-alt":"rubber","jelly":"rubber","damage":"rubber","slide-ltr":"slide","slide-rtl":"slide","slide-btt":"slide","slide-ttb":"slide","measure":"tremble","shiver":"tremble","swim":"tremble","tremble":"tremble"};

module.exports = {mods: mods, types: types};