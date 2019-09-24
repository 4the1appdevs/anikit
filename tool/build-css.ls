require! <[fs fs-extra ../src/anikit easing-fit]>
output = []
output.push """
  .ld { transform-origin: 50% 50%; transform-box: fill-box; }
"""

for k,v of anikit.types =>
  kit = new anikit.anikit k
  kit.mod = mod = require "../src/kits/#{kit.mod.name}"
  config = kit.config
  opt = {name: "ld-#{config.name}", prefix: ".ld"}
  output.push kit.cls config, opt

fs-extra.ensure-dir-sync \dist
fs.write-file-sync 'dist/anikit.bundle.css', output.join(\\n)
