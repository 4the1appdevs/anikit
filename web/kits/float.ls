ret = do
  name: \float
  preset:
    float: {}
  edit: 
    steep: default: 0.4, type: \number, min: 0, max: 1, step: 0.1
    offset: default: 15, type: \number, unit: \px, min: 0, max: 1000
    zoom: default: 0.7, type: \number, min: 0, max: 1, step: 0.1
    shadow_offset: default: 23, type: \number, unit: \px, min: 0, max: 1000
    shadow_blur: default: 5, type: \number, unit: \px, min: 0, max: 100
    shadow_expand: default: -15, type: \number, unit: \px, min: -1000, max: 1000
    unit: default: \px, type: \choice, values: ["px", "%", ""]

  css: (opt) ->

    """
    @keyframes #{opt.name} {
      0% {
        animation-timing-function: cubic-bezier(0,#{opt.steep},#{1 - opt.steep},1);
        transform: translate(0,0) scale(#{opt.zoom});
        box-shadow: 0 0 0 rgba(0,0,0,.3);
      }
      50% {
        animation-timing-function: cubic-bezier(#{opt.steep},0,1,#{1 - opt.steep});
        transform: translate(0,#{-opt.offset}#{opt.unit}) scale(1);
        box-shadow: 0 #{opt.shadow_offset}#{opt.unit} #{opt.shadow_blur}#{opt.unit} #{opt.shadow_expand}#{opt.unit} rgba(0,0,0,.2)
      }
      100% {
        transform: translate(0,0) scale(#{opt.zoom});
        box-shadow: 0 0 0 rgba(0,0,0,.3)
      }
    } """

  js: (t, opt) ->


module.exports = ret
