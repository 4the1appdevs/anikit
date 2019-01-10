
spin = do
  css: ->
    """
      @keyframes spin {
        0%,100% { animation-timing-function: linear }
        0% { transform: rotate(0deg); animation-timing-function: linear }
        100% { transform: rotate(360deg); animation-timing-function: linear }
      }
    """

  js: (t) ->
    r = Math.PI * 2 * (t - Math.floor(t))
    mat = [Math.cos(r), Math.sin(r), -Math.sin(r), Math.cos(r), 0, 0, 0, 0, 1]
    return mat

  glsl: ->
    """
    mat3 spin(float t) {
      t = 3.14159 * 2. * (t - floor(t));
      mat3 mat = mat3(
        cos(t),  sin(t), 0,
       -sin(t),  cos(t), 0,
             0,       0, 1.
      );
      return mat;
    }
    """

bounce = do
  css: ->
    """
    @keyframes bounce {
      0% {
        transform: translate(0, 0);
        animation-timing-function: ease-out;
      }
      50% {
        transform: translate(0, -20px);
        animation-timing-function: ease-in;
      }
      100% {
        transform: translate(0, 0);
      }
    }
    """
  js: (t, opt={}) ->
    t = (t - Math.floor(t))
    t = (0.25 - Math.abs((t - 0.5) ** 2)) * 4 * (opt.height or 1)
    return [ 1, 0, 0, 1, 0, t ]
  glsl: ->
    """
    mat3 bounce(float t, float height) {
      t = t - floor(t);
      t = (0.25 - pow(abs(t - 0.5), 2.)) * 4. * height;
      mat3 mat = mat3(
        1., 0., 0,
        0., 1., 0,
        0 , t , 1.
      );
      return mat;
    }
    """
