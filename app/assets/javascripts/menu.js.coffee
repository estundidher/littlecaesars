# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Caesars or= {}

class Caesars.Menu

  constructor: ->
    @$gallery = $('.gallery-content')
    @bind()

  bind: ->
    @$gallery.on 'click', '.element a', @open

  productList = {};
  
  populateProducList: (e) ->
  	@productList = $("a[id*='category" + $(e.currentTarget).data('category') + "product']").map ->
  		$(this)[0].dataset
 
  getPopulateSortedProducList: (e) ->
  
    # Add products dataset into array instance
    @populateProducList e

    firstList = []
    secondList = []
    productFound = false    

    # Add products into lists by starting from the selected product.
    @productList.each ->
      if productFound == true || $(e.currentTarget).data('product-index') == parseInt($(this)[0].productIndex, 10)
         firstList.push($(this)[0])
         productFound = true
      else
         secondList.push($(this)[0])

    # Merge the first list containing the first products to show with the second list with the rest of the products
    $.merge(firstList, secondList)
 
  getUrlAttributeList: (list) ->
  	$(list).map ->
  		$(this)[0].url
 
  getTitleAttributeList: (list) ->
  	$(list).map ->
  		$(this)[0].title
  		
  getDescriptionAttributeList: (list) ->
  	$(list).map ->
  		$(this)[0].description
  		  		
  open: (e) =>
    console.log 'menu open pretty foto fired! this: ' + $(e.currentTarget) + ' url: ' + $(e.currentTarget).data('url') + ', title: ' + $(e.currentTarget).data('title') + ', descr: ' + $(e.currentTarget).data('description')
    e.preventDefault();
    
    @productList = @getPopulateSortedProducList e
    
    $.prettyPhoto.open($(@getUrlAttributeList @productList), $(@getTitleAttributeList @productList), $(@getDescriptionAttributeList @productList));
    return false

create_menu = ->
  window.Caesars.menu = new Caesars.Menu()

$(document).on 'ready page:load', create_menu