// 메인 페이지 관련
$(function () {
  var swiper = new Swiper(".widgetSwiper", {
    // direction: "vertical",
    slidesPerView: 1,
    // spaceBetween: 30,
    // mousewheel: true,
    // allowTouchMove: false,
    pagination: {
      el: ".swiper-pagination",
      clickable: true,
      renderBullet: function (index, className) {
        return (
          '<span class="' + className + '"><span class="area"></span></span>'
        );
        // return '<span class="' + className + '">' + (index + 1) + "</span>";
      },
    },
  });
});

$(document).ready(function () {
  /* 인사 담당자 sort */
  var managerShortSwiper = new Swiper(".management_short", {
    pagination: {
      el: ".management_short .swiper-pagination",
      type: "bullets",
      clickable: true,
    },
    navigation: {
      nextEl: ".management_short .swiper-button-next",
      prevEl: ".management_short .swiper-button-prev",
    },
    nested: true,
    // preventInteractionOnTransition: true,
    /* autoplay: {
      delay: 3000,
    }, */
  });

  /* 인사 담당자 wide */
  var managerWideSwiper = new Swiper(".management_wide", {
    pagination: {
      el: ".management_wide .swiper-pagination",
      type: "bullets",
      clickable: true,
    },
    navigation: {
      nextEl: ".management_wide .swiper-button-next",
      prevEl: ".management_wide .swiper-button-prev",
    },
    nested: true,
    /* autoplay: {
      delay: 3000,
    }, */
  });

  /* 내결재 말풍선 이동 */
  $(".widget_approval .approval_list .progress_circle").mouseover(function (
    event
  ) {
    const xpos = $(this).position().left + 16;
    const ypos =
      $(this).position().top + $(this).parent().parent().position().top - 35;
    $(".superior_info").css({
      display: "flex",
      "margin-left": xpos + "px",
      "margin-top": ypos + "px",
    });
  });
  $(".widget_approval .approval_list .progress_circle").mouseout(function (
    event
  ) {
    $(".superior_info").hide();
  });
});
