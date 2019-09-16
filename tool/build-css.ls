require! <[fs fs-extra ../src/anikit easing-fit]>
output = []
output.push """
  .ld { transform-origin: 50% 50%; transform-box: fill-box; }
"""
for k,v of anikit.types => 
  {mod,config} = anikit.get k
  config <<< {name: "ld-#{config.name}"}
  mod = require "../src/kits/#{mod.name}"
  if !mod.css => continue
  css = mod.css config
  if mod.js and config.repeat =>
    js = mod.js 0, config
    init-values = (["animation-fill-mode: forwards"] ++ ["#name: #value" for name,value of js]).join(\;)
  else init-values = "";

  origin = if !(config.origin?) => ""
  else "transform-origin: #{config.origin[0 to 1].map(-> (it * 100) + \%).join(' ')}"
  output.push css
  output.push """
    .ld.#{config.name} {
      animation: #{config.name} #{config.dur or 1}s #{config.repeat or \infinite}; #init-values; #origin
    }
  """

fs-extra.ensure-dir-sync \dist
fs.write-file-sync 'dist/anikit.bundle.css', output.join(\\n)
