# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Cart

  constructor: ->
    @$modal_container = $('#modal_container')
    @$cart = $('.cart')
    @$form = @$cart.find('.cart-item-form')
    @$cart_panel = @$cart.find('.cart-panel')
    @$mode_form = @$cart.find('.mode form')
    @$mode_options = @$mode_form.find('input:radio')
    @$mode_one_flavour = @$mode_form.find('.one-flavour input:radio')
    @$mode_two_flavours = @$mode_form.find('.two-flavours input:radio')
    @$mode_spinner = @$mode_form.find('.fa-spin')
    @price = $('.cart .price .value')
    @bind_carousel()
    @bind_pretty_photo()
    @carousel_activate_item '.carousel.slide.vertical'
    @bind()

  bind: ->
    @$cart.on 'slide.bs.carousel', '.carousel.slide.vertical', @change_product
    @$cart.on 'click', '.categories .dropdown-menu a.left', @change_category
    @$cart.on 'ajax:before', '.categories .dropdown-menu a', @change_category_before
    @$cart.on 'ajax:success', '.categories .dropdown-menu a', @change_category_success
    @$cart.on 'click', '.sizable .dropdown-menu a', @change_size
    @$cart.on 'click', '.ingredient .label i', @ingredient_click
    @$cart.on 'click', '.ingredient .label-warning i', @remove_topping

    @$cart.on 'click', '.btn.add', @add_click
    @$cart.on 'ajax:success', '.cart-item-form', @add_success
    @$cart.on 'ajax:error', '.cart-item-form', @add_error

    @$cart.on 'ajax:success', '.cart-panel .cart-dropdown .cart-item .remove', @remove_success
    @$cart.on 'ajax:error', '.cart-panel .cart-dropdown .cart-item .remove', @remove_error

    @$mode_options.change @change_mode
    @$mode_form.on 'ajax:success', @change_mode_success

  remove_success: (e, data, status, xhr) =>
    console.log 'cart.button.remove ajax:success fired!'
    $('.btn-cart-md .cart-link .price').hide().empty().append(xhr.responseText).show()
    $(e.target).closest('.cart-item').slideUp 'slow', ->
      $(e.target).closest('.cart-item').remove()

  remove_error: (e, xhr, status, error) =>
    console.log 'cart.button.error ajax:before fired! Error: ' + error
    $('.btn-cart-md .cart-link .price').hide().empty().append(xhr.responseText).show()
    alert 'error'

  carousel_activate_item: (carousel) ->
    console.log 'cart: carousel_activate_item fired! index: ' + $(carousel).data('active-index')
    if carousel?
      item = $(carousel).find('.item')[$(carousel).data('active-index')];
      $(item).addClass 'active'

    if $(carousel).hasClass('left')
      @$mode_form.find('.product').val $(item).data 'id'

  reload_price: ->
    $.get($('.cart-panel').data('reload-price-url'))
    .done (response) =>
      $('.btn-cart-md .cart-link .price').hide().empty().append(response).show()
    .fail (jqHXR, textStatus) =>
      alert 'ops..'

  is_price_defined: ->
    @$cart.find('.cart-item-form .left .price').val().trim() != ''

  calculate_price: ->
    console.log 'cart: calculate_price fired!'
    if @is_price_defined() is true
      $.post(
        @$cart.find('.cart-item-form').data('calculate'),
        @$cart.find('.cart-item-form').serialize())
      .done (response) =>
        @price.hide().empty().append(response).slideDown 'fast'
      .fail (jqHXR, textStatus) =>
        alert 'ops..'

  load_product: (item, target) ->
    $item = $(item)
    $details = @$cart.find('.' + target + ' .details')

    console.log "cart: load_product item: '" + item + "', target: '" + target + "' on " + $details.attr('class')

    if $item.data('id')?
      console.log "cart: load_product id: " + $item.data('id') + ', url: ' + $item.data('url') + ', target: ' + target + ', price-id: ' + $item.data('price-id')
      if target == 'left'
        @$mode_form.find('.product').val $item.data 'id'

      $('.cart .cart-item-form .' + target + ' .product').val($item.data('id'))
      $('.cart .cart-item-form .' + target + ' .price').val($item.data('price-id'))

      $.get($item.data('url'))
      .done (response) =>
        $details.find('.product').hide().empty().html($item.data('name')).fadeIn 'fast'
        $details.find('.img-thumbnail').hide().attr('src', $item.data('photo')).fadeIn 'fast'
        $details.find('.gallery-img-link').attr 'href', $item.data 'photo'
        $('.cart .ingredients .' + target + ' .tags').hide().empty().append(response).fadeIn 'fast'
        if @is_two_flavours_mode() is true
          @calculate_price()
        else
          @price.hide().empty().append($item.data('price-value')).slideDown 'fast'

      .fail (jqHXR, textStatus) =>
        alert 'ops..'
    else
      console.log 'cart: load_product id: null. Cleaning up ' + $details.attr('class') + '..'
      $details.find('.product').hide().empty().html('No result').fadeIn 'fast'
      $details.find('.img-thumbnail').hide().attr('src', 'http://placehold.it/204x230/').fadeIn 'fast'
      $details.find('.gallery-img-link').hide()
      @$cart.find('.ingredients .' + target + ' .tags').hide().empty()
      @$cart.find('.ingredients .' + target).fadeOut 'fast'
      @$cart.find('.toppings .' + target).fadeOut 'fast'

  change_product: (e) =>
    console.log "cart: .cart .carousel.slide.vertical, 'slid.bs.carousel' fired! current: " + $(e.target).find('.active').index() + ', next: ' + $(e.relatedTarget).index()
    item = $(e.target).find('.item')[$(e.relatedTarget).index()]
    @load_product item, $(item).data('target')

  change_category: (e) =>
    console.log 'cart: .categories a clicked! id : ' + $(e.target).data('id')
    if $(e.target).data('id')?
      @$mode_form.find('.size').val('')
      @$mode_form.find('.product').val('')
      @disable_two_flavours()
      @$mode_form.find('.category').val($(e.target).data('id'))
      @$mode_one_flavour.trigger('change');

  change_category_before: (e, data, status, xhr) =>
    console.log "cart: .categories a 'ajax:before' fired! category: " + $(e.target).data('name') + ', target: ' + $(e.target).data('target')
    $menu = $(e.target).closest('.btn-group')
    $menu.find('.fa-spin').fadeIn 'fast'
    $menu.find('.name').empty().html $(e.target).data('name')
    $menu.removeClass 'open'

  change_category_success: (e, data, status, xhr) =>
    console.log "cart: .categories a 'ajax:success' fired! category: " + $(e.target).data('category') + ', target: ' + $(e.target).data('target')

    $carousel_container = @$cart.find('.slider .' + $(e.target).data('target'))
    $carousel_container.hide().empty().append(xhr.responseText).fadeIn 'fast'
    $carousel = $carousel_container.find('.carousel')

    @bind_carousel $carousel
    @carousel_activate_item $carousel
    @load_product($carousel.find('.active'), $(e.target).data('target'))
    $(e.target).closest('.btn-group').find('.fa-spin').fadeOut 'fast'

  change_size: (e) =>
    console.log 'cart: .sizable a clicked! id : ' + $(e.target).data('id') + ', name: ' + $(e.target).data('name') + ", splittable: '" + $(e.target).data('splittable') + "'"
    $(e.target).closest('.sizable').find('.name').html $(e.target).data 'name'
    if $(e.target).data('id')?
      @$mode_form.find('.size').val($(e.target).data('id'))
      @$form.find('.size').val($(e.target).data('id'))
      if $(e.target).data('splittable') is true
        console.log 'cart: .sizable a clicked! Enabeling two_flavours mode..'
        @$mode_two_flavours.prop('disabled', false)
      else
        @disable_two_flavours()

      @$mode_one_flavour.trigger('change');

  disable_two_flavours: ->
    @$mode_two_flavours.prop('disabled', true)
    @$mode_one_flavour.prop('checked', true)

  change_mode: (e) =>
    console.log "cart: .mode_form a 'change' fired!"
    @$mode_spinner.fadeIn 'fast'
    $(e.target).closest('form').submit()

  change_mode_success: (e, data, status, xhr) =>
    console.log "cart: .mode form a 'ajax:success' fired!"
    $('.chooser').hide().empty().append(xhr.responseText).fadeIn 'fast'
    @carousel_activate_item carousel for carousel in $('.carousel.slide.vertical')
    @$mode_spinner.fadeOut 'fast'
    @bind_pretty_photo()
    @bind_carousel()
    @calculate_price()

  ingredient_click: (e) =>
    console.log "cart: .ingredient .label i 'click' fired! id : " + $(e.target).closest('.ingredient').data 'id'
    if $(e.target).parent().hasClass 'label-info'
      $(e.target).parent().removeClass('label-info').addClass 'label-default'
      $(e.target).closest('.ingredient').find('.additionable').prop('disabled', false)
      $(e.target).removeClass('glyphicon-remove').removeClass('white').addClass 'glyphicon-plus-sign'
    else
      $(e.target).parent().removeClass('label-default').addClass 'label-info'
      $(e.target).closest('.ingredient').find('.additionable').prop('disabled', true)
      $(e.target).removeClass('glyphicon-plus-sign').addClass 'glyphicon-remove white'

  remove_topping: (e) =>
    console.log "cart: .ingredient .label-danger i 'click' fired! id : " + $(e.target).closest('.ingredient').data 'id'
    $(e.target).parent().fadeOut 'fast', ->
      console.log 'removing topping ' + $(e.target).closest('.ingredient').data 'id'
      $(e.target).closest('.topping').remove()
      window.Caesars.cart.calculate_price()

  add_click: (e) =>
    console.log 'cart: add clicked fired!'
    $button = $('.cart .btn.add')
    $button.addClass 'disabled'
    $button.find('.fa-spin').fadeIn 'fast'
    $button.find('.glyphicon').hide()
    $('.cart .cart-item-form').submit()

  add_success: (e, data, status, xhr) =>
    console.log 'cart: add success fired!'
    $('.cart-button .cart-dropdown li').last().before(xhr.responseText).prev().hide().slideDown 'slow'
    $('.cart .cart-dropdown li').last().before(xhr.responseText).prev().hide().slideDown 'slow'
    @reload_price()
    $button = $('.cart .btn.add')
    $button.removeClass 'disabled'
    $button.find('.fa-spin').fadeOut 'fast', ->
      $button.find('.glyphicon').show()

  add_error: (e, xhr, status, error) =>
    console.log 'cart: add error fired!'
    $('.cart .cart-panel').after xhr.responseText

  bind_carousel: (carousel) ->
    if carousel
      console.log "cart: bind_carousel '" + $(carousel).attr('class') + "' fired!"
      $carousel = $(carousel)
    else
      console.log "cart: bind_carousel fired!"
      $carousel = @$cart.find('.carousel.slide.vertical')

    $carousel.carousel({
      interval: false
    })

  bind_pretty_photo: ->
    console.log "cart: bind_pretty_photo fired!"
    $prettyLink = @$cart.find('.gallery-img-link')
    $prettyLink.prettyPhoto({
      overlay_gallery: false, social_tools: false
    })

  is_two_flavours_mode: ->
    $('.carousel.slide.vertical').length == 2

  is_one_flavours_mode: ->
    $('.carousel.slide.vertical').length == 1

create_cart = ->
  window.Caesars.cart = new Caesars.Cart()

$(document).on 'ready page:load', create_cart