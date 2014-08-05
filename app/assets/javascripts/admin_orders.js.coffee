# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Orders

  constructor: ->
    @$order = $('.orders')
    @bind()

  bind: ->
    @$order.on 'click', '.print', @print_click

  print_click: (e) =>
    console.log 'Orders - print: cliked! ' + $(e.target).parent().data('url')

    $.getJSON($(e.target).parent().data('url'))
      .done (response) =>
        @print response
      .fail (jqHXR, textStatus) =>
        alert 'ops..'

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

  print: (order) =>

    $('.print-modal').modal 'show'

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
    builder.addText('LITTLE CAESARS').addFeed()

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
        Caesars.orders.append builder, item
        if item.first_half?
          Caesars.orders.append builder, item.first_half, true
        if item.second_half?
          Caesars.orders.append builder, item.second_half, true
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
    url = 'http://' + order.pick_up.place.printer_ip_s + '/cgi-bin/epos/service.cgi?devid=' + order.pick_up.place.printer_name + '&timeout=60000'
    epos = new epson.ePOSPrint(url)

    #Send the print document
    epos.send request

    #register callback function
    epos.onreceive = (res) ->

      #Obtain the print result and error code
      msg = 'Print' + (res.success ? 'Success' : 'Failure') + '\nCode:' + res.code + '\nStatus:\n'

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

      $('.print-modal').find('.modal-body').empty().append msg

    #register callback function
    epos.onerror = (err) ->
      $('.print-modal').find('.modal-body').empty().append 'Network error occured.'

create_orders = ->
  window.Caesars.orders = new Caesars.Orders()

$(document).on 'ready page:load', create_orders