// Generated by LiveScript 1.3.1
var ret;
ret = {
  name: 'patrol',
  preset: {
    "jelly-alt": {
      count: 7,
      offset: 1,
      ratio: 0.7,
      delay: 30,
      propFunc: function(f, opt){
        return {
          transform: "skewX(" + f.value * 10 + "deg)"
        };
      }
    },
    jelly: {
      count: 5,
      offset: 1,
      ratio: 0.6,
      delay: 30,
      propFunc: function(f, opt){
        return {
          transform: "translate(" + f.value * 10 + "px,0) skewX(" + f.value * 10 + "deg)"
        };
      }
    },
    damage: {
      count: 10,
      offset: 1,
      ratio: 0.8,
      delay: 20,
      propFunc: function(f, opt){
        return {
          opacity: 1 - f.value
        };
      }
    }
  },
  edit: {
    count: {
      'default': 10,
      type: 'number',
      min: 0,
      max: 50
    },
    offset: {
      'default': 1,
      type: 'number',
      min: 0,
      max: 1,
      step: 0.1
    },
    ratio: {
      'default': 0.8,
      type: 'number',
      min: 0,
      max: 1,
      step: 0.1
    },
    delay: {
      'default': 20,
      type: 'number',
      min: 0,
      max: 100,
      step: 0.1
    }
  },
  timing: function(t){
    return Math.sin(t * Math.PI * 2);
  },
  css: function(opt){
    return anikit.stepToKeyframes(this.timing, opt);
  },
  js: function(t, opt){
    var style;
    t = this.timing(t);
    return style = opt.propFunc({
      value: t
    }, opt);
  }
  /*
  keyframes: (count, offset, ratio, delay) -> 
    ret = []
    ret.push p: 0, v: 0
    ret.push p: delay, v: offset
    for i from 1 til count
      ret.push do
        p: delay + i * (100 - delay) / count
        v: offset * (ratio ** (i - 1)) * ((-1) ** i)
        t: [0.5, 0.5, 0.5, 0.5]
    ret.push p: 100, v: 0
    ret
  */
};
module.exports = ret;