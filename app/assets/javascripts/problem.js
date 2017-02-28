var limited_length = 100;
var ending = "...";

function enable_disable_subit_btn(input_class, submit_btn_class) {
  var inputValue = $(input_class).val();
  if($.trim(inputValue).length > 0) {
    $(submit_btn_class).removeAttr('disabled');
  } else {
    $(submit_btn_class).attr('disabled', 'disabled');
  }
}

function  listen_field_updating(input_class, submit_btn_class) {
  enable_disable_subit_btn(input_class, submit_btn_class);
  $(input_class).on('input', function() {
    enable_disable_subit_btn(input_class, submit_btn_class)
  });
}

$.fn.mathSpace = function() {
  return $(this).each(function() {
    $(this).children('span').each(function() {
      var el = $(this);
      var text = el.text();
      if(text.length > limited_length) {
        text = text.substring(0, limited_length - ending.length) + ending;
      }
      el.text(
        text.split(' ').join('\u205f')
      );
    });
  });
}

$(document).on('turbolinks:load', function() {
  if ($('.problems.show').length > 0 ) {
    listen_field_updating('.comment__input', '.comment__button--submit');
  }
  if ($('.problems.new, .problems.edit').length > 0 ) {
    listen_field_updating('.problem__name', '.problem__btn--submit');
    createSlider('.tip__swiper-container', '.tip__swiper-pagination');
    stopShakingTip(isTipClicked != undefined);
  }
  if ($('.problems.lense').length > 0 ) {
    listen_field_updating('.ace-it', '.lense__btn--submit');
    stopShakingTip(isTipClicked != undefined);
  }
  if ($('.problems.index').length > 0 || $('.problems.show').length > 0) {
    $('.problem__title').mathSpace();
  }
  if ($('.problems.lense').length > 0 ) {
    createSlider('.tip__swiper-container', '.tip__swiper-pagination');
  }
});
