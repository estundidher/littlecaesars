# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Order

  constructor: ->
    @$form = $('.checkout')
    @$spinner = $('.checkout .checkout-form .fa-spin')
    @$ok_sign = $('.checkout .checkout-form .glyphicon-ok-sign')
    @$button = $('.checkout .checkout-form form .btn-primary')
    @$checkout_form = $('.checkout .checkout-form')
    @$order = $('.orders')
    @bind()
    
    # require to check because the bootstrap-validator.js is only loaded on the checkout order page
    if ($("checkoutOrderForm").bootstrap3Validate) && @$button.length > 0
       @validateForm()

  bind: ->
    @$order.on 'click', 'a.print', @print_click
    @$order.on 'click', 'a.print-button', @button_print_click

  button_print_click: (e) =>
    console.log 'Orders - button_print_click: fired!'
    $button = $(e.target)
    $button.addClass 'disabled'
    $button.find('.fa-spin').fadeIn 'fast'
    $button.find('.glyphicon').hide()
    $url = $(e.target).data('url')
    $.getJSON($url)
      .done (json) =>
        @send_to_print json, (=> @enable_button($button)), (=> @error_button($button))
      .fail (jqHXR, textStatus) =>
        alert 'ops..'

  error_button: (button) =>
    console.log 'Orders - enable_button: fired!'
    button.removeClass 'disabled'
    button.find('.fa-spin').fadeOut 'fast', ->
      button.find('.glyphicon-exclamation-sign').show()

  enable_button: (button) =>
    console.log 'Orders - enable_button: fired!'
    button.removeClass 'disabled'
    button.find('.fa-spin').fadeOut 'fast', ->
      button.find('.glyphicon-print').show()

  print_click: (e) =>
    $url = $(e.target).data('url')
    unless $url?
      $url = $(e.target).parent().data('url')
    console.log 'Orders - print: cliked! ' + $url
    $('.print-modal').modal 'show'
    $.getJSON($url)
      .done (json) =>
        @send_to_print json, null, null
      .fail (jqHXR, textStatus) =>
        alert 'ops..'

  print: (url, callback) =>
    console.log 'Orders - print: fired! URL: ' + url
    $.getJSON(url)
      .done (json) =>
        @send_to_print json, => @printed(callback)
      .fail (jqHXR, textStatus) =>
        alert 'ops..'

  printed: (callback) =>
    console.log 'Orders - printed: fired! CALLBACK: ' + callback
    $.get (callback)
        .fail (jqHXR, textStatus) =>
          alert data

  append: (builder, item, half = false) =>
    unless item.properties.size_name?
      builder.addText(item.properties.product_name)
              .addTextPosition(410).addText('$').addText(item.unit_price).addText('0').addFeed()
    else
      if half
        builder.addText('1/2 ')
      builder.addText(item.properties.product_name).addFeed()
      unless half
        if item.properties.size_name?
          builder.addText(item.properties.size_name)
        builder.addTextPosition(410)
               .addText('$').addText(item.unit_price).addText('0').addFeed()

    if item.additions?
      for key, value of item.additions
        do ->
          builder.addTextStyle false, false, true, undefined
          builder.addText(' WITH ').addText(key).addTextPosition(410).addText('$').addText(value).addText('0').addFeed()

    if item.subtractions?
      for key, value of item.subtractions
        do ->
          builder.addTextStyle false, false, true, undefined
          builder.addText(' NO ').addText(key).addFeed()

    builder.addTextStyle false, false, false, undefined

  send_to_print: (order, callback, error_callback) =>

    console.log 'Orders - print: fired! order: ' + order.code

    now = new Date()

    #create an ePOS-Print Builder object
    builder = new epson.ePOSBuilder()

    line = '------------------------------------------'

    #configure the print character settings
    builder.addTextLang 'en'
    builder.addTextSmooth true
    builder.addTextFont builder.FONT_A
    builder.addTextSize 1, 1
    builder.addTextStyle false, false, true, undefined

    #specify the print data
    builder.addTextAlign builder.ALIGN_CENTER
    builder.addText('LITTLE C\'s AUSTRALIA PTY LTD').addFeed()

    builder.addTextStyle false, false, false, undefined
    builder.addText(order.pick_up.place.name).addFeed()
    builder.addText(order.pick_up.place.address).addFeed()
    builder.addText(order.pick_up.place.phone).addFeed()
    builder.addText('ABN: ').addText(order.pick_up.place.abn).addFeed()
    builder.addTextSize 2, 2
    builder.addText('TAX INVOICE ').addText(order.code).addFeed()

    builder.addTextSize 1, 1
    builder.addText(now.toDateString() + ' ' + now.toTimeString().slice(0, 8)).addFeed().addFeed()

    builder.addText(line).addFeed()

    builder.addTextAlign builder.ALIGN_LEFT
    for item in order.items
      do ->
        Caesars.order.append builder, item, false
        if item.first_half?
          Caesars.order.append builder, item.first_half, true
        if item.second_half?
          Caesars.order.append builder, item.second_half, true
        builder.addFeed()

    builder.addText(line).addFeedLine 2

    builder.addText('SUBTOTAL:').addTextPosition(410).addText('$').addText(order.price).addText('0').addFeed()
    builder.addText('TAX:').addTextPosition(410).addText('$').addText(order.tax).addFeed()
    builder.addText('TOTAL:').addTextPosition(410).addText('$').addText(order.price).addText('0').addFeed()

    builder.addText('NAME: ').addText(order.customer.name).addFeed()
    builder.addText('P/UP TIME: ').addText(order.pick_up.date_s).addFeed()

    builder.addFeedLine 3

    builder.addCut builder.CUT_FEED

    request = builder.toString()

    #Create an ePOS-Print object
    url = '//' + order.pick_up.place.printer_ip_s + '/cgi-bin/epos/service.cgi?devid=' + order.pick_up.place.printer_name + '&timeout=60000'
    epos = new epson.ePOSPrint(url)

    #Send the print document
    epos.send request

    #register callback function
    epos.onreceive = (res) ->
    
       if !res.success
       
         #Obtain the print result and error code
         msg = 'Print ' + (res.success ? 'Success' : 'Failure') + '\nCode:' + res.code + '\nStatus:\n'

         #Obtain the printer status
         asb = res.status

         if asb & epos.ASB_NO_RESPONSE
           msg += ' No printer response\n'

         if asb & epos.ASB_PRINT_SUCCESS
           msg += ' Print complete\n'

         if asb & epos.ASB_DRAWER_KICK
           msg += ' Status of the drawer kick number 3 connector pin = "H"\n'

         if asb & epos.ASB_OFF_LINE
           msg += ' Offline status\n'

         if asb & epos.ASB_COVER_OPEN
           msg += ' Cover is open\n'

         if asb & epos.ASB_PAPER_FEED
           msg += ' Paper feed switch is feeding paper\n'

         if asb & epos.ASB_WAIT_ON_LINE
           msg += ' Waiting for online recovery\n'

         if asb & epos.ASB_PANEL_SWITCH
           msg += ' Panel switch is ON\n'

         if asb & epos.ASB_MECHANICAL_ERR
           msg += ' Mechanical error generated\n'

         if asb & epos.ASB_AUTOCUTTER_ERR
           msg += ' Auto cutter error generated\n'

         if asb & epos.ASB_UNRECOVER_ERR
           msg += ' Unrecoverable error generated\n'

         if asb & epos.ASB_AUTORECOVER_ERR
           msg += ' Auto recovery error generated\n'

         if asb & epos.ASB_RECEIPT_NEAR_END
           msg += ' No paper in the roll paper near end detector\n'

         if asb & epos.ASB_RECEIPT_END
           msg += ' No paper in the roll paper end detector\n'
           
         if asb & epos.ASB_BUZZER
           msg += ' Sounding the buzzer (limited model)\n'

         if asb & epos.ASB_SPOOLER_IS_STOPPED
           msg += ' Stop the spooler\n'
           
         if $('.print-modal')?
           $('.print-modal').find('.modal-body').empty().append msg
       else
         if callback?
            callback()
         else
            $('.print-modal').find('.modal-body').empty()
            $('.print-modal').modal 'hide'

    #register callback function
    epos.onerror = (err) ->
      if $('.print-modal')?
        $('.print-modal').find('.modal-body').empty().append 'Network error occured.'
      if error_callback?
        error_callback()

  validateForm: () =>
    console.log 'order: validateForm fired!'
    
    $("#checkoutOrderForm").bootstrap3Validate (e, data) ->
       e.preventDefault();

       self = $(this);

       $('.progress', self).show();
       $("[type='submit']", self).hide();
       $(".alert-danger", self).hide();

       $.ajax(
       ).done (response) =>
           Caesars.order.submit(self[0])
       .fail (jqHXR, textStatus) =>
           $('.alert-danger', self).text('Error!').show();
       .always () =>
           $('.progress', self).hide();
           $("[type='submit']", self).show();
           
  submit: (e) =>  
    console.log 'order: submit fired!'
    $.get($(e).data('update'))
      .done (response) ->
        Caesars.order.send($(e))
      .fail (jqHXR, textStatus) ->
        Caesars.order.reload()
    return false

  send: (form) =>
    console.log 'order: send fired!'
    @$button.addClass 'disabled'
    @$ok_sign.hide()
    @$spinner.fadeIn 'fast'
    $.post($(form).attr('action'), form.serialize())
      .done (response) ->
        console.log 'order.send: done fired!'
        Caesars.order.reload()
      .fail (jqHXR, textStatus) ->
        console.log 'order.send: fail fired!'
        Caesars.order.reload()

  reload: (path) =>
    console.log 'order.reload: fired!'
    window.location.reload(false)

create_order = ->
  window.Caesars.order = new Caesars.Order()

$(document).on 'ready page:load', create_order