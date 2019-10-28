(->
  if require? => require! <[easing-fit cubic ../anikit ../easing]>

  no-bounce = do
    count: {default: 1, hidden: true}
    decay: {default: 2, hidden: true}
    dtime: {default: 0.7, hidden: true}
    power: 0.25
   
  slide = do
    prop: (f, c, d, o) ->
      value = @value f.value, c, d, o
      return transform: anikit.util.decompose(anikit.util.m4to3(value.transform), c), opacity: value.opacity
    value: (t, c, d, o, p) ->
      if c.dir > 0 => t = 1 - t
      if t <= 0.005 => t = 0.005
      if d < 3 => 
        sgn = if d == 1 => 1 else -1
        ret = transform: [1, 0, 0, sgn * (1 - t) * c.offset, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
      else 
        sgn = if d == 3 => 1 else -1
        ret = transform: [1, 0, 0, 0, 0, 1, 0, sgn * (1 - t) * c.offset, 0, 0, 1, 0, 0, 0, 0, 1]
      if o? => ret.opacity = ((if p? => p else t) * 10 <? 1)
      else ret.opacity = if t <= 0.005 => 0 else 1
      ret

  flip = do
    prop: (f, c, d) ->
      value = @value f.value, c, d
      return transform: anikit.util.decompose(anikit.util.m4to3(value.transform), c), opacity: value.opacity
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
      ret = transform: anikit.util.decompose(anikit.util.m4to3(value.transform), c)
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
        label: "grow-in (right to left)"
        dir: 1
        local: seg-ptrs: [0.02]
        prop: (f, c) -> grow.prop f, c, 1
        value: (t, c) -> grow.value t, c, 1
      } <<< no-bounce
      "grow-rtl-out": {
        label: "grow-out (right to left)"
        dir: -1
        local: seg-ptrs: [0.97]
        prop: (f, c) -> grow.prop f, c, 1
        value: (t, c) -> grow.value t, c, 1
      } <<< no-bounce
      "grow-ltr-in": {
        label: "grow-in (left to right)"
        dir: 1
        local: seg-ptrs: [0.02]
        prop: (f, c) -> grow.prop f, c, 2
        value: (t, c) -> grow.value t, c, 2
      } <<< no-bounce
      "grow-ltr-out": {
        label: "grow-out (left to right)"
        dir: -1
        local: seg-ptrs: [0.97]
        prop: (f, c) -> grow.prop f, c, 2
        value: (t, c) -> grow.value t, c, 2
      } <<< no-bounce
      "grow-ttb-in": {
        label: "grow-in (top to bottom)"
        dir: 1
        local: seg-ptrs: [0.02]
        prop: (f, c) -> grow.prop f, c, 3
        value: (t, c) -> grow.value t, c, 3
      } <<< no-bounce
      "grow-ttb-out": {
        label: "grow-out (top to bottom)"
        dir: -1
        local: seg-ptrs: [0.97]
        prop: (f, c) -> grow.prop f, c, 3
        value: (t, c) -> grow.value t, c, 3
      } <<< no-bounce
      "grow-btt-in": {
        label: "grow-in (bottom to top)"
        dir: 1
        local: seg-ptrs: [0.02]
        prop: (f, c) -> grow.prop f, c, 4
        value: (t, c) -> grow.value t, c, 4
      } <<< no-bounce
      "grow-btt-out": {
        label: "grow-out (bottom to top)"
        dir: -1
        local: seg-ptrs: [0.97]
        prop: (f, c) -> grow.prop f, c, 4
        value: (t, c) -> grow.value t, c, 4
      } <<< no-bounce

      "flip-v-in": {
        label: "flip-in (vertically)"
        dir: 1
        local: seg-ptrs: [0.02]
        prop: (f, c) -> flip.prop f, c, 1
        value: (t, c) -> flip.value t, c, 1
      } <<< no-bounce
      "flip-v-out": {
        label: "flip-out (vertically)"
        dir: -1
        local: seg-ptrs: [0.97]
        prop: (f, c) -> flip.prop f, c, 1
        value: (t, c) -> flip.value t, c, 1
      } <<< no-bounce
      "flip-h-in": {
        label: "flip-in (horizontally)"
        dir: 1
        local: seg-ptrs: [0.02]
        prop: (f, c) -> flip.prop f, c, 2
        value: (t, c) -> flip.value t, c, 2
      } <<< no-bounce
      "flip-h-out": {
        label: "flip-out (horizontally)"
        dir: -1
        local: seg-ptrs: [0.97]
        prop: (f, c) -> flip.prop f, c, 2
        value: (t, c) -> flip.value t, c, 2
      } <<< no-bounce

      "slide-rtl-in": {
        label: "slide-in (right to left)"
        dir: 1, offset: default: 200, hidden: false
        local: seg-ptrs: [0.02]
        prop: (f, c) -> slide.prop f, c, 1, 1
        value: (t, c) -> slide.value t, c, 1, 1
      } <<< no-bounce
      "slide-rtl-out": {
        label: "slide-out (right to left)"
        dir: -1, offset: default: 200, hidden: false
        local: seg-ptrs: [0.97]
        prop: (f, c) -> slide.prop f, c, 1, 1
        value: (t, c) -> slide.value t, c, 1, 1
      } <<< no-bounce
      "slide-ltr-in": {
        label: "slide-in (left to right)"
        dir: 1, offset: default: 200, hidden: false
        local: seg-ptrs: [0.02]
        prop: (f, c) -> slide.prop f, c, 2, 1
        value: (t, c) -> slide.value t, c, 2, 1
      } <<< no-bounce
      "slide-ltr-out": {
        label: "slide-out (left to right)"
        dir: -1, offset: default: 200, hidden: false
        local: seg-ptrs: [0.97]
        prop: (f, c) -> slide.prop f, c, 2, 1
        value: (t, c) -> slide.value t, c, 2, 1
      } <<< no-bounce
      "slide-ttb-in": {
        label: "slide-in (top to bottom)"
        dir: 1, offset: default: 200, hidden: false
        local: seg-ptrs: [0.02]
        prop: (f, c) -> slide.prop f, c, 3, 1
        value: (t, c) -> slide.value t, c, 3, 1
      } <<< no-bounce
      "slide-ttb-out": {
        label: "slide-out (top to bottom)"
        dir: -1, offset: default: 200, hidden: false
        local: seg-ptrs: [0.97]
        prop: (f, c) -> slide.prop f, c, 3, 1
        value: (t, c) -> slide.value t, c, 3, 1
      } <<< no-bounce
      "slide-btt-in": {
        label: "slide-in (bottom to top)"
        dir: 1, offset: default: 200, hidden: false
        local: seg-ptrs: [0.02]
        prop: (f, c) -> slide.prop f, c, 4, 1
        value: (t, c) -> slide.value t, c, 4, 1
      } <<< no-bounce
      "slide-btt-out": {
        label: "slide-out (bottom to top)"
        dir: -1, offset: default: 200, hidden: false
        local: seg-ptrs: [0.97]
        prop: (f, c) -> slide.prop f, c, 4, 1
        value: (t, c) -> slide.value t, c, 4, 1
      } <<< no-bounce

      "float-rtl-in": {
        label: "float-in (right to left)"
        dir: 1, offset: default: 15, hidden: false
        prop: (f, c) -> slide.prop f, c, 1, 1
        value: (t, c) -> slide.value t, c, 1, 1
      } <<< no-bounce
      "float-rtl-out": {
        label: "float-out (right to left)"
        dir: -1, offset: default: 15, hidden: false
        prop: (f, c) -> slide.prop f, c, 1, 1
        value: (t, c) -> slide.value t, c, 1, 1
      } <<< no-bounce
      "float-ltr-in": {
        label: "float-in (left to right)"
        dir: 1, offset: default: 15, hidden: false
        prop: (f, c) -> slide.prop f, c, 2, 1
        value: (t, c) -> slide.value t, c, 2, 1
      } <<< no-bounce
      "float-ltr-out": {
        label: "float-out (left to right)"
        dir: -1, offset: default: 15, hidden: false
        prop: (f, c) -> slide.prop f, c, 2, 1
        value: (t, c) -> slide.value t, c, 2, 1
      } <<< no-bounce
      "float-ttb-in": {
        label: "float-in (top to bottom)"
        dir: 1, offset: default: 15, hidden: false
        prop: (f, c) -> slide.prop f, c, 3, 1
        value: (t, c) -> slide.value t, c, 3, 1
      } <<< no-bounce
      "float-ttb-out": {
        label: "float-out (top to bottom)"
        dir: -1, offset: default: 15, hidden: false
        prop: (f, c) -> slide.prop f, c, 3, 1
        value: (t, c) -> slide.value t, c, 3, 1
      } <<< no-bounce
      "float-btt-in": {
        label: "float-in (bottom to top)"
        dir: 1, offset: default: 15, hidden: false
        prop: (f, c) -> slide.prop f, c, 4, 1
        value: (t, c) -> slide.value t, c, 4, 1
      } <<< no-bounce
      "float-btt-out": {
        label: "float-out (bottom to top)"
        dir: -1, offset: default: 15, hidden: false
        prop: (f, c) -> slide.prop f, c, 4, 1
        value: (t, c) -> slide.value t, c, 4, 1
      } <<< no-bounce

      "fall-rtl-in":
        label: "fall-in (right to left)"
        dir: 1, count: 3
        prop: (f, c) -> slide.prop f, c, 1
        value: (t, c, p) -> slide.value t, c, 1, 1, p
      "fall-ltr-in":
        label: "fall-in (left to right)"
        dir: 1, count: 3
        prop: (f, c) -> slide.prop f, c, 2
        value: (t, c, p) -> slide.value t, c, 2, 1, p
      "fall-ttb-in":
        label: "fall-in (top to bottom)"
        dir: 1, count: 3
        prop: (f, c) -> slide.prop f, c, 3
        value: (t, c, p) -> slide.value t, c, 3, 1, p
      "fall-btt-in":
        label: "fall-in (bottom to top)"
        dir: 1, count: 3
        prop: (f, c) -> slide.prop f, c, 4
        value: (t, c, p) -> slide.value t, c, 4, 1, p


    edit: 
    
      dir: type: \number, default: 1, hidden: true, min: -1, max: 1, step: 2
      count: name: "Bounce Count", type: \number, default: 5, min: 1, max: 30, step: 2
      dtime: name: "Time Decay", type: \number, default: 0.7, min: 0, max: 1, step: 0.01
      decay: name: "Amount Decay", type: \number, default: 0.4, min: 0, max: 1, step: 0.01
      power: type: \number, default: 2, min: 0, max: 10, step: 0.01, hidden: true
      offset: type: \number, default: 50, min: 0, max: 500, step: 1, hidden: true
      unit: default: \px, type: \choice, values: ["px", "%", ""]
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
      t2 = @timing(t, opt)
      return if opt.value => opt.value(t2,opt,t) else @local.value(t2,opt,t)

  if module? => module.exports = ret
  return ret
)!
