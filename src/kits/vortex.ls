(->
  if require? => require! <[easing-fit cubic ../anikit]>
  value = (t, c) ->
    if t < 0.6 =>
      r = (t * c.rotate / 0.6) * Math.PI * 2
      s = (1 - c.zoom) * (t/0.6) + c.zoom
      o = t / 0.6
    else
      r = c.rotate * Math.PI * 2
      s = 1
      o = 1 - (t - 0.6)  / (1 - 0.6)
    ret = { transform: [
      s * Math.cos(r), s * Math.sin(r), 0, 0, -s * Math.sin(r), s * Math.cos(r), 0, 0, 0, 0, s, 0, 0, 0, 0, 1
    ]}
    if c.fade or t < 0.6 => ret.opacity = o
    return ret


  ret = do
    name: \vortex
    type: \animation
    preset:

      "vortex-out":
        zoom: 0.3
        local: sample-count: 20, error-threshold: 0.01, seg-sample-count: 1000
        prop: (f, c) -> 
          v = value f.value, c
          m = anikit.util.m4to3 v.transform
          return v <<< transform: "matrix(#{m.join(',')})"
        value: (t, c) -> value t, c
      "vortex-in":
        zoom: 3
        local: sample-count: 20, error-threshold: 0.01, seg-sample-count: 1000
        prop: (f, c) -> 
          v = value f.value, c
          m = anikit.util.m4to3 v.transform
          return v <<< transform: "matrix(#{m.join(',')})"
        value: (t, c) -> value t, c

      "vortex-alt-out":
        zoom: 0.1, fade: false, repeat: 1
        local: sample-count: 20, error-threshold: 0.01, seg-sample-count: 1000
        prop: (f, c) -> 
          v = value f.value, c
          m = anikit.util.m4to3 v.transform
          return v <<< transform: "matrix(#{m.join(',')})"
        value: (t, c) -> value t, c
      "vortex-alt-in":
        zoom: 3, fade: false, repeat: 1
        local: sample-count: 20, error-threshold: 0.01, seg-sample-count: 1000
        prop: (f, c) -> 
          v = value f.value, c
          m = anikit.util.m4to3 v.transform
          return v <<< transform: "matrix(#{m.join(',')})"
        value: (t, c) -> value t, c

    edit: 
      dur: default: 2
      steep: default: 0.3, type: \number, min: 0, max: 0.3, step: 0.01
      rotate: name: "Rotate Times", default: 5, type: \number, min: 1, max: 20
      zoom: name: "Scale", default: 3, type: \number, min: 0, max: 10, step: 0.1
      fade: default: true, type: \boolean, hidden: true

    timing: (t, opt) ->
      p1 = [opt.steep, 0, 1, 1 - opt.steep]
      if t == 0 => return 0
      if t < 0.6 => t = cubic.Bezier.y(cubic.Bezier.t(t/0.6, p1), p1) * 0.6
      else t = cubic.Bezier.y(cubic.Bezier.t((t - 0.6)/(1 - 0.6), p1), p1) * 0.4 + 0.6
      return t

    css: (opt) -> 
      s = opt.steep
      opacity = (v,force) -> if opt.fade or force => "opacity: #v;" else "opacity: 1;"
      """
      @keyframes #{opt.name} {
        0%, 60% { animation-timing-function: cubic-bezier(#s, 0, 1, #{1 - s}); }
        0% { #{opacity 0, 1} transform: rotate(#{-360 * opt.rotate}deg) scale(#{opt.zoom}); }
        60% { #{opacity 1} transform: rotate(0deg) scale(1); }
        100% { #{opacity 0} transform: rotate(0deg) scale(1); }
      }
      """
    js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
    affine: (t, opt) -> opt.value @timing(t, opt), opt

    /* equivalent keyframes */
    /*
      """
      @keyframes #{opt.name} {
        0% {
          timing-speed-up(config.accelerate)
          transform: rotate(360deg * config.rotate) scale(config.zoom)
          opacity: 0
        60%
          timing-speed-up(config.accelerate)
          transform: rotate(0deg) scale(1)
          opacity: 1
        100%
          opacity: 0

      """
    */

  if module? => module.exports = ret
  return ret
)!
