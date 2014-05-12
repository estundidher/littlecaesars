# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Price

  constructor: ->
    @$modal_container = $('#modal_container')
    @$prices = $('.product.prices')
    @$messages = $('.messages')
    @bind()

  bind: ->
    @$prices.on 'ajax:error', '.price .remove', @remove_error
    @$prices.on 'ajax:success', '.price .remove', @remove_success
    @$prices.on 'ajax:success', '.add', @open
    @$prices.on 'ajax:success', '.price .edit', @edit
    @$modal_container.on 'click', '.price-modal .btn.save', @save
    @$modal_container.on 'ajax:success', '.price-modal form', @save_success
    @$modal_container.on 'ajax:error', '.price-modal form', @save_error

  remove_success: (e, data, status, xhr) =>
    console.log 'price: remove success fired!'
    @$prices.hide().empty().append(xhr.responseText).fadeIn 'fast'

  remove_error: (e, xhr, status, error) =>
    console.log "price: remove error fired!"
    @$messages.hide().empty().append(xhr.responseText).fadeIn 'fast'

  open: (e, data, status, xhr) =>
    console.log 'price: add fired!'
    @$modal_container.empty().append xhr.responseText
    $('.price-modal').modal 'show'

  save: (e) =>
    console.log 'price: save fired!'
    $('.price-modal form').submit()

  save_success: (e, data, status, xhr) =>
    console.log 'price: save success fired!'
    $('.price-modal').modal 'hide'
    @$prices.hide().empty().append(xhr.responseText).fadeIn 'fast'

  save_error: (e, xhr, status, error) =>
    console.log 'price: save error fired!'
    $('.price-modal .modal-body').hide().empty().append(xhr.responseText).fadeIn 'fast'

  edit: (e, data, status, xhr) =>
    console.log 'price: edit fired!'
    @$modal_container.empty().append xhr.responseText
    $('.price-modal').modal 'show'

create_price = ->
  window.Caesars.price = new Caesars.Price()

$(document).on 'ready page:load', create_price