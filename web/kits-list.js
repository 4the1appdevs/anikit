var mods = {
  "blink": require("./kits/blink"),
  "blur": require("./kits/blur"),
  "bounce-rigid": require("./kits/bounce-rigid"),
  "bounce": require("./kits/bounce"),
  "clock": require("./kits/clock"),
  "fade": require("./kits/fade"),
  "heartbeat": require("./kits/heartbeat"),
  "hit": require("./kits/hit"),
  "orbit": require("./kits/orbit"),
  "patrol": require("./kits/patrol"),
  "rubber": require("./kits/rubber"),
  "rush": require("./kits/rush"),
  "slide": require("./kits/slide"),
  "spin": require("./kits/spin"),
  "squeeze": require("./kits/squeeze"),
  "surprise": require("./kits/surprise"),
  "tremble": require("./kits/tremble"),
  "vortex": require("./kits/vortex"),
  "wrench": require("./kits/wrench")
};

var types = {"blink":"blink","blur":"blur","beat":"bounce-rigid","bounceAlt":"bounce-rigid","pulse":"bounce-rigid","tick-alt":"bounce-rigid","jump":"bounce-rigid","bounce":"bounce","clock":"clock","fade":"fade","heartbeat":"heartbeat","hit":"hit","orbit":"orbit","breath":"patrol","dim":"patrol","metronome":"patrol","swing":"patrol","wander-v":"patrol","wander":"patrol","jingle":"rubber","rubber-v":"rubber","rubber":"rubber","shake-v":"rubber","shake":"rubber","tick":"rubber","smash":"rubber","jelly-alt":"rubber","jelly":"rubber","damage":"rubber","rush-btt":"rush","rush-ttb":"rush","rush-rtl":"rush","rush-ltr":"rush","slide-ltr":"slide","slide-rtl":"slide","slide-btt":"slide","slide-ttb":"slide","coin-h":"spin","coin-v":"spin","cycle":"spin","flip-h":"spin","flip-v":"spin","spin-fast":"spin","spin":"spin","squeeze":"squeeze","surprise":"surprise","measure":"tremble","shiver":"tremble","swim":"tremble","tremble":"tremble","vortex-out":"vortex","vortex-in":"vortex","wrench":"wrench"};

module.exports = {mods: mods, types: types};