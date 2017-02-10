$(document).ready(function() {
  $('#mealFormModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var action = button.data('action') // Extract info from data-* attributes
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    var modal = $(this)
    modal.find('.modal-title').text(action)
  });

  $("#mealList").on('change', ".meal-active-input", function() {
    $(this).submit();
  });

  $("#options a.add_fields").
  data("association-insertion-position", 'before').
  data("association-insertion-node", 'this');

  $('#options').on('cocoon:after-insert', function() {
    $(".meal-option-fields a.add_fields").
      data("association-insertion-position", 'before').
      data("association-insertion-node", 'this');
    $('.meal-option-fields').on('cocoon:after-insert', function() {
      $(this).children(".option_from_list").remove();
      $(this).children("a.add_fields").hide();
    });
  });
});

$(document).ajaxStop(function() {
  $("#options a.add_fields").
  data("association-insertion-position", 'before').
  data("association-insertion-node", 'this');

  $('#options').on('cocoon:after-insert', function() {
    $(".meal-option-fields a.add_fields").
      data("association-insertion-position", 'before').
      data("association-insertion-node", 'this');
    $('.meal-option-fields').on('cocoon:after-insert', function() {
      $(this).children(".option_from_list").remove();
      $(this).children("a.add_fields").hide();
    });
  });
});
