//= require categories
//= require opening_hours
//= require places
//= require prices
//= require product_types
//= require products
//= require sizes
//= require users

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