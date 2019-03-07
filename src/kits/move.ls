require! <[easing-fit cubic ../anikit]>
move = do
  prop: (f, c) -> 
    value = @value f.value, c
    return do 
      transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
  value: (t, c) -> do
    transform: anikit.util[if (c.dir % 2) => \tx else \ty](
      (if c.dir > 2 => -1 else 1) * 2 * (t - 0.5) * c.offset
    )


ret = do
  name: \move
  type: \animation
  preset:
    "move-ltr": {offset: 100, dir: 1} <<< move
    "move-rtl": {offset: 100, dir: 3} <<< move
    "move-ttb": {offset: 100, dir: 2} <<< move
    "move-btt": {offset: 100, dir: 4} <<< move

  edit: 
    steep: default: 0.3, type: \number, min: 0.3, max: 1, step: 0.01
    offset: name: "Move Distance", default: 100, type: \number, unit: \px, min: 0, max: 1000
    dir: default: 1, type: \number, hidden: true
    unit: default: \px, type: \choice, values: ["px", "%", ""]
    fade: type: \boolean, default: false

  timing: (t, opt) -> (((2 * t + 1) % 2) - 1) * 0.5 + 0.5

  css: (opt) -> 
    easing-fit.to-keyframes([
      {percent: 0, value: 0}
      {percent: 100, value: 1}
    ], {
      name: opt.name
      prop: (f, c) ->
        [a,b] = [0, f.value * c.offset * (if opt.dir > 2 => -1 else 1)]
        if ( c.dir % 2 ) => [a,b] = [b,a]
        return transform: "matrix(1,0,0,1,#a,#b)"
      config: opt
    }
    )
  js: (t, opt) -> opt.prop {value: t}, opt
  affine: (t, opt) -> opt.value t, opt

module.exports = ret
