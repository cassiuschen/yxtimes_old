$('[data-toggle="dropdown"]').click ->
  $this = $(this)
  $this.siblings('.dropdown').show()
  $(document.body).click (e) ->
    if !($this.has(e.target).length or $this.is(e.target))
      $this.siblings('.dropdown').hide()
      $(this).off("click")
