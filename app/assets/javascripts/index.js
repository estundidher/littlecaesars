//= require theme/jquery.themepunch.plugins.min
//= require theme/jquery.themepunch.revolution.min

$(document).on('ready page:load', function () {
  Index.bind_slider_revolution();
});

var Index = {

  /* ******************************************** */
  /*  JS for SLIDER REVOLUTION  */
  /* ******************************************** */
  bind_slider_revolution: function() {

    $('.tp-banner').revolution({
        delay:9000,
        startheight:500,
        hideThumbs:10,
        navigationType:"bullet",
        hideArrowsOnMobile:"on",
        touchenabled:"on",
        onHoverStop:"on",
        navOffsetHorizontal:0,
        navOffsetVertical:20,
        stopAtSlide:-1,
        stopAfterLoops:-1,
        shadow:0,
        fullWidth:"on",
        fullScreen:"off"
    });
  }
}