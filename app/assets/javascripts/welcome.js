$(document).on('turbolinks:load', function() {
  if ($('.welcome.index').length > 0 ) {
    createSlider('.welcome__swiper', '.welcome__swiper-pagination');
  }
});
