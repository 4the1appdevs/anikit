(->
  if require? => require! <[easing-fit cubic ../anikit]>

  ret = do
    name: \bounce-rigid
    type: \animation
    preset:
      beat:
        count: 1, decay: 0.5, unit: ''
        offset: name: "Scale Amount", default: 0.2, min: -1, max: 1, step: 0.01, unit: ''
        prop: (f, c) -> {transform: "scale(#{1 + c.offset * f.value})"}
        value: (t, c) -> transform: anikit.util.s 1 + t * c.offset

      bounce-alt:
        count: 0, decay: 0.5, power: 0, unit: 'px'
        offset: name: "Jump Height", default: -14, min: -300, max: 300, unit: \px, step: 1
        prop: (f, c) -> {transform: "translate(0, #{c.offset * f.value}#{c.unit})"}
        value: (t, c) -> transform: anikit.util.ty c.offset * t

      pulse:
        dur: 0.5
        count: 0, decay: 0.5, unit: ''
        offset: name: "Scale Amount", default: 0.2, min: -1, max: 1, step: 0.01, unit: ''
        local: error-threshold: 0.001, seg-sample-count: 20, sample-count: 1000
        prop: (f, c) -> {transform: "scale(#{1 - c.offset * f.value})"}
        value: (t, c) -> transform: anikit.util.s 1 - c.offset * t

      "tick-alt":
        count: 5, unit: ''
        offset: name: "Rotate Amount", default: -45, min: -180, max: 180, step: 1, unit: 'deg'
        prop: (f, c) -> {transform: "rotate(#{f.value * c.offset}deg)"}
        value: (t, c) -> transform: anikit.util.rz t * c.offset * Math.PI / 180

      jump:
        count: 5, unit: \px
        offset: name: "Jump Height", default: -14, min: -300, max: 300, unit: \px, step: 1
        prop: (f, c) -> {transform: "translate(0,#{f.value * c.offset}#{c.unit})"}
        value: (t, c) -> transform: anikit.util.ty t * c.offset

    edit: 
      steep: default: 0.4, type: \number, min: 0.3, max: 1, step: 0.01
      count: name: "Bounce Count", default: 5, type: \number, min: 0, max: 10
      decay: name: "Bounce Decay", default: 0.6, type: \number, min: 0, max: 1, step: 0.01
      power: name: "Decay Speed", default: 1.1, type: \number, min:0, max: 10, step: 0.01
      offset: name: "Offset", default: -14, type: \number, unit: \px, min: -300, max: 300
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
      easing-fit.fit-to-keyframes (~> @timing it, opt), ({} <<< opt.local or {}) <<< {config: opt} <<< opt{name, prop}
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

  if module? => module.exports = ret
  return ret
)!
