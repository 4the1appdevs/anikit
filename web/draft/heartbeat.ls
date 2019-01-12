require! <[easing-fit]>

waveform = "M0,50c0,0,2,0.5,6.7,0c5.6-0.6,3.5-18.1,7.1-18.1s4.2,25.6,8.9,25.6s6.8-10.3,8.4-14c1.9-4.4,7.9-5.4,10.9,0.1C46.7,52.3,100,50,100,50"

step = easing-fit.step-from-svg waveform

module.exports = do
  name: \heartbeat
  css: (opt = {}) ->
    ret = easing-fit.fit (-> step(it) + 1.0)
    ret = easing-fit.to-keyframes ret, do
      name: opt.name
      format: \css
      propFunc: -> ["transform: scale(#{it.value})"]
    return ret

  js: (t, opt={}) -> 
    t = step(t) + 1
    return [t, 0, 0, t, 0, 0]
  glsl: (opt = {}) ->
    """
    float a[5] = float[5](0., 1., 2., 3., 4.);
    mat3 #{opt.name or 'cycle'}(float t, int type, mat4 opt) {
      t = 3.14159 * 2. * (t - floor(t));
      mat3 mat = mat3(
        cos(t),  sin(t), 0,
       -sin(t),  cos(t), 0,
             0,       0, 1.
      );
      return mat;
    }
    """
