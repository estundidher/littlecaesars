# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.meiomask').setMask({mask:'99.999', type:'reverse', maxLength: 6})

$ ->
  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    $("#modal_container").empty().append xhr.responseText
    $("#price_modal").modal 'show'