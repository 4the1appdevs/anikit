(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \clock
    type: \animation
    preset:
      clock: {}
    edit: 
      dur: default: 12
      steep: default: 0.7, type: \number, min: 0, max: 1, step: 0.01
      count: default: 12, type: \number, min: 1, max: 60, step: 1

    timing: (t, opt) ->
      p1 = [0, opt.steep, 1 - opt.steep, 1]
      base = Math.floor(t * opt.count) / opt.count
      next = Math.ceil(t * opt.count ) /opt.count
      offset = t - base
      t = cubic.Bezier.y(cubic.Bezier.t(offset * opt.count, p1), p1)
      return (next - base) * t + base

    css: (opt) ->
      list = []
      for i from 0 to opt.count =>
        p = easingFit.round(i * 100 / opt.count)
        d = 360 * i / opt.count
        list.push """
        #{p}% {
          animation-timing-function: cubic-bezier(0,#{opt.steep},#{1 - opt.steep},1);
          transform: rotate(#{d}deg);
        }
        """

      return """
      @keyframes #{opt.name} {
      #{list.join('\n')}
      }
      """

    js: (t, opt) -> 
      return {transform: "rotate(#{@timing(t, opt) * 360}deg)"}

    affine: (t, opt) ->
      return {transform: anikit.util.rz(@timing(t,opt) * Math.PI * 2) }

    /* equivalent keyframes */
    /*
    rush(name, dur, rate, offset_near, offset_far, direction, percent_in, percent_out, skew)
      .{name}
        animation: unquote(name) 1s linear infinite
      @keyframes {name}
        0%
          transform: translate(-1 * direction * offset_far, 0 ) skewX( direction * skew )
          timing-speed-down(rate)
        {percent_in * .37}
          transform: translate( 1 * direction * offset_near, 0)  skewX( -0.78 * direction * skew )
        {percent_in * .56}
          transform: translate( -0.5 * direction * offset_near, 0)  skewX( 0.34 * direction * skew )
        {percent_in * .75}
          transform: translate( 0.25 * direction * offset_near, 0) skew( -0.17 * direction * skew )
        {percent_in * 1}
          transform: translate( 0, 0 ) skew(0deg)
        {percent_out * 1}
          transform: translate( 0, 0 ) skew(0deg)
        100%
          transform: translate(direction * offset_far, 0) skewX( direction * skew )
    */

  if module? => module.exports = ret
  return ret
)!
