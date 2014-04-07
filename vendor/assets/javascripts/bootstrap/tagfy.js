(function($) {

    var defaultSettings = {
        url     : null,
        id      : null,
        input   : null,
        style:  'primary'
    };

    function Config(field, settings) {

        this.hidden_name  = settings.name;
        this.tagfy_id     = $(field).attr('id') + '_' + 'tagfy';
        this.input_id     = $(field).attr('id') + '_tagfy_input';
        this.hidden_id    = $(field).attr('id');
        this.style_id     = $(field).attr('id') + '_' + 'tagfy_style';

        this.j_style      = '#' + this.style_id;
        this.j_tagfy      = '#' + this.tagfy_id;
        this.j_input      = '#' + this.input_id;
        this.j_hidden     = '#' + this.hidden_id;
    }

    var methods = {

        init : function(options) {

            var settings = $.extend({}, defaultSettings, options || {});

            var config = new Config($(this), settings);

            $(this).wrap($('<div>', {id: config.tagfy_id, 'class': 'tagfy form-control'}));
            $("<input>", {type:'hidden', id: config.style_id, value: settings.style}).appendTo(config.j_tagfy);

            if(settings.url) {

                $(this).autocomplete({
                    source: function(request, response) {
                        $.ajax({
                            url: settings.url,
                            dataType: "json",
                            data: {
                                term: request.term,
                            selected: $(config.j_tagfy + ' .value').map(function(){return $(this).val()}).get().join()
                            },
                            success: function(data) {
                                response(data);
                            }
                        })},
                        minLength: 2,
                        select: function(event, ui) {
                            $(this).tagfy('add', {
                               name: config.hidden_name,
                                 id: ui.item.id,
                                tag: ui.item.value
                            });
                        },
                        close: function(event, ui) {
                            $(this).val('');
                        }
                    }
                );

            } else {

                $("<input>", {type:'hidden', id: config.hidden_id, name: $(this).attr('name')}).appendTo(config.j_tagfy);
                $(this).attr('id', config.input_id).removeAttr('name');

                if($(config.j_input).val()) {
                    var values = $(config.j_input).val().split(',');
                    $(config.j_input).val('');
                    values.forEach(function(entry) {
                        $(config.j_input).tagfy('add', {
                           tag: entry
                        });
                    });
                }

                $(config.j_input).keypress(function(event) {
                    if(event.which == 13) {
                        event.preventDefault();
                        event.stopPropagation();
                        var value = $(this).val();
                        $(this).val('');
                        $(this).tagfy('add', {
                           tag: value
                        });
                    }
                });
            }
        },

        add : function(content) {

            var settings = $.extend({}, defaultSettings, content || {});

            var config = null

            if(settings.name) {
                config = new Config($(this), settings);
            } else {
                config = new Config($(this).parent().find('input:hidden').last(), settings);
            }

            var remove = $('<i>', {'class': 'glyphicon glyphicon-remove'});
            $(remove).on('click', function () {
                var span = $(this).parent();
                $(span).fadeOut('fast', function() {
                    $(span).remove();
                    if(!config.hidden_name) {
                        $(config.j_hidden).val('');
                        $(config.j_tagfy + ' .value').each(function(index, item) {
                            if($(config.j_hidden).val().length == 0) {
                                $(config.j_hidden).val($(item).val());
                            } else {
                                $(config.j_hidden).val($(config.j_hidden).val() + ',' + $(item).val());
                            }
                        });
                    }
                });
            });

            var span = $("<span>", {'class': 'label label-' + $(config.j_style).val()})
                        .append(settings.tag)
                        .append(" ")
                        .append(remove);

            if(config.hidden_name) {
                $("<input>", {type:'hidden', name:config.hidden_name, class:'value', val:settings.id}).appendTo(span);

                if($(config.j_tagfy + ' .label:last').length == 0) {
                    $(config.j_tagfy).prepend(span);
                } else {
                    $(config.j_tagfy + ' .label:last').after(span);
                }
            } else {

                console.log('config.j_tagfy: ' + config.j_tagfy);
                console.log('settings.tag: ' + settings.tag);

                var contains = false;
                $(config.j_tagfy + ' .value').each(function(index, item) {
                    console.log('$(item).val() :' + $(item).val());
                    if($(item).val() == settings.tag) {
                        contains = true;
                        $(item).parent().hide().fadeIn('fast');
                    }
                });

                if(!contains) {

                    $("<input>", {type:'hidden', class:'value', val:settings.tag}).appendTo(span);
                    if($(config.j_hidden).val().length == 0) {
                        $(config.j_hidden).val(settings.tag);
                    } else {
                        $(config.j_hidden).val($(config.j_hidden).val() + ',' + settings.tag);
                    }

                    if($(config.j_tagfy + ' .label:last').length == 0) {
                        $(config.j_tagfy).prepend(span);
                    } else {
                        $(config.j_tagfy + ' .label:last').after(span);
                    }
                }
            }
        }
    };

    $.fn.tagfy = function(options) {

        if (methods[options]) {
            return methods[options].apply( this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof options === 'object' || !options) {
            return methods.init.apply(this, arguments);
        } else {
            $.error('Method ' + method + ' does not exist on jQuery.inlineEdit');
        }
        return $(this);
    };

}(jQuery));