document.addEventListener("DOMContentLoaded", function () {
  $('.select_toggle_people').click(function(e) {
    const targetId = $(this).data('target'); 
    const target = $("#" + targetId); 
    const visibility = target.css('visibility'); 
    const x = e.clientX;
    const y = e.clientY;
    target.css('style', 'fixed');
    target.css('left', x+'px');
    target.css('top', y + "px");
    if (visibility === 'hidden') {
      target.addClass('active')
    }else{
      target.removeClass('active')
    }
    event.stopPropagation();
  });

    // 다른 곳을 클릭했을 때의 로직
  $(document).click(function() {
    $("#people_status").removeClass('active');
  });
})