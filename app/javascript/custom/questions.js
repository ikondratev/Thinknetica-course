$(document).on('turbolinks:load', function(){
  $(document).on('click', '.edit-question-link', function(e) {
      e.preventDefault();
      $(this).hide();
      $('form#edit-question').show();
  });
});