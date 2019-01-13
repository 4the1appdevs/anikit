ret = do
  name: \fade
  preset:
    fade: 
      prop-func: (f, opt) -> {opacity: 1 - f.value}
  edit: 
    dur: default: 1
    steep: default: 0, type: \number, min: 0, max: 0.5

  timing: (t, opt) ->
    p1 = [opt.steep, 0.5 - opt.steep, 0.5 + opt.steep, 1.0 - opt.steep]
    t = anikit.cubic.Bezier.y(anikit.cubic.Bezier.t(t, p1), p1)

  css: (opt) -> anikit.step-to-keyframes (~> @timing it, opt), opt
  js: (t, opt) -> opt.propFunc {value: @timing t, opt}, opt

  /* equivalent keyframes */
  /*
    @keyframes ld-fade
      0%
        opacity: 1
      100%
        opacity: 0
    .ld-fade
      animation: ld-fade config.dur linear infinite
  */

module.exports = ret
