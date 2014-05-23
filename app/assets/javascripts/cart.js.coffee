# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Cart

  constructor: ->
    @$cart = $('.cart')
    @$cart_item = $('.cart-item')
    @bind()

  bind: ->
    @$cart_item.on 'click', '.btn.add', @add_click
    @$cart_item.on 'ajax:success', '.cart-item-form', @add_success
    @$cart_item.on 'ajax:error', '.cart-item-form', @add_error
    @$cart.on 'ajax:success', '.cart-panel .cart-dropdown .cart-item .remove', @remove_success
    @$cart.on 'ajax:error', '.cart-panel .cart-dropdown .cart-item .remove', @remove_error
    @$cart.on 'ajax:success', '.cart-panel .cart-dropdown .checkout', @checkout

  checkout: (e, data, status, xhr) =>
    console.log "cart: checkout fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#modal_container .checkout').modal 'show'

  remove_success: (e, data, status, xhr) =>
    console.log 'cart.button.remove ajax:success fired!'
    $('.btn-cart-md .cart-link .price').hide().empty().append(xhr.responseText).show()

    $cart_item = $('.cart-button .cart-item-' + $(e.target).closest('.cart-item').data('id'))
    if $cart_item?
      $cart_item.slideUp 'slow', ->
        $cart_item.remove()

    $(e.target).closest('.cart-item').slideUp 'slow', ->
      $(e.target).closest('.cart-item').remove()

  remove_error: (e, xhr, status, error) =>
    console.log 'cart.button.error ajax:before fired! Error: ' + error
    alert 'error: ' + error

  reload_price: ->
    $.get($('.btn-cart-md').data('reload-price-url'))
    .done (response) =>
      $('.btn-cart-md .cart-link .price').hide().empty().append(response).show()
    .fail (jqHXR, textStatus) =>
      alert 'ops..'

  add_click: (e) =>
    console.log 'cart: add clicked fired!'
    $button = $('.cart-item .btn.add')
    $button.addClass 'disabled'
    $button.find('.fa-spin').fadeIn 'fast'
    $button.find('.glyphicon').hide()
    $('.cart-item .cart-item-form').submit()

  add_success: (e, data, status, xhr) =>
    console.log 'cart: add success fired!'
    $('.cart-button .cart-dropdown li').last().before(xhr.responseText).prev().hide().slideDown 'slow'
    $('.cart .cart-dropdown li').last().before(xhr.responseText).prev().hide().slideDown 'slow'
    @reload_price()
    $button = $('.cart-item .btn.add')
    $button.removeClass 'disabled'
    $button.find('.fa-spin').fadeOut 'fast', ->
      $button.find('.glyphicon').show()

  add_error: (e, xhr, status, error) =>
    console.log 'cart: add error fired!'
    $('.cart .cart-panel').after xhr.responseText

create_cart = ->
  window.Caesars.cart = new Caesars.Cart()

$(document).on 'ready page:load', create_cart