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
    @bind()

  bind: ->
    @$form.on 'submit', '.checkout-form form', @submit

  submit: (e) =>
    console.log 'order: submit fired!'
    @send $(e.target)
    return false

  send: (form) =>
    console.log 'order: send fired!'
    @$button.addClass 'disabled'
    @$ok_sign.hide
    @$spinner.fadeIn 'fast'
    $.post(form.attr('action'), form.serialize())
      .done (response) ->
        location.href = form.data('success')
      .fail (jqHXR, textStatus) ->
        console.log 'order: fail fired!'
        @$spinner.fadeOut 'fast', ->
          @$ok_sign.show()
          @$button.removeClass 'disabled'
          alert 'ops..'

create_order = ->
  window.Caesars.order = new Caesars.Order()

$(document).on 'ready page:load', create_order