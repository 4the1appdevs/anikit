tomato-js = document.querySelector \.tomato.js
tomato-css = document.querySelector \.tomato.css
tomato-webgl = document.querySelector \.tomato.webgl

$( \input.slider )
  ..val 0
  ..ionRangeSlider do
    min: -1.0, max: 1.0, step: 0.001
    onChange: ->
      suite.animate.offset = it.from
      if suite.shader => suite.shader.uniforms.offset.value = it.from

suite = do
  init: ->
    /* CSS */
    @style = document.createElement("style")
    document.head.appendChild @style
    @style.setAttribute \type, \text/css

  stop: -> @animate.aniid = -1
  animate: (func) ->
    @animate.aniid = aniid = Math.random!
    requestAnimationFrame (step = (t) ~> 
      t = t * 0.001
      func t
      if @animate.aniid == aniid => requestAnimationFrame step
    )

  use: ({mod, config}) ->
    config.name = \kit
    /* CSS */
    t1 = Date.now!
    @style.textContent = """
    #{mod.css config}
    .tomato.css {
      animation: kit #{config.dur or 1}s infinite;
      transform-origin: 50% 50%;
    }
    """
    console.log mod.css config
    console.log "CSS Generation elapsed: #{(Date.now! - t1) * 0.001}"

    /* JS */
    @animate (t) ~>
      t = (t + (@animate.offset or 0)) / (config.dur or 1)
      tomato-js.style <<< mod.js (t - Math.floor(t)), config
      #mat = kit.js (t - Math.floor(t)), opt
      #tomato-js.style.transform = "matrix(#{mat.join(',')})"
    return

    /* WEBGL */
    return
    args = new Float32Array([0 til 16].map -> opt.args[it] or 0)
    @shader = shader = do
      render: (renderer, program, t)  ->
        gl = renderer.gl
        gl.clearColor 0,0,0,0
        gl.clear gl.COLOR_BUFFER_BIT
        gl.drawArrays gl.TRIANGLES, 0, 6
      uniforms:
        offset: type: \1f, value: 0.0
        args: type: \Matrix4fv, value: args

      vertexShader: '''
      precision highp float;
      ''' + kit.glsl(name:\kit) + '''
      attribute vec3 position;
      uniform float uTime;
      uniform float offset;
      uniform vec2 uResolution;
      void main() {
        float t = uTime;
        vec3 pos = vec3(vec2(position), 1.);
        gl_Position = vec4(pos, 1.);
      }
      '''
      fragmentShader: '''
      precision highp float;
      ''' + kit.glsl(name:\kit) + '''
      uniform float uTime;
      uniform float offset;
      uniform mat4 args;
      uniform vec2 uResolution;
      void main() {
        float len, alpha, p, t = uTime + offset;
        mat4 opt = mat4(args);
        vec3 pos, c1, c2;
        vec2 uv;
        c1 = vec3(.5625, .5625, 1.);
        c2 = vec3(.8125, .5625, 1.);
        uv = gl_FragCoord.xy / uResolution.xy;
        pos = vec3(uv - vec2(.5, .5), 1.);

        /* 0 ~ 1 = 0 ~ 40px */
        //opt[0][0] = opt[0][0] / 40.;
        //opt[0][1] = opt[0][1] / 40.;

        pos.xy = (pos.xy * uResolution.xy / 40.0);
        t = t - floor(t);
        pos = kit(t, 0, opt) * pos;

        len = length(pos.xy);
        alpha = smoothstep(1.02,.98,len);
        p = smoothstep(0.81, 0.79, len);
        if(pos.y < 0.0) { p = 1.; }
        if(pos.x < 0.0) { p = 1.; }
        gl_FragColor = vec4(c2 * p + c1 * (1. - p), alpha);
      }
      '''

    if @renderer => @renderer.destroy!
    @renderer = new ShaderRenderer [shader], {root: tomato-webgl}
    @renderer.init!
    @renderer.animate!

suite.init!

select = document.querySelector \#select
select.addEventListener \change, -> 
  name = @value
  ret = anikit.use name
  suite.use ret


for k,v of anikit.types =>
  opt = document.createElement("option")
  opt.setAttribute \value, k
  opt.textContent = k
  select.appendChild opt

