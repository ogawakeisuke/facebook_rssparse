$(document).ready(function(){
  
  $('.action-getdescription').on("click", function(e) {
    $(".iihanashi-form [name=desc]").val("");
    $this = $(this); 

    $.ajax({
      url: $(this).attr('action'),
      type: 'GET',
      dataType: 'json'
      
    })
    .done( function(obj) {
      $(".iihanashi-form [name=desc]").val( roundText(obj.title, obj.desc) );
      $(".main-image img").attr("src", obj.img_url);
      $(".main-image_hidden input").attr("value", obj.img_url);
    })
    .fail( function(obj) {
      console.log("failed...");
    })
    return false;
  });


  function roundText(title, desc) {
    var textbox = title + "\n\n\n";
    for(var i in desc){
      textbox += desc[i];
      textbox += "\n\n";
    };
    return textbox;
  }

});