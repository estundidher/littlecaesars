# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Wizard

  constructor: ->
    @bind()

  bind: ->
    @bind_wizard()

  bind_wizard: =>
    console.log "wizard: binding fired!"
    $('#rootwizard').bootstrapWizard 'nextSelector':'.button-next', 'previousSelector':'.button-previous', onTabShow: (tab, navigation, index) ->
      console.log "wizard: onTabShow fired!"
      $total = $('#rootwizard').find('.nav li').length
      $current = index+1
      $percent = ($current/$total) * 100
      $('#rootwizard').find('.progress-bar').css {width:$percent+'%'}

create_wizard = ->
  window.Caesars.wizard = new Caesars.Wizard()

$(document).on 'ready page:load', create_wizard