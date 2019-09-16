lsc = require \livescript
textarea = ld$.find document, 'textarea', 0
block = ld$.find document, '.block', 0

handler = debounce ->
  ret = lsc.run("return #{textarea.value}")
  anikit.set \custom, ret
  names = [k for k of ret.preset]
  select.innerHTML = names.map -> """<option name="#it">#it</option>"""

textarea.addEventListener \keyup, handler

render = debounce ->
  kit = new anikit select.value
  kit.animate block, {dur: 1/(ldrs.get!)}

ldrs = new ldSlider root: '.ldrs', min: 0, max: 2, step: 0.01, from: 1
ldrs.on \change, render
select.addEventListener \change, -> render!now!
