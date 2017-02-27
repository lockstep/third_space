$(document).on('turbolinks:load', function() {
  if ($('.welcome.index').length > 0 ) {
    var swiper = new Swiper('.welcome__swiper', {
      pagination: '.welcome__swiper-pagination',
      paginationClickable: true
    });
  }
});
