// Generated by LiveScript 1.3.1
var fs, anikit, easingFit, output, k, ref$, v, ref1$, mod, config, css;
fs = require('fs');
anikit = require('./anikit');
easingFit = require('easing-fit');
output = [];
output.push(".ld { transform-origin: 50% 50%; transform-box: fill-box; }");
for (k in ref$ = anikit.types) {
  v = ref$[k];
  ref1$ = anikit.get(k), mod = ref1$.mod, config = ref1$.config;
  config.name = "ld-" + config.name;
  mod = require("./kits/" + mod.name);
  css = mod.css(config);
  output.push(css);
  output.push(".ld." + config.name + " { animation: " + config.name + " " + (config.dur || 1) + "s infinite; }");
}
fs.writeFileSync('anikit.bundle.css', output.join('\n'));