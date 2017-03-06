$(document).on('turbolinks:load', function() {
  if ($('.registrations.edit').length > 0 ) {
    $(document).on('change', "#user_avatar", function() {
      var data = new FormData();
      data.append('user[avatar]', $('#user_avatar')[0].files[0]);
      $.ajax({
        url: '/users/upload_avatar',
        type: 'PATCH',
        data: data,
        cache: false,
        contentType: false,
        processData: false,
        beforeSend: function() {
          $('.profile__img').addClass('hide-loading');
          $('.loading__piano-conatiner').removeClass('hide-loading');
        }
      }).done(function(data, statusText, xhr ) {
        $('.profile__img').removeClass('hide-loading');
        $('.loading__piano-conatiner').addClass('hide-loading');
        if (xhr.responseJSON) {
          $('.avatar__error').text(xhr.responseJSON.error);
        } else {
          window.location = '/users/edit';
        }
      });
    });
  }
});
