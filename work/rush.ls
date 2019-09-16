(->
  ret = do
    name: \rush
    type: \animation
    preset:

      "rush-rtl":
        direction: -1, local: sample-count: 40, error-threshold: 0.001
        prop: ((f, c) -> rush-h.prop f, c), value: ((t, c) -> rush-h.value t, c)

      "rush-ltr":
        direction: 1, local: sample-count: 40, error-threshold: 0.001
        prop: ((f, c) -> rush-h.prop f, c), value: ((t, c) -> rush-h.value t, c)

    edit: do
      offset: name: "Offset", default: 30, type: \number, min: 0, max: 1000
      size: name: "Item Size", default: 32, type: \number, min: 0, max: 1000
      skew: name: "Skew", default: 30, type: \number, unit: \deg, min: 0, max: 90

    css: (opt) -> 
      RD = Math.PI / 180
      size = 32
      offset = 100
      deg = 45
      return """
      @keyframes #{opt.name} {
        0% { 
          animation-timing-function: cubic-bezier(0,0.5,0.5,1);
          transform: translate(0,#{-offset - size * Math.tan(deg * RD)}px) skewX(#{deg}deg)
        }
        33% {
          transform: translate(0,#{-size * Math.tan(RD * -deg / 2)}px) skewX(#{-deg / 2}deg)
        }
        44% {
          transform: translate(0,#{-size * Math.tan(RD *  deg / 4)}px) skewX(#{ deg / 4}deg)
        }
        55% {
          transform: translate(0,#{-size * Math.tan(RD * -deg / 8)}px) skewX(#{-deg / 8}deg)
        }
        66%, 80% {
          transform: translate(0px,0) skew(0)
        }
        100% {
          transform: translate(0,#{offset}px) skew(#{deg}deg)
        }
      }
      """
    js: (t, opt) ->
      RD = Math.PI / 180
      deg = 45
      offset = 100
      size = 32
      ds = [ deg, 0, -deg/2, deg/4, -deg/8, 0, 0, deg ]
      xs = [
        -offset - size * Math.tan(deg * RD),
        -offset/5 - size * Math.tan(0 * RD), 
        -size * Math.tan(RD * -deg / 2),
        -size * Math.tan(RD *  deg / 4),
        -size * Math.tan(RD * -deg / 8),
        0, 0, offset
      ]
      ts = [0, 0.15, 0.33, 0.44, 0.55, 0.66, 0.8, 1]
      ts = [0, 0.21, 0.5, 0.6, 0.7, 0.8, 1, 1]
      for i from 0 til ts.length => if t < ts[i] => break
      [d1, d2] = ds[i - 1 to i]
      [x1, x2] = xs[i - 1 to i]
      [t1, t2] = ts[i - 1 to i]
      if i == 1 => t = Math.pow(t / ts.1, 0.5) * ts.1
      x = x1 + (x2 - x1) * (t - t1) / (t2 - t1)
      d = d1 + (d2 - d1) * (t - t1) / (t2 - t1)
      return transform: "translateY(#{-x}px) skewY(#{d}deg)"
      return transform: "translate(#{x}px,0) skew(#{d}deg)"

  if module? => module.exports = ret
  return ret
)!
