# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.OpeningHour

  constructor: ->
    @$modal_container = $('#modal_container')
    @$places = $('.admin .places')
    @bind()

  bind: ->
    @$places.on 'ajax:success', '.opening-hours .add', @add_success
    @$places.on 'ajax:success', '.opening-hours .alter', @edit_success
    @$places.on 'ajax:success', '.opening-hours .remove', @remove_success

    @$modal_container.on 'click', '#opening_hour_modal .btn-primary', @save
    @$modal_container.on 'ajax:success', '#opening_hour_modal form', @save_success
    @$modal_container.on 'ajax:error', '#opening_hour_modal form', @save_error

  add_success: (e, data, status, xhr) =>
    console.log 'admin.places.opening-hours: add_success fired!'
    $('#modal_container').empty().append xhr.responseText
    Application.bind_dateTimePickers();
    $('#opening_hour_modal').modal 'show'

  edit_success: (e, data, status, xhr) =>
    console.log 'admin.places.opening-hours: edit_success fired!'
    $('#modal_container').empty().append xhr.responseText
    Application.bind_dateTimePickers();
    $('#opening_hour_modal').modal 'show'

  remove_success: (e, data, status, xhr) =>
    console.log 'admin.places.opening-hours: remove_success fired!'
    @$places.find('.opening-hours').hide().empty()
                                   .append(xhr.responseText)
                                   .fadeIn 'fast'

  save: (e) =>
    console.log 'admin.places.opening-hours: save click fired!'
    $('#opening_hour_modal form').submit()

  save_success: (e, data, status, xhr) =>
    console.log 'admin.places.opening-hours: save_success fired!'
    $('#opening_hour_modal').modal 'hide'
    @$places.find('.opening-hours').hide().empty()
                                   .append(xhr.responseText)
                                   .fadeIn 'fast'

  save_error: (e, xhr, status, error) =>
    console.log 'admin.places.opening-hours: save_error fired!'
    $("#opening_hour_modal .modal-body").hide().empty().append(xhr.responseText).fadeIn 'fast'
    Application.bind_dateTimePickers();

create_opening_hour = ->
  window.Caesars.opening_hour = new Caesars.OpeningHour()

$(document).on 'ready page:load', create_opening_hour