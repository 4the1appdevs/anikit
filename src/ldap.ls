(->
  ldAnikitPicker = (opt) ->
    @root = if typeof(opt.root) == \string => document.querySelector(opt.root) else opt.root
    @ldcv = new ldCover root: @root
    @input = @root.querySelector \input
    @item = Array.from(@root.querySelectorAll \.item)
    @base = @root.querySelector \.base
    @root.addEventListener \click, (e) ~>
      n = e.target
      while n and n != @root =>
        if n.classList.contains \item => break
        n = n.parentNode
      if !(n and n.classList.contains(\item)) => return
      ret = n.getAttribute(\data-value)
      @ldcv.set ret
    handler = ~>
      @item.map ~> it.style.display = if !(~it.textContent.indexOf(@input.value)) => \none else \block
    @input.addEventListener \input, handler
    @
  ldAnikitPicker.prototype = Object.create(Object.prototype) <<< do
    get: (opt = {}) ->
      @pos opt
      @ldcv.get!
    pos: (opt = {}) ->
      if opt.host =>
        box = opt.host.getBoundingClientRect!
        @base.style.left = "#{box.x}px"

  window.ldAnikitPicker = ldAnikitPicker
)!
