require! <[easing-fit cubic ../anikit]>
move = do
  prop: (f, c) -> 
    value = @value f.value, c
    return do 
      transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
      opacity: value.opacity if c.fade
  value: (t, c) -> do
    transform: anikit.util[if c.dir == 1 => \tx else \ty] t * c.offset
    opacity: (if t <= -0.8 or t >= 0.8 => 0 else 1) if c.fade


ret = do
  name: \move
  type: \animation
  preset:
    "move-ltr": {offset: 200} <<< move
    "move-rtl": {offset: -200} <<< move
    "move-btt": {offset: -200, dir: 2} <<< move
    "move-ttb": {offset: 200, dir: 2} <<< move

  edit: 
    steep: default: 0.3, type: \number, min: 0.3, max: 1, step: 0.01
    offset: name: "Move Distance", default: 200, type: \number, unit: \px, min: -2000, max: 2000
    dir: default: 1, type: \number, hidden: true
    unit: default: \px, type: \choice, values: ["px", "%", ""]
    fade: type: \boolean, default: false

  css: (opt) -> 
    local = error-threshold: 0.0001, sample-count: 20
    prop = (f, c) -> opt.prop f, c
    easing-fit.fit-to-keyframes (~>it), (local <<< opt.local or {}) <<< {prop, config: opt} <<< opt{name}
  js: (t, opt) -> opt.prop {value: t}, opt
  affine: (t, opt) -> opt.value t, opt

module.exports = ret
