require! <[fs fs-extra ../src/anikit easing-fit]>
output = []
gn = ["No Animation", "Popular Animation", "Repeat Animation", "Transition"]
gs = [[],[],[],[]]
pop = <[spin bounce bounce-in bounce-out blink fade breath spin tremble]>
for k,v of anikit.types => 
  idx = if k == \static => 0 else if /\-(on|off|in|out)$/.exec(k) => 3 else 2
  gs[idx].push k
  if k in pop => gs.1.push k

animation = group-name: gn, members: gs

output = """
//- module
- var anikit = #{JSON.stringify(animation)};

mixin anikit-dropdown
  .dropdown
    .btn.btn-outline-dark.dropdown-toggle(data-toggle="dropdown") Animations...
    .dropdown-menu
      .in: +anikit-dropdown-menu

mixin anikit-dropdown-menu
  each n,i in anikit.groupName
    h6.dropdown-header.head #\{n}
    each k in anikit.members[i]
      a.dropdown-item.anikit(href="#",data-anikit=k) #[span= k] #[.demo: .inner: .ld(class="ld-" + k)]
    if i < 3
      .dropdown-divider

mixin anikit-modal
  .ldcv.default-size: .base(style="position:relative")
    .inner
      .closebtn.lg(data-ldcv-set)
      +anikit-modal-content

mixin anikit-modal-content
  each n,i in anikit.groupName
    h6.ml-4.mt-4.head #\{n}
    .anikits
      each k in anikit.members[i]
        .anikit(data-ldcv-set=k,data-anikit=k)
          .demo: .inner: .ld(class="ld-" + k)
          span= k
    .dropdown-divider
  if i < 3
    hr

mixin anikit-select-options
  each n,i in anikit.groupName
    optgroup(label=n)
      each k in anikit.members[i]
        option(value=k)= k

"""
console.log output
