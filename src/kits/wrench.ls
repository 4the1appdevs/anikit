(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \wrench
    type: \animation
    preset:
      wrench: {}
    edit: 
      dur: default: 1
      rotate: name: "Rotate Degree", default: 45, type: \number, min: 0, max: 360, step: 1

    css: (opt) ->
      """
      @keyframes #{opt.name} {
        20%, 36%, 70%, 86% {
          transform: rotate(0deg);
        }
        0%, 50%, 100% {
          transform: rotate(#{opt.rotate}deg);
        }
      }
      """
    js: (t, opt) ->
      m = anikit.util.m4to3 @affine(t, opt).transform
      return transform: "matrix(#{m.join(',')})"
    affine: (t, opt) ->
      t = (t * 2 - Math.floor(t * 2)) * 0.5
      if t < 0.2 => t = 1 - (t / 0.2)
      else if t > 0.36 => t = (t - 0.36) / 0.14
      else t = 0
      r = t * opt.rotate * Math.PI / 180
      return transform: [Math.cos(r), Math.sin(r), 0, 0, -Math.sin(r), Math.cos(r), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]


  if module? => module.exports = ret
  return ret
)!
