ret = do
  name: \vortex
  preset:

    "vortex-out":
      steep: 0.3, rotate: 5, zoom: 0.3
      sample-count: 20, error-threshold: 0.01, seg-sample-count: 1000
      propFunc: (f, opt) -> 
        if f.value < 0.6 =>
          r = f.value * opt.rotate * 360/0.6 
          s = (1 - opt.zoom) * (f.value/0.6) + opt.zoom
        else
          r = opt.rotate * 360
          s = 1
        do
          transform: "rotate(#{r}deg) scale(#s)"
          opacity: if f.value < 0.6 => (f.value / 0.6) else 1 - ((f.value - 0.6) / (1 - 0.6))

    "vortex-in":
      steep: 0.3, rotate: 5, zoom: 3
      sample-count: 20, error-threshold: 0.01, seg-sample-count: 1000
      propFunc: (f, opt) -> 
        if f.value < 0.6 =>
          r = f.value * opt.rotate * 360/0.6 
          s = (1 - opt.zoom) * (f.value/0.6) + opt.zoom
        else
          r = opt.rotate * 360
          s = 1
        do
          transform: "rotate(#{r}deg) scale(#s)"
          opacity: if f.value < 0.6 => (f.value / 0.6) else 1 - ((f.value - 0.6) / (1 - 0.6))

  edit: 
    dur: default: 2
    steep: default: 0.3, type: \number, min: 0, max: 0.3
    rotate: default: 5, type: \number, min: 0, max: 20
    zoom: default: 3, type: \number, min: 0, max: 10

  timing: (t, opt) ->
    p1 = [opt.steep, 0, 1, 1 - opt.steep]
    if t == 0 => return 0
    if t < 0.6 => t = anikit.cubic.Bezier.y(anikit.cubic.Bezier.t(t/0.6, p1), p1) * 0.6
    else t = anikit.cubic.Bezier.y(anikit.cubic.Bezier.t((t - 0.6)/(1 - 0.6), p1), p1) * 0.4 + 0.6
    return t

  css: (opt) -> anikit.step-to-keyframes (~> @timing it, opt), opt
  js: (t, opt) -> opt.propFunc {value: @timing t, opt}, opt

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

module.exports = ret
