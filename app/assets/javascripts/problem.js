function enableDisablePostCommentBtn() {
  var $commentInput = $('.comment__input');
  $commentInput.on('input', function() {
    var commentValue = $commentInput.val();
    if($.trim(commentValue).length > 0) {
      $('.comment__send-button').removeAttr('disabled');
    } else {
      $('.comment__send-button').attr('disabled', 'disabled');
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
    enableDisablePostCommentBtn();
  }
  if ($('.problems.index').length > 0 || $('.problems.show').length > 0) {
    $('.problem__title').mathSpace();
  }
});




