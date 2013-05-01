$(document).ready(function(){
  
  $('.action-submit').on("click", function(e) {
    $this = $(this); 

    $.ajax({
      url: 'mains/create_data_to_session',
      type: 'POST',
      data: $(".iihanashi-form").serialize(),
      dataType: 'json'
    })
    .done( function(obj) {
      location.href = "/auth/facebook";
    })
    .fail( function(obj) {
      alert("申し訳ありません、サーバーの調子が悪いようです。少々お待ちください。。。");
      console.log("failed...");
    })
    return false;
  });

});