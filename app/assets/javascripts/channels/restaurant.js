$(document).ready(function() {
  if ($(".orders.index").length > 0) {
    App.orders = App.cable.subscriptions.create({ channel: "RestaurantOrdersChannel", restaurant_id: restaurantId }, {
      received: function(data) {
        $.ajax({
          method: "get",
          url: '/restaurants/'+ restaurantId + '/orders/refresh/' + data.order_status
        });
      }
    });
  };
});
