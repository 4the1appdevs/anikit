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



  if module? => module.exports = ret
  return ret
)!
