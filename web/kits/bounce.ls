
ret = do
  name: \bounce
  preset:
    beat:
      steep: 0.4, count: 1, decay: 0.5, power: 1.1, offset: 0.2, unit: ''
      propFunc: (f, opt) -> {transform: "scale(#{1 - opt.offset * f.value})"}

    bounce-alt:
      steep: 0.5, count: 0, decay: 0.5, power: 0, offset: -14, unit: 'px'
      propFunc: (f, opt) -> {transform: "translate(0, #{opt.offset * f.value}#{opt.unit})"}
    pulse:
      dur: 0.5
      steep: 0.6, count: 0, decay: 0.5, power: 1.1, offset: 0.2, unit: ''
      error-threshold: 0.001, seg-sample-count: 20, sample-count: 1000
      propFunc: (f, opt) -> {transform: "scale(#{1 - opt.offset * f.value})"}
    "tick-alt":
      steep: 0.4, count: 5, decay: 0.6, power: 1.1, offset: -45, unit: ''
      propFunc: (f, opt) -> {transform: "rotate(#{f.value * opt.offset}deg)"}
    jump:
      steep: 0.4, count: 5, decay: 0.6, power: 1.1, offset: -14, unit: \px
      propFunc: (f, opt) -> {transform: "translate(0,#{f.value * opt.offset}#{opt.unit})"}

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
        t = anikit.cubic.Bezier.y(anikit.cubic.Bezier.t(t, p2), p2)
      else if t < pf =>
        t = (t - ph) / (pf - ph)
        t = anikit.cubic.Bezier.y(anikit.cubic.Bezier.t(t, p1), p1)
        t = 1 - t
      else continue
      return t * d
    return 0

  css: (opt) -> anikit.step-to-keyframes (~> @timing it, opt), opt
  js: (t, opt) -> opt.propFunc {value: @timing t, opt}, opt

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
