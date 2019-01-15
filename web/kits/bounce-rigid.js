// Generated by LiveScript 1.3.1
var ret;
ret = {
  name: 'bounce-rigid',
  preset: {
    beat: {
      steep: 0.4,
      count: 1,
      decay: 0.5,
      power: 1.1,
      offset: 0.2,
      unit: '',
      prop: function(f, c){
        return {
          transform: "scale(" + (1 - c.offset * f.value) + ")"
        };
      },
      value: function(t, c){
        return {
          transform: anikit.util.s(1 - t * c.offset)
        };
      }
    },
    bounceAlt: {
      steep: 0.5,
      count: 0,
      decay: 0.5,
      power: 0,
      offset: -14,
      unit: 'px',
      prop: function(f, c){
        return {
          transform: "translate(0, " + c.offset * f.value + c.unit + ")"
        };
      },
      value: function(t, c){
        return {
          transform: anikit.util.ty(c.offset * t)
        };
      }
    },
    pulse: {
      dur: 0.5,
      steep: 0.6,
      count: 0,
      decay: 0.5,
      power: 1.1,
      offset: 0.2,
      unit: '',
      local: {
        errorThreshold: 0.001,
        segSampleCount: 20,
        sampleCount: 1000
      },
      prop: function(f, c){
        return {
          transform: "scale(" + (1 - c.offset * f.value) + ")"
        };
      },
      value: function(t, c){
        return {
          transform: anikit.util.s(1 - c.offset * t)
        };
      }
    },
    "tick-alt": {
      steep: 0.4,
      count: 5,
      decay: 0.6,
      power: 1.1,
      offset: -45,
      unit: '',
      prop: function(f, c){
        return {
          transform: "rotate(" + f.value * c.offset + "deg)"
        };
      },
      value: function(t, c){
        return {
          transform: anikit.util.rz(t * c.offset * Math.PI / 180)
        };
      }
    },
    jump: {
      steep: 0.4,
      count: 5,
      decay: 0.6,
      power: 1.1,
      offset: -14,
      unit: 'px',
      prop: function(f, c){
        return {
          transform: "translate(0," + f.value * c.offset + c.unit + ")"
        };
      },
      value: function(t, c){
        return {
          transform: anikit.util.ty(t * c.offset)
        };
      }
    }
  },
  edit: {
    steep: {
      'default': 0.4,
      type: 'number',
      min: 0.3,
      max: 1
    },
    count: {
      'default': 5,
      type: 'number',
      min: 0,
      max: 10
    },
    decay: {
      'default': 0.6,
      type: 'number',
      min: 0,
      max: 1,
      step: 0.1
    },
    power: {
      'default': 1.1,
      type: 'number',
      min: 0,
      max: 10,
      step: 0.1
    },
    offset: {
      'default': -14,
      type: 'number',
      unit: 'px',
      min: -100,
      max: 100
    },
    unit: {
      'default': 'px',
      type: 'choice',
      values: ["px", "%", ""]
    }
  },
  timing: function(t, opt){
    var p1, p2, R, i$, to$, i, pp, pf, ph, d;
    p1 = [opt.steep, 0, 1, 1 - opt.steep];
    p2 = [0, opt.steep, 1 - opt.steep, 1];
    R = (opt.decay - 1) / (Math.pow(opt.decay, opt.count + 1) - 1);
    for (i$ = 0, to$ = opt.count; i$ <= to$; ++i$) {
      i = i$;
      pp = R * (Math.pow(opt.decay, i) - 1) / (opt.decay - 1);
      pf = R * (Math.pow(opt.decay, i + 1) - 1) / (opt.decay - 1);
      ph = (pf + pp) * 0.5;
      d = Math.pow(Math.pow(opt.decay, opt.power), i);
      if (t < ph) {
        t = (t - pp) / (ph - pp);
        t = cubic.Bezier.y(cubic.Bezier.t(t, p2), p2);
      } else if (t < pf) {
        t = (t - ph) / (pf - ph);
        t = cubic.Bezier.y(cubic.Bezier.t(t, p1), p1);
        t = 1 - t;
      } else {
        continue;
      }
      return t * d;
    }
    return 0;
  }
  /*
  css: (opt) -> anikit.step-to-keyframes (~> @timing it, opt), opt
  js: (t, opt) -> opt.prop {value: @timing t, opt}, opt
  */,
  css: function(opt){
    var ref$, ref1$, this$ = this;
    return easingFit.fitToKeyframes(function(it){
      return this$.timing(it, opt);
    }, (ref$ = (ref1$ = opt.local || {}, ref1$.config = opt, ref1$), ref$.name = opt.name, ref$.prop = opt.prop, ref$));
  },
  js: function(t, opt){
    return opt.prop({
      value: this.timing(t, opt)
    }, opt);
  },
  affine: function(t, opt){
    return opt.value(this.timing(t, opt), opt);
  }
  /* equivalent keyframes */
  /*
  bounce(name, dur, iterations, accelerate, decay, power, offset, func)
    R = 100 * (decay - 1) / (decay ** (iterations + 1) - 1)
    .{name}
      animation: unquote(name) dur linear infinite
    @keyframes {name}
      0%
        func(0,0)
        timing-speed-down(accelerate)
      for num in (0..iterations)
        p = (decay ** ( num + 1 ) - 1) / (decay - 1)
        p2 = p - (decay ** num) * 0.5
        d = offset * ((decay ** power) ** num)
        {R * 1% * p2 }
          func(d,num * 2 + 1)
          timing-speed-up(accelerate)
        {R * 1% * p}
          func(0,num * 2 + 2)
          timing-speed-down(accelerate)
  */
};
module.exports = ret;