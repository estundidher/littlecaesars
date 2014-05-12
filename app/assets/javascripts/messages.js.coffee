# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Messages

  constructor: ->
    @$container = $('.messages')
    @bind()

  bind: ->
    @$container.on 'click', '.alert .alert-link', @more

  more: (e) =>
    console.log 'messages: more fired!'
    $('.messages .alert .details').toggle()

create_messages = ->
  window.Caesars.messages = new Caesars.Messages()

$(document).on 'ready page:load', create_messages