ret = do
  name: \spin
  preset:
    "coin-h":
      steep: 0.4, cycle: 3600, dur: 2
      local: error-threshold: 0.001, sample-count: 20
      prop: (f, c) -> {transform: "rotateY(#{f.value * c.cycle}deg)"}
      value: (t, c) -> {transform: anikit.util.ry(t * c.cycle * Math.PI / 180)}
    "coin-v":
      steep: 0.4, cycle: 3600, dur: 2
      local: error-threshold: 0.001, sample-count: 20
      prop: (f, c) -> {transform: "rotateX(#{f.value * c.cycle}deg)"}
      value: (t, c) -> {transform: anikit.util.rx(t * c.cycle * Math.PI / 180)}
    "cycle":
      steep: 0.0, cycle: 360
      local: error-threshold: 0.001, sample-count: 20
      prop: (f, c) -> {transform: "rotate(#{f.value * c.cycle}deg)"}
      value: (t, c) -> {transform: anikit.util.rz(t * c.cycle * Math.PI / 180)}
    "flip-h":
      steep: 0.4, cycle: 360, flip: true
      local: error-threshold: 0.001, sample-count: 20
      prop: (f, c) -> {transform: "rotateY(#{f.value * c.cycle}deg)"}
      value: (t, c) -> {transform: anikit.util.ry(t * c.cycle * Math.PI / 180)}
    "flip-v":
      steep: 0.4, cycle: 360, flip: true
      local: error-threshold: 0.001, sample-count: 20
      prop: (f, c) -> {transform: "rotateX(#{f.value * c.cycle}deg)"}
      value: (t, c) -> {transform: anikit.util.rx(t * c.cycle * Math.PI / 180)}
    "spin-fast":
      steep: 0.4, cycle: 1800
      local: error-threshold: 0.001, sample-count: 20
      prop: (f, c) -> {transform: "rotate(#{f.value * c.cycle}deg)"}
      value: (t, c) -> {transform: anikit.util.rz(t * c.cycle * Math.PI / 180)}
    spin:
      steep: 0.4, cycle: 360
      local: error-threshold: 0.001, sample-count: 20
      prop: (f, c) -> {transform: "rotate(#{f.value * c.cycle}deg)"}
      value: (t, c) -> {transform: anikit.util.rz(t * c.cycle * Math.PI / 180)}
  edit: 
    steep: default: 0.4, type: \number, min: 0, max: 1
    cycle: default: 360, type: \number, unit: \deg, min: 0, max: 3600, step: 360
    flip: default: false, type: \boolean
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  timing: (t, opt) ->
    p1 = [opt.steep, 0, 1, 1 - opt.steep] # speed up
    p2 = [0, opt.steep, 1 - opt.steep, 1] # speed down
    if opt.flip => p1 = p2
    if t == 0 or t == 1 => return t
    if t < 0.5 =>
      t = cubic.Bezier.y(cubic.Bezier.t(t * 2, p1), p1)
      t = t * 0.5
    else
      t = cubic.Bezier.y(cubic.Bezier.t((t - 0.5) * 2, p2), p2)
      t = t * 0.5 + 0.5
    return t

  css: (opt) ->
    easing-fit.fit-to-keyframes (~> @timing it, opt), (opt.local or {}) <<< {config: opt} <<< opt{name, prop}
  js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
  affine: (t, opt) -> opt.value @timing(t, opt), opt

  /* equivalent keyframes */
  /*
    spin(name, dur, rate, offset, func)
      .{name}
	animation: unquote(name) dur linear infinite
      @keyframes {name}
	0%
	  timing-speed-up(rate)
	  func(0)
	50%
	  timing-speed-down(rate)
	  func(offset * 0.5)
	100%
	  func(offset)
  */

module.exports = ret
