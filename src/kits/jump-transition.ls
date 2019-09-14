require! <[easing-fit cubic ../anikit ../easing]>

no-bounce = do
  count: {default: 1, hidden: true}
  decay: {default: 2, hidden: true}
  dtime: {default: 0.7, hidden: true}
  power: 0.25
 
slide = do
  prop: (f, c, d, o) ->
    value = @value f.value, c, d, o
    return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})", opacity: value.opacity
  value: (t, c, d, o) ->
    if c.dir > 0 => t = 1 - t
    if t <= 0.005 => t = 0.005
    if d < 3 => 
      sgn = if d == 1 => 1 else -1
      ret = transform: [1, 0, 0, sgn * (1 - t) * c.offset, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    else 
      sgn = if d == 3 => 1 else -1
      ret = transform: [1, 0, 0, 0, 0, 1, 0, sgn * (1 - t) * c.offset, 0, 0, 1, 0, 0, 0, 0, 1]
    if o? => ret.opacity = t
    else ret.opacity = if t <= 0.005 => 0 else 1
    ret

flip = do
  prop: (f, c, d) ->
    value = @value f.value, c, d
    return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})", opacity: value.opacity
  value: (t, c, d) ->
    if c.dir > 0 => t = 1 - t
    if t <= 0.005 => t = 0.005
    ret = if d == 1 => {transform: [1, 0, 0, 0, 0, t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]}
    else  {transform: [t, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]}
    ret.opacity = if t <= 0.005 => 0 else 1
    ret

grow = do
  prop: (f, c, d) ->
    value = @value f.value, c, d
    ret = transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
    if value.opacity? => ret.opacity = value.opacity
    ret
  value: (t, c, d) ->
    if c.dir > 0 => t = 1 - t
    if t <= 0.005 => t = 0.005
    o = if t <= 0.005 => 0 else 1

    if d < 3 => 
      sgn = if d == 1 => 1 else -1
      ret = {transform: [t, 0, 0, sgn * (1 - t) * c.offset, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]}
    else 
      sgn = if d == 3 => 1 else -1
      ret = {transform: [1, 0, 0, 0, 0, t, 0, sgn * (1 - t) * c.offset, 0, 0, 1, 0, 0, 0, 0, 1]}
    ret.opacity = o
    return ret

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

    "grow-rtl-in": {
      dir: 1
      local: seg-ptrs: [0.02]
      prop: (f, c) -> grow.prop f, c, 1
      value: (t, c) -> grow.value t, c, 1
    } <<< no-bounce
    "grow-rtl-out": {
      dir: -1
      local: seg-ptrs: [0.97]
      prop: (f, c) -> grow.prop f, c, 1
      value: (t, c) -> grow.value t, c, 1
    } <<< no-bounce
    "grow-ltr-in": {
      dir: 1
      local: seg-ptrs: [0.02]
      prop: (f, c) -> grow.prop f, c, 2
      value: (t, c) -> grow.value t, c, 2
    } <<< no-bounce
    "grow-ltr-out": {
      dir: -1
      local: seg-ptrs: [0.97]
      prop: (f, c) -> grow.prop f, c, 2
      value: (t, c) -> grow.value t, c, 2
    } <<< no-bounce
    "grow-ttb-in": {
      dir: 1
      local: seg-ptrs: [0.02]
      prop: (f, c) -> grow.prop f, c, 3
      value: (t, c) -> grow.value t, c, 3
    } <<< no-bounce
    "grow-ttb-out": {
      dir: -1
      local: seg-ptrs: [0.97]
      prop: (f, c) -> grow.prop f, c, 3
      value: (t, c) -> grow.value t, c, 3
    } <<< no-bounce
    "grow-btt-in": {
      dir: 1
      local: seg-ptrs: [0.02]
      prop: (f, c) -> grow.prop f, c, 4
      value: (t, c) -> grow.value t, c, 4
    } <<< no-bounce
    "grow-btt-out": {
      dir: -1
      local: seg-ptrs: [0.97]
      prop: (f, c) -> grow.prop f, c, 4
      value: (t, c) -> grow.value t, c, 4
    } <<< no-bounce

    "flip-v-in": {
      dir: 1
      local: seg-ptrs: [0.02]
      prop: (f, c) -> flip.prop f, c, 1
      value: (t, c) -> flip.value t, c, 1
    } <<< no-bounce
    "flip-v-out": {
      dir: -1
      local: seg-ptrs: [0.97]
      prop: (f, c) -> flip.prop f, c, 1
      value: (t, c) -> flip.value t, c, 1
    } <<< no-bounce
    "flip-h-in": {
      dir: 1
      local: seg-ptrs: [0.02]
      prop: (f, c) -> flip.prop f, c, 2
      value: (t, c) -> flip.value t, c, 2
    } <<< no-bounce
    "flip-h-out": {
      dir: -1
      local: seg-ptrs: [0.97]
      prop: (f, c) -> flip.prop f, c, 2
      value: (t, c) -> flip.value t, c, 2
    } <<< no-bounce

    "slide-rtl-in": {
      dir: 1, offset: default: 200, hidden: false
      local: seg-ptrs: [0.02]
      prop: (f, c) -> slide.prop f, c, 1
      value: (t, c) -> slide.value t, c, 1
    } <<< no-bounce
    "slide-rtl-out": {
      dir: -1, offset: default: 200, hidden: false
      local: seg-ptrs: [0.97]
      prop: (f, c) -> slide.prop f, c, 1
      value: (t, c) -> slide.value t, c, 1
    } <<< no-bounce
    "slide-ltr-in": {
      dir: 1, offset: default: 200, hidden: false
      local: seg-ptrs: [0.02]
      prop: (f, c) -> slide.prop f, c, 2
      value: (t, c) -> slide.value t, c, 2
    } <<< no-bounce
    "slide-ltr-out": {
      dir: -1, offset: default: 200, hidden: false
      local: seg-ptrs: [0.97]
      prop: (f, c) -> slide.prop f, c, 2
      value: (t, c) -> slide.value t, c, 2
    } <<< no-bounce
    "slide-ttb-in": {
      dir: 1, offset: default: 200, hidden: false
      local: seg-ptrs: [0.02]
      prop: (f, c) -> slide.prop f, c, 3
      value: (t, c) -> slide.value t, c, 3
    } <<< no-bounce
    "slide-ttb-out": {
      dir: -1, offset: default: 200, hidden: false
      local: seg-ptrs: [0.97]
      prop: (f, c) -> slide.prop f, c, 3
      value: (t, c) -> slide.value t, c, 3
    } <<< no-bounce
    "slide-btt-in": {
      dir: 1, offset: default: 200, hidden: false
      local: seg-ptrs: [0.02]
      prop: (f, c) -> slide.prop f, c, 4
      value: (t, c) -> slide.value t, c, 4
    } <<< no-bounce
    "slide-btt-out": {
      dir: -1, offset: default: 200, hidden: false
      local: seg-ptrs: [0.97]
      prop: (f, c) -> slide.prop f, c, 4
      value: (t, c) -> slide.value t, c, 4
    } <<< no-bounce

    "float-rtl-in": {
      dir: 1, offset: default: 15, hidden: false
      prop: (f, c) -> slide.prop f, c, 1, 1
      value: (t, c) -> slide.value t, c, 1, 1
    } <<< no-bounce
    "float-rtl-out": {
      dir: -1, offset: default: 15, hidden: false
      prop: (f, c) -> slide.prop f, c, 1, 1
      value: (t, c) -> slide.value t, c, 1, 1
    } <<< no-bounce
    "float-ltr-in": {
      dir: 1, offset: default: 15, hidden: false
      prop: (f, c) -> slide.prop f, c, 2, 1
      value: (t, c) -> slide.value t, c, 2, 1
    } <<< no-bounce
    "float-ltr-out": {
      dir: -1, offset: default: 15, hidden: false
      prop: (f, c) -> slide.prop f, c, 2, 1
      value: (t, c) -> slide.value t, c, 2, 1
    } <<< no-bounce
    "float-ttb-in": {
      dir: 1, offset: default: 15, hidden: false
      prop: (f, c) -> slide.prop f, c, 3, 1
      value: (t, c) -> slide.value t, c, 3, 1
    } <<< no-bounce
    "float-ttb-out": {
      dir: -1, offset: default: 15, hidden: false
      prop: (f, c) -> slide.prop f, c, 3, 1
      value: (t, c) -> slide.value t, c, 3, 1
    } <<< no-bounce
    "float-btt-in": {
      dir: 1, offset: default: 15, hidden: false
      prop: (f, c) -> slide.prop f, c, 4, 1
      value: (t, c) -> slide.value t, c, 4, 1
    } <<< no-bounce
    "float-btt-out": {
      dir: -1, offset: default: 15, hidden: false
      prop: (f, c) -> slide.prop f, c, 4, 1
      value: (t, c) -> slide.value t, c, 4, 1
    } <<< no-bounce

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
  
    dir: type: \number, default: 1, hidden: true, min: -1, max: 1, step: 2
    count: name: "Bounce Count", type: \number, default: 5, min: 1, max: 30, step: 2
    dtime: name: "Time Decay", type: \number, default: 0.7, min: 0, max: 1, step: 0.01
    decay: name: "Amount Decay", type: \number, default: 0.4, min: 0, max: 1, step: 0.01
    power: type: \number, default: 2, min: 0, max: 10, step: 0.01, hidden: true
    offset: type: \number, default: 50, min: 0, max: 500, step: 1, hidden: true
    repeat: default: 1
  local: 
    prop: (f, c) ->
      value = @value f.value, c
      return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
    value: (t, c) ->
      if c.dir > 0 => t = 1 - t
      t >?= 0.01
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
    if value.opacity? => ret.opacity = value.opacity
    return ret
  affine: (t, opt) -> 
    t = @timing(t, opt)
    return if opt.value => opt.value(t,opt) else @local.value(t,opt)

module.exports = ret
