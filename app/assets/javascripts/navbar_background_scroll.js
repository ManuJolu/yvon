$(document).ready(function() {
  $(document).on('scroll', function (e) {
    $('.navbar-background-scroll').css('opacity', Math.min(0.9, ($(document).scrollTop() / 480)));
  });
});
