$(document).ready(function() {
  $("#restaurantPreparationTime").on('change', ".preparation-time-input", function() {
    $(this).submit();
  });
});
