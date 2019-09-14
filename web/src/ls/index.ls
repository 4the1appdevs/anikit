(->
  ld$.find document, '.item' .map (n) -> 
    n.addEventListener \click, ->
      a = n.getAttribute \data-name
      s = ld$.find(n, '.square', 0)
      s.classList.remove a
      s.offsetHeight
      setTimeout (-> s.classList.add a), 0
  ldcv-nodes = ld$.find document, '.ldcv'
  window.ldcv1 = new ldCover root: ldcv-nodes.0
  window.ldcv2 = new ldCover root: ldcv-nodes.1
  ldrs = new ldSlider root: '.ldrs', min: 0, max: 1, step: 0.01
  ldrs-demo = ld$.find document, '#ldrs-demo', 0
  kit = new anikit \bounce
  ldrs.on \change, -> kit.animate-js ldrs-demo, it

)!
