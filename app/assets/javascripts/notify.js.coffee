$(() ->
  for flash in gon.flash
  
    $.notify(flash["message"],
      globalPosition: "bottom right"
      className: "info"
    )
)
