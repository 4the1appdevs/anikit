(->
  handler = ->

  ldSelect = (opt) ->
    @root = if typeof(opt.root) == \string => document.querySelector(opt.root) else opt.root
    @ldcv = new ldCover root: @root
    @base = @root.querySelector \.base
    @root.addEventListener \click, (e) ~>
      n = e.target
      while n and n != @root =>
        if n.classList.contains \item => break
        n = n.parentNode
      if !(n and n.classList.contains(\item)) => return
      ret = n.getAttribute(\data-value)
      @ldcv.set ret
    @
  ldSelect.prototype = Object.create(Object.prototype) <<< do
    get: (opt = {}) ->
      @pos opt
      @ldcv.get!
    pos: (opt = {}) ->
      if opt.host =>
        box = opt.host.getBoundingClientRect!
        x = ( box.x + box.width / 2)
        @base.style.left = "#{x}px"
        @base.style.transform = "translate(-50%,0)"

  window.ldSelect = ldSelect

)!
