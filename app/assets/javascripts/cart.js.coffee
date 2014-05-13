# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Cart

  constructor: ->
    @$modal_container = $('#modal_container')
    @$container = $('.container')
    @$chooser = $('.chooser')
    @$mode_chooser = $('.mode_chooser')
    @$mode_chooser_form = $('.mode_chooser_form')
    @bind_carousel()
    @bind_pretty_photo()
    @carousel_activate_item '.carousel.slide.vertical'
    @bind()

  bind: ->
    @$chooser.on 'slide.bs.carousel', '.carousel.slide.vertical', @show_product
    @$chooser.on 'ajax:before', '.categories .dropdown-menu a', @change_category_before
    @$chooser.on 'ajax:success', '.categories .dropdown-menu a', @change_category_success
    @$container.on 'click', '.sizable .dropdown-menu a', @change_size
    @$chooser.on 'click', '.addition .label i', @click_addition
    @$chooser.on 'click', '.addition .label-warning i', @remove_topping
    @$mode_chooser.change @change_mode
    @$mode_chooser_form.on 'ajax:success', @change_mode_success

  carousel_activate_item: (splitter) ->
    console.log 'cart: carousel_activate_item fired! index: ' + $(splitter).data('active-index')
    if splitter?
      item = $(splitter).find('.item')[$(splitter).data('active-index')];
      $(item).addClass 'active'

    if $(splitter).hasClass('left')
      $('.mode_chooser_form .product').val $(item).data 'id'

  load_product: (item) ->
    $item = $(item)
    console.log "cart: load_product id: " + $item.data('id') + ', url: ' + $item.data('url') + ', target: ' + $item.data('target')
    if $item.data('target') == 'left'
      $('.mode_chooser_form .product').val $item.data 'id'

    $.get $item.data('url'), (data) ->
      $('.chooser .' + $item.data('target') + ' .product').hide().empty().html($item.data('name')).fadeIn 'fast'
      $('.chooser .' + $item.data('target') + ' .img-thumbnail').hide().attr('src', $item.data('photo')).fadeIn 'fast'
      $('.chooser .' + $item.data('target') + ' .gallery-img-link').attr 'href', $item.data 'photo'
      $('.chooser .' + $item.data('target') + '.ingredients .selected').hide().empty().append(data).fadeIn 'fast'

  show_product: (e) =>
    console.log "cart: .carousel.splitter, .carousel.slider 'slid.bs.carousel' fired! current: " + $(e.target).find('.active').index() + ', next: ' + $(e.relatedTarget).index()
    @load_product $(e.target).find('.item')[$(e.relatedTarget).index()]

  change_category_before: (e, data, status, xhr) =>
    $(this).data('params', {size_id: $('#size_id').val()})
    console.log "cart: .categories a 'ajax:before' fired! category: " + $(e.target).data('name') + ', target: ' + $(e.target).data('target')
    $menu = $(e.target).closest('.btn-group')
    $menu.find('.fa-spin').fadeIn 'fast'
    $menu.find('.name').empty().html $(e.target).data('name')
    $menu.removeClass 'open'

  change_category_success: (e, data, status, xhr) =>
    console.log "cart: .categories a 'ajax:success' fired! category: " + $(e.target).data('category') + ', target: ' + $(e.target).data('target')
    $('.chooser .carousel.' + $(e.target).data('target')).parent().hide().empty().append(xhr.responseText).fadeIn 'fast'
    @bind_carousel $('.chooser .carousel.' + $(e.target).data('target'))
    @carousel_activate_item '.chooser .carousel.' + $(e.target).data 'target'
    @load_product $('.chooser .carousel.' + $(e.target).data('target')).find '.active'
    $(e.target).closest('.btn-group').find('.fa-spin').fadeOut 'fast'

  change_size_before: (e, data, status, xhr) =>
    console.log "cart: .sizable a 'ajax:before' fired! category: " + $(e.target).data('name') + ', target: ' + $(e.target).data('target')
    $menu = $(e.target).closest('.btn-group')
    $menu.find('.fa-spin').fadeIn 'fast'
    $menu.find('.name').empty().html $(e.target).data('name')
    $menu.removeClass 'open'

  change_size_success: (e, data, status, xhr) =>
    console.log "cart: .sizable a 'ajax:success' fired! category: " + $(e.target).data('category') + ', target: ' + $(e.target).data('target')
    $('.chooser .carousel.' + $(e.target).data('target')).parent().hide().empty().append(xhr.responseText).fadeIn 'fast'
    @bind_carousel $('.chooser .carousel.' + $(e.target).data('target'))
    @carousel_activate_item '.chooser .carousel.' + $(e.target).data 'target'
    @load_product $('.chooser .carousel.' + $(e.target).data('target')).find '.active'
    $(e.target).closest('.btn-group').find('.fa-spin').fadeOut 'fast'

  change_size: (e) =>
    console.log 'cart: .sizable a clicked! id : ' + $(e.target).data('id') + ', name: ' + $(e.target).data('name') + ", splittable: '" + $(e.target).data('splittable') + "'"
    $(e.target).closest('.sizable').find('.name').html $(e.target).data 'name'
    $(e.target).closest('.sizable').find('.name').html $(e.target).data 'name'
    if $(e.target).data('id')?
      $('.mode_chooser_form #size_id').val($(e.target).data('id'))
      if $(e.target).data('splittable') is true
        console.log 'cart: .sizable a clicked! Is splittable. enabeling mode splitter..'
        $('.mode_chooser_form .splitter').prop('disabled', false)
      else
        $('.mode_chooser_form .splitter').prop('disabled', true)
        $('.mode_chooser_form .slider').prop('checked', true)

      $('.mode_chooser_form .slider').trigger('change');

  change_mode: (e) =>
    console.log "cart: .mode_chooser a 'change' fired!"
    $('.mode_chooser_form .fa-spin').fadeIn 'fast'
    $(e.target).closest('form').submit()

  change_mode_success: (e, data, status, xhr) =>
    console.log "cart: .mode_chooser_form a 'ajax:success' fired!"
    $('.chooser').hide().empty().append(xhr.responseText).fadeIn 'fast'
    @carousel_activate_item carousel for carousel in $('.carousel.slide.vertical')
    $('.mode_chooser_form .fa-spin').fadeOut 'fast'
    @bind_pretty_photo()
    @bind_carousel()

  is_splitter: ->
    $('.carousel.slide.vertical').length == 2

  is_slider: ->
    $('.carousel.slide.vertical').length == 1

  click_addition: (e) =>
    console.log "cart: .addition .label i 'click' fired! id : " + $(e.target).closest('.addition').data 'id'
    if $(e.target).parent().hasClass 'label-info'
      $(e.target).parent().removeClass('label-info').addClass 'label-default'
      $(e.target).removeClass('glyphicon-remove').removeClass('white').addClass 'glyphicon-plus-sign'
    else
      $(e.target).parent().removeClass('label-default').addClass 'label-info'
      $(e.target).removeClass('glyphicon-plus-sign').addClass 'glyphicon-remove white'

  remove_topping: (e) =>
    console.log "cart: .addition .label-danger i 'click' fired! id : " + $(e.target).closest('.addition').data 'id'
    $(e.target).parent().fadeOut 'fast', ->
      console.log 'removing topping..'
      $(e.target).closest('.topping').remove()

  bind_carousel: (carousel) ->
    if carousel
      console.log "cart: bind_carousel '" + $(carousel).attr('class') + "' fired!"
      $carousel = $(carousel)
    else
      console.log "cart: bind_carousel fired!"
      $carousel = $('.chooser .carousel.slide.vertical')

    $carousel.carousel({
      interval: false
    })

  bind_pretty_photo: ->
    console.log "cart: bind_pretty_photo fired!"
    $('.chooser .gallery-img-link').prettyPhoto({
      overlay_gallery: false, social_tools: false
    })

create_cart = ->
  window.Caesars.cart = new Caesars.Cart()

$(document).on 'ready page:load', create_cart