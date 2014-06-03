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
    @$carousel.on 'ajax:before', '.places a', @place_chosen_before
    @$carousel.on 'ajax:success', '.places a', @place_chosen_success

    @$pick_up.on 'change', '.when .dates select', @date_chosen

  date_chosen: (e) =>
    console.log "pick up: date_chosen fired! path: " + $(e.target).find('option:selected').data('path')
    if $(e.target).find('option:selected').data('path')
      $('.pick-up .when .fa-spin').fadeIn 'fast'
      $.get($(e.target).find('option:selected').data('path'))
      .done (response) ->
        console.log 'pick up: date_chosen done fired!'
        $('.pick-up .when .times').hide().empty().append(response).fadeIn 'fast', ->
          $('.pick-up .when .fa-spin').fadeOut 'fast'
      .fail (jqHXR, textStatus) ->
        alert 'ops..'

  place_chosen_before: (e, data, status, xhr) =>
    console.log "pick up: .places a 'ajax:before' fired!"

  place_chosen_success: (e, data, status, xhr) =>
    console.log "pick up: .places a 'ajax:success' fired!"

    $('.pick-up .carousel .when').empty().append(xhr.responseText).fadeIn 'fast', ->
      $('.pick-up .carousel').carousel 'next'

create_pick_up = ->
  window.Caesars.pick_up = new Caesars.PickUp()

$(document).on 'ready page:load', create_pick_up