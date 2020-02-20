import consumer from "channels/consumer"

$(document).on('turbolinks:load', function(){

  subsriptions();

  $(document).on('click', '.edit-question-link', function(e) {
      e.preventDefault();
      $(this).hide();
      $('form#edit-question').removeClass('hidden');
  })

  $('a.like, a.dislike').on('ajax:success', function(e) {
  	var acc = e.target.parentNode.parentNode;
  	var pac = e.detail[0];
  	acc.getElementsByClassName('score')[0].innerHTML = pac.score;
  })
  
});

function subsriptions() {
  var path = document.location.pathname
  
  if (path == '/' || path == '/questions') {
    questionsChannel();
  };

  if (/\/questions\/\d+/.test(path)) {  
    answersChannel();
    commentsChannel();
  };
}

function questionsChannel() {
  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      console.log('Questions channel connected.');
      this.perform('follow');
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      var _question_id = data.question.id
      var href = '<a href="/questions/'+ _question_id +'"> ';
      var title = '<td> ' + href + data.question.title + ' </a> </td>';
      var body = '<td> ' + href + data.question.body + ' </a> </td>';

      $("tbody").append('<tr> ' + title + body + '</tr>');
    }
  });
}

function answersChannel() {
  consumer.subscriptions.create({channel: 'AnswersChannel', id: gon.question_id}, {
    connected: function() { 
      console.log('Answer channel connected.');
      this.perform('follow');
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received: function(data) { 
      var href = '"/answers/' + data['answer'].id + '/set_the_best"'
      var answer_id = data['answer'].id
      var answer_links = data.links
      var answer_files = data.files

      $(".answers").append('<div class="answer" id="answer-' + data['answer'].id + '">');
      $(".answers").append('<p> Author: ' + data['email'] + ' </p>');
      $(".answers").append('<p class="answer-error-' + answer_id + '"></p>');
      $(".answers").append('<p class="answer-body"> ' + data['answer'].body + ' </p>');

      if (answer_files.length) {
        answer_files.map(function(file) {
          $(".answers").append('<p>Files:</p>');
          $(".answers").append('<ul><li><a href="' + file['url'] +  '">' + file['name'] + '</a></li><a rel="nofollow" data-method="delete" href=/attachments/' + file['id'] + '">delete file</a></ul>');
        });

      }

      if (data['answer'].user_id  == gon.user_id) {
        $(".answers").append('<p><a data-remote="true" rel="nofollow" data-method="patch" href=' + href + '> best </a></p>');
      };

      if (answer_links.length) {
        answer_links.map(function(link) {
          $(".answers").append('<div class="links"><p>Links:</p><ul><li class="link_' + link['id'] + '"><p><a href="' + link['url'] +  '">' + link['name'] + '</a></p></li></ul></div>');
        });

      } else {
        $(".answers").append('<div class="links"><p>Links:</p><ul></ul></div>');
      }

      if (data['answer'].user_id  == gon.user_id) {
        $(".answers").append('<div class="answer-score"><p>like</p><p class="score">0</p><p>dislike</p></div>');
        $(".answers").append('<p><a data-remote="true" rel="nofollow" data-method="delete" href="/answers/' + answer_id + '">Delete answer</a></p>');
        $(".answers").append('<p><a class="edit-answer-link" data-answer-id="' + answer_id + '" href="#">edit</a></p>');
      };

      if (data['answer'].user_id  != gon.user_id) {
        $(".answers").append('<p><a class="like" data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + answer_id + '/like">like</a></p>');
        $(".answers").append('<p class="score">0</p>');
        $(".answers").append('<p><a class="dislike" data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + answer_id + '/like">like</a></p>');
      };

      $(".answers").append('</div>');
        
    }
  });
}

function commentsChannel() {
  consumer.subscriptions.create({channel: 'CommentsChannel', id: gon.question_id}, {
    connected() {
      console.log('Comments channel connected.');
      this.perform('follow');
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (data.comment.author_id != gon.user_id) {
                
        if (data.comment.commentable_type == "Question") {
          $('#question .comments').append('<p>' + data.comment.body + '</p>');
        };

        if (data.comment.commentable_type == "Answer") {          
          $('#answer-'+ data.comment.commentable_id + ' .comments').append('<p>' + data.comment.body + '</p>');
        };        
      }
    }
  });
}