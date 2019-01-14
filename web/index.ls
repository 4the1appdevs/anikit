tomato-js = document.querySelector \.tomato.js
tomato-css = document.querySelector \.tomato.css
tomato-webgl = document.querySelector \.tomato.webgl
tomato-three = document.querySelector \.tomato.three

$( \input.slider )
  ..val 0
  ..ionRangeSlider do
    min: -1.0, max: 1.0, step: 0.001
    onChange: ->
      suite.animate.offset = it.from
      if suite.shader => suite.shader.uniforms.offset.value = it.from

three-init = (root, w = window.innerWidth, h = window.innerHeight) ->
  box = tomato-three.parentNode.getBoundingClientRect!
  [w,h] = [box.width, box.height]
  camera = new THREE.PerspectiveCamera 45, w/h, 1, 10000
  scene = new THREE.Scene!
  renderer = new THREE.WebGLRenderer antialias: true, alpha: true
  renderer.setSize w, h
  renderer.setClearColor 0x0, 0
  root.appendChild renderer.domElement
  #controls = new THREE.OrbitControls camera
  controls = {}
  animate = (render-func) ->
    _animate = (value) ->
      requestAnimationFrame _animate
      render-func value
    _animate!
  return {camera, scene, renderer, w, h, controls}

suite = do
  init: ->
    /* CSS */
    @style = document.createElement("style")
    document.head.appendChild @style
    @style.setAttribute \type, \text/css
    @ <<< three-init tomato-three
    [renderer, scene, camera] = [@renderer, @scene, @camera]
    geom = new THREE.SphereGeometry 1, 20, 20
    shape = new THREE.Shape!
    d = 1.1
    shape.moveTo d, 0
    shape.bezierCurveTo d, 1.3 * d, -d, 1.3 * d, -d, 0
    shape.bezierCurveTo -d, -1.3 * d, d, -1.3 * d, d, 0

    geom = new THREE.ShapeGeometry shape
    @mat = mat = new THREE.MeshStandardMaterial color: 0xffffff, metalness: 0, roughness: 0.5
    @mat = mat = new THREE.ShaderMaterial do
      side: THREE.DoubleSide
      vertexShader: '''
      varying vec2 vUv;
      void main() {
        vUv = uv;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.);
      }
      '''
      fragmentShader: '''
      varying vec2 vUv;
      void main() {
        vec3 c1 = vec3(1., 1., 0.5);
        vec3 c2 = vec3(0., 0., 1.);
        vec2 v = vUv;
        float len = 0.;
        len = length(v - 0.);
        len = smoothstep(0.88,0.89,len);
        if(v.y + v.x < 0.0 || v.y - v.x < 0.0 ) { len = 0.; }

        gl_FragColor = vec4(mix(c1, c2, len), 1.);
      }
      '''
    @mesh = mesh = new THREE.Mesh geom, mat
    @light = light = new THREE.HemisphereLight 0x0099ff, 0xff9900, 0.9
    scene.add light

    mesh.matrixAutoUpdate = false
    scene.add mesh
    camera.position.set 0, 0, 10
    camera.lookAt 0, 0, 0
    renderer.render scene, camera

  stop: -> @animate.aniid = -1
  animate: (func) ->
    @animate.aniid = aniid = Math.random!
    requestAnimationFrame (step = (t) ~> 
      t = t * 0.001
      func t

      t = t + (@animate.offset or 0)
      @mesh.matrix.set.apply(
        @mesh.matrix,
        (@kit.affine(t - Math.floor(t)).transform or [1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1])
      )

      @renderer.render @scene, @camera
      if @animate.aniid == aniid => requestAnimationFrame step
    )

  use: (name) ->

    @kit = kit = new anikit name, {name: \kit}

    /* CSS */
    t1 = Date.now!
    @style.textContent = kit.css name: \kit
    kit.animate(tomato-css)
    console.log "CSS Generation elapsed: #{(Date.now! - t1) * 0.001}"

    console.log kit.affine 0

    /* JS */
    @animate (t) ~>
      t = (t + (@animate.offset or 0)) / (kit.config.dur or 1)
      tomato-js.style <<< kit.js (t - Math.floor(t))
      #cfg = kit.affine(t - Math.floor(t))
      #tomato-js.style.transform = "matrix3d(#{(cfg.transform or []).join(',')})"
      #mat = kit.js (t - Math.floor(t)), opt
      #tomato-js.style.transform = "matrix(#{mat.join(',')})"

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
select.addEventListener \change, -> suite.use @value

for k,v of anikit.types =>
  opt = document.createElement("option")
  opt.setAttribute \value, k
  opt.textContent = k
  select.appendChild opt

