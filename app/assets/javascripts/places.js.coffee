# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $(document).on 'ajax:success', '.add_opening_hour', (e, data, status, xhr) ->
    console.log "add_opening_hour fired!"
    $('#modal_container').empty().append xhr.responseText
    Application.bind_dateTimePickers();
    $('#opening_hour_modal').modal 'show'

  $(document).on 'ajax:success', '.alter_opening_hour', (e, data, status, xhr) ->
    console.log "alter_opening_hour fired!"
    $('#modal_container').empty().append xhr.responseText
    Application.bind_dateTimePickers();
    $('#opening_hour_modal').modal 'show'

  $(document).on 'ajax:success', '.remove_opening_hour', (e, data, status, xhr) ->
    console.log "remove_opening_hour fired!"
    $('#place_opening_hours_list_container').hide()
                                            .empty()
                                            .append(xhr.responseText)
                                            .fadeIn 'fast'

  $(document).on 'click', '.opening_hour_modal_save', ->
    console.log "opening_hour_modal_save click fired!"
    $('#opening_hour_form').submit()

  $(document).on 'ajax:success', '#opening_hour_form', (e, data, status, xhr) ->
    console.log "opening_hour_form ajax:success fired!"
    $("#opening_hour_modal").modal 'hide'
    $("#place_opening_hours_list_container").hide()
                                            .empty()
                                            .append(xhr.responseText)
                                            .fadeIn 'fast'

  $(document).on 'ajax:error', '#opening_hour_form', (e, xhr, status, error) ->
    console.log "opening_hour_form ajax:error fired!"
    $("#opening_hour_modal_form_container").hide().empty().append(xhr.responseText).fadeIn 'fast'
    Application.bind_dateTimePickers();

  $(document).on 'hidden.bs.modal', '#opening_hour_modal', (e) ->
    console.log "#opening_hours_modal hidden.bs.modal fired!"
    $('#modal_container').empty()

# -------- shifts

  $(document).on 'ajax:before', '.add_shift', (event, xhr, settings) ->
    console.log "add_shift 'ajax:before' fired!"
    $(this).data('params', { shifts: $('#opening_hour_shifts_container .row').size() });

  $(document).on 'ajax:success', '.add_shift', (e, data, status, xhr) ->
    console.log "add_shift 'ajax:success' fired!"
    $('#opening_hour_shifts_container .row').last().find('.remove_shift,.delete_shift').prop 'disabled', true
    $('#opening_hour_shifts_container .row').last().after xhr.responseText
    Application.bind_dateTimePickers();

  $(document).on 'ajax:success', '.delete_shift', (e, data, status, xhr) ->
    console.log ".delete_shift click fired!"
    $('#opening_hour_shifts_container .row').last().prev().find('.remove_shift,.delete_shift').prop 'disabled', false
    $(this).closest('.row').fadeOut('fast').remove()

  $(document).on 'click', '.remove_shift', (e) ->
    console.log ".remove_shift click fired!"
    $('#opening_hour_shifts_container .row').last().prev().find('.remove_shift,.delete_shift').prop 'disabled', false
    $(this).closest('.row').fadeOut('fast').remove()