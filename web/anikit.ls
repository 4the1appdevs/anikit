require! <[easing-fit cubic ./kits-list ./easing]>
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
  js: (t, opt=@config) -> if @mod.js => @mod.js t, opt else {}
  affine: (t, opt=@config) -> if @mod.affine => @mod.affine t, opt else {}

  animate-js: (node, t, opt) ->
    if node.ld-style => for k,v of that => node.style[k] = ""
    node.ld-style = @js (t - Math.floor(t))
    node.style <<< @js (t - Math.floor(t))

  animate-three: (node, t, opt) ->
    values = @affine t, (if opt => {} <<< @config <<< opt else @config)
    box = new THREE.Box3!setFromObject node
    node.geometry.computeBoundingBox!
    bbox = node.geometry.boundingBox
    [wx,wy,wz] = <[x y z]>
      .map -> bbox.max[it] - bbox.min[it]
      .map (d,i) -> ((values.transform-origin or [0.5,0.5,0.5])[i] - 0.5) * d
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
    node.style.animation = "#{@config.name}-#{@id} #{opt.dur or 1}s #{opt.repeatCount or \infinite} linear"
    node.style.animationDelay = "#{opt.delay or 0}s"
  statify: (node) -> node.style.animation = node.style.animationDelay = ""
  destroy: -> @dom.parentNode.removechild @dom

anikit <<< do
  util:
    m4to3: (m) -> [m.0, m.1, m.4, m.5, m.3, -m.7].map -> easing-fit.round it
    noise: (t) -> (Math.sin(t * 43758.5453) + 1 ) * 0.5
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
    mod = if @types[name] => @mods[@types[name]] else @mods[name]
    config = {name: name, dur: 1}
    for k,v of mod.edit => config[k] = v.default
    /* default / preset / overwrite */
    config <<< mod.preset[name] <<< opt
    return {mod, config}
  /* all available mods */
  mods: kits-list.mods
  /* all available animations, base on mods */
  types: kits-list.types


if window? => window <<< {easing, anikit, easing-fit, cubic}
if module? => module.exports <<< anikit
