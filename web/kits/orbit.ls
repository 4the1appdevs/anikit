ret = do
  name: \orbit
  preset:
    orbit:
      count: 12, radius: 60, unit: \px
  edit: 
    count: default: 8, type: \number, min: 4, max: 36
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
    a = Math.PI * 2 * t
    x = Math.sin(a) * opt.radius
    y = -Math.cos(a) * opt.radius
    r = 360 * t
    return {
      transform: "translate(#{x}#{opt.unit},#{y}#{opt.unit}) rotate(#{r}deg)"
    }



module.exports = ret
