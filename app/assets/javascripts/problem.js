function enableDisableSubmitBtn(input_class, submit_btn_class) {
  var $input = $(input_class);
  $input.on('input', function() {
    var inputValue = $input.val();
    if($.trim(inputValue).length > 0) {
      $(submit_btn_class).removeAttr('disabled');
    } else {
      $(submit_btn_class).attr('disabled', 'disabled');
    }
  });
}

var limited_length = 100;
var ending = "...";

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
    enableDisableSubmitBtn('.comment__input', '.btn__submit');
  }
  if ($('.problems.new, .problems.edit').length > 0 ) {
    enableDisableSubmitBtn('.problem__name', '.btn__submit');
  }
  if ($('.problems.lense').length > 0 ) {
    enableDisableSubmitBtn('.ace-it', '.btn__submit');
  }
  if ($('.problems.index').length > 0 || $('.problems.show').length > 0) {
    $('.problem__title').mathSpace();
  }
});
