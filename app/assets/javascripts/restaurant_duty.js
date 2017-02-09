$(document).ready(function() {
  $('#restaurantDutySwitch input').change(function(e){
    var checked = $(this).is(":checked");

    var onDuty = "off";
    if (checked) {
      onDuty = "on";
    }

    $.ajax({
      method: "patch",
      url: '/restaurants/'+ restaurantId + '/duty/' + onDuty
    });
  });
});
