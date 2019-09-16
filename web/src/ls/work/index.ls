lsc = require \livescript
textarea = ld$.find document, 'textarea', 0
block = ld$.find document, '.block', 0

handler = debounce ->
  ret = lsc.run("return #{textarea.value}")
  anikit.set \custom, ret
  kit = new anikit \custom
  kit.animate block

textarea.addEventListener \keyup, handler

