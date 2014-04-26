# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $('#s3_uploader').S3Uploader
    remove_completed_progress_bar: false
    progress_bar_target: $('#uploads_container')
    allow_multiple_files: false

  $(document).on 's3_uploads_start', '#s3_uploader', (e) ->
    console.log 's3_uploads_start fired!'

  $(document).on 's3_upload_failed', '#s3_uploader', (e, content) ->
    console.log 's3_upload_failed fired!'
    alert content.filename + ' failed to upload'

  $(document).on 's3_upload_complete', '#s3_uploader', (e, content) ->
    console.log 's3_upload_complete fired!'
    $('#product_direct_upload_url').val(content.url);
    $('#product_attached_file_file_name').val(content.filename);
    $('#product_attached_file_file_path').val(content.filepath);
    $('#product_attached_file_file_size').val(content.filesize);
    $('#product_attached_file_content_type').val(content.filetype);
    alert 's3_upload_complete fired! Content.url: ' + content.url

  $(document).on 'ajax:success', '.add_price', (e, data, status, xhr) ->
    console.log "add_price fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#price_modal').modal 'show'

  $(document).on 'ajax:success', '.alter_price', (e, data, status, xhr) ->
    console.log "alter_price fired!"
    $('#modal_container').empty().append xhr.responseText
    $('#price_modal').modal 'show'

  $(document).on 'ajax:success', '.remove_price', (e, data, status, xhr) ->
    console.log "remove_price fired!"
    $('#products_prices_list_container').hide()
                                      .empty()
                                      .append(xhr.responseText)
                                      .fadeIn 'fast'

  $(document).on 'click', '.price_modal_save', ->
    console.log "price_form_modal_save click fired!"
    $('#price_form').submit()

  $(document).on 'ajax:success', '#price_form', (e, data, status, xhr) ->
    console.log "price_form ajax:success fired!"
    $("#price_modal").modal 'hide'
    $("#products_prices_list_container").hide()
                                        .empty()
                                        .append(xhr.responseText)
                                        .fadeIn 'fast'

  $(document).on 'ajax:error', '#price_form', (e, xhr, status, error) ->
    console.log "price_form ajax:error fired!"
    $("#price_modal_form_container").hide()
                                    .empty()
                                    .append(xhr.responseText)
                                    .fadeIn 'fast'

  $(document).on 'hidden.bs.modal', '#price_modal', (e) ->
    console.log "hidden.bs.modal fired!"
    $('#modal_container').empty()