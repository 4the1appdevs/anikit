require! <[easing-fit cubic ../anikit ../easing]>
ret = do
  name: \rubber
  type: \animation
  preset: 
    jingle:
      count: 7, offset: 10, ratio: 0.6, delay: 0.1, unit: ''
      prop: (f, c) -> {transform: "rotate(#{f.value * c.offset}deg)", "transform-origin": "50% 0%"}
      value: (t, c) -> {transform: anikit.util.rz(t * c.offset * Math.PI / 180), transform-origin: [0.5, 0.0, 0.5]}
    "rubber-v":
      count: 7, offset: 0.2, ratio: 0.7, delay: 0.3, unit: ''
      prop: (f, c) -> {transform: "scaleY(#{1 + f.value * c.offset})"}
      value: (t, c) -> {transform: anikit.util.sy(1 + t * c.offset)}
    rubber:
      count: 7, offset: 0.2, ratio: 0.7, delay: 0.3, unit: ''
      prop: (f, c) -> {transform: "scaleX(#{1 + f.value * c.offset})"}
      value: (t, c) -> {transform: anikit.util.sx(1 + t * c.offset)}
    "shake-v":
      count: 5, offset: 10, ratio: 0.6, delay: 0.3, unit: \px
      prop: (f, c) -> {transform: "translate(0,#{f.value * c.offset}#{c.unit})"}
      value: (t, c) -> {transform: anikit.util.ty(t * c.offset)}
    shake:
      count: 5, offset: 10, ratio: 0.7, delay: 0.3, unit: \px
      prop: (f, c) -> {transform: "translate(#{f.value * c.offset}#{c.unit},0)"}
      value: (t, c) -> {transform: anikit.util.tx(t * c.offset)}
    tick:
      count: 7, offset: 20, ratio: 0.7, delay: 0.3, unit: ""
      prop: (f, c) -> {transform: "rotate(#{f.value * c.offset}deg)"}
      value: (t, c) -> {transform: anikit.util.rz(t * c.offset * Math.PI / 180)}
    smash:
      count: 4, offset: 30, ratio: 0, delay: 0.5, unit: ""
      local: sample-count: 20, error-threshold: 0.001
      prop: (f, c) -> {transform: "rotate(#{f.value * c.offset}deg)"}
      value: (t, c) -> {transform: anikit.util.rz(t * c.offset * Math.PI / 180)}
    "jelly-alt":
      count: 7, offset: 10, ratio: 0.7, delay: 0.3, unit: ""
      prop: (f, c) -> {transform : "skewX(#{f.value * c.offset}deg)"}
      value: (t, c) -> {transform: anikit.util.kx(t * c.offset * Math.PI / 180)}
    jelly:
      count: 5, offset: 10, ratio: 0.6, delay: 0.3, unit: \px
      prop: (f, c) -> {transform: 
        "translate(#{f.value * -c.offset}#{c.unit},0) skewX(#{f.value * c.offset}deg)"
      }
      value: (t, c) -> {transform: [1, -Math.tan(t * c.offset * Math.PI / 180), 0, t * -c.offset, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 ]}
    damage:
      count: 10, offset: 1, ratio: 0.8, delay: 0.2, unit: ""
      prop: (f, c) -> {opacity: 1 - f.value * c.offset}
      value: (t, c) -> {opacity: 1 - t * c.offset}
  edit: 
    count: default: 10, type: \number, min: 0, max: 50
    offset: default: 1, type: \number, min: 0, max: 100, step: 0.01, unit: \px
    ratio: default: 0.8, type: \number, min: 0, max: 1, step: 0.01
    delay: default: 0.2, type: \number, min: 0, max: 1, step: 0.01
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

  /* equivalent keyframes */
  /*
  @keyframes {name}
    0%
      func(0)
    {delay * 1%}
      func(offset)
    for num in (1..(iterations - 1))
      value = (offset) * (ratio ** (num - 1)) * (-1 ** (num))
      {(delay + num * (100 - delay) / iterations) * 1%}
        func(value)
    100%
      func(0)
  */

module.exports = ret
