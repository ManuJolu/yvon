if ($(".orders.index").length > 0) {
  App.orders = App.cable.subscriptions.create('OrdersChannel', {
    received: function(data) {
      $("#orders").removeClass('hidden')
      return $('#orders').append(this.renderMessage(data));
    },

    renderMessage: function(data) {
      return "<p> <b>" + data.user + ": </b>" + data.order + "</p>";
    }
  });
};
