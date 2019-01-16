require! <[easing-fit cubic ../anikit]>
ret = do
  name: \slide
  type: \animation
  preset:
    "slide-ltr": 
      local: error-threshold: 0.0001, sample-count: 20
      offset: 200
      prop: (f, c) -> do
        transform: "translate(#{f.value * c.offset}#{c.unit},0)"
        opacity: if f.value <= -0.8 or f.value >= 0.8 => 0 else 1
      value: (t, c) -> do
        transform: anikit.util.tx t * c.offset
        opacity: if t <= -0.8 or t >= 0.8 => 0 else 1

    "slide-rtl": 
      local: error-threshold: 0.0001, sample-count: 20
      offset: -200
      prop: (f, c) -> do
        transform: "translate(#{f.value * c.offset}#{c.unit},0)"
        opacity: if f.value <= -0.8 or f.value >= 0.8 => 0 else 1
      value: (t, c) -> do
        transform: anikit.util.tx t * c.offset
        opacity: if t <= -0.8 or t >= 0.8 => 0 else 1

    "slide-btt": 
      local: error-threshold: 0.0001, sample-count: 20
      offset: -200
      prop: (f, c) -> do
        transform: "translate(0,#{f.value * c.offset}#{c.unit})"
        opacity: if f.value <= -0.8 or f.value >= 0.8 => 0 else 1
      value: (t, c) -> do
        transform: anikit.util.ty t * c.offset
        opacity: if t <= -0.8 or t >= 0.8 => 0 else 1

    "slide-ttb": 
      local: error-threshold: 0.0001, sample-count: 20
      offset: 200
      prop: (f, c) -> do
        transform: "translate(0,#{f.value * c.offset}#{c.unit})"
        opacity: if f.value <= -0.8 or f.value >= 0.8 => 0 else 1
      value: (t, c) -> do
        transform: anikit.util.ty t * c.offset
        opacity: if t <= -0.8 or t >= 0.8 => 0 else 1

  edit: 
    steep: default: 0.3, type: \number, min: 0.3, max: 1, step: 0.01
    offset: default: 200, type: \number, unit: \px, min: -2000, max: 2000
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  timing: (t, opt) ->
    p1 = [opt.steep, 0, 1, 1 - opt.steep] # speed up
    p2 = [0, opt.steep, 1 - opt.steep, 1] # speed down
    if t < 0.5 =>
      t = cubic.Bezier.y(cubic.Bezier.t(t * 2, p1), p1)
    else
      t = (cubic.Bezier.y(cubic.Bezier.t((t - 0.5) * 2, p2), p2) / 2)
      t = t * 2 - 1
    return t

  /*
  css: (opt) -> anikit.step-to-keyframes (~> @timing it, opt), opt
  js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
  */

  css: (opt) -> 
    easing-fit.fit-to-keyframes (~> @timing it, opt), (opt.local or {}) <<< {config: opt} <<< opt{name, prop}
  js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
  affine: (t, opt) -> opt.value @timing(t, opt), opt

  /* equivalent keyframes */
  /*
  slide(name, dur, rate, offset, func)
    .{name}
      animation: unquote(name) dur linear infinite
    @keyframes {name}
      0%, 100%
        timing-speed-up(rate)
      50%
        timing-speed-down(rate)
      0%
        func(0)
      49.9%
        func(offset)
      50%
        func(-1 * offset)
      100%
        func(0)
  */
module.exports = ret
