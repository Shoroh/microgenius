# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('[data-spy="scroll"]').each ->
    $spy = $(this).scrollspy('refresh')
  $(".fotorama").fotorama
    loop: true,
    maxheight: 1000,
    width: '100%'
  $("#post_tag_list").select2
    tags: gon.tag_list
    tokenSeparators: [
      ","
      "."
    ]
  $("#post_geolocation_list").select2(
    tags: gon.geolocation_list
    tokenSeparators: [
      ","
      "."
    ])
  .on "select-blur", (e) ->
    codeAddress()
  return

$ ->
  elems = Array::slice.call(document.querySelectorAll(".js-switch"))
  elems.forEach (html) ->
    switchery = new Switchery(html, { color: '#41b7f1' })


$(document).on "click", ".spoiler-btn", (e) ->
  e.preventDefault()
  $(this).parent().children(".spoiler-body").slideToggle 100
  return

$(document).on "click", "#tag_cloud_edit a", (e) ->
  e.preventDefault()
  txt = $(this).text()
  $("#post_tag_list").select2 "val", $("#post_tag_list").select2("val").concat(txt)
  return

$(document).ready ->
  $("#my-affix").affix offset:
    top: 65
  $("[data-toggle]").click ->
    toggle_el = $(this).data("toggle")
    $(toggle_el).toggleClass "open-sidebar"
  $("[data-clampedwidth]").each ->
    elem = $(this)
    parentPanel = elem.data("clampedwidth")
    resizeFn = ->
      sideBarNavWidth = $(parentPanel).width()
      elem.css "width", sideBarNavWidth
      return
    resizeFn()
    $(window).resize resizeFn
    return
  return

$(document).ready(ready)