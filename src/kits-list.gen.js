var mods = {
  "blink": require("./kits/blink"),
  "blur-transition": require("./kits/blur-transition"),
  "blur": require("./kits/blur"),
  "bounce-rigid": require("./kits/bounce-rigid"),
  "bounce-transition": require("./kits/bounce-transition"),
  "bounce": require("./kits/bounce"),
  "clock": require("./kits/clock"),
  "fade": require("./kits/fade"),
  "flip": require("./kits/flip"),
  "float": require("./kits/float"),
  "heartbeat": require("./kits/heartbeat"),
  "hit": require("./kits/hit"),
  "jump-transition": require("./kits/jump-transition"),
  "move": require("./kits/move"),
  "orbit": require("./kits/orbit"),
  "patrol": require("./kits/patrol"),
  "power": require("./kits/power"),
  "pulse": require("./kits/pulse"),
  "rubber": require("./kits/rubber"),
  "rush": require("./kits/rush"),
  "skew": require("./kits/skew"),
  "slide": require("./kits/slide"),
  "spin": require("./kits/spin"),
  "squeeze": require("./kits/squeeze"),
  "static": require("./kits/static"),
  "surprise": require("./kits/surprise"),
  "throw": require("./kits/throw"),
  "tremble": require("./kits/tremble"),
  "vortex": require("./kits/vortex"),
  "wrench": require("./kits/wrench")
};

var types = {"blink":"blink","blur-in":"blur-transition","blur-out":"blur-transition","blur":"blur","beat":"bounce-rigid","bounceAlt":"bounce-rigid","tick-alt":"bounce-rigid","jump":"bounce-rigid","bounce-alt-out":"bounce-transition","bounce-alt-in":"bounce-transition","bounce-out":"bounce-transition","bounce-in":"bounce-transition","spring-ltr-in":"bounce-transition","spring-rtl-in":"bounce-transition","spring-ttb-in":"bounce-transition","spring-btt-in":"bounce-transition","bounce":"bounce","clock":"clock","fade":"fade","flip":"flip","float":"float","heartbeat":"heartbeat","hit":"hit","jump-alt-in":"jump-transition","jump-alt-out":"jump-transition","jump-in":"jump-transition","jump-out":"jump-transition","zoom-in":"jump-transition","zoom-out":"jump-transition","fade-in":"jump-transition","fade-out":"jump-transition","grow-rtl-in":"jump-transition","grow-rtl-out":"jump-transition","grow-ltr-in":"jump-transition","grow-ltr-out":"jump-transition","grow-ttb-in":"jump-transition","grow-ttb-out":"jump-transition","grow-btt-in":"jump-transition","grow-btt-out":"jump-transition","flip-v-in":"jump-transition","flip-v-out":"jump-transition","flip-h-in":"jump-transition","flip-h-out":"jump-transition","slide-rtl-in":"jump-transition","slide-rtl-out":"jump-transition","slide-ltr-in":"jump-transition","slide-ltr-out":"jump-transition","slide-ttb-in":"jump-transition","slide-ttb-out":"jump-transition","slide-btt-in":"jump-transition","slide-btt-out":"jump-transition","float-rtl-in":"jump-transition","float-rtl-out":"jump-transition","float-ltr-in":"jump-transition","float-ltr-out":"jump-transition","float-ttb-in":"jump-transition","float-ttb-out":"jump-transition","float-btt-in":"jump-transition","float-btt-out":"jump-transition","fall-rtl-in":"jump-transition","fall-ltr-in":"jump-transition","fall-ttb-in":"jump-transition","fall-btt-in":"jump-transition","move-ltr":"move","move-rtl":"move","move-ttb":"move","move-btt":"move","move-fade-ltr":"move","move-fade-rtl":"move","move-fade-ttb":"move","move-fade-btt":"move","orbit":"orbit","breath":"patrol","dim":"patrol","metronome":"patrol","swing":"patrol","wander-v":"patrol","wander":"patrol","power-off":"power","power-on":"power","pulse":"pulse","jingle":"rubber","rubber-v":"rubber","rubber":"rubber","shake-v":"rubber","shake":"rubber","tick":"rubber","smash":"rubber","jelly-alt":"rubber","jelly":"rubber","damage":"rubber","rush-ltr":"rush","rush-rtl":"rush","rush-ttb":"rush","rush-btt":"rush","rush-ltr-in":"rush","rush-rtl-in":"rush","rush-ttb-in":"rush","rush-btt-in":"rush","skew":"skew","skew-alt":"skew","slide-ltr":"slide","slide-rtl":"slide","slide-btt":"slide","slide-ttb":"slide","coin-h":"spin","coin-v":"spin","cycle":"spin","cycle-alt":"spin","flip-h":"spin","flip-v":"spin","spin-fast":"spin","spin":"spin","squeeze":"squeeze","static":"static","surprise":"surprise","throw-ttb-in":"throw","throw-ltr-in":"throw","throw-rtl-in":"throw","throw-btt-in":"throw","measure":"tremble","shiver":"tremble","swim":"tremble","tremble":"tremble","vortex":"vortex","vortex-alt":"vortex","vortex-in":"vortex","vortex-out":"vortex","vortex-alt-in":"vortex","vortex-alt-out":"vortex","wrench":"wrench"};

module.exports = {mods: mods, types: types};