ret = do
  name: \hit
  preset:
    hit: {}
  edit: 
    dur: default: 2.0
    steep: default: 0.5, type: \number, min: 0, max: 1
    zoom: default: 1, type: \number, min: 0, max: 10
    skew: default: 20, type: \number, unit: \deg, min: -90, max: 90
    offset: default: 200, type: \number, unit: \px, min: 0, max: 10000
    fade: default: 1, type: \number, min: 0, max: 1, step: 0.01
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  timing: (t, opt) ->

  css: (opt) -> 
    """
    @keyframes #{opt.name} {
      0% {
        animation-timing-function: cubic-bezier(#{opt.steep},0,1,#{1 - opt.steep});
        transform: scale(0) translate(0,0) skewX(0);
        opacity: 1;
      }
      20% {
        transform: scale(#{opt.zoom}) translate(0,0) skewX(#{opt.skew}deg);
      }
      50% {
        animation-timing-function: cubic-bezier(#{opt.steep * 1.2},0,1,#{1 - opt.steep * 1.2});
        transform: scale(#{opt.zoom}) translate(0,0) skewX(#{opt.skew}deg);
      }
      #{100 - opt.fade * 50}% {
        opacity: 1;
      }
      100% {
        transform: scale(#{opt.zoom})  translate(0,#{opt.offset}#{opt.unit}) skewX(#{opt.skew}deg);
        opacity: 0;
      }
    } """
  js: (t, opt) ->
    values = @affine t, opt
    m = values.transform
    m = [m.0, -m.1, m.4, m.5, m.3, -m.7]
    return do
      transform: "matrix(#{m.join(,)})" #"scale(#s) translate(0,#{p}#{opt.unit}) skewX(#{k}deg)"
      opacity: values.o
  affine: (t, opt) ->
    p1 = [opt.steep, 0, 1, 1 - opt.steep]
    [s, p, k,o] = [opt.zoom, 0, opt.skew,1]
    if t < 0.2 =>
      t = cubic.Bezier.y(cubic.Bezier.t(t/0.2, p1), p1)
      s = t * opt.zoom
      k = t * opt.skew
    else if t >= 0.5
      t = cubic.Bezier.y(cubic.Bezier.t((t - 0.5) * 2, p1), p1)
      p = opt.offset * t
      if t >= 1 - 0.5 * opt.fade => o = (1 - t) / (1 - 0.5 * opt.fade)
    return do
      transform: [
        s, -Math.tan(k * Math.PI / 180), 0, 0, 
        0, 1, 0, -p, 0, 0, 1, 0, 0, 0, 0, 1
      ]
      opacity: o

  /* similar keyframes */
  /*
    @keyframes ld-hit
      0%
        timing-speed-up(config.accelerate)
        transform: scale(0) translate(0,0) skewX(0)
      20%
        transform: scale(config.zoom) translate(0,0) skewX(config.skew)
      50%
        //animation-timing-function: cubic-bezier(1,0,1,.5)
        timing-speed-up(config.accelerate * 1.2)
        transform: scale(config.zoom) translate(0,0) skewX(config.skew)
      100%
        transform: scale(config.zoom)  translate(0,config.offset) skewX(config.skew)
    .ld-hit
      animation: ld-hit config.dur infinite
  */

module.exports = ret
