$(document).ready(function() {
  if ($("#restaurantTabs").length > 0) {
    App.restaurant = App.cable.subscriptions.create({ channel: "RestaurantChannel", restaurant_id: restaurantId }, {
      received: function(data) {
        $.ajax({
          method: "get",
          url: '/restaurants/'+ restaurantId + '/refresh/' + data.update
        });
      }
    });
  };
});
