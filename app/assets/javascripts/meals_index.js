$('#mealEditModal').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget) // Button that triggered the modal
  var mealId = button.data('meal-id') // Extract info from data-* attributes
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  $.ajax({
    method: "get",
    url: '/meals/'+ mealId + '/edit/'
  });
})
