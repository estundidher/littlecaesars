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
    @$carousel.on 'ajax:before', '.places a', @place_chosen_before
    @$carousel.on 'ajax:success', '.places a', @place_chosen_success

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

  place_chosen_before: (e, data, status, xhr) =>
    console.log "pick up: .places a 'ajax:before' fired!"

  place_chosen_success: (e, data, status, xhr) =>
    console.log "pick up: .places a 'ajax:success' fired!"

    $('.pick-up .carousel .when').empty().append(xhr.responseText).fadeIn 'fast', ->
      $('.pick-up .carousel').carousel 'next'

create_pick_up = ->
  window.Caesars.pick_up = new Caesars.PickUp()

$(document).on 'ready page:load', create_pick_up