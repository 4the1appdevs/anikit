(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \flip
    type: \animation
    preset: "flip": {}
    edit: do
      steep: default: 0.4, type: \number, min: 0, max: 1, step: 0.01
    css: (opt) ->
      ds = 1 - opt.scale
      s = opt.steep
      c = if opt.dir == 0 => \X else \Y
      """@keyframes #{opt.name} {
        0%, 25%, 50%, 75%, 100% { animation-timing-function: cubic-bezier(0, #s,#{1 - s}, 1) }
          0% { transform: scale(1,1) }
         25% { transform: scale(-1,1) }
         50% { transform: scale(-1,-1) }
         75% { transform: scale(1,-1) }
        100% { transform: scale(1,1) }
      }
      """
    js: (t, opt) ->
      v = @affine t, opt
      m = anikit.util.m4to3 v.transform
      return transform: "matrix(#{m.join(',')})"

    affine: (t, opt) ->
      p = [0, opt.steep, 1 - opt.steep, 1]
      phase = Math.floor(t * 4)
      t = t * 4 - phase
      t = cubic.Bezier.y(cubic.Bezier.t(t, p), p)
      ss = [[1,1], [-1,1], [-1,-1], [1,-1], [1,1]]
      [s1, s2] = [ss[phase], ss[phase + 1]]
      [sx, sy] = [(s2.0 - s1.0) * t + s1.0, (s2.1 - s1.1) * t + s1.1]
      return transform: [
        sx, 0, 0, 0, 
        0, sy, 0, 0, 
        0, 0, 1, 0, 
        0, 0, 0, 1
      ]

  if module? => module.exports = ret
  return ret
)!
