# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.CartItem

  constructor: ->
    @$modal_container = $('#modal_container')
    @$cart_item = $('.cart-container .cart-item')
    @$form = @$cart_item.find('.cart-item-form')
    @$mode_form = @$cart_item.find('.mode form')
    @$mode_options = @$mode_form.find('input:radio')
    @$mode_one_flavour = @$mode_form.find('.one-flavour input:radio')
    @$mode_two_flavours = @$mode_form.find('.two-flavours input:radio')
    @$mode_spinner = @$mode_form.find('.fa-spin')
    @price = $('.cart-item .price .value')
    @bind_carousel()
    @bind_pretty_photo()
    @carousel_activate_item '.carousel.slide.vertical'
    @bind()

  bind: ->
    @$cart_item.on 'slide.bs.carousel', '.carousel.slide.vertical', @change_product
    @$cart_item.on 'click', '.categories .dropdown-menu a.left', @change_category
    @$cart_item.on 'ajax:before', '.categories .dropdown-menu a', @change_category_before
    @$cart_item.on 'ajax:success', '.categories .dropdown-menu a', @change_category_success
    @$cart_item.on 'click', '.sizable .dropdown-menu a', @change_size
    @$cart_item.on 'click', '.ingredient .label.label-info i', @ingredient_click
    @$cart_item.on 'click', '.ingredient .label.label-warning i', @remove_topping
    @$mode_options.change @change_mode
    @$mode_form.on 'ajax:success', @change_mode_success

  carousel_activate_item: (carousel) ->
    console.log 'cart-item: carousel_activate_item fired! index: ' + $(carousel).data('active-index')
    if carousel?
      item = $(carousel).find('.item')[$(carousel).data('active-index')];
      $(item).addClass 'active'

    if $(carousel).hasClass('left')
      @$mode_form.find('.product').val $(item).data 'id'

  is_price_defined: ->
    @$cart_item.find('.cart-item-form .left .price').val().trim() != ''

  calculate_price: ->
    console.log 'cart-item: calculate_price fired!'
    if @is_price_defined() is true
      $.post(
        @$cart_item.find('.cart-item-form').data('calculate'),
        @$cart_item.find('.cart-item-form').serialize())
      .done (response) =>
        @price.hide().empty().append(response).slideDown 'fast'
      .fail (jqHXR, textStatus) =>
        alert 'ops..'

  load_product: (item, target) ->
    $item = $(item)
    $details = @$cart_item.find('.' + target + ' .details')

    console.log "cart-item: load_product item: '" + item + "', target: '" + target + "' on " + $details.attr('class')

    if $item.data('id')?
      console.log "cart-item: load_product id: " + $item.data('id') + ', url: ' + $item.data('url') + ', target: ' + target + ', price-id: ' + $item.data('price-id')
      if target == 'left'
        @$mode_form.find('.product').val $item.data 'id'

      $('.cart-item .cart-item-form .' + target + ' .product').val($item.data('id'))
      $('.cart-item .cart-item-form .' + target + ' .price').val($item.data('price-id'))

      $.get($item.data('url'))
      .done (response) =>
        $details.find('.product').hide().empty().html($item.data('name')).fadeIn 'fast'
        $details.find('.img-thumbnail').hide().attr('src', $item.data('photo')).fadeIn 'fast'
        $details.find('.gallery-img-link').attr 'href', $item.data 'photo'
        $('.cart-item .ingredients .' + target + ' .ingredients_container').hide().empty().append(response).fadeIn 'fast'
        if @is_two_flavours_mode() is true
          @calculate_price()
        else
          @price.hide().empty().append($item.data('price-value')).slideDown 'fast'

      .fail (jqHXR, textStatus) =>
        alert 'ops..'
    else
      console.log 'cart-item: load_product id: null. Cleaning up ' + $details.attr('class') + '..'
      $details.find('.product').hide().empty().html('No result').fadeIn 'fast'
      $details.find('.img-thumbnail').hide().attr('src', 'http://placehold.it/204x230/').fadeIn 'fast'
      $details.find('.gallery-img-link').hide()
      @$cart_item.find('.ingredients .' + target + ' .tags').hide().empty()
      @$cart_item.find('.ingredients .' + target).fadeOut 'fast'
      @$cart_item.find('.toppings .' + target).fadeOut 'fast'

  change_product: (e) =>
    console.log "cart-item: .carousel.slide.vertical, 'slid.bs.carousel' fired! current: " + $(e.target).find('.active').index() + ', next: ' + $(e.relatedTarget).index()
    item = $(e.target).find('.item')[$(e.relatedTarget).index()]
    @load_product item, $(item).data('target')

  change_category: (e) =>
    console.log 'cart-item: .categories a clicked! id : ' + $(e.target).data('id')
    if $(e.target).data('id')?
      @$mode_form.find('.size').val('')
      @$mode_form.find('.product').val('')
      @disable_two_flavours()
      @$mode_form.find('.category').val($(e.target).data('id'))
      @$mode_one_flavour.trigger('change');

  change_category_before: (e, data, status, xhr) =>
    console.log "cart-item: .categories a 'ajax:before' fired! category: " + $(e.target).data('name') + ', target: ' + $(e.target).data('target')
    $menu = $(e.target).closest('.btn-group')
    $menu.find('.fa-spin').fadeIn 'fast'
    $menu.find('.name').empty().html $(e.target).data('name')
    $menu.removeClass 'open'

  change_category_success: (e, data, status, xhr) =>
    console.log "cart-item: .categories a 'ajax:success' fired! category: " + $(e.target).data('category') + ', target: ' + $(e.target).data('target')

    $carousel_container = @$cart_item.find('.slider .' + $(e.target).data('target'))
    $carousel_container.hide().empty().append(xhr.responseText).fadeIn 'fast'
    $carousel = $carousel_container.find('.carousel')

    @bind_carousel $carousel
    @carousel_activate_item $carousel
    @load_product($carousel.find('.active'), $(e.target).data('target'))
    $(e.target).closest('.btn-group').find('.fa-spin').fadeOut 'fast'

  change_size: (e) =>
    console.log 'cart-item: .sizable a clicked! id : ' + $(e.target).data('id') + ', name: ' + $(e.target).data('name') + ", splittable: '" + $(e.target).data('splittable') + "'"
    $(e.target).closest('.sizable').find('.name').html $(e.target).data 'name'
    if $(e.target).data('id')?
      @$mode_form.find('.size').val($(e.target).data('id'))
      @$form.find('.size').val($(e.target).data('id'))
      if $(e.target).data('splittable') is true
        console.log 'cart-item: .sizable a clicked! Enabeling two_flavours mode..'
        @$mode_two_flavours.prop('disabled', false)
      else
        @disable_two_flavours()

      @$mode_one_flavour.trigger('change');

  disable_two_flavours: ->
    @$mode_two_flavours.prop('disabled', true)
    @$mode_one_flavour.prop('checked', true)

  change_mode: (e) =>
    console.log "cart-item: .mode_form a 'change' fired!"
    @$mode_spinner.fadeIn 'fast'
    $(e.target).closest('form').submit()

  change_mode_success: (e, data, status, xhr) =>
    console.log "cart-item: .mode form a 'ajax:success' fired!"
    $('.chooser').hide().empty().append(xhr.responseText).fadeIn 'fast'
    @carousel_activate_item carousel for carousel in $('.carousel.slide.vertical')
    @$mode_spinner.fadeOut 'fast'
    @bind_pretty_photo()
    @bind_carousel()
    if @is_two_flavours_mode() is true
      @calculate_price()
    else
      $item = $('.cart-item .carousel .item.active')
      @price.hide().empty().append($item.data('price-value')).slideDown 'fast'

  ingredient_click: (e) =>
    console.log "cart-item: .ingredient .label i 'click' fired! id : " + $(e.target).closest('.ingredient').data 'id'
    if $(e.target).parent().hasClass 'label-info'
      $(e.target).parent().removeClass('label-info').addClass 'label-default'
      $(e.target).closest('.ingredient').find('.additionable').prop('disabled', false)
      $(e.target).removeClass('glyphicon-remove').removeClass('white').addClass 'glyphicon-plus-sign'
    else
      $(e.target).parent().removeClass('label-default').addClass 'label-info'
      $(e.target).closest('.ingredient').find('.additionable').prop('disabled', true)
      $(e.target).removeClass('glyphicon-plus-sign').addClass 'glyphicon-remove white'

  remove_topping: (e) =>
    console.log "cart-item: .ingredient .label-danger i 'click' fired! id : " + $(e.target).closest('.ingredient').data 'id'
    $(e.target).parent().fadeOut 'fast', ->
      console.log 'removing topping ' + $(e.target).closest('.ingredient').data 'id'
      $(e.target).closest('.ingredient').remove()
      window.Caesars.cart_item.calculate_price()

  bind_carousel: (carousel) ->
    if carousel
      console.log "cart-item: bind_carousel '" + $(carousel).attr('class') + "' fired!"
      $carousel = $(carousel)
    else
      console.log "cart-item: bind_carousel fired!"
      $carousel = @$cart_item.find('.carousel.slide.vertical')

    $carousel.carousel({
      interval: false
    })

  bind_pretty_photo: ->
    console.log "cart-item: bind_pretty_photo fired!"
    $prettyLink = @$cart_item.find('.gallery-img-link')
    $prettyLink.prettyPhoto({
      overlay_gallery: false, social_tools: false
    })

  is_two_flavours_mode: ->
    @$cart_item.find('.carousel.slide.vertical').length == 2

  is_one_flavours_mode: ->
    @$cart_item.find('.carousel.slide.vertical').length == 1

create_cart_item = ->
  window.Caesars.cart_item = new Caesars.CartItem()

$(document).on 'ready page:load', create_cart_item