# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $(document).on 'slid', '#sizes_carousel', (e) ->
    console.log '#sizes_carousel slid event fired! id : ' + $('#sizes_carousel .item.active .id').val()
    $('#cart_item_sizable_additionable_price_id').val $('#sizes_carousel .item.active .id').val()
    Cart.calculate_price()

  $(document).on 'click', '.cart-modal .label a', (e) ->
    if $(this).parent().hasClass('label-info')
      $(this).parent().removeClass('label-info').addClass('label-default')
      $(this).find('i').removeClass('glyphicon-remove').removeClass('white').addClass('glyphicon-plus black')
    else
      $(this).parent().removeClass('label-default').addClass('label-info')
      $(this).find('i').removeClass('glyphicon-plus').removeClass('black').addClass('glyphicon-remove white')

  $(document).on 'ajax:success', '.add_to_cart', (e, data, status, xhr) ->
    console.log "add_to_cart 'ajax:success' fired!"
    $('#modal_container').empty().append xhr.responseText
    Application.bind_carousel();
    $('#cart_add_item_modal').modal 'show'

  $(document).on 'click', '.cart_add_item_save', (e) ->
    console.log "cart_add_item_save 'click' fired!"
    $('#cart_add_item_form').submit()

  $(document).on 'ajax:success', '#cart_add_item_modal', (e, data, status, xhr) ->
    console.log "cart_add_item_modal 'ajax:success' fired!"
    $('#cart_add_item_modal').modal 'hide'

  $(document).on 'ajax:success', '#cart_add_item_form', (e, data, status, xhr) ->
    console.log "cart_add_item_form ajax:success fired!"
    $("#cart_add_item_modal").modal 'hide'
    $("#cart_container").hide().empty().append(xhr.responseText).show()
    Application.bind_cart();

  $(document).on 'ajax:error', '#cart_add_item_form', (e, xhr, status, error) ->
    console.log "cart_add_item_form ajax:error fired!"
    $("#cart_add_item_modal_form_container").hide().empty().append(xhr.responseText).fadeIn 'fast'

  $(document).on 'hidden.bs.modal', '#cart_add_item_modal', (e) ->
    console.log "#cart_add_item_modal 'hidden.bs.modal' fired!"
    $('#modal_container').empty()

#cart_item

  $(document).on 'ajax:before', '.cart_item_remove', (event, xhr, settings) ->
    console.log "cart_item_remove ajax:before fired!"
    Application.cart_toggle('fast');

  $(document).on 'ajax:success', '.cart_item_remove', (e, data, status, xhr) ->
    console.log "cart_item_remove ajax:success fired!"
    $("#cart_container").hide().empty().append(xhr.responseText).show()
    Application.bind_cart();

  $(document).on 'ajax:error', '.cart_item_remove', (e, xhr, status, error) ->
    $("#cart_container").hide().empty().append(xhr.responseText).show()
    Application.bind_cart();

#checkout

  $(document).on 'ajax:success', '.cart_add_item_checkout', (e, data, status, xhr) ->
    console.log "cart_add_item_checkout 'ajax:success' fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#checkout_modal').modal 'show'

  $(document).on 'hidden.bs.modal', '#checkout_modal', (e) ->
    console.log "#checkout_modal 'hidden.bs.modal' fired!"
    $('#modal_container').empty()

#toppings

  $(document).on 'change', '.cart_add_item_modal_size', (e) ->
    Cart.calculate_price()

  $(document).on 'click', '#toppings_carousel_button_add', (e) ->

    $remove = $('<i>', {'class': 'glyphicon glyphicon-remove white'})

    $remove.on 'click', ->
      $div = $(this).parent().parent()
      $div.fadeOut 'fast', ->
        $div.remove()
        Cart.calculate_price()

    $addition = $('<div>', {'class': 'addition'}).hide().append(
      $('<span>', {'class': 'label label-warning'})
        .append($('<input>', {type: 'hidden', name:'cart_item_sizable_additionable[addition_ids][]', value: $(this).data("id")}))
        .append($(this).data("name"))
        .append(' (' + $(this).data("price") + ') ')
        .append($remove)).prepend(' ')

    $('#cart_add_item_modal_additions_container').append $addition

    $addition.fadeIn 'fast', ->
      Cart.calculate_price()