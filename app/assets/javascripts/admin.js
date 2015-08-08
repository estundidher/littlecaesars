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
//= require categories
//= require places
//= require opening_hours
//= require shifts
//= require prices
//= require product_types
//= require products
//= require sizes
//= require users

$( document ).ready(function() {
    $('.orders').on('ajax:before', '.btn-success.done', doneBefore);
	$('.orders').on('ajax:success', '.btn-success.done', doneSuccess);
	$('.orders').on('ajax:error', '.btn-success.done', doneError);
	
	$(document).on('show.bs.modal', '.modal', centerModal);

	$(window).on("resize", function () {
	    $('.modal:visible').each(centerModal);
	});
	$(window).on("orientationChange", function () {
	    $('.modal:visible').each(centerModal);
	});
});
    
var selectedOrdem;    
function showDonePopup (obj) {
	$(obj).find('+ .modal').modal('show');
	
	selectedOrdem = $(obj).find('.order-inner');
	selectedOrdem.addClass('active');  
};
function hideDonePopup (obj) {
	selectedOrdem.prevObject.find('+ .modal').modal('hide');
	
	selectedOrdem.removeClass('active');
	selectedOrdem = null;
	
	if (obj) {
		var $button;
		$button = $(obj.target);
	  	$button.removeClass('disabled');
	  	$button.find('.fa-spin').hide();
	  	$button.find('.glyphicon').show();
	}
};

function centerModal() {
    $(this).css('display', 'block');
    var $dialog  = $(this).find(".modal-dialog"),
    offset       = ($(window).height() - $dialog.height()) / 2,
    bottomMargin = parseInt($dialog.css('marginBottom'), 10);

    // Make sure you don't hide the top part of the modal w/ a negative margin if it's longer than the screen height, and keep the margin equal to the bottom margin of the modal
    if(offset < bottomMargin) offset = bottomMargin;
    $dialog.css("margin-top", offset);
}

function doneBefore(e, data, status, xhr) {
	var $button;
	$button = $(e.target);
  	$button.addClass('disabled');
  	$button.find('.fa-spin').fadeIn('fast');
  	$button.find('.glyphicon').hide();
};

function doneSuccess(e, data, status, xhr) {
  var $order;
  console.log('Admin Order done: success fired!');
  $order = selectedOrdem.closest('.order');
  $order.slideUp('slow', function() {
    $order.remove();
  });
  
  hideDonePopup($order.find('> .order-item-anchor'));
};

function doneError(e, xhr, status, error) {
  console.log('Admin Order done: error fired!');
  console.log('order.reload: fired!');
  window.location.reload(false);
};