# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.CartButton

  constructor: ->
    @$modal_container = $('#modal_container')
    @$cart_button = $('.cart-button')
    @bind()

  bind: ->
    @$cart_button.on 'click', '.btn-cart-md .cart-link', @toggle
    @$cart_button.on 'ajax:before', '.cart-dropdown .cart-item .remove', @remove_before
    @$cart_button.on 'ajax:success', '.cart-dropdown .cart-item .remove', @remove_success
    @$cart_button.on 'ajax:error', '.cart-dropdown .cart-item .remove', @remove_error
    @$cart_button.on 'ajax:success', '.cart-dropdown .checkout', @checkout

  toggle: (e, speed) =>
    e.preventDefault();
    $dd_menu = $('.btn-cart-md .cart-dropdown');
    if $dd_menu.hasClass 'open'
      $dd_menu.fadeOut speed
      $dd_menu.removeClass 'open'
    else
      $dd_menu.fadeIn speed
      $dd_menu.addClass 'open'

  remove_before: (e, xhr, settings) =>
    console.log 'cart.button.remove ajax:before fired!'
    @toggle e, 'fast'

  remove_success: (e, data, status, xhr) =>
    console.log 'cart.button.remove ajax:success fired!'
    $('.cart-button').hide().empty().append(xhr.responseText).show()

  remove_error: (e, xhr, status, error) =>
    console.log 'cart.button.error ajax:before fired! Error: ' + error
    $('.cart-button').hide().empty().append(xhr.responseText).show()
    @toggle e, 'fast'

  checkout: (e, data, status, xhr) =>
    console.log "cart.button.checkout fired!"
    @toggle e, 'fast'
    $('#modal_container').empty().append xhr.responseText
    $('#modal_container .checkout').modal 'show'

create_cart_button = ->
  window.Caesars.cart_button = new Caesars.CartButton()

$(document).on 'ready page:load', create_cart_button