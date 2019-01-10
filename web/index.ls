tomato-js = document.querySelector \.tomato.js
tomato-css = document.querySelector \.tomato.css
tomato-webgl = document.querySelector \.tomato.webgl

/* CSS */
style = document.createElement("style")
document.head.appendChild style

style.setAttribute \type, \text/css
style.textContent = """
#{bounce.css!}
.tomato.css {
  animation: bounce 1s infinite
}
"""


/* JS */
animate = (func) ->
  requestAnimationFrame (step = (t) -> func t * 0.001; requestAnimationFrame step)

animate (t) ->
  mat = bounce.js t, {height: -20}
  tomato-js.style.transform = "matrix(#{mat.join(',')})"

/* WEBGL */
shader = do
  render: (renderer, program, t)  ->
    gl = renderer.gl
    gl.clearColor 0,0,0,0
    gl.clear gl.COLOR_BUFFER_BIT
    gl.drawArrays gl.TRIANGLES, 0, 6

  vertexShader: '''
  precision highp float;
  ''' + bounce.glsl! + '''
  attribute vec3 position;
  uniform float uTime;
  uniform vec2 uResolution;
  void main() {
    float t = uTime;
    vec3 pos = vec3(vec2(position), 1.);
    gl_Position = vec4(pos, 1.);
  }
  '''
  fragmentShader: '''
  precision highp float;
  ''' + bounce.glsl! + '''
  uniform float uTime;
  uniform vec2 uResolution;
  void main() {
    float len, alpha, p, t = uTime;
    vec3 pos, c1, c2;
    vec2 uv;
    c1 = vec3(.5625, .5625, 1.);
    c2 = vec3(.8125, .5625, 1.);
    uv = gl_FragCoord.xy / uResolution.xy;
    pos = vec3(uv - vec2(.5, .5), 1.);

    float height = -20.;
    height = height / uResolution.y;

    pos = bounce(t, height) * pos;

    pos.xy = (pos.xy * uResolution.xy / 40.0);
    len = length(pos.xy);
    alpha = smoothstep(1.02,.98,len);
    p = smoothstep(0.81, 0.79, len);
    if(pos.y < 0.0) { p = 1.; }
    if(pos.x < 0.0) { p = 1.; }
    gl_FragColor = vec4(c2 * p + c1 * (1. - p), alpha);
  }
  '''

renderer = new ShaderRenderer [shader], {root: tomato-webgl}
renderer.init!
renderer.animate!
