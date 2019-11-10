(->
  if require? => require! <[easing-fit cubic ../anikit]>
  ret = do
    name: \float
    type: \animation
    preset: float: {}
    edit: 
      steep: default: 0.4, type: \number, min: 0, max: 1, step: 0.01
      offset: name: "Float Height", default: 15, type: \number, unit: \px, min: 0, max: 1000
      zoom: name: "Min Scale", default: 0.7, type: \number, min: 0, max: 1, step: 0.01
      shadow_offset: name: "Shadow offset", default: 23, type: \number, unit: \px, min: 0, max: 1000
      shadow_blur: name: "Shadow Blur", default: 5, type: \number, unit: \px, min: 0, max: 100
      shadow_expand: name: "Shadow Expand", default: -15, type: \number, unit: \px, min: -1000, max: 1000
      unit: default: \px, type: \choice, values: ["px", "%", ""]

    css: (c) ->
      """
      @keyframes #{c.name} {
        0% {
          animation-timing-function: cubic-bezier(0,#{c.steep},#{1 - c.steep},1);
          transform: translate(0,0) scale(#{c.zoom});
          box-shadow: 0 0 0 rgba(0,0,0,.3);
        }
        50% {
          animation-timing-function: cubic-bezier(#{c.steep},0,1,#{1 - c.steep});
          transform: translate(0,#{-c.offset}#{c.unit}) scale(1);
          box-shadow: 0 #{c.shadow_offset}#{c.unit} #{c.shadow_blur}#{c.unit} #{c.shadow_expand}#{c.unit} rgba(0,0,0,.2)
        }
        100% {
          transform: translate(0,0) scale(#{c.zoom});
          box-shadow: 0 0 0 rgba(0,0,0,.3)
        }
      } """


    timing: (t, opt) ->
      p1 = [0, opt.steep, 1 - opt.steep, 1]
      p2 = [opt.steep, 0, 1, 1 - opt.steep]
      if t == 0 or t == 1 => return t
      if t < 0.5 =>
        t = cubic.Bezier.y(cubic.Bezier.t(t * 2, p1), p1)
        t = t * 0.5
      else
        t = cubic.Bezier.y(cubic.Bezier.t((t - 0.5) * 2, p2), p2)
        t = t * 0.5 + 0.5
      return 2 * (0.5 - Math.abs(t - 0.5))

    js: (t, opt) ->
      t = @timing t, opt
      return do
        transform: "translate(0,#{t * -opt.offset}#{opt.unit}) scale(#{t * ( 1 - opt.zoom ) + opt.zoom})"
    affine: (t, opt) ->
      t = @timing t, opt
      s = t * ( 1 - opt.zoom ) + opt.zoom
      ty = t * -opt.offset
      return do
        transform: [s, 0, 0, 0, 0, s, 0, -ty, 0, 0, s, 0, 0, 0, 0, 1]

  if module? => module.exports = ret
  return ret
)!
