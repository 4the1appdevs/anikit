require! <[easing-fit cubic ../anikit ../easing]>

slide = do
  prop: (f, c, d) ->
    value = @value f.value, c, d
    return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})", opacity: value.opacity
  value: (t, c, d) ->
    if c.dir > 0 => t = 1 - t
    if t <= 0.01 => t = 0.01
    if d < 3 => 
      sgn = if d == 1 => 1 else -1
      {
        transform: [1, 0, 0, sgn * (1 - t) * c.offset, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
        opacity: t
      }
    else 
      sgn = if d == 3 => 1 else -1
      {
        transform: [1, 0, 0, 0, 0, 1, 0, sgn * (1 - t) * c.offset, 0, 0, 1, 0, 0, 0, 0, 1]
        opacity: t
      }

flip = do
  prop: (f, c, d) ->
    value = @value f.value, c, d
    return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
  value: (t, c, d) ->
    if c.dir > 0 => t = 1 - t
    if t <= 0.01 => t = 0.01
    if d == 1 => {transform: [1, 0, 0, 0, 0, t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]}
    else  {transform: [t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]}

grow = do
  prop: (f, c, d) ->
    value = @value f.value, c, d
    return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
  value: (t, c, d) ->
    if c.dir > 0 => t = 1 - t
    if t <= 0.01 => t = 0.01
    if d < 3 => 
      sgn = if d == 1 => 1 else -1
      {transform: [t, 0, 0, sgn * (1 - t) * c.offset, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]}
    else 
      sgn = if d == 3 => 1 else -1
      {transform: [1, 0, 0, 0, 0, t, 0, sgn * (1 - t) * c.offset, 0, 0, 1, 0, 0, 0, 0, 1]}

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
    "fade-in": 
      dir:  1, count: 1, power: 0.25
      prop: (f, c) -> {opacity: if c.dir > 0 => 1 - f.value else f.value}
      value: (t, c) -> {opacity: if c.dir > 0 => 1 - t else t}
    "fade-out": 
      dir:  -1, count: 1, power: 0.25
      prop: (f, c) -> {opacity: f.value}
      value: (t, c) -> {opacity: t}

    "grow-rtl-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> grow.prop f, c, 1
      value: (t, c) -> grow.value t, c, 1
    "grow-rtl-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> grow.prop f, c, 1
      value: (t, c) -> grow.value t, c, 1
    "grow-ltr-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> grow.prop f, c, 2
      value: (t, c) -> grow.value t, c, 2
    "grow-ltr-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> grow.prop f, c, 2
      value: (t, c) -> grow.value t, c, 2
    "grow-ttb-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> grow.prop f, c, 3
      value: (t, c) -> grow.value t, c, 3
    "grow-ttb-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> grow.prop f, c, 3
      value: (t, c) -> grow.value t, c, 3
    "grow-btt-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> grow.prop f, c, 4
      value: (t, c) -> grow.value t, c, 4
    "grow-btt-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> grow.prop f, c, 4
      value: (t, c) -> grow.value t, c, 4

    "flip-v-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> flip.prop f, c, 1
      value: (t, c) -> flip.value t, c, 1
    "flip-v-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> flip.prop f, c, 1
      value: (t, c) -> flip.value t, c, 1

    "flip-h-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> flip.prop f, c, 2
      value: (t, c) -> flip.value t, c, 2
    "flip-h-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> flip.prop f, c, 2
      value: (t, c) -> flip.value t, c, 2

    "slide-rtl-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> slide.prop f, c, 1
      value: (t, c) -> slide.value t, c, 1
    "slide-rtl-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> slide.prop f, c, 1
      value: (t, c) -> slide.value t, c, 1
    "slide-ltr-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> slide.prop f, c, 2
      value: (t, c) -> slide.value t, c, 2
    "slide-ltr-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> slide.prop f, c, 2
      value: (t, c) -> slide.value t, c, 2
    "slide-ttb-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> slide.prop f, c, 3
      value: (t, c) -> slide.value t, c, 3
    "slide-ttb-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> slide.prop f, c, 3
      value: (t, c) -> slide.value t, c, 3
    "slide-btt-in":
      dir: 1, count: 1, power: 0.25
      prop: (f, c) -> slide.prop f, c, 4
      value: (t, c) -> slide.value t, c, 4
    "slide-btt-out":
      dir: -1, count: 1, power: 0.25
      prop: (f, c) -> slide.prop f, c, 4
      value: (t, c) -> slide.value t, c, 4

    "fall-rtl-in":
      dir: 1, count: 3
      prop: (f, c) -> slide.prop f, c, 1
      value: (t, c) -> slide.value t, c, 1
    "fall-ltr-in":
      dir: 1, count: 3
      prop: (f, c) -> slide.prop f, c, 2
      value: (t, c) -> slide.value t, c, 2
    "fall-ttb-in":
      dir: 1, count: 3
      prop: (f, c) -> slide.prop f, c, 3
      value: (t, c) -> slide.value t, c, 3
    "fall-btt-in":
      dir: 1, count: 3
      prop: (f, c) -> slide.prop f, c, 4
      value: (t, c) -> slide.value t, c, 4


  edit: 
  
    dir: type: \number, default: 1, hidden: true
    count: type: \number, default: 5, min: 1, max: 30, step: 2
    dtime: type: \number, default: 0.7, min: 0, max: 1, step: 0.01
    decay: type: \number, default: 0.4, min: 0, max: 1, step: 0.01
    power: type: \number, default: 2, min: 0, max: 10, step: 0.01, hidden: true
    offset: type: \number, default: 50, min: 0, max: 100, step: 1
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
