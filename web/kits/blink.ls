ret = do
  name: \blink
  preset:
    blink: 
      showtime: 0.5, transtime: 0.01
  edit: 
    dur: default: 1
    steep: default: 0.0, type: \number, min: 0.3, max: 1
    showtime: default: 0.5, type: \number, min: 0, max: 1, step: 0.01
    transtime: default: 0.01, type: \number, min: 0.01, max: 1, step: 0.01

  css: (opt) ->
    delta = opt.transtime * opt.showtime * 0.5
    """
      @keyframes #{opt.name} {
        0% { opacity: 1; }
        #{100 * (opt.showtime - delta)}% { opacity: 1; }
        #{100 * (opt.showtime + delta)}% { opacity: 0; }
        #{100 * (1 - 2 * delta)}% { opacity: 0; }
        100% { opacity: 1; }
      }
    """
  js: (t, opt) ->
    delta = opt.transtime * opt.showtime * 0.5
    if t < opt.showtime - delta => t = 1
    else if t < opt.showtime + delta => t = 1 - (t - (opt.showtime - delta)) / (2 * delta)
    else if t > 1 - 2 * delta => t = (t - (1 - 2 * delta)) / (2 * delta)
    else t = 0
    return { opacity: t }

  /* equivalent keyframes */
  /*
    @keyframes ld-blink
      0%
        opacity: 1
      {config.showtime * 1%}
        opacity: 1
      {(config.transitiontime + config.showtime) * 1%}
        opacity: 0
      {(100 - config.transitiontime) * 1%}
        opacity: 0
      100%
        opacity: 1
    .ld-blink
      animation: ld-blink config.dur linear infinite
  */

module.exports = ret
