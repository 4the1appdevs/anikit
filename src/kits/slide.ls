(->
  if require? => require! <[easing-fit cubic ../anikit]>
  slide = do
    prop: (f, c) -> 
      value = @value f.value, c
      return do 
        transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
        opacity: if c.fade => value.opacity else 1
    value: (t, c) -> do
      transform: anikit.util[if c.dir == 1 => \tx else \ty] t * c.offset
      opacity: if c.fade and (t <= -0.8 or t >= 0.8) => 0 else 1


  ret = do
    name: \slide
    type: \animation
    preset:
      "slide-ltr": {offset:  200} <<< slide
      "slide-rtl": {offset: -200} <<< slide
      "slide-btt": {offset: -200, dir: 2} <<< slide
      "slide-ttb": {offset:  200, dir: 2} <<< slide

    edit: 
      fade: default: true, type: \boolean, hidden: true
      steep: default: 0.3, type: \number, min: 0.3, max: 1, step: 0.01
      offset: name: "Move Distance", default: 200, type: \number, unit: \px, min: -2000, max: 2000
      dir: default: 1, type: \number, hidden: true
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

    css: (opt) -> 
      local = error-threshold: 0.0001, sample-count: 20
      prop = (f, c) -> opt.prop f, c
      easing-fit.fit-to-keyframes (~> @timing it, opt), (local <<< opt.local or {}) <<< {prop, config: opt} <<< opt{name}
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
  if module? => module.exports = ret
  return ret
)!
