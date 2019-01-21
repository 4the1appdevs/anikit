require! <[easing-fit cubic ../anikit]>
ret = do
  name: \slot
  type: \animation
  debug: true
  preset:
    slot:
      # css not working. need linear interpolation instead of curve-fit.
      dur: 5, local: seg-sample-count: 3, sample-count: 5000, error-threshold: 0.00001
      prop: (f, c) -> return transform: "matrix(#{anikit.util.m4to3(@value(f.value,c).transform).join(',')})"
      value: (t, c) -> 
        t = t * c.amount + 0.5
        t = t - Math.floor(t)
        return transform: anikit.util.ty((t - 0.5) * c.offset)
    roulette:
      dur: 5, offset: default: 0, hidden: true
      local: seg-sample-count: 40, sample-count: 200, error-threshold: 0.001
      prop: (f, c) -> transform: "rotate(#{f.value * c.amount * 360}deg)"
      value: (t, c) -> transform: anikit.util.rz(t * c.amount * Math.PI * 2)
  edit:
    steep: default: 0.5, type: \number, min: 0, max: 1, step: 0.01
    amount: default: 50, type: \number, min: 0, max: 100, step: 1
    offset: default: 200, type: \number, min: 0, max: 1000, step: 1
  timing: (t, opt) ->
    max = 1 / ( 1 + Math.exp(-0.5 * (7 + 10 * opt.steep) ) )
    min = 1 / ( 1 + Math.exp(0.5 * (7 + 10 * opt.steep) ) )
    t = 1 / ( 1 + Math.exp(-(t - 0.5) * (7 + 10 * opt.steep) ) )
    return (t - min) / (max - min)
  css: (opt) ->
    prop = (f, c) -> opt.prop f, c
    easing-fit.fit-to-keyframes (~> @timing it, opt), ({} <<< opt.local or {}) <<< {prop,config: opt} <<< opt{name}
  js: (t, opt) -> 
    value = @affine t, opt
    return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
  affine: (t, opt) ->
    return opt.value @timing(t,opt), opt
    #return transform: anikit.util.rz(@timing(t,opt) * opt.amount * Math.PI * 2)
    #return transform: anikit.util.ty((t - 0.5) * opt.offset)

  /*
  css: (opt) ->
    prop = (f, c) -> return transform: "rotate(#{f.value * c.amount * 360}deg)"
    easing-fit.fit-to-keyframes (~> @timing it, opt), ({} <<< opt.local or {}) <<< {prop, config: opt} <<< opt{name}
  js: (t, opt) -> 
    value = @affine t, opt
    return transform: "matrix(#{anikit.util.m4to3(value.transform).join(',')})"
  affine: (t, opt) ->
    return transform: anikit.util.rz(@timing(t,opt) * opt.amount * Math.PI * 2)
  */

module.exports = ret
