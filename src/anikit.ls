require! <[easing-fit cubic ./easing]>
kits-list = require './kits-list.gen'
uuid = require 'uuid/v4'

GBCR = (n) -> n.getBoundingClientRect!
if navigator? => if /Firefox\/([0-9.]+)/.exec(navigator.userAgent) =>
  GBCR = (n) ->
    box = n.getBoundingClientRect!
    t = getComputedStyle(n).transform
    t = t.trim!.substring(7).replace(/[)]/g,'').split(\,)
    if t.length < 6 => t = [1,0,0,1,0,0]
    t = t.map -> +it
    box <<< x: box.x + t.4, y: box.y + t.5


{cos,sin,tan} = Math{cos,sin,tan}

anikit = (name, opt={}) ->
  @{mod, config} = anikit.get(name, opt)
  [@name, @dom, @id] = [name, null, uuid!]
  @set-config @config
  @

anikit.prototype = Object.create(Object.prototype) <<< do
  set-config: (c={}) ->
    @config <<< c
    if @dom => @dom.textContent = @mod.css({} <<< @config <<< name: "#{@config.name}-#{@id}")
    @mod.config = @config
  get-config: -> @config
  css: (opt={}) -> if @mod.css => @mod.css {} <<< @config <<< opt else {}
  js: (t, opt={}) -> if @mod.js => @mod.js t, opt = {} <<< @config <<< opt
  affine: (t, opt={}) -> if @mod.affine => @mod.affine t, opt = {} <<< @config <<< opt
  get-dom: ->
    if !@dom =>
      document.body.appendChild(@dom = document.createElement \style)
      @dom.setAttribute \id, "#{@config.name}-#{@id}"
      @dom.setAttribute \data-anikit, ""
      @set-config!
    @dom

  timing: (t, opt=@config) ->
    t = t / (opt.dur or 1)
    if opt.repeat < 0 => return t
    if opt.repeat and t > opt.repeat => t = 1
    if t != Math.floor(t) => t = t - Math.floor(t)
    t

  animate-js: (node, t, opt={}) ->
    opt = {} <<< @config <<< opt
    if node.ld-style => for k,v of that => node.style[k] = ""
    t = @timing t, opt
    node.ld-style = @js t, opt
    node.style <<< node.ld-style

  animate-three: (node, t, opt={}) ->
    opt = {} <<< @config <<< opt
    t = @timing t, opt
    values = @affine t, opt
    if !values => return
    box = new THREE.Box3!setFromObject node
    node.geometry.computeBoundingBox!
    bbox = node.geometry.boundingBox
    [wx,wy,wz] = <[x y z]>
      .map -> bbox.max[it] - bbox.min[it]
      .map (d,i) -> ((opt.origin or values.transform-origin or [0.5,0.5,0.5])[i] - 0.5) * d
    [nx,ny,nz] = <[x y z]>
      .map -> (bbox.max[it] + bbox.min[it]) * 0.5
    if (nx or ny or nz) and !node.repos =>
      m = new THREE.Matrix4!
      m.set 1,0,0,-nx,0,1,0,-ny,0,0,1,-nz,0,0,0,1
      node.geometry.applyMatrix m
      node.repos = m.getInverse m
    node.matrixAutoUpdate = false
    mat = values.transform or [1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1]
    [3,7,11].map -> mat[it] = mat[it] / 40 #TODO make to real ratio

    gmat = new THREE.Matrix4!makeTranslation wx, wy, wz
    node.matrix.set.apply( node.matrix, mat)
    node.matrix.multiply gmat
    node.matrix.premultiply gmat.getInverse gmat
    if node.repos => node.matrix.premultiply node.repos

    opacity = if values.opacity? => values.opacity else 1
    if node.material.uniforms and node.material.uniforms.alpha =>
      node.material.uniforms.alpha.value = opacity
    node.material.transparent = true
    node.material.opacity = opacity

  animate: (node, opt={}) ->
    opt = {} <<< @config <<< opt
    @get-dom!

    [dur,rpt, dir] = [opt.dur or 1, if opt.repeat => that else \infinite, opt.animation-dir or \normal]
    origin = if @config.origin => that else [0.5, 0.5, 0.5]
    # this works perfectly only when transform is in animation. see README for more detail
    #node.style.transformOrigin = [origin.0 or 0.5, origin.1 or 0.5].map(-> "#{it * 100}%").join(' ')
    #node.style.transformBox = "fill-box"
    node.style.animation = "#{@config.name}-#{@id} #{dur}s #{rpt} linear forwards #{dir}"
    node.style.animationDelay = "#{opt.delay or 0}s"
  origin: (n,h,opt={}) ->
    {x,y,ox,oy,s} = opt
    if x? and y? => return anikit.util.origin n, h, x, y, ox, oy, if s? => s else 1
    if @config.origin => [x,y,z] = that
    else if @mod.affine =>
      value = @mod.affine 0, @config
      if value.transform-origin => [x,y,z] = value.transform-origin
    if !(x?) or !(y?) => [x,y,z] = [0.5, 0.5, 0.5]
    if n.style => anikit.util.origin n, h, x, y, ox, oy, if s? => s else 1

  statify: (node) -> node.style.animation = node.style.animationDelay = ""
  destroy: -> if @dom and @dom.parentNode => @dom.parentNode.removeChild @dom

anikit <<< do
  util:
    m4to3: (m) -> [m.0, m.1, m.4, m.5, m.3, -m.7].map -> easing-fit.round it
    noise: (t) -> (Math.sin(t * 43758.5453) + 1 ) * 0.5
    round: easing-fit.round
    /* TBD: we should design a better flow for rounding output
    rounds: (v, d = 5) ->
      if v.opacity? => v.opacity = easing-fit.round v.opacity, d
      if v.transform? => v.transform = v.transform.map -> easing-fit.round it, d
      return v
    */
    kth: (n,m,k) ->
      if k > n => k = n
      if m == 1 => return k
      k = k * m + m - 1
      while k >= n => k = k - n + Math.floor((k - n) / (m - 1))
      return k
    origin: (n,h,px=0.5,py=0.5,ox=0,oy=0,s=1) ->
      if typeof(h.x) == typeof(h.width) == \number =>
        [x,y] = [h.x + h.width * px, h.y + h.height * py]
        n.style.transform-origin = "#{x}px #{y}px"
        [x,y]
      else if n.transform
        svg = null
        _ = (n) ~>
          if n.nodeName.toLowerCase! == \svg => svg := n; return n.createSVGMatrix!
          return _(n.parentNode).multiply(
            if n.transform and n.transform.baseVal.consolidate! => that.matrix else svg.createSVGMatrix!
          )
        mat = _ n.parentNode
        p = svg.createSVGPoint!
        abox = n.getBoundingClientRect!
        rbox = h.getBoundingClientRect!
        p1 = (p <<< x: abox.x - rbox.x, y: abox.y - rbox.y).matrixTransform(mat.inverse!)
        p2 = (p <<< x: abox.x + abox.width - rbox.x, y: abox.y + abox.height - rbox.y).matrixTransform(mat.inverse!)
        box = x: p1.x, y: p1.y, width: p2.x - p1.x, height: p2.y - p1.y
        [x,y] = [box.x + box.width * px, box.y + box.height * py]
        n.style.transform-origin = "#{x}px #{y}px"
        [x,y]
      else
        [nb, hb] = [n,h].map -> GBCR it #!it.getBoundingClientRect!
        x = nb.width * px + nb.x - hb.x + ox # - hb.width * 0.5
        y = nb.height * py + nb.y - hb.y + oy # - hb.height * 0.5
        n.style.transform-origin = "#{x * s}px #{y * s}px"
        [x,y]
    /* forward, reverse, random */
    order: (i,n,t = 0) ->
      if t == 0 => return i
      else if t == 1 => return n - i - 1
      else if t == 2 => return @kth n, n * n + 7, i

    rx: (t) -> [1, 0, 0, 0, 0, cos(t), -sin(t), 0, 0, sin(t), cos(t), 0, 0, 0, 0, 1]
    ry: (t) -> [cos(t), 0, sin(t), 0, 0, 1, 0, 0, -sin(t), 0, cos(t), 0, 0, 0, 0, 1]
    rz: (t) -> [cos(t), sin(t), 0, 0, -sin(t), cos(t), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    tx: (t) -> [1, 0, 0, t, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    ty: (t) -> [1, 0, 0, 0, 0, 1, 0, -t, 0, 0, 1, 0, 0, 0, 0, 1]
    tz: (t) -> [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, t, 0, 0, 0, 1]
    sx: (t) -> [t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    sy: (t) -> [1, 0, 0, 0, 0, t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    sz: (t) -> [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, t, 0, 0, 0, 0, 1]
    s:  (t) -> [t, 0, 0, 0, 0, t, 0, 0, 0, 0, t, 0, 0, 0, 0, 1]
    kx: (t) -> [1, -tan(t), 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    ky: (t) -> [1, 0, 0, 0, tan(t), 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
  get: (name, opt={}) ->
    config = {name: name, dur: 1, repeat: 0}
    ret = if @types[name] => @mods[@types[name]] else @mods[name]
    mod = {}
    # make a whole new object and clone the subject-to-modified edit
    # so we won't pollute the raw mod
    for k,v of ret => mod[k] = v
    mod.edit = JSON.parse JSON.stringify mod.edit

    # overwrite edit settings
    if mod.preset[name] => for k,v of mod.edit =>
      o = mod.preset[name][k]
      if o and o.default? => mod.edit[k] <<< mod.preset[name][k]

    for k,v of mod.edit => config[k] = v.default

    # overwrite configs: deprecated, should use 'overwrite edit settings'.
    if mod.preset[name] =>
      for k,v of config =>
        o = mod.preset[name][k]
        # if o exists, and it's an edit setting (check with default attr) then pass
        if typeof(o) == \undefined or (typeof(o) == \object and o.default?) => continue
        config[k] = o
      config <<< mod.preset[name]{prop, value, local, origin}

    # overwrite by custom
    config <<< opt
    return {mod, config}
  /* all available mods */
  mods: kits-list.mods
  /* all available animations, base on mods */
  types: kits-list.types


if window? => window <<< {easing, anikit, easing-fit, cubic}
if module? => module.exports <<< anikit
