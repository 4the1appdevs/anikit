
ret = do
  name: \bounce-rigid
  preset:
    beat:
      steep: 0.4, count: 1, decay: 0.5, power: 1.1, offset: 0.2, unit: ''
      prop: (f, c) -> {transform: "scale(#{1 - c.offset * f.value})"}
      value: (t, c) -> transform: anikit.util.s 1 - t * c.offset

    bounce-alt:
      steep: 0.5, count: 0, decay: 0.5, power: 0, offset: -14, unit: 'px'
      prop: (f, c) -> {transform: "translate(0, #{c.offset * f.value}#{c.unit})"}
      value: (t, c) -> transform: anikit.util.ty c.offset * t

    pulse:
      dur: 0.5
      steep: 0.6, count: 0, decay: 0.5, power: 1.1, offset: 0.2, unit: ''
      local: error-threshold: 0.001, seg-sample-count: 20, sample-count: 1000
      prop: (f, c) -> {transform: "scale(#{1 - c.offset * f.value})"}
      value: (t, c) -> transform: anikit.util.s 1 - c.offset * t

    "tick-alt":
      steep: 0.4, count: 5, decay: 0.6, power: 1.1, offset: -45, unit: ''
      prop: (f, c) -> {transform: "rotate(#{f.value * c.offset}deg)"}
      value: (t, c) -> transform: anikit.util.rz t * c.offset * Math.PI / 180

    jump:
      steep: 0.4, count: 5, decay: 0.6, power: 1.1, offset: -14, unit: \px
      prop: (f, c) -> {transform: "translate(0,#{f.value * c.offset}#{c.unit})"}
      value: (t, c) -> transform: anikit.util.ty t * c.offset

  edit: 
    steep: default: 0.4, type: \number, min: 0.3, max: 1
    count: default: 5, type: \number, min: 0, max: 10
    decay: default: 0.6, type: \number, min: 0, max: 1, step: 0.1
    power: default: 1.1, type: \number, min:0, max: 10, step: 0.1
    offset: default: -14, type: \number, unit: \px, min: -100, max: 100
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  timing: (t, opt) ->
    p1 = [opt.steep, 0, 1, 1 - opt.steep] # speed up
    p2 = [0, opt.steep, 1 - opt.steep, 1] # speed down
    R = (opt.decay - 1) / (opt.decay ** (opt.count + 1) - 1)

    for i from 0 to opt.count
      pp = R * (( opt.decay ** i ) - 1) / (opt.decay - 1)
      pf = R * (( opt.decay ** (i + 1)) - 1) / (opt.decay - 1)
      ph = (pf + pp) * 0.5
      d = ((opt.decay ** opt.power) ** i)
      if t < ph =>
        t = (t - pp) / (ph - pp)
        t = cubic.Bezier.y(cubic.Bezier.t(t, p2), p2)
      else if t < pf =>
        t = (t - ph) / (pf - ph)
        t = cubic.Bezier.y(cubic.Bezier.t(t, p1), p1)
        t = 1 - t
      else continue
      return t * d
    return 0

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
  bounce(name, dur, iterations, accelerate, decay, power, offset, func)
    R = 100 * (decay - 1) / (decay ** (iterations + 1) - 1)
    .{name}
      animation: unquote(name) dur linear infinite
    @keyframes {name}
      0%
        func(0,0)
        timing-speed-down(accelerate)
      for num in (0..iterations)
        p = (decay ** ( num + 1 ) - 1) / (decay - 1)
        p2 = p - (decay ** num) * 0.5
        d = offset * ((decay ** power) ** num)
        {R * 1% * p2 }
          func(d,num * 2 + 1)
          timing-speed-up(accelerate)
        {R * 1% * p}
          func(0,num * 2 + 2)
          timing-speed-down(accelerate)
  */

module.exports = ret
