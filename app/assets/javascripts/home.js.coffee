# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Home

  constructor: ->
    @$modal_container = $('#modal_container')
    @$footer = $('.footer')
    @bind()

  bind: ->
    @$footer.on 'ajax:success', '.footer-copyright .terms a', @open

  fill: (content) ->
    @$modal_container.empty().append content

  open: (e, data, status, xhr) =>
    console.log 'home: open term fired!'
    @fill xhr.responseText
    $('#modal_container .term').modal 'show'

create_home = ->
  window.Caesars.home = new Caesars.Home()

$(document).on 'ready page:load', create_home