[js,gl,cb] = [{},{},{}]
ret = {js, cb, glsl: gl}

js.linear = (t) -> t
cb.linear = (t) -> [0.5, 0.5, 0.5, 0.5]
gl.linear = 'float linear(float t) { return t; }'

js.ease-in-out-quad = (t) -> if t < 0.5 => 2 * t * t else 4 * t - 2 * t * t - 1
cb.ease-in-out-quad = [0.455, 0.03, 0.515, 0.955]
gl.ease-in-out-quad = """float easeInOutQuad(float t) { 
  return (t < 0.5 ? 2. * t * t : 4. * t - 2. * t * t - 1.); 
}"""

js.ease-out-quad = (t) -> t * (2 - t)
module.exports = ret
