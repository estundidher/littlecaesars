# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Shift

  constructor: ->
    @$modal_container = $('#modal_container')
    @bind()

  bind: ->
    @$modal_container.on 'click', '#opening_hour_modal .btn.add-shift', @add
    @$modal_container.on 'click', '#opening_hour_modal .shift .remove', @remove
    @$modal_container.on 'click', '#opening_hour_modal .shift .delete', @delete

  add: (e) =>
    console.log 'admin.places.opening-hours.shift: add fired!'
    $.post($('#opening_hour_modal form').data('add-shift'),
           $('#opening_hour_modal form').serialize())
      .done (response) ->
        console.log 'admin.places.opening-hours.shift: add success fired!'
        $('#opening_hour_modal .shifts .shift').find('.remove,.delete').prop 'disabled', true
        $('#opening_hour_modal .shifts .shift').last().after(response).hide().fadeIn 'fast'
        Application.bind_dateTimePickers();
      .fail (jqHXR, textStatus) ->
        alert 'ops..'

  remove: (e) =>
    e.preventDefault();
    console.log 'admin.places.opening-hours.shift: remove fired!'
    $('#opening_hour_modal .shifts .shift').last().prev().find('.remove,.delete').prop 'disabled', false
    $('#opening_hour_modal .shifts .shift').last().fadeOut('fast').remove()

  delete: (e) =>
    e.preventDefault();
    console.log 'admin.places.opening-hours.shift: delete fired: e: ' + e  + ', target:' + $(e.target).attr('class') + ', data: ' + $(e.target).data('path')
    if $(e.target).data('path')
      $.ajax(
        url: $(e.target).data('path'),
        type: 'DELETE'
        dataType: 'text'
      ).done (response) =>
        console.log 'admin.places.opening-hours.shift: delete done fired!'
        @remove(e)
      .fail (jqHXR, textStatus) =>
        alert 'ops..'

create_shift = ->
  window.Caesars.shift = new Caesars.Shift()

$(document).on 'ready page:load', create_shift