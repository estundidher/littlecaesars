# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Product

  constructor: ->
    @$modal_container = $('#modal_container')
    @$prices = $('.product.prices')
    @$messages = $('.messages')
    @$container = $('.container')
    @bind()

  bind: ->
    @$prices.on 'ajax:success', '.price .remove', @remove_success
    @$prices.on 'ajax:error', '.price .remove', @remove_error
    @$prices.on 'ajax:success', '.add', @open
    @$prices.on 'ajax:success', '.price .edit', @edit
    @$modal_container.on 'click', '.price-modal .btn.save', @save
    @$modal_container.on 'ajax:success', '.price-modal form', @save_success
    @$modal_container.on 'ajax:error', '.price-modal form', @save_error
    @$container.on 'change', '.product-reloadable', @load_items

  load_items: (e) =>
    console.log 'product: load items fired!'
    $('#product_options_container').hide().empty()
    $.get($(e.target).data('path'), {id:$(e.target).val()}).done (data) ->
      $('#product_options_container').html(data).fadeIn 'fast'

  remove_success: (e, data, status, xhr) =>
    console.log 'product price: remove success fired!'
    @$prices.hide().empty().append(xhr.responseText).fadeIn 'fast'

  remove_error: (e, xhr, status, error) =>
    console.log "product price: remove error fired!"
    @$messages.hide().empty().append(xhr.responseText).fadeIn 'fast'

  open: (e, data, status, xhr) =>
    console.log 'product price: add fired!'
    @$modal_container.empty().append xhr.responseText
    $('.price-modal').modal 'show'

  save: (e) =>
    console.log 'product price: save fired!'
    $('.price-modal form').submit()

  save_success: (e, data, status, xhr) =>
    console.log 'product price: save success fired!'
    $('.price-modal').modal 'hide'
    @$prices.hide().empty().append(xhr.responseText).fadeIn 'fast'

  save_error: (e, xhr, status, error) =>
    console.log 'product price: save error fired!'
    $('.price-modal .modal-body').hide().empty().append(xhr.responseText).fadeIn 'fast'

  edit: (e, data, status, xhr) =>
    console.log 'product price: edit fired!'
    @$modal_container.empty().append xhr.responseText
    $('.price-modal').modal 'show'

create_product = ->
  window.Caesars.product = new Caesars.Product()

$(document).on 'ready page:load', create_product