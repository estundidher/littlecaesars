# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Menu

  constructor: ->
    @$gallery = $('.gallery-content')
    @bind()

  bind: ->
    @$gallery.on 'click', '.element a', @open

  open: (e) =>
    console.log 'menu open pretty foto fired! this: ' + $(e.currentTarget) + ' url: ' + $(e.currentTarget).data('url') + ', title: ' + $(e.currentTarget).data('title') + ', descr: ' + $(e.currentTarget).data('description')
    e.preventDefault();
    $.prettyPhoto.open($(e.currentTarget).data('url'), $(e.currentTarget).data('title'), $(e.currentTarget).data('description'));
    return false

create_menu = ->
  window.Caesars.menu = new Caesars.Menu()

$(document).on 'ready page:load', create_menu