ret = do
  name: \surprise
  preset:
    surprise: {}
  edit: 
    zoom_min: default: 0.5, type: \number, min: 0, max: 10, step: 0.1
    zoom_max: default: 1.0, type: \number, min: 0, max: 10, step: 0.1
    skew: default: 25, type: \number, unit: \deg, min: -90, max: 90

  css: (opt) ->
    """
    @keyframes #{opt.name} {
      0% { transform: skewX(0deg) scale(1); }
      10% { transform: skewX(#{-opt.skew}deg) scale(#{opt.zoom_min}); }
      20% { transform: skewX(#{-opt.skew}deg) scale(#{opt.zoom_min}); }
      30% { transform: skewX(#{opt.skew}deg) scale(#{opt.zoom_max}); }
      40% { transform: skewX(#{-opt.skew}deg) scale(#{opt.zoom_max}); }
      50% { transform: skewX(#{opt.skew}deg) scale(#{opt.zoom_max}); }
      60% { transform: skewX(#{-opt.skew}deg) scale(#{opt.zoom_max}); }
      70% { transform: skewX(#{opt.skew}deg) scale(#{opt.zoom_max}); }
      80% { transform: skewX(#{-opt.skew}deg) scale(#{opt.zoom_max}); }
      90% { transform: skewX(#{opt.skew}deg) scale(#{opt.zoom_max}); }
      100% { transform: skewX(#{-opt.skew}deg) scale(#{opt.zoom_max}); }
    }
    """

  js: (t, opt) ->
    [k1,k2,s1,s2] = [0,0,opt.zoom_min,opt.zoom_min]
    d = Math.floor(t * 10)
    if d == 0 => [k1,k2] = [0, -1]
    else if d == 1 => [k1,k2] = [-1, -1]
    else [k1,k2] = [(-1) ** (d - 1), (-1) ** d]
    if d == 0 => [s1,s2] = [1, opt.zoom_min]
    else 
      if d > 1 => s2 = opt.zoom_max
      if d > 2 => s1 = opt.zoom_max
    t = (10 * t - d)
    k = (k2 - k1) * t + k1
    s = (s2 - s1) * t + s1
    return {
      transform: "skewX(#{k * opt.skew}deg) scale(#{s})"
    }
module.exports = ret
