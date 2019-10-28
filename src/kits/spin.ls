(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \spin
    type: \animation
    preset:
      "coin-h":
        name: "coin (horizontally)"
        cycle: 10, dur: 2
        prop: (f, c) -> {transform: "rotateY(#{f.value * c.cycle * 360}deg)"}
        value: (t, c) -> {transform: anikit.util.ry(t * c.cycle * Math.PI * 2)}
      "coin-v":
        name: "coin (vertically)"
        cycle: 10, dur: 2
        prop: (f, c) -> {transform: "rotateX(#{f.value * c.cycle * 360}deg)"}
        value: (t, c) -> {transform: anikit.util.rx(t * c.cycle * Math.PI * 2)}
      "cycle":
        steep: 0.0, cycle: 1
        prop: (f, c) -> {transform: "rotate(#{f.value * c.cycle * 360}deg)"}
        value: (t, c) -> {transform: anikit.util.rz(t * c.cycle * Math.PI * 2)}
      "cycle-alt":
        steep: 0.0, cycle: -1
        prop: (f, c) -> {transform: "rotate(#{f.value * c.cycle * 360}deg)"}
        value: (t, c) -> {transform: anikit.util.rz(t * c.cycle * Math.PI * 2)}
      "flip-h":
        name: "flip (horizontally)"
        cycle: 1, flip: true
        prop: (f, c) -> {transform: "rotateY(#{f.value * c.cycle * 360}deg)"}
        value: (t, c) -> {transform: anikit.util.ry(t * c.cycle * Math.PI * 2)}
      "flip-v":
        name: "flip (vertically)"
        cycle: 1, flip: true
        prop: (f, c) -> {transform: "rotateX(#{f.value * c.cycle * 360}deg)"}
        value: (t, c) -> {transform: anikit.util.rx(t * c.cycle * Math.PI * 2)}
      "spin-fast":
        cycle: 5
        prop: (f, c) -> {transform: "rotate(#{f.value * c.cycle * 360}deg)"}
        value: (t, c) -> {transform: anikit.util.rz(t * c.cycle * Math.PI * 2)}
      spin:
        cycle: 1
        prop: (f, c) -> {transform: "rotate(#{f.value * c.cycle * 360}deg)"}
        value: (t, c) -> {transform: anikit.util.rz(t * c.cycle * Math.PI * 2)}
    edit: 
      steep: default: 0.4, type: \number, min: 0, max: 1, step: 0.01
      cycle: default: 1, type: \number, min: -20, max: 20, step: 1
      flip: default: false, type: \boolean, hidden: true
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
      local = error-threshold: 0.001, sample-count: 20
      easing-fit.fit-to-keyframes (~> @timing it, opt), (local <<< opt.local or {}) <<< {config: opt} <<< opt{name, prop}
    js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
    affine: (t, opt) -> opt.value @timing(t, opt), opt

  if module? => module.exports = ret
  return ret
)!
