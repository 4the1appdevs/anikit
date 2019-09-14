require! <[easing-fit cubic ../anikit ../easing]>
ret = do
  name: \power
  type: \animation
  preset: 
    "power-off": dir: -1, repeat: 1
    "power-on": dir: 1, repeat: 1

  edit: 
    steep: default: 0.5, type: \number, min: 0, max: 1, step: 0.01
    dir: default: 1, hidden: true, min: -1, max: 1, step: 2
  local: 
    value: (t, c) -> 
      if c.dir > 0 =>
        if t < 0.2 => [x,y] = [t * 5, 0.05]
        else [x,y] = [1, 1.25 * (t - 0.2)]
        o = if t < 0.01 => 0 else 1
      else
        if t < 0.2 => [x,y] = [1, 1 - 5 * 0.95 * (t)]
        else [x,y] = [1 - 1.25 * 0.95 * ( t - 0.2 ), 0.05]
        o = if t > 0.95 => 0 else 1
      return do
        transform: [x, 0, 0, 0, 0, y, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
        opacity: o

  timing: (t, opt) ->
    p = [0, opt.steep, 1 - opt.steep, 1]
    if t < 0.2 => t = cubic.Bezier.y(cubic.Bezier.t(t * 5, p), p) * 0.2
    else t = cubic.Bezier.y(cubic.Bezier.t((t - 0.2) * 1.25, p), p) * 0.8 + 0.2
  css: (opt) -> 
    ret = """
    @keyframes #{opt.name} {
      0%, 20%, 100% {
        animation-timing-function: cubic-bezier(0,#{opt.steep},#{1 - opt.steep},1);
      }
      #{if opt.dir > 0 => 0 else 100}% { transform: scale(0,0); opacity: 0}
      #{if opt.dir > 0 => 1 else 99}% { transform: scale(0.05,0.05); opacity: 1 }
      #{if opt.dir < 0 => 0 else 100}% { transform: scale(1,1); opacity: 1 }
      20% { transform: scale(1,0.1); }
    }
    """
    ret
  js: (t, opt) -> 
    value = @local.value(@timing(t,opt), opt)
    [o,m] = [value.opacity, anikit.util.m4to3(value.transform)]
    return {transform: "matrix(#{m.join(',')})", opacity: o}
  affine: (t, opt) -> return @local.value(@timing(t,opt),opt)

module.exports = ret
