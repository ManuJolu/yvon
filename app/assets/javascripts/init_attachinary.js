$(document).ready(function() {
  $('.attachinary-input').attachinary();
});

$( document ).ajaxStop(function() {
  $('.attachinary-input').attachinary();
});
