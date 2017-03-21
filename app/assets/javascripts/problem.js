var limited_length = 100;
var ending = "...";

function enable_disable_submit_btn(input_class, submit_btn_class) {
  var inputValue = $(input_class).val();
  if($.trim(inputValue).length > 0) {
    $(submit_btn_class).removeAttr('disabled');
  } else {
    $(submit_btn_class).attr('disabled', 'disabled');
  }
}

function listen_field_updating(input_class, submit_btn_class) {
  enable_disable_submit_btn(input_class, submit_btn_class);
  $(input_class).on('input', function() {
    enable_disable_submit_btn(input_class, submit_btn_class)
  });
}

function show_edit_modal() {
  $('#editModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget)
    var id = button.data('comment-id')
    var commentMessage = $('#comment-id-'+id).text();
    $('#edit-comment-input').val(commentMessage);
    $('#comment_id').val(id);

    $("#edit-comment-form").attr("action", "/comments/" + id);
  });
}

function share_problem_by_email() {
  $('#problem-form__share--email').bind('ajax:success',
    function(event, data, status, xhr) { $('#shareModal').modal('hide'); }
  );
}

function toggle_like() {
  $('#like-action').bind('ajax:success',
    function(event, data, status, xhr) {
      var liked = $('#like-action').data('liked');

      if(liked){
        $('#like-action').addClass('problem__btn--like').removeClass('problem__btn--liked');
        likes = parseInt($('.problem__like-number').text()) - 1;
        $('#like-status').text('Like');
      } else {
        $('#like-action').addClass('problem__btn--liked').removeClass('problem__btn--like');
        likes = parseInt($('.problem__like-number').text()) + 1;
        $('#like-status').text('Liked');
      }
      var show_text = likes == 1? likes + ' like' : likes + ' likes';
      $('.problem__like-number').text(show_text);
      $('#like-action').data('liked', !liked);

    }
  );
}

function change_title_height() {
  var wrapper_height = $('.problem__title-wrapper').height();
  var title_height = $('.problem__title').height();
  if (title_height > wrapper_height) {
    $('.problem__title-wrapper').height(title_height+20);
  }
}

function match_space(title_class, elipses) {
  return $(title_class).each(function() {
    $(this).children('span').each(function() {
      var el = $(this);
      var text = el.text();
      if(elipses && text.length > limited_length) {
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
    match_space('.problem__title', false);
    listen_field_updating('#problem__share--receiver-email', '#problem__share-btn--email');
    show_edit_modal();
    share_problem_by_email();
    toggle_like();
    change_title_height();
  }
  if ($('.problems.new, .problems.edit').length > 0 ) {
    listen_field_updating('.problem__name', '.problem__btn--submit');
    createSlider('.tip__swiper-container', '.tip__swiper-pagination');
    stopShakingTip(isTipClicked != undefined);
  }
  if ($('.problems.lens').length > 0 ) {
    listen_field_updating('.ace-it', '.lens__btn--submit');
    stopShakingTip(isTipClicked != undefined);
  }
  if ($('.problems.index').length > 0) {
    match_space('.problem__title', true);
  }
  if ($('.problems.lens').length > 0 ) {
    createSlider('.tip__swiper-container', '.tip__swiper-pagination');
  }
});
