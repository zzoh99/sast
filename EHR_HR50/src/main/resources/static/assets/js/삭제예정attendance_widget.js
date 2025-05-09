document.addEventListener("DOMContentLoaded", function () {
  $('.tab_menu').on('click', function() {
    $('.tab_menu').removeClass('active');
    $(this).addClass('active');
  });

  /* 내결재 말풍선 이동 */
  $('.widget_approval .approval_list .progress_circle').mouseover(function(event){
    const xpos = $(this).position().left + 16;
    const ypos = $(this).position().top + $(this).parent().parent().position().top - 35;
    $('.superior_info').css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
  });
  $('.widget_approval .approval_list .progress_circle').mouseout(function(event){
    $('.superior_info').hide();
  });

  $('.renewal_table tbody td').each(function() {
    if ($(this).text().trim().match(/^\d+$/)) {
      $(this).addClass('number_font');
    }
  });

  /* 인사 담당자 short */
  var managerShortSwiper = new Swiper('.swiper.management_short', {
    pagination: {
      el: '.swiper.management_short .swiper-pagination',
      type: 'bullets',
      clickable: true,
    },
    navigation: {
      nextEl: '.swiper.management_short .swiper-button-next',
      prevEl: '.swiper.management_short .swiper-button-prev',
    },
    /* autoplay: {
      delay: 3000,
    }, */
  });

  /* 인사 담당자 wide */
  var managerWideSwiper = new Swiper('.swiper.management_wide', {
    pagination: {
      el: '.swiper.management_wide .swiper-pagination',
      type: 'bullets',
      clickable: true,
    },
    navigation: {
      nextEl: '.swiper.management_wide .swiper-button-next',
      prevEl: '.swiper.management_wide .swiper-button-prev',
    },
    /* autoplay: {
      delay: 3000,
    }, */
  });
})