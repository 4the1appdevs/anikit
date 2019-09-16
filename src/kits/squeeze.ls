(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \squeeze
    type: \animation
    preset:
      squeeze:
        local: sample-count: 20, error-threshold: 0.001
        prop: (f, c) ->
          sx = 1 - 2 * (Math.abs(0.5 - f.value)) * c.zoomx
          sy = 1 - 2 * (0.5 - Math.abs(0.5 - f.value)) * c.zoomy
          { transform: "scale(#{sx},#{sy})" }
        value: (t, c) ->
          sx = 1 - 2 * (Math.abs(0.5 - t)) * c.zoomx
          sy = 1 - 2 * (0.5 - Math.abs(0.5 - t)) * c.zoomy
          return transform: [ sx, 0, 0, 0, 0, sy, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 ]
    edit: 
      steep: default: 0.5, type: \number, min: 0, max: 1, step: 0.01
      zoomx: name: "X Scale", default: 0.5, type: \number, min: 0, max: 1, step: 0.01
      zoomy: name: "Y Scale", default: 0.5, type: \number, min: 0, max: 1, step: 0.01

    timing: (t, opt) ->
      p1 = [0, opt.steep, 1 - opt.steep, 1]
      d = (t - Math.floor(t * 2) * 0.5) * 2
      d = cubic.Bezier.y(cubic.Bezier.t(d, p1), p1) * 0.5
      d = d + Math.floor(t * 2) * 0.5
      return d

    css: (opt) -> 
      easing-fit.fit-to-keyframes (~> @timing it, opt), ({} <<< opt.local or {}) <<< {config: opt} <<< opt{name, prop}
    js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
    affine: (t, opt) -> opt.value @timing(t, opt), opt

    /* equivalent keyframes */
    /*
     @keyframes ld-squeeze
        0%
          transform: scale(1,config.zoom_y)
        50%
          transform: scale(config.zoom_x,1)
        100%
          transform: scale(1,config.zoom_y)
      .ld-squeeze
        animation: ld-squeeze config.dur infinite
        timing-speed-down(config.accelerate)
    */

  if module? => module.exports = ret
  return ret
)!
