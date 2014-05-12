# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $(document).on 'change', '.product_reloadable', ->
    console.log "product_reloadable change fired!"
    $('#product_options_container').hide().empty()
    $.get($(this).data('path'), {id:$(this).val()}).done (data) ->
      $('#product_options_container').html(data).fadeIn 'fast'