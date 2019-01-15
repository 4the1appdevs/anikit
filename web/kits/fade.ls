ret = do
  name: \fade
  preset:
    fade: 
      prop: (f, c) -> { opacity: 1 - f.value }
      value: (t, c) -> { opacity: 1 - t }
  edit: 
    dur: default: 1
    steep: default: 0, type: \number, min: 0, max: 0.5, step: 0.01

  timing: (t, opt) ->
    p1 = [opt.steep, 0.5 - opt.steep, 0.5 + opt.steep, 1.0 - opt.steep]
    t = cubic.Bezier.y(cubic.Bezier.t(t, p1), p1)

  css: (opt) -> 
    easing-fit.fit-to-keyframes (~> @timing it, opt), (opt.local or {}) <<< {config: opt} <<< opt{name, prop}
  js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
  affine: (t, opt) -> return opt.value @timing(t, opt), opt

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
