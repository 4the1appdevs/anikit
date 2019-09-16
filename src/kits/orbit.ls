(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \orbit
    type: \animation
    preset: orbit: {count: 12, radius: 60, unit: \px}
    edit: 
      count: name: "Sample Count", default: 8, type: \number, min: 4, max: 36
      radius: default: 60, type: \number, unit: \%, min: 0, max: 1000
      unit: default: \px, type: \choice, values: ["px", "%", ""]

    css: (opt) ->
      list = []
      for i from 0 to opt.count =>
        r = 360 * i / opt.count
        a = Math.PI * 2 * i / opt.count
        x = Math.sin(a) * opt.radius
        y = -Math.cos(a) * opt.radius
        p = 100 * i / opt.count
        list.push """ #{p}% {
          animation-timing-function: linear;
          transform: translate(#{x}#{opt.unit},#{y}#{opt.unit}) rotate(#{r}deg) } 
        """
      """ @keyframes #{opt.name} { #{list.join('\n')} } """

    js: (t, opt) ->
      m = @affine(t, opt).transform
      m = [m.0, -m.1, m.4, -m.5, m.3, -m.7]
      return transform: "matrix(#{m.join(',')})"

    affine: (t, opt) ->
      a = Math.PI * 2 * t
      x = Math.sin(a) * opt.radius
      y = -Math.cos(a) * opt.radius

      return transform: [
        Math.cos(a), Math.sin(a), 0, x, 
        -Math.sin(a), Math.cos(a), 0, -y, 0, 0, 1, 0, 0, 0, 0, 1
      ]



  if module? => module.exports = ret
  return ret
)!
