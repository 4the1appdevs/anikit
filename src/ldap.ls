(->
  ldAnikitPicker = (opt) ->
    @opt = opt
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
      @ldcv.set {name: ret, info: limited: n.classList.contains(\limited) }
    handler = ~>
      @item.map ~> it.style.display = if !(~it.textContent.indexOf(@input.value)) => \none else \block
    @input.addEventListener \input, handler
    # when ldap is on, focus the input.
    # it's believed that focus take effect only when the panel is visible, but there is an animation
    # so we take a break before doing it. #TODO should find a better way to detect animation ends.
    @ldcv.on \toggle.on, debounce 250, ~> @input.focus!
    @
  ldAnikitPicker.prototype = Object.create(Object.prototype) <<< do
    get: (opt = {}) ->
      @pos opt
      @ldcv.get!
    pos: (opt = {}) ->
      if opt.host =>
        box = opt.host.getBoundingClientRect!
        @base.style.left = "#{box.x}px"
    # re-apply disable-filter and default-filter. default-filter is destructive. ( TODO: better way? )
    apply-filters: (o) ->
      if o? => <[disableFilter defaultFilter]>.map ~> if o[it] => @opt[it] = o[it]
      ld$.find @root, '.item' .map (d,i) ~>
        if @opt.disable-filter =>
          ret = @opt.disable-filter(d.getAttribute(\data-anikit),i)
          ld$.cls d, (if @opt.limit-hard => {disabled: ret} else {limited: ret})
        if @opt.default-filter and !@opt.default-filter(d.getAttribute(\data-anikit),i) => ld$.remove d

  window.ldAnikitPicker = ldAnikitPicker
)!
