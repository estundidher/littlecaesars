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

//= require jquery
//= require jquery.turbolinks
//= require jquery-ujs
//= require bootstrap
//= require jquery-meiomask/dist/meiomask
//= require jquery-prettyPhoto/js/jquery.prettyPhoto
//= require moment
//= require respond
//= require html5shiv
//= require eonasdan-bootstrap-datetimepicker
//= require data-confirm-modal

//= require home
//= require modal
//= require cart
//= require cart_item
//= require cart_modal
//= require cart_button
//= require checkout
//= require toppings
//= require menu
//= require turbolinks
//= require pick_up
//= require messages
//= require order

$(document).on('ready page:load', function () {
  Application.bind_checkAll();
  Application.bind_dateTimePickers();
  Application.bind_moneyMask();
  Application.bind_scroolToTop();
  Application.bind_carousel();
  Application.bind_tabs();
  Application.bind_spinnable();
  Application.bind_expanable();
});

var Application = {

  bind_expanable: function() {
    $('.expanable').click(function (e) {
      console.log('.expanable clicked!' + $(e).data('target'));
      $($(this).data('target')).toggle();
    })
  },

  bind_spinnable: function() {
    $('.spinnable').click(function (e) {
      $(this).addClass('disabled').find('.glyphicon').hide();
      $(this).find('.fa-spin').fadeIn('fast');
    })
  },

  bind_tabs: function() {
    $('.nav-pills a').click(function (e) {
      e.preventDefault()
      $(this).tab('show')
    })
  },

  bind_dateTimePickers: function() {
   return $('.bootstrap-datetimepicker').datetimepicker({
        pickDate: false
    });
  },

  bind_checkAll: function() {
    return $('.check_all').on('click', function () {
        $(this).closest('table').find(':checkbox').prop('checked', this.checked);
    });
  },

  bind_moneyMask: function() {
    $('.meio-mask').setMask();
    return $('.money_mask').setMask({mask:'99.99', type:'reverse', maxLength: 5});
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