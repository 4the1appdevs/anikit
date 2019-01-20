require! <[easing-fit cubic ../anikit]>
ret = do
  name: \blur-transition
  type: \animation
  preset:
    "blur-in": dir: -1, repeat: 1
    "blur-out": dir: 1, repeat: 1
  edit: 
    blur: default: 10, type: \number, unit: \px, units: <[px %]>, min: 0, max: 100, step: 1
    dir: default: 1, type: \number, min: -1, max: 1, step: 2
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  css: (opt) ->
    p = if opt.dir > 0 => [0,100] else [100,0]
    """
    @keyframes #{opt.name} {
      #{p.0}% { filter: blur(0); opacity: 1 }
      #{p.1}% { filter: blur(#{opt.blur}#{opt.unit}); opacity: 0 }
    }
    """

  js: (t, opt) ->
    if opt.dir < 0 => t = 1 - t
    return { filter: "blur(#{opt.blur * t}#{opt.unit})", opacity: 1 - t }



module.exports = ret
