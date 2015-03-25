# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Checkout

  constructor: ->
    @$checkout = $('#modal_container')
    @$cart = $('.cart-container .cart')
    @bind()

  bind: ->
    @$cart.on 'ajax:success', '.cart-panel .cart-dropdown .checkout', @open
    @$checkout.on 'click', '.checkout form .btn.btn-info', @checkout_click

  checkout_click: (e) =>
    console.log 'Checkout - checkout_click: fired!'
    $button = $(e.target)
    $button.addClass 'disabled'
    $button.find('.fa-spin').fadeIn 'fast'
    $button.find('.glyphicon').hide()
    $button.parent().submit()

  open: (e, data, status, xhr) =>
    console.log "checkout: open fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#modal_container .checkout').modal 'show'

create_checkout = ->
  window.Caesars.checkout = new Caesars.Checkout()

$(document).on 'ready page:load', create_checkout