var mods = {
  "patrol": require("./kits/patrol"),
  "rubber": require("./kits/rubber"),
  "tremble": require("./kits/tremble")
};

var types = {"breath":"patrol","dim":"patrol","metronome":"patrol","swing":"patrol","wander-v":"patrol","wander":"patrol","jingle":"rubber","rubber-v":"rubber","rubber":"rubber","shake-v":"rubber","shake":"rubber","tick":"rubber","smash":"rubber","jelly-alt":"rubber","jelly":"rubber","damage":"rubber","measure":"tremble","shiver":"tremble","swim":"tremble","tremble":"tremble"};

module.exports = {mods: mods, types: types};