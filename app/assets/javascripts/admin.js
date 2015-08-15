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
    $('.orders').on('ajax:before', '.btn-success.oven', ovenBefore);
	$('.orders').on('ajax:success', '.btn-success.oven', ovenSuccess);
	$('.orders').on('ajax:error', '.btn-success.oven', ovenError);
	
	$(document).on('show.bs.modal', '.modal', centerModal);
	$(document).on('hide.bs.modal', '.modal', hideModal);

	$(window).on("resize", function () {
	    $('.modal:visible').each(centerModal);
	});
	$(window).on("orientationChange", function () {
	    $('.modal:visible').each(centerModal);
	});
	
	
	$("#editOvenTimeBtn").on("click", function () {
		$(".navbar-nav > li > .oven-time").hide();
	    $(".navbar-nav > li > .oven-time-place").show();
	});
	
	$(".oven-time-place-btn").on("click", function () {
		$("#ovenId").val($(this).data("oven-time-id"));
		$("#ovenTime").val($(this).data("oven-time"));
		$("#ovenTimePlaceId").val($(this).data("place-id"));
		$("#newOvenTime").val($(this).data("oven-time"));
			
	    $(".navbar-nav > li > .oven-time-place").hide();
	    $(".navbar-nav > li > .edit-oven-time").show();
	});
	
	$("#cancelOvenTimeBtn").on("click", function () {
		$(".navbar-nav > li > .edit-oven-time").hide();
		$(".navbar-nav > li > .oven-time").show();
	});
	$("#saveOvenTimeBtn").on("click", function () {
		$.ajax({
			method: "PUT",
			url: "/admin/oven_time/" + $("#ovenId").val(),
			data: { id: $("#ovenId").val(), time: $("#newOvenTime").val(), place_id: $("#ovenTimePlaceId").val() },
			dataType: 'json'
		})
		.done(function(response) {				
			$("#saveOvenTimeBtn").removeClass('disabled');
	  		$("#saveOvenTimeBtn").find('.fa-spin').hide();
			$("#saveOvenTimeBtn").find('.glyphicon').show();
			
			$(".oven-time-place-btn[data-oven-time-id=" + $("#ovenId").val() + "]").data("oven-time", ($("#newOvenTime").val()));
			
	    	$(".navbar-nav > li > .oven-time").show();
    		$(".navbar-nav > li > .edit-oven-time").hide();
	  	})
		.fail(function(jqHXR, textStatus) {
	    	alert('ops..');
	  	});		
	});
});
    
var selectedOrdem;    
function showLivePopup (obj) {
	$(obj).find('+ .modal').modal('show');
	
	selectedOrdem = $(obj).find('.order-inner');
	selectedOrdem.addClass('active');  
};
function hideLivePopup (obj) {		
	if (obj) {
		var $button;
		$button = $(obj.target);
	  	$button.removeClass('disabled');
	  	$button.find('.fa-spin').hide();
	  	$button.find('.glyphicon').show();
	}
	
	selectedOrdem.prevObject.find('+ .modal').modal('hide');
};

function hideModal() {
	$(document).find(".order-inner.active").removeClass("active");	
	selectedOrdem = null;
}

function centerModal() {
    $(this).css('display', 'block');
    var $dialog  = $(this).find(".modal-dialog"),
    offset       = ($(window).height() - $dialog.height()) / 2,
    bottomMargin = parseInt($dialog.css('marginBottom'), 10);

    // Make sure you don't hide the top part of the modal w/ a negative margin if it's longer than the screen height, and keep the margin equal to the bottom margin of the modal
    if(offset < bottomMargin) offset = bottomMargin;
    $dialog.css("margin-top", offset);
}

function ovenBefore(e, data, status, xhr) {
	var $button;
	$button = $(e.target);
  	$button.addClass('disabled');
  	$button.find('.fa-spin').fadeIn('fast');
  	$button.find('.glyphicon').hide();
};

function ovenSuccess(e, data, status, xhr) {
  var $order;
  $order = selectedOrdem.closest('.order');
  $order.slideUp('slow', function() {
    $order.remove();
  });
  
  hideLivePopup($order.find('> .order-item-anchor'));
};

function ovenError(e, xhr, status, error) {
  alert('Admin live: error fired!');
  console.log('order.reload: fired!');
  window.location.reload(false);
};

function maxLengthCheck(object) {
	if (object.value.length > object.maxLength) {
    	object.value = object.value.slice(0, object.maxLength);
    }
}