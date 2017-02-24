$(document).ready(function() {
  $(document).on('scroll', function (e) {
    $('.navbar-background-scroll').css('opacity', ($(document).scrollTop() / 640));
  });
});
