require! <[../src/anikit]>
require! <[../src/kits/orbit]>

name = process.argv.2
if !name =>
  console.log "usage: lsc getkit.ls [kitname]"
  process.exit!

kit = anikit.get name
css = kit.mod.css (kit.config <<< {unit: \%})

re = do
  skewX: /skewX\(0deg\)/g
  skewY: /skewY\(0deg\)/g
  rotate: /rotate\(0deg\)/g
  scale: /scale\(1,1\)/g
has = {}
[k for k of re].map (k)->
  if (new RegExp(k)).exec(css.replace(re[k], '')) => return
  css := css.replace(re[k], '')
css = css.replace /\s+;/g, ';'

console.log css
