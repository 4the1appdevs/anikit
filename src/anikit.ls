require! <[easing-fit cubic ./easing]>
kits-list = require './kits-list.gen'
uuid = require 'uuid/v4'

{cos,sin,tan} = Math{cos,sin,tan}

anikit = (name, opt={}) ->
  @{mod, config} = anikit.get(name, opt)
  [@dom, @id] = [null, uuid!]
  @set-config @config
  @

anikit.prototype = Object.create(Object.prototype) <<< do
  set-config: (c={}) ->
    @config <<< c
    if @dom => @dom.textContent = @mod.css({} <<< @config <<< name: "#{@config.name}-#{@id}")
    @mod.config = @config
  css: (opt={}) -> if @mod.css => @mod.css {} <<< @config <<< opt else {}
  js: (t, opt={}) -> if @mod.js => @mod.js t, opt = {} <<< @config <<< opt
  affine: (t, opt={}) -> if @mod.affine => @mod.affine t, opt = {} <<< @config <<< opt

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
    box = new THREE.Box3!setFromObject node
    node.geometry.computeBoundingBox!
    bbox = node.geometry.boundingBox
    [wx,wy,wz] = <[x y z]>
      .map -> bbox.max[it] - bbox.min[it]
      .map (d,i) -> ((opt.origin or values.transform-origin or [0.5,0.5,0.5])[i] - 0.5) * d
    [nx,ny,nz] = <[x y z]>
      .map -> (bbox.max[it] + bbox.min[it]) * 0.5
    if nx or ny or nz =>
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
    else
      node.material.transparent = true
      node.material.opacity = opacity

  animate: (node, opt={}) ->
    opt = {} <<< @config <<< opt
    if !@dom =>
      document.body.appendChild(@dom = document.createElement \style)
      @set-config!
    [dur,rpt] = [opt.dur or 1, if opt.repeat => that else \infinite]
    if @config.origin =>
      node.style.transformOrigin = [@config.origin.0 or 0.5, @config.origin.1 or 0.5].map(-> "{it * 50}%").join(' ')
    node.style.animation = "#{@config.name}-#{@id} #{dur}s #{rpt} linear forwards"
    node.style.animationDelay = "#{opt.delay or 0}s"
  origin: (n,h,x,y) ->
    if x? and y? => return anikit.util.origin n, h, x, y
    if @config.origin => [x,y,z] = that
    else if @mod.affine =>
      value = @mod.affine 0, @config
      if value.transform-origin => [x,y,z] = value.transform-origin
    if !(x?) or !(y?) => [x,y,z] = [0.5, 0.5, 0.5]
    anikit.util.origin n, h, x, y

  statify: (node) -> node.style.animation = node.style.animationDelay = ""
  destroy: -> @dom.parentNode.removechild @dom

anikit <<< do
  util:
    m4to3: (m) -> [m.0, m.1, m.4, m.5, m.3, -m.7].map -> easing-fit.round it
    noise: (t) -> (Math.sin(t * 43758.5453) + 1 ) * 0.5
    kth: (n,m,k) ->
      if k > n => k = n
      if m == 1 => return k
      k = k * m + m - 1
      while k >= n => k = k - n + Math.floor((k - n) / (m - 1))
      return k
    origin: (n,h,px,py) ->
      [nb, hb] = [n,h].map -> it.getBoundingClientRect!
      x = nb.width * px + nb.x - hb.x - hb.width * 0.5
      y = nb.height * py + nb.y - hb.y - hb.height * 0.5
      n.style.transform-origin = "#{x}px #{y}px"
      [x,y]

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
