$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    console.log(answerId);
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });
}); 

function moveGift(placeForGift) {
  giftQuestionPlace = $(".gift_question_place");
  gift = $('.gift');
  
  if (gift.parent()[0] == giftQuestionPlace[0]) {
    placeForGift.append(gift);
  }  
};