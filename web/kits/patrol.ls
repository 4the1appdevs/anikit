ret = do
  name: \patrol
  preset: 
    breath:
      steep: 0.6, offset: 0.06
      propFunc: (f, opt) -> {transform: "scale(#{1 + f.value * opt.offset - 0.03})"}
    dim:
      steep: 0.6, offset: 0.5
      propFunc: (f, opt) -> {opacity: 0.5 + f.value * opt.offset}
    metronome:
      steep: 0.6, offset: 10, rotate: 30, unit: \px
      propFunc: (f, opt) -> {
        transform: "translate(#{f.value * opt.offset}#{opt.unit}) rotate(#{f.value * opt.rotate}deg)"
      }
    swing:
      steep: 0.6, offset: 30, unit: ''
      propFunc: (f, opt) -> {transform: "rotate(#{f.value * opt.offset}deg)"}
    "wander-v": 
      steep: 0.6, offset: 10, unit: \px
      propFunc: (f, opt) -> {transform: "translate(0,#{f.value * opt.offset}#{opt.unit})"}
    wander:
      steep: 0.6, offset: 10, unit: \px
      propFunc: (f, opt) -> {transform: "translate(#{f.value * opt.offset}#{opt.unit},0)"}

  edit: 
    steep: default: 0.6, type: \number, min: 0, max: 1
    offset: default: 10, type: \number, unit: \px, min: 0, max: 30
    unit: default: \px, type: \choice, values: ["px", "%", ""]
  timing: (t, opt) ->
    p = [opt.steep,0,1 - opt.steep,1]
    if t < 0.5 =>
      t = anikit.cubic.Bezier.y(anikit.cubic.Bezier.t(t * 2, p), p) / 2
    else
      t = (anikit.cubic.Bezier.y(anikit.cubic.Bezier.t((t - 0.5) * 2, p), p) / 2) + 0.5
    t = 1 - 4 * Math.abs(t - 0.5)
    return t

  css: (opt) -> anikit.step-to-keyframes (~> @timing it, opt), opt
  js: (t, opt) -> opt.propFunc {value: @timing t, opt}, opt

  /* equivalent keyframes */
  /*
  @keyframes {name}
    0%,50%,100%
      timing-step(rate)
    0%
      func(-1 * max)
    50%
      func(1 * max)
    100%
      func(-1 * max)
  */

module.exports = ret
