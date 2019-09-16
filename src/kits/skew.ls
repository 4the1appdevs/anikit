(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \skew
    type: \animation
    preset: "skew": {}, "skew-alt": {dir: 90}
    edit: do
      # future proof - we can make dir angle of skew direction.
      dir: type: \number, default: 0, min: 0, max: 90, step: 1
      deg: type: \number, default: 20, min: 0, max: 60, step: 0.1
      scale: type: \number, default: 0.1, min: 0, max: 1, step: 0.01
      steep: default: 0.4, type: \number, min: 0, max: 1, step: 0.01
    css: (opt) ->
      ds = 1 - opt.scale
      s = opt.steep
      c = if opt.dir == 0 => \X else \Y
      """@keyframes #{opt.name} {
        0%, 50%, 100% { animation-timing-function: cubic-bezier(#s,0,1,#{1 - s}) }
        25%, 75% {      animation-timing-function: cubic-bezier(0,#s,#{1 - s},1) }
          0% { transform: skew#c(#{opt.deg}deg) scale(1) }
         25% { transform: skew#c(0deg) scale(#ds) }
         50% { transform: skew#c(-#{opt.deg}deg) scale(1) }
         75% { transform: skew#c(0deg) scale(#ds) }
        100% { transform: skew#c(#{opt.deg}deg) scale(1) }
      }
      """
    js: (t, opt) ->
      v = @affine t, opt
      m = anikit.util.m4to3 v.transform
      return transform: "matrix(#{m.join(',')})"

    affine: (t, opt) ->
      ds = 1 - opt.scale
      s = opt.steep
      p1 = [s, 0, 1, 1 - s]
      p2 = [0, s, 1 - s, 1]
      phase = Math.floor(t * 4)
      dt = t * 4 - phase
      p = if phase % 2 => p2 else p1
      t = cubic.Bezier.y(cubic.Bezier.t(dt, p), p)
      s = if phase % 2 => (1 - ds) * t + ds else ( ds - 1 ) * t + 1
      a = (if phase % 2=> opt.deg * t else opt.deg * (1 - t)) * Math.PI / 180
      if phase >= 1 && phase < 3 => a = -a
      sx = sy = Math.tan(a)
      if opt.dir == 0 => sy = 0 else sx = 0
      return transform: [
        s, sy, 0, 0, 
        sx, s, 0, 0, 
        0, 0, s, 0, 
        0, 0, 0, 1
      ]

  if module? => module.exports = ret
  return ret
)!
