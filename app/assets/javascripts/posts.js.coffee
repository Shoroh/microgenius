# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $("#post_tag_list").select2
    tags: gon.tag_list
    tokenSeparators: [
      ","
      "."
    ]
  return

$ ->
  $(".fotorama").fotorama
    loop: true,
    maxheight: 1000,
    width: '100%'
  return


$(document).ready(ready)
$(document).on('page:load', ready)


$(document).on "click", ".spoiler-btn", (e) ->
  e.preventDefault()
  $(this).parent().children(".spoiler-body").slideToggle 100
  return

$(document).on "click", "#tag_cloud_edit a", (e) ->
  e.preventDefault()
  txt = $(this).text()
  $("#post_tag_list").select2 "val", $("#post_tag_list").select2("val").concat(txt)
  return