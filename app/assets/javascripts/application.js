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
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.mouse
//= require jquery.ui.position
//= require jquery.ui.autocomplete
//= require turbolinks
//= require bootstrap/bootstrap
//= require theme/theme
//= require meiomask
//= require moment
//= require bootstrap-datetimepicker
//= require cart

$(document).on('ready page:load', function () {
  Application.bind_checkAll();
  Application.bind_dateTimePickers();
  Application.bind_moneyMask();
  Application.bind_cart();
  Application.bind_tooltip();
  Application.bind_scroolToTop();
  Application.bind_carousel();
  Application.bind_tabs();
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
  },

  /* *************************************** */
  /* Cart Button Drop Down */
  /* *************************************** */
  bind_cart: function() {
    $('.btn-cart-md .cart-link').click(function(e) {
        e.preventDefault();
        Application.cart_toggle();
    });
  },

  /* *************************************** */
  /* Cart Toggle */
  /* *************************************** */
  cart_toggle: function(speed) {
    var $dd_menu = $('.btn-cart-md .cart-dropdown');
    if ($dd_menu.hasClass('open')) {
        $dd_menu.fadeOut(speed);
        $dd_menu.removeClass('open');
    } else {
        $dd_menu.fadeIn(speed);
        $dd_menu.addClass('open');
    }
  },

  /* *************************************** */
  /* Carrousel */
  /* *************************************** */
  bind_carousel: function() {
    return $('.carousel').carousel({
      interval: false
    });
  },

  /* *************************************** */
  /* Tool Tip JS */
  /* *************************************** */
  bind_tooltip: function() {
    $('.my-tooltip').tooltip();
  },

  /* *************************************** */
  /* Scroll to Top */
  /* *************************************** */
  bind_scroolToTop: function() {
    $(".totop").hide();
    $(window).scroll(function(){
    if ($(this).scrollTop() > 300) {
        $('.totop').fadeIn();
    } else {
        $('.totop').fadeOut();
    }
    });
    $(".totop a").click(function(e) {
        e.preventDefault();
        $("html, body").animate({ scrollTop: 0 }, 'slow');
        return false;
    });
  },

  bind_tabs: function() {
    $('.nav-tabs a').click(function (e) {
       e.preventDefault();
       $(this).tab('show');
    });
  }
};

var Cart = {
  calculate_price: function() {
    $.post($('#cart_add_item_calculate_url').val(), $('#cart_add_item_form').serialize(), function(data) {
      return $('.item-price').hide().empty().append(data).slideDown('fast')
    });
  }
};