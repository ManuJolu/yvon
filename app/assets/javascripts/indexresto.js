$(document).on("click", "#pending", function () {
  $("#orderspending, #trianglependingdown, #trianglependingup").toggleClass( "hidden" );
});


$(document).on("click", "#delivered", function () {
  $("#ordersdelivered, #triangledelivereddown, #triangledeliveredup").toggleClass( "hidden" );
});
