require! <[easing-fit cubic ../anikit ../easing]>
ret = do
  name: \jump-transition
  type: \animation
  preset: 
    "jump-alt-in":  
      dir:  1, count: 9, dtime: 0.85, decay: 0.5
      local: sample-count: 40, error-threshold: 0.0001, seg-sample-count: 1000
    "jump-alt-out":
      dir: -1, count: 9, dtime: 0.85, decay: 0.5
      local: sample-count: 40, error-threshold: 0.0001, seg-sample-count: 1000
    "jump-in":  
      dir:  1, count: 3
      local: sample-count: 20, error-threshold: 0.0001, seg-sample-count: 1000
    "jump-out":
      dir: -1, count: 3
      local: sample-count: 40, error-threshold: 0.0001, seg-sample-count: 1000
    "zoom-in":
      dir:  1, count: 1, power: 0.25
      local: sample-count: 40, error-threshold: 0.01, seg-sample-count: 100
    "zoom-out": 
      dir: -1, count: 1, power: 0.25
      local: sample-count: 40, error-threshold: 0.01, seg-sample-count: 100
  edit: 
  
    dir: type: \number, default: 1, hidden: true
    count: type: \number, default: 5, min: 1, max: 30, step: 2
    dtime: type: \number, default: 0.7, min: 0, max: 1, step: 0.01
    decay: type: \number, default: 0.4, min: 0, max: 1, step: 0.01
    power: type: \number, default: 2, min: 0, max: 10, step: 0.01, hidden: true
  local: 
    prop: (f, c) ->
      value = @value f.value, c
      return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
    value: (t, c) ->
      if c.dir > 0 => t = 1 - t
      if t <= 0.01 => t = 0.01
      return transform: [t,0,0,0,0,t,0,0,0,0,t,0,0,0,0,1]

  timing: (t, opt) ->
    pt = 1 / ( 2 * ((( Math.pow(opt.dtime, opt.count) - 1 ) / ( opt.dtime - 1 )) - 0.5 ))
    et = 0
    t = t + pt

    for i from 0 til opt.count =>
      oet = et
      delta = pt * Math.pow(opt.dtime, i)
      et = et + 2 * delta
      if t <= et => 
        x = (1 - (((t - oet) - delta) ** opt.power) / (delta ** opt.power)) * Math.pow(opt.decay, i)
        return x
    return 0

  css: (opt) -> 
    prop = (f, c) ~> @local.prop f, c
    ret = easing-fit.fit-to-keyframes(
      (~> @timing it, opt),
      ({} <<< opt.local or {}) <<< {config: opt} <<< opt{name} <<< {prop: prop}
    )
    console.log ret
    ret
  js: (t, opt) ->
    value = @local.value(@timing(t,opt), opt )
    return {transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"}
  affine: (t, opt) -> @local.value @timing(t, opt), opt

module.exports = ret
