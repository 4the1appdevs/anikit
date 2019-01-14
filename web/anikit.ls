require! <[easing-fit cubic ./kits-list ./easing]>
uuid = require 'uuid/v4'

{cos,sin} = Math{cos,sin}

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
    noise: (t) -> (Math.sin(t * 43758.5453) + 1 ) * 0.5
    rx: (t) -> [1, 0, 0, 0, 0, cos(t), -sin(t), 0, 0, sin(t), cos(t), 0, 0, 0, 0, 1]
    ry: (t) -> [cos(t), 0, sin(t), 0, 0, 1, 0, 0, -sin(t), 0, cos(t), 0, 0, 0, 0, 1]
    rz: (t) -> [cos(t), sin(t), 0, 0, -sin(t), cos(t), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    tx: (t) -> [1, 0, 0, t, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    ty: (t) -> [1, 0, 0, 0, 0, 1, 0, t, 0, 0, 1, 0, 0, 0, 0, 1]
    tz: (t) -> [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, t, 0, 0, 0, 1]
    sx: (t) -> [t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    sy: (t) -> [1, 0, 0, 0, 0, t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    sz: (t) -> [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, t, 0, 0, 0, 0, 1]
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
if module? => module.exports = anikit
