# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $(document).on 'click', '.cart_add_item_modal_size', (e) ->
    console.log 'cart_add_item_modal_size. clicked! id : ' + $(this).data('id')
    $('.cart_item_sizable_price_id').val $(this).data('id')
    $('#cart_add_item_modal_size_name').html $(this).data('name')
    if $(this).data('splittable')
      $('.splittable .btn').removeClass 'disabled'
    else
      if !$('.splittable .btn').hasClass 'disabled'
        $('.splittable .btn').addClass 'disabled'
    Cart.calculate_price()

  $(document).on 'change', '.cart_add_item_modal_quantity', (e) ->
    Cart.calculate_price()

  $(document).on 'click', '.addition .label i', (e) ->
    console.log ".addition .label i 'click' fired! id : " + $(this).closest('.addition').data 'id'
    if $(this).parent().hasClass 'label-info'
      $(this).parent().removeClass('label-info').addClass 'label-default'
      $(this).removeClass('glyphicon-remove').removeClass('white').addClass 'glyphicon-plus-sign'
    else
      $(this).parent().removeClass('label-default').addClass 'label-info'
      $(this).removeClass('glyphicon-plus-sign').addClass 'glyphicon-remove white'

  $(document).on 'ajax:success', '.add_to_cart', (e, data, status, xhr) ->
    console.log "add_to_cart 'ajax:success' fired!"
    $('#modal_container').empty().append xhr.responseText
    Application.bind_carousel()
    Application.bind_tabs()
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
    Application.bind_cart()

  $(document).on 'ajax:error', '#cart_add_item_form', (e, xhr, status, error) ->
    console.log "cart_add_item_form ajax:error fired!"
    $("#cart_add_item_modal_form_container").hide().empty().append(xhr.responseText).fadeIn 'fast'

  $(document).on 'hidden.bs.modal', '#cart_add_item_modal', (e) ->
    console.log "#cart_add_item_modal 'hidden.bs.modal' fired!"
    $('#modal_container').empty()

#cart_item

  $(document).on 'ajax:before', '.cart_item_remove', (event, xhr, settings) ->
    console.log "cart_item_remove ajax:before fired!"
    Application.cart_toggle('fast')

  $(document).on 'ajax:success', '.cart_item_remove', (e, data, status, xhr) ->
    console.log "cart_item_remove ajax:success fired!"
    $("#cart_container").hide().empty().append(xhr.responseText).show()
    Application.bind_cart()

  $(document).on 'ajax:error', '.cart_item_remove', (e, xhr, status, error) ->
    $("#cart_container").hide().empty().append(xhr.responseText).show()
    Application.bind_cart()

#checkout

  $(document).on 'ajax:success', '.cart_add_item_checkout', (e, data, status, xhr) ->
    console.log "cart_add_item_checkout 'ajax:success' fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#checkout_modal').modal 'show'

  $(document).on 'hidden.bs.modal', '#checkout_modal', (e) ->
    console.log "#checkout_modal 'hidden.bs.modal' fired!"
    $('#modal_container').empty()

#additions

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

# splitter
loadProduct = (item) ->
  $item = $(item)
  console.log "loadProduct id: " + $item.data('id') + ', url: ' + $item.data('url') + ', target: ' + $item.data('target')
  if $item.data('target') == 'left'
    $('.mode_chooser_form .product').val($item.data('id'))

  $.get $item.data('url'), (data) ->
    $('.chooser .' + $item.data('target') + ' .product').hide().empty().html($item.data('name')).fadeIn 'fast'
    $('.chooser .' + $item.data('target') + ' .img-thumbnail').hide().attr('src', $item.data('photo')).fadeIn 'fast'
    $('.chooser .' + $item.data('target') + ' .gallery-img-link').attr('href', $item.data('photo'))
    $('.chooser .' + $item.data('target') + ' .additions').hide().empty().append(data).fadeIn 'fast'

$(document).on 'slide.bs.carousel', '.splitter, .slider', (e)->
  console.log ".splitter, .slider 'slid.bs.carousel' fired! current: " + $(this).find('.active').index() + ', next: ' + $(e.relatedTarget).index()
  loadProduct $(this).find('.item')[$(e.relatedTarget).index()]

$(document).on 'ajax:before', '.categories a', (e, data, status, xhr) ->
  console.log ".categories a 'ajax:before' fired! category: " + $(this).data('category') + ', target: ' + $(this).data('target')
  $menu = $(this).closest('.btn-group')
  $menu.find('.loader').fadeIn 'fast'
  $menu.find('.category').empty().html($(this).data('category'))
  $menu.removeClass 'open'

$(document).on 'ajax:success', '.categories a', (e, data, status, xhr) ->
  console.log ".categories a 'ajax:success' fired! category: " + $(this).data('category') + ', target: ' + $(this).data('target')
  $('.chooser .carousel.' + $(this).data('target')).parent().hide().empty().append(xhr.responseText).fadeIn 'fast'
  Application.bind_carousel()
  loadProduct $('.chooser .carousel.' + $(this).data('target')).find '.active'
  Application.bind_prettyPhoto()
  $(this).closest('.btn-group').find('.loader').fadeOut 'fast'

#chooser_mode
$(document).on 'change', '.mode_chooser', (e) ->
  console.log ".mode_chooser a 'change' fired!"
  $('.mode_chooser_form .loader').fadeIn 'fast'
  $(this).closest('form').submit()

$(document).on 'ajax:success', '.mode_chooser_form', (e, data, status, xhr) ->
  console.log ".mode_chooser_form a 'ajax:success' fired!"
  $('.chooser_container').hide().empty().append(xhr.responseText).fadeIn 'fast'
  Application.bind_carousel();
  Application.bind_prettyPhoto()
  $('.mode_chooser_form .loader').fadeOut 'fast'








