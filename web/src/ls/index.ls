(->
  ld$.find document, '.item' .map (n) -> 
    n.addEventListener \click, ->
      a = n.getAttribute \data-name
      s = ld$.find(n, '.square', 0)
      s.classList.remove a
      s.offsetHeight
      setTimeout (-> s.classList.add a), 0
  ldcv-nodes = ld$.find document, '.ldcv'
  ldrs-nodes = ld$.find document, '.ldrs'
  window.ldcv1 = new ldCover root: ldcv-nodes.0
  window.ldcv2 = new ldCover root: ldcv-nodes.1
  ldrs1 = new ldSlider root: ldrs-nodes.0, min: 0, max: 1, step: 0.01
  ldrs2 = new ldSlider root: ldrs-nodes.1, min: 0, max: 1, step: 0.01
  ldrs1-demo = ld$.find document, '#ldrs-demo', 0
  kit = new anikit \bounce
  ldrs1.on \change, -> kit.animate-js ldrs1-demo, it

  three-init = (root) ->
    box = root.getBoundingClientRect!
    [w,h] = [box.width, box.height]
    camera = new THREE.PerspectiveCamera 45, w/h, 1, 10000
    scene = new THREE.Scene!
    renderer = new THREE.WebGLRenderer antialias: true, alpha: true
    renderer.setSize w, h
    renderer.setClearColor 0x0, 0
    root.appendChild renderer.domElement
    controls = {}
    animate = (render-func) ->
      _animate = (value) ->
        requestAnimationFrame _animate
        render-func value
      _animate!
    return {camera, scene, renderer, w, h, controls}

  three-root = ld$.find document, '#three-root', 0
  {camera, scene, renderer, w, h, controls} = three-init three-root

  d = 1.1
  shape = new THREE.Shape!
  shape.moveTo d, 0
  shape.bezierCurveTo d, 1.3 * d, -d, 1.3 * d, -d, 0
  shape.bezierCurveTo -d, -1.3 * d, d, -1.3 * d, d, 0
  geom = geom = new THREE.ShapeGeometry shape
  mat = mat = new THREE.MeshStandardMaterial color: 0xffffff, metalness: 0, roughness: 0.5
  mat = mat = new THREE.ShaderMaterial do
    side: THREE.DoubleSide
    transparent: true
    uniforms: alpha: type: \f, value: 1
    vertexShader: '''
    varying vec2 vUv;
    varying float vA;
    uniform float alpha;
    void main() {
      vUv = uv;
      vA = alpha;
      gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.);
    }
    '''
    fragmentShader: '''
    varying vec2 vUv;
    varying float vA;
    void main() {
      vec3 c1 = vec3(.3, .5, 0.9);
      vec3 c2 = vec3(.6, .8, 1.);
      vec2 v = vUv;
      float len = 0.;
      len = length(v - 0.);
      len = smoothstep(0.88,0.89,len);
      if(v.y + v.x < 0.0 || v.y - v.x < 0.0 ) { len = 0.; }
      gl_FragColor = vec4(mix(c1, c2, len), vA);
    }
    '''
  mesh = mesh = new THREE.Mesh geom, mat
  group = group = new THREE.Group!
  group.add mesh
  scene.add group
  light = new THREE.HemisphereLight 0x0099ff, 0xff9900, 0.9
  scene.add light
  camera.position.set 0, 0, 10
  camera.lookAt 0, 0, 0
  renderer.render scene, camera

  ldrs2.on \change, ->
    kit.animate-three mesh, it
    renderer.render scene, camera
  /*
  f = (t) ->
    t = (t / 1000) - Math.floor(t / 1000)
    kit.animate-three mesh, t
    renderer.render scene, camera
    requestAnimationFrame f
  requestAnimationFrame f
  */

)!
