$(document).ready(function() {
  $("#restaurantPreparationTime").on('change', ".restaurant_preparation_time", function() {
    $(this).submit();
  });
});
