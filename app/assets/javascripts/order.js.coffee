# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Order

  constructor: ->
    @$form = $('.checkout')
    @$spinner = $('.checkout .checkout-form .fa-spin')
    @$ok_sign = $('.checkout .checkout-form .glyphicon-ok-sign')
    @$button = $('.checkout .checkout-form form .btn-primary')
    @$checkout_form = $('.checkout .checkout-form')
    @bind()

  bind: ->
    @$form.on 'submit', '.checkout-form form', @submit

  submit: (e) =>
    console.log 'order: submit fired!'
    $.get($(e.target).data('update'))
      .done (response) ->
        Caesars.order.send($(e.target))
      .fail (jqHXR, textStatus) ->
        alert 'ops..'
    return false

  send: (form) =>
    console.log 'order: send fired!'
    @$button.addClass 'disabled'
    @$ok_sign.hide()
    @$spinner.fadeIn 'fast'
    $.post($(form).attr('action'), form.serialize())
      .done (response) ->
        console.log 'order.send: done fired!'
        Caesars.order.reload(form.data('reload'))
      .fail (jqHXR, textStatus) ->
        console.log 'order.send: fail fired!'
        Caesars.order.reload(form.data('reload'))

  reload: (path) =>
    console.log 'order.reload: fired!'
    $.get(path)
      .done (response) ->
        $('.checkout .checkout-form').hide().empty().append(response).fadeIn 'fast'
      .fail (jqHXR, textStatus) ->
        alert 'ops..'

create_order = ->
  window.Caesars.order = new Caesars.Order()

$(document).on 'ready page:load', create_order