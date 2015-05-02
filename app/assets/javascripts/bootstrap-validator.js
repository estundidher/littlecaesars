($) ->

  $.fn.validate = (options) ->
    settings = $.extend({
      init: ->
      success: ->
      fail: (invalids) ->

    }, options)
    validators = 
      'name+family': /^((?![0-9]).+\s.+)/g
      'name': /^((?![0-9]).+)/g
      'family': /^((?![0-9]).+)/g
      'number': /^[0-9]+/g
      'url': /^(ht|f)tps?:\/\/[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>\#%"\,\{\}\\|\\\^\[\]`]+)?$/
      'date': /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/
      'email': /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      'tel': /^[0-9\-\+]{3,25}$/
    @on('submit', (e) ->
      form = this
      invalids = []
      settings.init.call form
      data = {}
      $('input,textarea,select', this).filter(':visible,[type=\'hidden\']').each ->
        i = $(this)
        if !i.parent().is(':visible')
          return
        name = i.attr('name')
        if typeof name != 'undefined' and (i.is(':not([type=\'checkbox\'],[type=\'radio\'])') or i.is(':checked'))
          value = i.val()
          if typeof data[name] != 'undefined'
            data[name] = [].concat(data[name]).concat(value)
          else
            data[name] = value
        return

      ### join array if it's required ###

      if typeof settings.join != 'undefined'
        for i of data
          if typeof data[i] == 'function'
            data[i] = data[i].join(settings.join)

      ###* [data-require] is deprecated use requried instead *###

      $('[data-regex],[data-require],[data-required],[required],[data-equals]', form).filter(':visible').each ->
        self = $(this)
        regex = self.attr('data-regex')
        required = self.is('[required]') or self.is('[data-required]') or self.is('[data-require]')
        equals = self.attr('data-equals')
        value = self.val()
        if self.is('[type=\'checkbox\']') and !self.is(':checked')
          value = ''
        # replace value with total value
        name = self.attr('name')
        if typeof name != 'undefined'
          value = data[name]
        if typeof equals != 'undefined' and typeof data[equals] != 'undefined'
          if value != data[equals]
            invalids.push this
            invalids.push $('[name=\'' + equals + '\']')[0]

        ###* array is always valid, because for array inputs we just check required *###

        if !Array.isArray(value)
          if value and value.length > 0
            # try to use tag name for regex
            if typeof regex == 'undefined'
              type = $(this).attr('type')
              if typeof type != 'undefined' and typeof validators[type.toLowerCase()] != 'undefined'
                regex = type.toLowerCase()
            if regex
              r = undefined
              if typeof validators[regex] != 'undefined'
                r = validators[regex]
              else
                r = new RegExp(regex)
              if !r.test(value)
                invalids.push this
          else if required
            invalids.push this
        return
      if invalids.length > 0
        e.preventDefault()
        settings.fail.call form, e, invalids, data
      else
        settings.success.call form, e, data
      return
    ).attr 'novalidate', ''

  $.fn.bootstrap3Validate = (success, data) ->
    @validate
      'init': ->
        $('.has-error', this).removeClass('has-error').find('input,textarea').tooltip 'destroy'
        $('.alert').hide()
        $('[role=\'tooltip\']', this).tooltip 'destroy'
        return
      'success': (e, data) ->
        if typeof success == 'function'
          success.call this, e, data
        return
      'fail': (e, invalids) ->
        form = this
        $(invalids).closest('.form-group').addClass('has-error').find('input,select,textarea').each (i) ->
          target = $(this)
          text = target.attr('data-title')
          if !text
            text = target.attr('placeholder')
          if text
            if !target.is('[type=\'checkbox\']')
              target.tooltip
                'trigger': 'focus'
                placement: 'top'
                title: text
            if i == 0
              $('.alert-danger', form).show().text text
              @focus()
          return
        return
  return