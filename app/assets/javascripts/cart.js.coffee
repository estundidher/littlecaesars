# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Cart

  constructor: ->
    @$modal_container = $('#modal_container')
    @$cart = $('.cart')
    @$form = @$cart.find('.cart-item-form')
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
    @$cart.on 'click', '.ingredient .label i', @click_ingredient
    @$cart.on 'click', '.ingredient .label-warning i', @remove_topping
    @$mode_options.change @change_mode
    @$mode_form.on 'ajax:success', @change_mode_success

  carousel_activate_item: (carousel) ->
    console.log 'cart: carousel_activate_item fired! index: ' + $(carousel).data('active-index')
    if carousel?
      item = $(carousel).find('.item')[$(carousel).data('active-index')];
      $(item).addClass 'active'

    if $(carousel).hasClass('left')
      @$mode_form.find('.product').val $(item).data 'id'

  is_price_defined: ->
    @$form.find('.left .price').val().trim() != ''

  calculate_price: (target) ->
    if @is_price_defined() is true
      console.log 'cart: calculate_price fired!'
      $.post(
        @$cart.find('.cart-item-form').data('calculate'),
        @$cart.find('.cart-item-form').serialize())
      .done (response) =>
        @price.hide().empty().append(response).slideDown 'fast'
      .fail (jqHXR, textStatus) =>
        alert('error')

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
        $('.cart .ingredients .' + target + ' .tags').hide().empty().append(response).fadeIn 'fast', ->
          window.Caesars.cart.calculate_price()
      .fail (jqHXR, textStatus) =>
        alert('error')
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

  click_ingredient: (e) =>
    console.log "cart: .ingredient .label i 'click' fired! id : " + $(e.target).closest('.ingredient').data 'id'
    if $(e.target).parent().hasClass 'label-info'
      $(e.target).parent().removeClass('label-info').addClass 'label-default'
      $(e.target).removeClass('glyphicon-remove').removeClass('white').addClass 'glyphicon-plus-sign'
    else
      $(e.target).parent().removeClass('label-default').addClass 'label-info'
      $(e.target).removeClass('glyphicon-plus-sign').addClass 'glyphicon-remove white'

  remove_topping: (e) =>
    console.log "cart: .ingredient .label-danger i 'click' fired! id : " + $(e.target).closest('.ingredient').data 'id'
    $(e.target).parent().fadeOut 'fast', ->
      console.log 'removing topping ' + $(e.target).closest('.ingredient').data 'id'
      $(e.target).closest('.topping').remove()
      window.Caesars.cart.calculate_price()

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

create_cart = ->
  window.Caesars.cart = new Caesars.Cart()

$(document).on 'ready page:load', create_cart