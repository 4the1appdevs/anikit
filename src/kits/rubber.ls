(->
  if require? => require! <[easing-fit cubic ../anikit ../easing]>
  ret = do
    name: \rubber
    type: \animation
    preset: 
      jingle:
        count: 7, ratio: 0.6, delay: 0.1, unit: ''
        offset: default: 10, min: -180, max: 180, step: 1, name: "Rotate Amount"
        origin: [0.5, 0, 0.5]
        prop: (f, c) -> {transform: "rotate(#{f.value * c.offset}deg)"}
        value: (t, c) -> {transform: anikit.util.rz(t * c.offset * Math.PI / 180)}
      "rubber-v":
        count: 7, ratio: 0.7, delay: 0.3, unit: ''
        offset: default: 0.2, min: 0.01, max: 1, step: 0.01, name: "Scale Amount"
        prop: (f, c) -> {transform: "scaleY(#{1 + f.value * c.offset})"}
        value: (t, c) -> {transform: anikit.util.sy(1 + t * c.offset)}
      "rubber-h":
        count: 7, ratio: 0.7, delay: 0.3, unit: ''
        offset: default: 0.2, min: 0.01, max: 1, step: 0.01, name: "Scale Amount"
        prop: (f, c) -> {transform: "scaleX(#{1 + f.value * c.offset})"}
        value: (t, c) -> {transform: anikit.util.sx(1 + t * c.offset)}
      "shake-v":
        count: 5, ratio: 0.6, delay: 0.3, unit: \px
        offset: default: 10, min: 0, max: 500, step: 1, name: "Move Amount"
        prop: (f, c) -> {transform: "translate(0,#{f.value * c.offset}#{c.unit})"}
        value: (t, c) -> {transform: anikit.util.ty(t * c.offset)}
      "shake-h":
        count: 5, ratio: 0.7, delay: 0.3, unit: \px
        offset: default: 10, min: 0, max: 500, step: 1, name: "Move Amount"
        prop: (f, c) -> {transform: "translate(#{f.value * c.offset}#{c.unit},0)"}
        value: (t, c) -> {transform: anikit.util.tx(t * c.offset)}
      tick:
        count: 7, ratio: 0.7, delay: 0.3, unit: ""
        offset: default: 20, min: -180, max: 180, step: 1, name: "Rotate Amount"
        prop: (f, c) -> {transform: "rotate(#{f.value * c.offset}deg)"}
        value: (t, c) -> {transform: anikit.util.rz(t * c.offset * Math.PI / 180)}
      smash:
        count: 4, ratio: 0, delay: 0.5, unit: ""
        offset: default: 30, min: -180, max: 180, step: 1, name: "Rotate Amount"
        local: sample-count: 20, error-threshold: 0.001
        prop: (f, c) -> {transform: "rotate(#{f.value * c.offset}deg)"}
        value: (t, c) -> {transform: anikit.util.rz(t * c.offset * Math.PI / 180)}
      "jelly-alt":
        count: 7, ratio: 0.7, delay: 0.3, unit: ""
        offset: default: 10, min: -180, max: 180, step: 1, name: "Rotate Amount"
        prop: (f, c) -> {transform : "skewX(#{f.value * c.offset}deg)"}
        value: (t, c) -> {transform: anikit.util.kx(t * c.offset * Math.PI / 180)}
      jelly:
        count: 5, ratio: 0.6, delay: 0.3, unit: \px
        offset: default: 10, min: -180, max: 180, step: 1, name: "Rotate Amount"
        prop: (f, c) -> {transform: 
          "translate(#{f.value * -c.offset}#{c.unit},0) skewX(#{f.value * c.offset}deg)"
        }
        value: (t, c) -> {transform: [1, -Math.tan(t * c.offset * Math.PI / 180), 0, t * -c.offset, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 ]}
      damage:
        count: 10, ratio: 0.8, delay: 0.2, unit: ""
        offset: default: 1, min: 0, max: 1, step: 0.01, name: "Amount"
        prop: (f, c) -> {opacity: 1 - f.value * c.offset}
        value: (t, c) -> {opacity: 1 - t * c.offset}
    edit: 
      count: name: "Bounce Count", default: 10, type: \number, min: 0, max: 50
      offset: default: 1, type: \number, min: 0, max: 100, step: 0.01, unit: \px
      ratio: name: "Decay", default: 0.8, type: \number, min: 0, max: 1, step: 0.01
      delay: name: "Prepare Time", default: 0.2, type: \number, min: 0, max: 1, step: 0.01
      unit: default: \px, type: \choice, values: ["px", "%", ""]
    timing: (t, opt) ->
      if t < opt.delay => return t / opt.delay
      len = ( 1 - opt.delay ) / opt.count
      idx = Math.floor((t - opt.delay) / len )
      t = (t - (idx * len + opt.delay)) / len
      t = easing.js.ease-out-quad t
      v1 = (opt.ratio ** (idx)) * ((-1) ** (idx))
      v2 = (opt.ratio ** (idx + 1)) * ((-1) ** (idx + 1))
      return (v2 - v1) * t + v1
    css: (opt) -> 
      easing-fit.fit-to-keyframes (~> @timing it, opt), ({} <<< opt.local or {}) <<< {config: opt} <<< opt{name, prop}
    js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
    affine: (t, opt) -> opt.value @timing(t, opt), opt

  if module? => module.exports = ret
  return ret
)!
