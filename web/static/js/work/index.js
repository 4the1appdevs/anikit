// Generated by LiveScript 1.3.1
var lsc, textarea, block, blockJs, kit, handler, restart, st, render, ldrs, renderJs;
lsc = require('livescript');
textarea = ld$.find(document, 'textarea', 0);
block = ld$.find(document, '.block', 0);
blockJs = ld$.find(document, '.block', 1);
kit = null;
handler = debounce(function(){
  var ret, names, res$, k;
  ret = lsc.run("return " + textarea.value);
  anikit.set('custom', ret);
  res$ = [];
  for (k in ret.preset) {
    res$.push(k);
  }
  names = res$;
  return select.innerHTML = names.map(function(it){
    return "<option name=\"" + it + "\">" + it + "</option>";
  });
});
textarea.addEventListener('keyup', handler);
restart = false;
st = 0;
render = debounce(function(){
  kit = new anikit(select.value);
  kit.animate(block, {
    dur: 1 / ldrs.get()
  });
  return restart = true;
});
ldrs = new ldSlider({
  root: '.ldrs',
  min: 0,
  max: 2,
  step: 0.01,
  from: 1
});
ldrs.on('change', render);
select.addEventListener('change', function(){
  return render().now();
});
renderJs = function(t){
  var st;
  if (restart) {
    st = t;
  }
  t = t - st;
  t = (t / 1000) / ldrs.get();
  t = t - Math.floor(t);
  if (kit != null) {
    kit.animateJs(blockJs, t);
  }
  return requestAnimationFrame(renderJs);
};
requestAnimationFrame(renderJs);