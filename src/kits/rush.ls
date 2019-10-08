(->
  ret = do
    name: \rush
    type: \animation
    preset:
      "rush-ltr": dir: 1, repeat: 0
      "rush-rtl": dir: 2, repeat: 0
      "rush-ttb": dir: 3, repeat: 0
      "rush-btt": dir: 4, repeat: 0
      "rush-ltr-in": dir: 1, repeat: 1
      "rush-rtl-in": dir: 2, repeat: 1
      "rush-ttb-in": dir: 3, repeat: 1
      "rush-btt-in": dir: 4, repeat: 1

    edit: do
      dir: name: "Direction", type: \Choice, values: [1,2,3,4], default: 1
      offset: name: "Offset", default: 60, type: \number, min: 0, max: 1000
      size: name: "Item Size", default: 32, type: \number, min: 0, max: 1000
      deg: name: "Skew", default: 30, type: \number, unit: \deg, min: 0, max: 90
      flip: name: "Flip", default: false, type: \boolean
      unit: default: \px, type: \choice, values: ["px", "%", ""]
    local: data: (opt) ->
      RD = Math.PI / 180
      {deg, offset, size} = opt
      ds = [ deg, -deg/2, -deg/2, deg/4, -deg/8, 0, 0, deg ]
      xs = [
        -offset - size * Math.tan(deg * RD),
        -offset / 10 - size * Math.tan(RD * -deg / 2 ), 
        -size * Math.tan(RD * -deg / 2),
        -size * Math.tan(RD *  deg / 4),
        -size * Math.tan(RD * -deg / 8),
        0, 0, offset
      ]
      if opt.repeat => ts = [0, 0.3, 0.4, 0.55, 0.7, 0.8, 1]
      else ts = [0, 0.25, 0.33, 0.44, 0.55, 0.66, 0.8, 1]
      dc = if opt.dir <= 2 => \X else \Y
      sgn = if opt.dir % 2 => 1 else -1
      flip = if opt.flip => -1 else 1

      return {RD, deg, offset, size, ds, xs, ts, dc, sgn, flip}

    css: (opt) -> 
      {RD,deg,offset,size,ds,xs,ts,dc,sgn,flip} = @local.data opt
      fs = ""
      for i from 0 til ts.length =>
        fs += "#{ts[i] * 100}% { transform: translate#dc(#{sgn * xs[i]}#{opt.unit}) skew#dc(#{flip * sgn * ds[i]}deg); }\n"
      return """
      @keyframes #{opt.name} {
        0% { animation-timing-function: cubic-bezier(0,0.5,0.5,1); opacity: 0 }
        5% { opacity: 1}
        #fs
        100% { opacity: 1}
      }
      """

    js: (t, opt) ->
      #TODO align with affin
      {RD,deg,offset,size,ds,xs,ts,dc,sgn,flip} = @local.data opt
      for i from 0 til ts.length => if t < ts[i] => break
      [d1, d2] = ds[i - 1 to i]
      [x1, x2] = xs[i - 1 to i]
      [t1, t2] = ts[i - 1 to i]
      if i == 1 => t = Math.pow(t / ts.1, 0.5) * ts.1
      x = x1 + (x2 - x1) * (t - t1) / (t2 - t1)
      d = d1 + (d2 - d1) * (t - t1) / (t2 - t1)
      return transform: "translate#{dc}(#{sgn * x}#{opt.unit}) skew#{dc}(#{flip * sgn * d}deg)", opacity: (t * 20 <? 1)

    affine: (t, opt) ->
      {RD,deg,offset,size,ds,xs,ts,dc,sgn,flip} = @local.data opt
      for i from 0 til ts.length => if t < ts[i] => break
      [d1, d2] = ds[i - 1 to i]
      [x1, x2] = xs[i - 1 to i]
      [t1, t2] = ts[i - 1 to i]
      if i == 1 => t = Math.pow(t / ts.1, 0.5) * ts.1
      x = x1 + (x2 - x1) * (t - t1) / (t2 - t1)
      d = d1 + (d2 - d1) * (t - t1) / (t2 - t1)
      kx = if dc == \X => -Math.tan(flip * sgn * d * Math.PI / 180) else 0
      ky = if dc == \Y => -Math.tan(flip * sgn * d * Math.PI / 180) else 0
      tx = if dc == \X => sgn * x else 0
      ty = if dc == \Y => -sgn * x else 0

      return do
        transform: [
          1, kx, 0, tx,
          ky, 1, 0, ty,
          0,  0, 1,  0,
          0,  0, 0,  1
        ],
        opacity: t * 20 <? 1

  if module? => module.exports = ret
  return ret
)!
