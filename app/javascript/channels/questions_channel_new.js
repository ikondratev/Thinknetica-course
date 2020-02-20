import consumer from "./consumer"

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
    // $("tbody").append('<td> ' + href + data.question.body + ' </a> </td>');
    // $("#questions-list").append("td= link_to data.question.body, question_path(data.question)");
  }
});
