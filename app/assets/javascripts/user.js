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
          // to show loading progress here
        }
      }).done(function(data, statusText, xhr ) {
        // to close loading progress here
        if (xhr.responseJSON) {
          console.log(xhr.responseJSON.error)
        } else {
          window.location = '/users';
        }
      });
    });
  }
});
