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
    console.log 'Orders - print: cliked! ' + $(e.target).parent().data('code')
    @print $(e.target).parent().data('code')

  print: (serial) =>

    console.log 'Orders - print: fired! ' + code

    $('.print-modal').modal 'show'

    #Settings
    ipaddr = '192.168.0.13'
    devid = 'local_printer'
    timeout = '60000'
    grayscale = true
    layout = false

    #Queue Ticket Sequence Number
    sequence = 1

    #
    #draw print data
    #

    #get context of canvas
    canvas = $('#canvas').get(0)
    context = canvas.getContext('2d')

    #get current date
    now = new Date()

    #draw background image
    context.clearRect(0, 0, 512, 480)
    context.drawImage($('#coffee').get(0), 0, 0, 512, 384)
    context.fillStyle = 'rgba(255, 255, 255, 0.5)'
    context.fillRect(0, 0, 512, 480)
    context.fillStyle = 'rgba(0, 0, 0, 1.0)'

    #draw water mark
    context.drawImage($('#wmark').get(0), 0, 0)
    context.drawImage($('#wmark').get(0), 256, 324)

    #draw serial number
    context.textAlign = 'end'
    context.textBaseline = 'top'
    context.font = 'normal normal normal 24px "Arial", sans-serif'
    context.fillText('No. ' + ('000000' + serial).slice(-6), 512, 0)

    #draw message with rotation
    context.translate(96, 112)
    context.rotate(-Math.PI / 12)
    context.textAlign = 'center'
    context.textBaseline = 'middle'
    context.font = 'italic normal normal 48px "Times New Roman", serif'
    context.fillText('Enjoy!', 0, 0)
    context.rotate(Math.PI / 12)
    context.translate(-96, -112)

    #draw title
    context.textAlign = 'center'
    context.textBaseline = 'alphabetic'
    context.font = 'normal normal bold 72px "Arial", sans-serif'
    context.fillText('FREE Coffee', 256, 224)
    context.font = 'normal normal bold 36px "Times New Roman", serif'
    context.fillText('Expires ' + now.toDateString(), 256, 288)

    #draw time
    context.textAlign = 'start'
    context.textBaseline = 'bottom'
    context.font = 'normal normal normal 24px "Arial", sans-serif'
    context.fillText(now.toTimeString().slice(0, 8), 0, 384)

    #draw barcode
    if !grayscale
      drawEan13(context, '201234567890', 139, 400, 2, 80)

    #
    #print
    #

    #create print object
    url = 'http://' + ipaddr + '/cgi-bin/epos/service.cgi?devid=' + devid + '&timeout=' + timeout
    epos = new epson.CanvasPrint(url)

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

    #paper layout
    if layout
      epos.paper = epos.PAPER_RECEIPT
      epos.layout = { width:580 }

    #print
    if grayscale
      epos.mode = epos.MODE_GRAY16
    else
      epos.mode = epos.MODE_MONO
      epos.halftone = epos.HALFTONE_ERROR_DIFFUSION

    epos.cut = true
    epos.print canvas

    #set next serial number
    serial = serial % 999999 + 1

create_orders = ->
  window.Caesars.orders = new Caesars.Orders()

$(document).on 'ready page:load', create_orders