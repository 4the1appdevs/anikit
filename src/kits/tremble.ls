require! <[easing-fit cubic ../anikit]>
ret = do
  name: \tremble
  type: \animation
  preset: 
    measure: dur: 5, count: 30, offset: 0, degree: 30, zoom: 0
    shiver: dur: 0.5, count: 30, offset: 0, degree: 0, zoom: 0.1
    swim: dur: 10, count: 12, offset: 12, degree: 30, zoom: 0, unit: \px
    tremble: dur: 0.5, count: 30, offset: 8, degree: 0, zoom: 0, unit: \px

  edit: 
    count: default: 30, type: \number, min: 0, max: 100
    offset: default: 4, type: \number, unit: \px, min: 0, max: 30
    degree: default: 0, type: \number, unit: \degree, min: 0, max: 360
    zoom: default: 0.0, type: \number, min: 0, max: 2, step: 0.01
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  prop: (f, opt) ->
    [x,y,r,s] = @calc f.value, opt
    { transform: "translate(#x#{opt.unit},#y#{opt.unit}) rotate(#{r}deg) scale(#s)" }
  css: (opt) -> 
    ret = [
      "@keyframes #{opt.name} {"
      "  0% { transform: #{@prop({value:0}, opt).transform } }"
    ]
    for i from 1 til opt.count =>
      p = easing-fit.round(100 * i / opt.count)
      ret.push "  #{p}% { transform: #{@prop({value:p/100}, opt).transform}; animation-timing-function: linear }"
    ret.push "  100% { transform: translate(0,0) rotate(0) scale(1) }"
    ret.push "}"
    return ret.join('\n')
  calc: (t, opt) ->
    {offset, degree, zoom} = opt
    if t == 0 or t == 1 => return [0,0,0,1]
    x = anikit.util.noise(t * 78779) * offset - offset * 0.5
    y = anikit.util.noise(t * 57793) * offset - offset * 0.5
    r = anikit.util.noise(t * 19901) * degree - degree * 0.5
    s = 1 + anikit.util.noise(t + 31393) * zoom - zoom * 0.5
    return [x,y,r,s]

  js: (t, opt) -> 
    values = @affine t, opt
    mat = values.transform
    return {transform: "matrix(#{[mat.0, mat.1, mat.4, mat.5, mat.3, mat.7].join(',')})"}

  affine: (t, opt) ->
    t1 = Math.floor(t * opt.count) / opt.count
    t2 = Math.ceil(t * opt.count) / opt.count
    [x1, y1, r1, s1] = @calc (t1 - Math.floor(t1)), opt
    [x2, y2, r2, s2] = @calc (t2 - Math.floor(t2)), opt
    t = (t - t1) / (t2 - t1)
    x = (x2 - x1) * t + x1
    y = (y2 - y1) * t + y1
    r = ((r2 - r1) * t + r1) * Math.PI / 180
    s = (s2 - s1) * t + s1
    return transform: [
      s * Math.cos(r), Math.sin(r), 0, x,
      -Math.sin(r), s * Math.cos(r), 0, y,
      0, 0, s, 0,
      0, 0, 0, 1
    ]

  /* equivalent keyframes */
  /*
  tremble(name, dur, iterations, offset, degree, zoom)
    x0 = 0
    y0 = 0
    .{name}
      animation: unquote(name) dur linear infinite
    @keyframes {name}
      0%
        transform: translate(x0,y0) rotate(0deg) scale(1)
      for num in (1..(iterations - 1))
        {1% * num * 100/iterations}
          x = random() * offset - offset * 0.5
          y = random() * offset - offset * 0.5
          r = random() * degree - degree * 0.5
          s = 1 + random() * zoom - zoom * 0.5
          transform: translate(x,y) rotate(r) scale(s)
      100%
        transform: translate(x0,y0) rotate(0deg) scale(1)
  */
module.exports = ret
