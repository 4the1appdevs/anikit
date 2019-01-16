require! <[fs fs-extra ../src/anikit easing-fit]>
output = []
output.push """
  .ld { transform-origin: 50% 50%; transform-box: fill-box; }
"""
for k,v of anikit.types => 
  {mod,config} = anikit.get k
  config <<< {name: "ld-#{config.name}"}
  mod = require "../src/kits/#{mod.name}"
  css = mod.css config
  output.push css
  output.push """
    .ld.#{config.name} { animation: #{config.name} #{config.dur or 1}s infinite; }
  """

fs-extra.ensure-dir-sync \dist
fs.write-file-sync 'dist/anikit.bundle.css', output.join(\\n)
