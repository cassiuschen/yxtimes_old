$('[data-toggle="dropdown"]').click ->
  $this = $(this).siblings('.dropdown').show()
  $(document.body).click (e) ->
    if !($this.has(e.target).length or $this.is(e.target))
      $this.hide()
      $(this).off("click")
  return false;
