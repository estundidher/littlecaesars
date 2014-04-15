// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.mouse
//= require jquery.ui.position
//= require jquery.ui.autocomplete
//= require turbolinks
//= require bootstrap/bootstrap
//= require meiomask
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

$(function() {
    Application.bind_checkAll();
    Application.bind_dateTimePickers();
    Application.bind_moneyMask();
});

var Application = {

  bind_dateTimePickers: function() {
   return $('.datetimepicker_timer').datetimepicker({
        pickDate: false
    });
  },

  bind_checkAll: function() {
    return $('.check_all').on('click', function () {
        $(this).closest('table').find(':checkbox').prop('checked', this.checked);
    });
  },

  bind_moneyMask: function() {
    return $('.money_mask').setMask({mask:'99.99', type:'reverse', maxLength: 5});
  }
};

var Products = {

  load_options_by_type: function(path, type_id) {
    $('#product_options_container').hide()
                                   .empty();
    if(type_id != null && type_id != undefined && type_id != '') {
      $.get(path, {id:type_id}).done(function(data) {
          $('#product_options_container') .html(data)
                                          .fadeIn('fast');
      });
    }
  }
};