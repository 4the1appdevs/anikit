var mods = {
  "blink": require("./kits/blink"),
  "blur": require("./kits/blur"),
  "bounce": require("./kits/bounce"),
  "clock": require("./kits/clock"),
  "fade": require("./kits/fade"),
  "heartbeat": require("./kits/heartbeat"),
  "hit": require("./kits/hit"),
  "patrol": require("./kits/patrol"),
  "rubber": require("./kits/rubber"),
  "rush": require("./kits/rush"),
  "slide": require("./kits/slide"),
  "spin": require("./kits/spin"),
  "squeeze": require("./kits/squeeze"),
  "tremble": require("./kits/tremble"),
  "wrench": require("./kits/wrench")
};

var types = {"blink":"blink","blur":"blur","beat":"bounce","bounceAlt":"bounce","pulse":"bounce","tick-alt":"bounce","jump":"bounce","clock":"clock","fade":"fade","heartbeat":"heartbeat","hit":"hit","breath":"patrol","dim":"patrol","metronome":"patrol","swing":"patrol","wander-v":"patrol","wander":"patrol","jingle":"rubber","rubber-v":"rubber","rubber":"rubber","shake-v":"rubber","shake":"rubber","tick":"rubber","smash":"rubber","jelly-alt":"rubber","jelly":"rubber","damage":"rubber","rush-btt":"rush","rush-ttb":"rush","rush-rtl":"rush","rush-ltr":"rush","slide-ltr":"slide","slide-rtl":"slide","slide-btt":"slide","slide-ttb":"slide","coin-h":"spin","coin-v":"spin","cycle":"spin","flip-h":"spin","flip-v":"spin","spin-fast":"spin","spin":"spin","squeeze":"squeeze","measure":"tremble","shiver":"tremble","swim":"tremble","tremble":"tremble","wrench":"wrench"};

module.exports = {mods: mods, types: types};