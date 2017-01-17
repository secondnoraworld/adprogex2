$(function() {

  $(document).on('click', '.clear-btn', function() {
    $('#card-alert').fadeOut(800, function() {
      $('#card-alert').remove();
    });
  });

});
