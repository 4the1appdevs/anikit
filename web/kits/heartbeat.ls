ret = do
  name: \heartbeat
  preset:
    heartbeat: 
      prop: (f, c) -> {transform: "scale(#{1 + f.value * c.scale})"}
      value: (t, c) -> transform: anikit.util.s 1 + t * c.scale
  edit: 
    dur: default: 1
    scale: default: 0.3, type: \number, min: 0, max: 100, step: 0.01
    peak2: default: 0.5, type: \number, min: 0, max: 1, step: 0.01
    decay: default: 2, type: \number, min: 0.1, max: 10, step: 0.01
    span: default: 0.3, type: \number, min: 0.1, max: 1, step: 0.01
    len: default: 0.5, type: \number, min: 0.1, max: 1, step: 0.01

  timing: (t, opt) ->
    # use exp
    # t = (1.5 * t / opt.len)
    # t = 1 + Math.exp(-1 * t * t) * Math.sin( 2 * Math.PI * ( t - 1) )
    # t = Math.pow(t, 0.1) - 1

    # use sigmoid
    # t = (1.5 * t / opt.len)
    # t = (1 / (1 + Math.exp(10 * (t - 1.2)))) * Math.sin(2 * Math.PI * (t))

    # procedural
    if t < opt.span =>
      t = (opt.span - t)/opt.span
      t = Math.pow(t, opt.decay)
    else
      t = (1 - t) / (1 - opt.span)
      t = Math.pow(t, opt.decay) * opt.peak2
    t

  css: (opt) -> 
    easing-fit.fit-to-keyframes (~> @timing it, opt), (opt.local or {}) <<< {config: opt} <<< opt{name, prop}
  js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
  affine: (t, opt) -> opt.value @timing(t, opt), opt

  /* similar keyframes */
  /*
    @keyframes ld-heartbeat
      0%
        transform: scale(1.05)
      5%
        transform: scale(config.max)
      39%
        transform: scale(config.min)
      45%
        transform: scale(1 + (config.max - 1) * 0.5)
      60%
        transform: scale(1.05)
      100%
        transform: scale(1.00)
  */

module.exports = ret
