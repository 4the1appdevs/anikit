require! <[easing-fit cubic ../anikit ../easing]>

spring = do
  prop: (f, c, d) ->
    value = @value f.value, c, d
    return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})", opacity: value.opacity
  value: (t, c, d) ->
    t = if c.dir > 0 => t else 1 - t
    if c.dir < 0 and t > 1 => t = 1
    t >?= 0.01
    if d < 3 =>
      sgn = if d == 1 => 1 else -1
      return transform: [1,0,0,c.offset * (1 - t) * sgn,0,1,0,0,0,0,1,0,0,0,0,1], opacity: t
    else
      sgn = if d == 3 => 1 else -1
      return transform: [1,0,0,0,0,1,0,c.offset * (1 - t) * sgn,0,0,1,0,0,0,0,1], opacity: t

ret = do
  name: \bounce-transition
  type: \animation
  preset: 
    "bounce-in-alt":  
      dir:  1, count: 3, mag: 0.1, extrude: 0.5
      local: sample-count: 20, error-threshold: 0.001, seg-sample-count: 1000
    "bounce-out-alt":
      dir: -1, count: 3, mag: 0.1
      local: sample-count: 20, error-threshold: 0.001, seg-sample-count: 1000
    "bounce-in":  
      dir:  1, count: 4, mag: 0.2, extrude: 0.5
      local: sample-count: 40, error-threshold: 0.0001, seg-sample-count: 1000
    "bounce-out":
      dir: -1, count: 4, mag: 0.2
      local: sample-count: 20, error-threshold: 0.001, seg-sample-count: 1000
    "spring-ltr-in":
      dir: 1, count: 3, mag: 0.2, extrude: 0.5, offset: 50
      local: sample-count: 20, error-threshold: 0.001, seg-sample-count: 1000
      prop: (f, c) -> spring.prop f, c, 2
      value: (t, c) -> spring.value t, c, 2
    "spring-rtl-in":
      dir: 1, count: 3, mag: 0.2, extrude: 0.5, offset: 50
      local: sample-count: 20, error-threshold: 0.001, seg-sample-count: 1000
      prop: (f, c) -> spring.prop f, c, 1
      value: (t, c) -> spring.value t, c, 1
    "spring-ttb-in":
      dir: 1, count: 3, mag: 0.2, extrude: 0.5, offset: 50
      local: sample-count: 20, error-threshold: 0.001, seg-sample-count: 1000
      prop: (f, c) -> spring.prop f, c, 3
      value: (t, c) -> spring.value t, c, 3
    "spring-btt-in":
      dir: 1, count: 3, mag: 0.2, extrude: 0.5, offset: 50
      local: sample-count: 20, error-threshold: 0.001, seg-sample-count: 1000
      prop: (f, c) -> spring.prop f, c, 4
      value: (t, c) -> spring.value t, c, 4

  edit: 
    dir: type: \number, default: 1, hidden: true
    count: type: \number, default: 30, min: 0, max: 100, step: 0.1
    mag: type: \number, default: 0.3, min: 0, max: 1, step: 0.01
    extrude: type: \number, default: 0, min: 0, max: 1, step: 0.01
    offset: type: \number, default: 0, min: -300, max: 300, step: 1
  local: 
    prop: (f, c) ->
      value = @value f.value, c
      return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
    value: (t, c) ->
      t = if c.dir > 0 => t else 1 - t
      if c.dir < 0 and t > 1 => t = 1
      t >?= 0.01
      return transform: [t,0,0,0,0,t,0,0,0,0,t,0,0,0,0,1]

  timing: (t, opt) ->
    return 1 - (
      Math.cos(t * 6.28 * opt.count) * ( 1 - t ** opt.mag ) + ( 1 - t ** (opt.mag * (1 - opt.extrude)) )
    )
    return ( 1 - (
      (1 - Math.exp(t * 5 - 5)) * Math.sin(t * opt.count) * (1 - t ** opt.mag) * Math.max(0,(0.9 - t)) * 1.11 +
      Math.min(Math.pow(2,-t * opt.count ), 1)
    ))

  css: (opt) -> 
    prop = (f, c) ~> if opt.prop => opt.prop(f,c) else @local.prop(f, c)
    ret = easing-fit.fit-to-keyframes(
      (~> @timing it, opt),
      ({} <<< opt.local or {}) <<< {config: opt} <<< opt{name} <<< {prop: prop}
    )
    ret
  js: (t, opt) ->
    value = @affine t, opt
    ret = {}
    if value.transform => ret.transform = "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
    if value.opacity => ret.opacity = value.opacity
    return ret
  affine: (t, opt) ->
    t = @timing(t, opt)
    return if opt.value => opt.value(t,opt) else @local.value(t,opt)


module.exports = ret
