ret = do
  name: \rush
  preset:
    "rush-btt":
      dur: 2
      steep: 0.4, offset_near: 20, offset_far: 200, direction: -1
      percent_in: 0.6, percent_out: 0.8, skew: 30, unit: \px
      sample-count: 40, error-threshold: 0.001
      prop: (f, c) -> {
        transform: """
          translate(0,#{f.value * c.offset_far * c.direction}#{c.unit})
          skewY(#{f.value * c.skew * c.direction}deg)
        """
        opacity: Math.cos(f.value * Math.PI * 0.5)
      }
      value: (t, c) -> do
        transform: [
          1, -Math.tan(t * c.skew * c.direction * Math.PI / 180), 0, 0,
          0, 1, 0, -t * c.offset_far * c.direction, 0, 0, 1, 0, 0, 0, 0, 1
        ]
        opacity: Math.cos(t * Math.PI * 0.5)

    "rush-ttb":
      dur: 2
      steep: 0.4, offset_near: 20, offset_far: 200, direction: 1
      percent_in: 0.6, percent_out: 0.8, skew: 30, unit: \px
      sample-count: 40, error-threshold: 0.001
      prop: (f, c) -> {
        transform: """
          translate(0,#{f.value * c.offset_far * c.direction}#{c.unit})
          skewY(#{f.value * c.skew * c.direction}deg)
        """
        opacity: Math.cos(f.value * Math.PI * 0.5)
      }
      value: (t, c) -> do
        transform: [
          1, -Math.tan(t * c.skew * c.direction * Math.PI / 180), 0, 0,
          0, 1, 0, -t * c.offset_far * c.direction, 0, 0, 1, 0, 0, 0, 0, 1
        ]
        opacity: Math.cos(t * Math.PI * 0.5)

    "rush-rtl":
      dur: 2
      steep: 0.4, offset_near: 20, offset_far: 200, direction: -1
      percent_in: 0.6, percent_out: 0.8, skew: 30, unit: \px
      sample-count: 40, error-threshold: 0.001
      prop: (f, c) -> {
        transform: """
          translate(#{f.value * c.offset_far * c.direction}#{c.unit},0)
          skew(#{f.value * c.skew * -c.direction}deg)
        """
        opacity: Math.cos(f.value * Math.PI * 0.5)
      }
      value: (t, c) -> do
        transform: [
          1, -Math.tan(t * c.skew * -c.direction * Math.PI / 180), 0, t * c.offset_far * c.direction,
          0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1
        ]
        opacity: Math.cos(t * Math.PI * 0.5)

    "rush-ltr":
      dur: 2
      steep: 0.4, offset_near: 20, offset_far: 200, direction: 1
      percent_in: 0.6, percent_out: 0.8, skew: 30, unit: \px
      sample-count: 40, error-threshold: 0.001
      prop: (f, c) -> {
        transform: """
          translate(#{f.value * c.offset_far * c.direction}#{c.unit},0)
          skew(#{f.value * c.skew * -c.direction}deg)
        """
        opacity: Math.cos(f.value * Math.PI * 0.5)
      }
      value: (t, c) -> do
        transform: [
          1, -Math.tan(t * c.skew * -c.direction * Math.PI / 180), 0, t * c.offset_far * c.direction,
          0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1
        ]
        opacity: Math.cos(t * Math.PI * 0.5)

  edit: 
    steep: default: 0.6, type: \number, min: 0, max: 1
    offset_near: default: 20, type: \number, unit: \px, min: 0, max: 1000
    offset_far: default: 200, type: \number, unit: \px, min: 0, max: 1000
    direction: default: -1, type: \number, min: -1, max: 1, step: 2
    percent_in: default: 0.7, type: \number, unit: \%, min: 0, max: 100
    percent_out: default: 0.8, type: \number, unit: \%, min: 0, max: 100
    skew: default: 15, type: \number, unit: \deg, min: 0, max: 360
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  timing: (t, opt) ->
    p1 = [0, opt.steep, 1 - opt.steep, 1] # speed down
    pi = opt.percent_in
    po = opt.percent_out
    if po < pi => po = pi
    near = opt.offset_near / opt.offset_far
    if t == 0 => return -1
    if t < (pi / 3) =>
      t = cubic.Bezier.y(cubic.Bezier.t(t * 3/pi, p1), p1) * pi/3
      return ((near + 1) * t / (pi/3)) - 1
    if t < pi =>
      t = ((t - (pi/3)) * 3.75 / pi)
      return near * Math.cos(t * Math.PI) * (0.5 ** t)
    if t < po => return 0
    return (t - po) / (1 - po)

  css: (opt) -> 
    easing-fit.fit-to-keyframes (~> @timing it, opt), (opt.local or {}) <<< {config: opt} <<< opt{name, prop}
  js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
  affine: (t, opt) -> opt.value @timing(t, opt), opt

  /* equivalent keyframes */
  /*
  rush(name, dur, rate, offset_near, offset_far, direction, percent_in, percent_out, skew)
    .{name}
      animation: unquote(name) 1s linear infinite
    @keyframes {name}
      0%
        transform: translate(-1 * direction * offset_far, 0 ) skewX( direction * skew )
        timing-speed-down(rate)
      {percent_in * .37}
        transform: translate( 1 * direction * offset_near, 0)  skewX( -0.78 * direction * skew )
      {percent_in * .56}
        transform: translate( -0.5 * direction * offset_near, 0)  skewX( 0.34 * direction * skew )
      {percent_in * .75}
        transform: translate( 0.25 * direction * offset_near, 0) skew( -0.17 * direction * skew )
      {percent_in * 1}
        transform: translate( 0, 0 ) skew(0deg)
      {percent_out * 1}
        transform: translate( 0, 0 ) skew(0deg)
      100%
        transform: translate(direction * offset_far, 0) skewX( direction * skew )
  */

module.exports = ret
