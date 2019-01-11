# Anikit

Animation Toolkit for CSS Animation, SMIL, JavaScript and WebGL. Currently in draft stage.


## Introduction

AniKit.js ( アニキト / 兄貴止, ANImation KITs ) is a collection of animations that provides in formats including CSS, JS and GLSL functions. It focuses on animations that could be accomplished with affine transformation and changing opacities.

All animations are defined under src/kits/ as separated files, with following structure:

 * step: Object or Function. Optional, could be used for css/js/glsl auto population in the future.
   - function(time, opts): output Array(6).
   - Object
     - each member is a function(time, opts) and return a number.
     - each member corresponding to opacity or affine transformation type of their name. includes:
     - tx
     - ty
     - sx
     - sy
     - rz ( output should be radian )
     - opacity ( output: 0 ~ 1 )

 * css: function(opts). return css animation keyframes.
   - default opts:
     * name: keyframes name.

 * js: function(time, opts). output: Array(7), use in css transform(1~6) and opacity(7)

 * glsl: function, return glsl function string.
   - glsl function(float time, 0, vec4 config1, vec4 config2) return mat3 for affine transformation.
   - glsl function(float time, 1, vec4 config1, vec4 config2) return float for opacity.
   - default opts:
     * name: function name.
  

Parameter consideration:
 * all time expect to have range 0 ~ 1.
 * opts provide options for tweaking animations.


## Anikit JSON ( tentative )

 * JSON objects for representing keyframes. Or we could align this with easing-fit?
   ```
     [
       {
         time: 0                     # 0 ~ 1
         spline: [0, 0, 1, 1]        # cubic bezier
         attr: {
           name: {value: 0, unit: "px"}, 
           ...
         }
       }, ...
     ]
   ```

 * JSON from easing-fit:
   ```
     [
       { percent: 0                # 0 ~ 100
         cubicBezier: [0, 0, 1, 1] # cubic bezier
         value: 0                  # value
       }, ...
     ]
   ```

## LICENSE

MIT
