# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $(document).on 'change', '.product_reloadable', ->
    console.log "product_reloadable change fired!"
    $('#product_options_container').hide().empty()
    $.get($(this).data('path'), {id:$(this).val()}).done (data) ->
      $('#product_options_container').html(data).fadeIn 'fast'

  $(document).on 'ajax:success', '.add_price', (e, data, status, xhr) ->
    console.log "add_price fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#price_modal').modal 'show'

  $(document).on 'ajax:success', '.alter_price', (e, data, status, xhr) ->
    console.log "alter_price fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#price_modal').modal 'show'

  $(document).on 'ajax:success', '.remove_price', (e, data, status, xhr) ->
    console.log "remove_price fired!"
    $('#products_prices_list_container').hide().empty()
                                        .append(xhr.responseText)
                                        .fadeIn 'fast'

  $(document).on 'click', '.price_modal_save', ->
    console.log "price_form_modal_save click fired!"
    $('#price_form').submit()

  $(document).on 'ajax:success', '#price_form', (e, data, status, xhr) ->
    console.log "price_form ajax:success fired!"
    $("#price_modal").modal 'hide'
    $("#products_prices_list_container").hide().empty()
                                        .append(xhr.responseText)
                                        .fadeIn 'fast'

  $(document).on 'ajax:error', '#price_form', (e, xhr, status, error) ->
    console.log "price_form ajax:error fired!"
    $("#price_modal_form_container").hide().empty()
                                    .append(xhr.responseText)
                                    .fadeIn 'fast'

  $(document).on 'hidden.bs.modal', '#price_modal', (e) ->
    console.log "hidden.bs.modal fired!"
    $('#modal_container').empty()