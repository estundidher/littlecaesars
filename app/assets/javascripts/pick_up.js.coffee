# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.PickUp

  constructor: ->
    @$pick_up = $('.pick-up')
    @$carousel = @$pick_up.find('.carousel')
    @bind()

  bind: ->
    @$carousel.on 'slid.bs.carousel', @slide

  slide: =>
    $idx = @$carousel.find('.item.active').index();

    console.log "pick up: slide fired!"

    $next = @$pick_up.find('.btn.next')
    $prev = @$pick_up.find('.btn.prev')

    @$pick_up.find('.carousel-indicators li')
    @$pick_up.find('.carousel-indicators li').removeClass 'active'
    item = @$pick_up.find('.carousel-indicators li')[$idx]
    $(item).addClass 'active'

    $prev.removeClass 'disabled'
    $next.removeClass 'disabled'

    if $idx == (@$carousel.find('.item').length - 1)
      $next.addClass 'disabled'
    else if $idx == 0
      $prev.addClass 'disabled'

create_pick_up = ->
  window.Caesars.pick_up = new Caesars.PickUp()

$(document).on 'ready page:load', create_pick_up