# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->

#modal

  $('#modal_container').on 'change', '.cart_add_item_modal_quantity', (e) ->
    Cart.calculate_price()

  $('.add_to_cart').on 'ajax:success', (e, data, status, xhr) ->
    console.log "add_to_cart 'ajax:success' fired!"
    $('#modal_container').empty().append xhr.responseText
    Application.bind_carousel()
    Application.bind_tabs()
    $('#cart_add_item_modal').modal 'show'

  $('#modal_container').on 'click', '.cart_add_item_save', (e) ->
    console.log "cart_add_item_save 'click' fired!"
    $('#cart_add_item_form').submit()

  $('#modal_container').on 'ajax:success', '#cart_add_item_modal', (e, data, status, xhr) ->
    console.log "cart_add_item_modal 'ajax:success' fired!"
    $('#cart_add_item_modal').modal 'hide'

  $('#modal_container').on 'ajax:success', '#cart_add_item_form', (e, data, status, xhr) ->
    console.log "cart_add_item_form ajax:success fired!"
    $("#cart_add_item_modal").modal 'hide'
    $("#cart_container").hide().empty().append(xhr.responseText).show()
    Application.bind_cart()

  $('#modal_container').on 'ajax:error', '#cart_add_item_form', (e, xhr, status, error) ->
    console.log "cart_add_item_form ajax:error fired!"
    $("#cart_add_item_modal_form_container").hide().empty().append(xhr.responseText).fadeIn 'fast'

  $('#modal_container').on 'hidden.bs.modal', '#cart_add_item_modal', (e) ->
    console.log "#cart_add_item_modal 'hidden.bs.modal' fired!"
    $('#modal_container').empty()

#top/cart

  $('#cart_container').on 'ajax:before', '.cart_item_remove', (event, xhr, settings) ->
    console.log "cart_item_remove ajax:before fired!"
    Application.cart_toggle('fast')

  $('#cart_container').on 'ajax:success', '.cart_item_remove', (e, data, status, xhr) ->
    console.log "cart_item_remove ajax:success fired!"
    $("#cart_container").hide().empty().append(xhr.responseText).show()
    Application.bind_cart()

  $('#cart_container').on 'ajax:error', '.cart_item_remove', (e, xhr, status, error) ->
    $("#cart_container").hide().empty().append(xhr.responseText).show()
    Application.bind_cart()

#checkout

  $('modal_container').on 'ajax:success', '.cart_add_item_checkout', (e, data, status, xhr) ->
    console.log "cart_add_item_checkout 'ajax:success' fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#checkout_modal').modal 'show'

  $('modal_container').on 'hidden.bs.modal', '#checkout_modal', (e) ->
    console.log "#checkout_modal 'hidden.bs.modal' fired!"
    $('#modal_container').empty()

#additions

  $('.chooser').on 'click', '.addition .label i', ->
    console.log ".addition .label i 'click' fired! id : " + $(this).closest('.addition').data 'id'
    if $(this).parent().hasClass 'label-info'
      $(this).parent().removeClass('label-info').addClass 'label-default'
      $(this).removeClass('glyphicon-remove').removeClass('white').addClass 'glyphicon-plus-sign'
    else
      $(this).parent().removeClass('label-default').addClass 'label-info'
      $(this).removeClass('glyphicon-plus-sign').addClass 'glyphicon-remove white'

  $('modal_container').on 'change', '.cart_add_item_modal_size', (e) ->
    Cart.calculate_price()

  $('modal_container').on 'click', '#toppings_carousel_button_add', (e) ->
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

# slider

  loadProduct = (item) ->
    $item = $(item)
    console.log "loadProduct id: " + $item.data('id') + ', url: ' + $item.data('url') + ', target: ' + $item.data('target')
    if $item.data('target') == 'left'
      $('.mode_chooser_form .product').val $item.data('id')

    $.get $item.data('url'), (data) ->
      $('.chooser .' + $item.data('target') + ' .product').hide().empty().html($item.data('name')).fadeIn 'fast'
      $('.chooser .' + $item.data('target') + ' .img-thumbnail').hide().attr('src', $item.data('photo')).fadeIn 'fast'
      $('.chooser .' + $item.data('target') + ' .gallery-img-link').attr('href', $item.data('photo'))
      $('.chooser .' + $item.data('target') + ' .additions').hide().empty().append(data).fadeIn 'fast'

  $('.chooser').on 'slide.bs.carousel', '.carousel.splitter, .carousel.slider', (e) ->
    console.log ".splitter, .slider 'slid.bs.carousel' fired! current: " + $(this).find('.active').index() + ', next: ' + $(e.relatedTarget).index()
    loadProduct $(this).find('.item')[$(e.relatedTarget).index()]

  $('.chooser').on 'ajax:before', '.categories a', (e, data, status, xhr) ->
    console.log ".categories a 'ajax:before' fired! category: " + $(this).data('category') + ', target: ' + $(this).data('target')
    $menu = $(this).closest('.btn-group')
    $menu.find('.loader').fadeIn 'fast'
    $menu.find('.category').empty().html($(this).data('category'))
    $menu.removeClass 'open'

  $('.chooser').on 'ajax:success', '.categories a', (e, data, status, xhr) ->
    console.log ".categories a 'ajax:success' fired! category: " + $(this).data('category') + ', target: ' + $(this).data('target')
    $('.chooser .carousel.' + $(this).data('target')).parent().hide().empty().append(xhr.responseText).fadeIn 'fast'
    Application.bind_carousel()
    loadProduct $('.chooser .carousel.' + $(this).data('target')).find '.active'
    Application.bind_prettyPhoto()
    $(this).closest('.btn-group').find('.loader').fadeOut 'fast'

#size chooser

  $('.container').on 'click', '.sizable .dropdown-menu a', (e) ->
    console.log '.sizable a clicked! id : ' + $(this).data('id') + ', name: ' + $(this).data('name')
    $(this).closest('.sizable .price_id').find('.price_id').val $(this).data 'id'
    $(this).closest('.sizable').find('.name').html $(this).data 'name'

#mode chooser

  $('.mode_chooser').change (e) ->
    console.log ".mode_chooser a 'change' fired!"
    $('.mode_chooser_form .loader').fadeIn 'fast'
    $(this).closest('form').submit()
    $.get $(this).data('url'), (data) ->
      $('#sizes_container').hide().empty().append(data).fadeIn 'fast'

  $('.mode_chooser_form').on 'ajax:success', (e, data, status, xhr) ->
    console.log ".mode_chooser_form a 'ajax:success' fired!"
    $('.chooser_container').hide().empty().append(xhr.responseText).fadeIn 'fast'
    Application.bind_carousel();
    Application.bind_prettyPhoto()
    $('.mode_chooser_form .loader').fadeOut 'fast'






