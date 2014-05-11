# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.CartToppings

  constructor: ->
    @$chooser = $('.chooser')
    @$modal_container = $('#modal_container')
    @bind()

  bind: ->
    @$chooser.on 'ajax:before', '.additions form', @before_open
    @$chooser.on 'ajax:success', '.additions form', @open
    @$modal_container.on 'click', '.toppings-modal .available .btn.add', @add
    @$modal_container.on 'ajax:success', '.toppings-modal .added form', @add_success
    @$modal_container.on 'ajax:error', '.toppings-modal .added form', @add_error
    @$modal_container.on 'click', '.toppings-modal .added .btn.remove', @remove
    @$modal_container.on 'click', '.toppings-modal .modal-footer .btn.save', @add_to_cart

  before_open: (e, data, status, xhr) =>
    console.log 'toppings modal: before_open fired!'
    $button = $(e.target).find('.btn')
    if $button?
      $button.addClass 'disabled'
      $button.find('.fa-spin').fadeIn 'fast'
      $button.find('.glyphicon-plus-sign').hide()

  open: (e, data, status, xhr) =>
    console.log 'toppings modal: open fired!'
    @$modal_container.empty().append xhr.responseText
    $('#modal_container .toppings-modal').modal 'show'
    @bind_carousel $('.toppings-modal .carousel')
    $button = $(e.target).find('.btn')
    if $button?
      $button.removeClass 'disabled'
      $button.find('.fa-spin').hide()
      $button.find('.glyphicon-plus-sign').fadeIn 'slow'

  calculate_price: (e) ->
    console.log 'toppings modal: calculate_price fired!'
    $.post $('.toppings-modal .added form').data('calculate-url'), $('.toppings-modal .added form').serialize(), (data) =>
      $('.toppings-modal .price').hide().empty().append(data).slideDown 'fast'

  add: (e) =>
    console.log "toppings modal: .available .btn.add fired. id: " + $(e.target).data 'id'
    if $(e.target).data('id')?
      $(e.target).addClass 'disabled'
      $(e.target).find('.glyphicon-plus-sign').hide()
      $(e.target).find('.fa-spin').fadeIn 'fast'
      $('.toppings-modal .added form #product_id').val $(e.target).data('id')
      $('.toppings-modal .added form').submit()

  add_success: (e, data, status, xhr) =>
    console.log "toppings modal: .available .btn.add 'ajax:success' fired! "
    $('.toppings-modal .added form').append(xhr.responseText).find('.col-md-2').last().hide().fadeIn('slow')
    @calculate_price()
    $spin = $('.available .fa-spin:visible')
    if $spin?
      $spin.parent().removeClass 'disabled'
      $spin.parent().find('.glyphicon-plus-sign').fadeIn 'slow'
      $spin.hide()

  add_error: (e, xhr, status, error) =>
    console.log "toppings modal: .available .btn.add 'ajax:error' fired! "
    $('.toppings-modal .modal-footer .warning').hide().empty().append(xhr.responseText).fadeIn 'fast'
    $spin = $('.available .fa-spin:visible')
    if $spin?
      $spin.parent().removeClass 'disabled'
      $spin.parent().find('.glyphicon-plus-sign').fadeIn 'fast'
      $spin.hide()

  add_to_cart: (e) =>
    console.log "toppings modal: .modal-footer .btn.save fired!"
    $.post $('.toppings-modal .added form').data('add-url'), $('.toppings-modal .added form').serialize(), (data) =>
      $('#modal_container .toppings-modal').modal 'hide'
      $('.additions.' + $('.toppings-modal .added form #side').val() + ' .topping').remove()
      $('.additions.' + $('.toppings-modal .added form #side').val() + ' .selected').append(data)
      $('.additions.' + $('.toppings-modal .added form #side').val() + ' .selected .topping').hide().fadeIn('slow')

  remove: (e) =>
    console.log "toppings modal: remove_topping fired! id: " + $(e.target).data('id')
    if $(e.target).data('id')?
      $(e.target).closest('.col-md-2').fadeOut 'slow', ->
        $(e.target).closest('.col-md-2').remove()
      $('.toppings-modal .modal-footer .warning').empty()
      @calculate_price()

  is_splitter: ->
    $('.carousel.slide.vertical').length == 2

  is_slider: ->
    $('.carousel.slide.vertical').length == 1

  bind_carousel: (carousel) ->
    if carousel
      console.log "toppings modal: bind_carousel '" + $(carousel).attr('class') + "' fired!"
      $carousel = $(carousel)
    else
      console.log "toppings modal: bind_carousel fired!"
      $carousel = $('.chooser .carousel.slide.vertical')

    $carousel.carousel({
      interval: false
    })

#  $('modal_container').on 'click', '#toppings_carousel_button_add', (e) ->
#    $remove = $('<i>', {'class': 'glyphicon glyphicon-remove white'})
#    $remove.on 'click', ->
#      $div = $(this).parent().parent()
#      $div.fadeOut 'fast', ->
#        $div.remove()
#        Cart.calculate_price()
#    $addition = $('<div>', {'class': 'addition'}).hide().append(
#      $('<span>', {'class': 'label label-warning'})
#        .append($('<input>', {type: 'hidden', name:'cart_item_sizable_additionable[addition_ids][]', value: $(this).data("id")}))
#        .append($(this).data("name"))
#        .append(' (' + $(this).data("price") + ') ')
#        .append($remove)).prepend(' ')
#    $('#cart_add_item_modal_additions_container').append $addition
#    $addition.fadeIn 'fast', ->
#      Cart.calculate_price()

create_cart_toppings = ->
  window.Caesars.cart_toppings = new Caesars.CartToppings()

$(document).on 'ready page:load', create_cart_toppings