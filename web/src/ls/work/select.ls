input = ld$.find document, 'input', 0
menu = ld$.find document, '.item'
input.addEventListener \click, (e) -> e.stopPropagation!
input.addEventListener \keyup, (e) ->
  menu.map -> it.classList.toggle \d-none, (!(~it.textContent.indexOf(input.value)))

