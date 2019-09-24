(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \blink
    type: \animation
    preset: blink: {}
    edit: 
      dur: default: 1
      showtime: default: 0.5, type: \number, min: 0.01, max: 0.99, step: 0.01
      transtime: default: 0.01, type: \number, min: 0.01, max: 1, step: 0.01

    css: (opt) ->
      delta = opt.transtime * opt.showtime * 0.5
      """
        @keyframes #{opt.name} {
          0% { opacity: 1; }
          #{anikit.util.round(100 * (opt.showtime - delta))}% { opacity: 1; }
          #{anikit.util.round(100 * (opt.showtime + delta))}% { opacity: 0; }
          #{anikit.util.round(100 * (1 - 2 * delta))}% { opacity: 0; }
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
    affine: (t, opt) -> @js t, opt

  if module? => module.exports = ret
  return ret
)!
