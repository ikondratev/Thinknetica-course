$(document).on('turbolinks:load', function(){
  $(document).on('click', '.edit-question-link', function(e) {
      e.preventDefault();
      $(this).hide();
      $('form#edit-question').show();
  })

  $('a.like, a.dislike').on('ajax:success', function(e) {
  	var acc = e.target.parentNode.parentNode;
  	var pac = e.detail[0];
  	acc.getElementsByClassName('score')[0].innerHTML = pac.score;
  })
  
});