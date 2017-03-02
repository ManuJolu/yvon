$(document).ready(function() {
  $('#restaurantDutyCheckbox').on('change', "input", function(){
    var checked = $(this).is(":checked");

    var onDuty = "off";
    if (checked) {
      onDuty = "on";
    }

    $.ajax({
      method: "patch",
      url: '/restaurants/'+ restaurantId + '/duty_update/' + onDuty
    });
  });
});
