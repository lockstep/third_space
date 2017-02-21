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

$(document).on('turbolinks:load', function() {
  if ($('.problems.show').length > 0 ) {
    enableDisablePostCommentBtn();
  }
});
