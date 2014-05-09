# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.CartModal

  constructor: ->
    @$modal_container = $('#modal_container')
    @$add_to_cart_button = $('.add_to_cart')
    @$cart_item_modal = $('.cart-modal')
    @$cart_item_form = $('.cart_item_form')
    @bind()

  bind: ->
    @$modal_container.on 'change', '.cart_add_item_modal_quantity', @calculate_price
    @$add_to_cart_button.on 'ajax:success', @open
    @$modal_container.on 'click', '.cart-modal .save', @save
    @$modal_container.on 'ajax:success', '.cart-modal .cart_item_form', @save_success
    @$modal_container.on 'ajax:error', '.cart-modal .cart_item_form', @save_error

  fill: (content) ->
    @$modal_container.empty().append content

  open: (e, data, status, xhr) =>
    console.log 'cart.modal: open_cart_modal fired!'
    @fill xhr.responseText
    $('#modal_container .cart-modal').modal 'show'

  calculate_price: (e) =>
    console.log 'cart.modal: calculate_price fired!'
    $.post $(e.target).data('url'), $('.cart-modal .cart_item_form').serialize(), (data) =>
      $('.cart-modal .item-price').hide().empty().append(data).slideDown 'fast'

  save: (e) =>
    console.log 'cart.modal: moda_save fired!'
    $('#modal_container .cart-modal .cart_item_form').submit()

  save_success: (e, data, status, xhr) =>
    console.log 'cart.modal: moda_save_sucess fired!'
    $('#modal_container .cart-modal').modal 'hide'
    $('.cart-button').hide().empty().append(xhr.responseText).show()

  save_error: (e, xhr, status, error) =>
    console.log 'cart.modal: moda_save_error fired!'
    $('#modal_container .cart-modal .cart_item_form_container').hide().empty().append(xhr.responseText).fadeIn 'fast'

create_cart_modal = ->
  window.Caesars.cart_modal = new Caesars.CartModal()

$(document).on 'page:load', create_cart_modal
$(document).ready create_cart_modal