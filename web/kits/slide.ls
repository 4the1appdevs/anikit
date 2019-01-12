ret = do
  name: \slide
  preset:

    "slide-ltr": 
      error-threshold: 0.0001
      sample-count: 20
      offset: 200
      propFunc: (f, opt) -> do
        transform: "translate(#{f.value * opt.offset}#{opt.unit},0)"
        opacity: if f.value <= -0.8 or f.value >= 0.8 => 0 else 1

    "slide-rtl": 
      error-threshold: 0.0001
      sample-count: 20
      offset: -200
      propFunc: (f, opt) -> do
        transform: "translate(#{f.value * opt.offset}#{opt.unit},0)"
        opacity: if f.value <= -0.8 or f.value >= 0.8 => 0 else 1

    "slide-btt": 
      error-threshold: 0.0001
      sample-count: 20
      offset: -200
      propFunc: (f, opt) -> do
        transform: "translate(0,#{f.value * opt.offset}#{opt.unit})"
        opacity: if f.value <= -0.8 or f.value >= 0.8 => 0 else 1

    "slide-ttb": 
      error-threshold: 0.0001
      sample-count: 20
      offset: 200
      propFunc: (f, opt) -> do
        transform: "translate(0,#{f.value * opt.offset}#{opt.unit})"
        opacity: if f.value <= -0.8 or f.value >= 0.8 => 0 else 1

  edit: 
    steep: default: 0.3, type: \number, min: 0.3, max: 1
    offset: default: 200, type: \number, unit: \px, min: -2000, max: 2000
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  timing: (t, opt) ->
    p1 = [opt.steep, 0, 1, 1 - opt.steep] # speed up
    p2 = [0, opt.steep, 1 - opt.steep, 1] # speed down
    if t < 0.5 =>
      t = anikit.cubic.Bezier.y(anikit.cubic.Bezier.t(t * 2, p1), p1)
    else
      t = (anikit.cubic.Bezier.y(anikit.cubic.Bezier.t((t - 0.5) * 2, p2), p2) / 2)
      t = t * 2 - 1
    return t

  css: (opt) -> anikit.step-to-keyframes (~> @timing it, opt), opt
  js: (t, opt) -> opt.propFunc {value: @timing t, opt}, opt

  /*
  timing-speed-down(rate)
    animation-timing-function: cubic-bezier(0,rate,1 - rate,1)
  timing-speed-up(rate)
    animation-timing-function: cubic-bezier(rate,0,1,1 - rate)
  */

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
