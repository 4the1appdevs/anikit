var mods = {
  "bounce": require("./kits/bounce"),
  "patrol": require("./kits/patrol"),
  "rubber": require("./kits/rubber"),
  "rush": require("./kits/rush"),
  "slide": require("./kits/slide"),
  "spin": require("./kits/spin"),
  "tremble": require("./kits/tremble")
};

var types = {"beat":"bounce","bounceAlt":"bounce","pulse":"bounce","tick-alt":"bounce","jump":"bounce","breath":"patrol","dim":"patrol","metronome":"patrol","swing":"patrol","wander-v":"patrol","wander":"patrol","jingle":"rubber","rubber-v":"rubber","rubber":"rubber","shake-v":"rubber","shake":"rubber","tick":"rubber","smash":"rubber","jelly-alt":"rubber","jelly":"rubber","damage":"rubber","rush-btt":"rush","rush-ttb":"rush","rush-rtl":"rush","rush-ltr":"rush","slide-ltr":"slide","slide-rtl":"slide","slide-btt":"slide","slide-ttb":"slide","coin-h":"spin","coin-v":"spin","cycle":"spin","flip-h":"spin","flip-v":"spin","spin-fast":"spin","spin":"spin","measure":"tremble","shiver":"tremble","swim":"tremble","tremble":"tremble"};

module.exports = {mods: mods, types: types};