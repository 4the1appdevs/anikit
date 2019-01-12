
ret = do
  name: \patrol
  preset: 
    jingle:
      count: 7, offset: 10, ratio: 0.6, delay: 0.1, unit: ''
      propFunc: (f, opt) -> {transform: "rotate(#{f.value * opt.offset}deg)", "transform-origin": "50% 0%"}
    "rubber-v":
      count: 7, offset: 0.2, ratio: 0.7, delay: 0.3, unit: ''
      propFunc: (f, opt) -> {transform: "scaleY(#{1 + f.value * opt.offset})"}
    rubber:
      count: 7, offset: 0.2, ratio: 0.7, delay: 0.3, unit: ''
      propFunc: (f, opt) -> {transform: "scaleX(#{1 + f.value * opt.offset})"}
    "shake-v":
      count: 5, offset: 10, ratio: 0.6, delay: 0.3, unit: \px
      propFunc: (f, opt) -> {transform: "translate(0,#{f.value * opt.offset}#{opt.unit})"}
    shake:
      count: 5, offset: 10, ratio: 0.7, delay: 0.3, unit: \px
      propFunc: (f, opt) -> {transform: "translate(#{f.value * opt.offset}#{opt.unit},0)"}
    tick:
      count: 7, offset: 20, ratio: 0.7, delay: 0.3, unit: ""
      propFunc: (f, opt) -> {transform: "rotate(#{f.value * opt.offset}deg)"}
    smash:
      count: 4, offset: 30, ratio: 0, delay: 0.5, unit: ""
      sample-count: 20, error-threshold: 0.001
      propFunc: (f, opt) -> {transform: "rotate(#{f.value * opt.offset}deg)"}
    "jelly-alt":
      count: 7, offset: 10, ratio: 0.7, delay: 0.3, unit: ""
      propFunc: (f, opt) -> {transform : "skewX(#{f.value * opt.offset}deg)"}
    jelly:
      count: 5, offset: 10, ratio: 0.6, delay: 0.3, unit: \px
      propFunc: (f, opt) -> {transform: 
        "translate(#{f.value * -opt.offset}#{opt.unit},0) skewX(#{f.value * opt.offset}deg)"
      }
    damage:
      count: 10, offset: 1, ratio: 0.8, delay: 0.2, unit: ""
      propFunc: (f, opt) -> {opacity: 1 - f.value * opt.offset}
  edit: 
    count: default: 10, type: \number, min: 0, max: 50
    offset: default: 1, type: \number, min: 0, max: 1, step: 0.1
    ratio: default: 0.8, type: \number, min: 0, max: 1, step: 0.1
    delay: default: 0.2, type: \number, min: 0, max: 1, step: 0.01
    unit: default: \px, type: \choice, values: ["px", "%", ""]
  timing: (t, opt) ->
    if t < opt.delay => return t / opt.delay
    len = ( 1 - opt.delay ) / opt.count
    idx = Math.floor((t - opt.delay) / len )
    t = (t - (idx * len + opt.delay)) / len
    t = anikit.timing.js.ease-out-quad t
    v1 = (opt.ratio ** (idx)) * ((-1) ** (idx))
    v2 = (opt.ratio ** (idx + 1)) * ((-1) ** (idx + 1))
    return (v2 - v1) * t + v1
  css: (opt) -> anikit.step-to-keyframes (~> @timing it, opt), opt
  js: (t, opt) -> opt.propFunc {value: @timing t, opt}, opt

module.exports = ret
