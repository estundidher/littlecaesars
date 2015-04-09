$(document).on('ready page:load', function () {
	checkScreenSize();
});

// Listen for resize changes
window.addEventListener("resize", function() {
	// Get screen size (inner/outerWidth, inner/outerHeight)
	checkScreenSize();
}, false);

function checkScreenSize() {
	if (screen.width > 700) {
		$("#signInDiv").show();
		$("#customerSignUpDiv").show();
	} else {
		if ($("#controllerName").val() == "sessions") {
			$("#customerSignUpDiv").hide();			
		} else if ($("#controllerName").val() == "registrations") {
			$("#signInDiv").hide();
		}
	}
};