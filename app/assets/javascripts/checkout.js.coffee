# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Checkout

  constructor: ->
    @$cart = $('.cart-container .cart')
    @bind()

  bind: ->
    @$cart.on 'ajax:success', '.cart-panel .cart-dropdown .checkout', @open

  open: (e, data, status, xhr) =>
    console.log "checkout: open fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#modal_container .checkout').modal 'show'

create_checkout = ->
  window.Caesars.checkout = new Caesars.Checkout()

$(document).on 'ready page:load', create_checkout