$(document).ready(function(){
  if ( window.location.pathname == '/thanks'){
    $(".notices").text("投稿中…");
    console.log("action facebook post");
    $.ajax({
      url: $(".iihanashi-post").attr('action'),
      type: 'POST',
      data: $(".iihanashi-post").serialize(),
      dataType: 'json'
    })
    .done( function(obj) {
      $(".notices").text("ありがとうございました");
      console.log("ok");
    })
    .fail( function(obj) {
      console.log("failed...");
    })
    return false;
  }
});