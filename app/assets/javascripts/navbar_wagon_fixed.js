$(document).on('scroll', function (e) {
    $('.navbar-wagon-fixed').css('opacity', ($(document).scrollTop() / 500));
});
