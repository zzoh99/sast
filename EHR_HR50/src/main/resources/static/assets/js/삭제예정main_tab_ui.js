// 메인 탭 메뉴
$(function () {
  function updateSlideZIndex() {
    let slides = this.slides;
    for (let i = 0; i < slides.length; i++) {
      if (slides[i].classList.contains("active")) {
        slides[i].style.zIndex = 98;
      } else {
        slides[i].style.zIndex = slides.length - i;
      }
    }
  }

  const mainTabSwiper = new Swiper(".swiper.main_tab_wrap", {
    slidesPerView: "auto",
    watchSlidesVisibility: true,
    spaceBetween: 0,
    navigation: {
      nextEl: ".arrow_right_btn",
      prevEl: ".arrow_left_btn",
    },
    slidesPerGroupAuto: true,

    simulateTouch: false,
    preventClicks: true,
    preventClicksPropagation: true,
    onlyExternal: true,
    watchOverflow: true,

    on: {
      init: function () {
        updateSlideZIndex.call(this);
      },
      slideChange: function () {
        updateSlideZIndex.call(this);
      },
    },
  });

  $(".main_tab_menu").sortable({
    items: ".tab_menu",
    helper: "clone",
    axis: "x",
    containment: ".main_tab_menu",
    update: function (event, ui) {
      let newOrder = [];

      $(".tab_menu").each(function () {
        newOrder.push($(this).data("swiper-slide-index"));
      });

      mainTabSwiper.slides.sort(function (a, b) {
        let indexA = $(a).data("swiper-slide-index");
        let indexB = $(b).data("swiper-slide-index");
        return newOrder.indexOf(indexA) - newOrder.indexOf(indexB);
      });

      mainTabSwiper.update();
      mainTabSwiper.slideTo(0);

      mainTabSwiper.emit("init");
    },
  });

  var iframeSources = {
    tab_01: "../process_map/process_map_list_user.html",
    tab_02: "../process_map/process_map_edit.html",
    tab_03: "../process_map/process_map_start.html",
  };

  $(".tab_menu").on("mousedown", function (e) {
    $(".tab_menu > i").on("mousedown", function (e) {
      e.stopPropagation();
    });

    if (e.which === 3) {
      return;
    }
    $(".tab_menu").removeClass("active");
    $(this).addClass("active");
    mainTabSwiper.emit("init");

    // 탭 메뉴 변경 테스트 코드
    var tabId = $(this).attr("id");
    var newSrc = iframeSources[tabId];

    if (newSrc) {
      $(".main_content iframe").attr("src", newSrc);
    }
  });

  $(".main_tab_menu").disableSelection();

  // 탭메뉴 우클릭 드롭다운 띄우는 함수
  $(".main_tab_wrap .swiper-slide.tab_menu").on("contextmenu", function (e) {
    e.preventDefault();

    // 현재 슬라이드의 정보를 콘솔에 출력
    console.log($(this).attr("id"));

    let slidePosition = $(this).position();
    let slideHeight = $(this).outerHeight();
    let slideWidth = $(this).outerWidth();

    $(".main_tab_wrap .custom_select .select_options").css({
      visibility: "visible",
      position: "absolute",
      top: "-15px",
      left: slidePosition.left + slideWidth / 2 + "px",
      transform: "translateX(10%)",
    });
  });

  $(document).on("click", function (e) {
    if (
      !$(e.target).closest(".main_tab_wrap .swiper-slide.tab_menu").length &&
      !$(e.target).closest(".main_tab_wrap .custom_select").length
    ) {
      $(".main_tab_wrap .custom_select .select_options").css(
        "visibility",
        "hidden"
      );
    }
  });
});

// 탭 삭제
function closeTab(e, element) {
  e.preventDefault();

  let $currentTab = $(element).closest(".tab_menu");
  if (!$currentTab.hasClass("active")) {
    $currentTab.remove();
    return;
  }
  let $prevTab = $currentTab.prev(".tab_menu");

  $currentTab.remove();

  // 탭 삭제 시 탭 변경 테스트 코드
  var iframeSources = {
    tab_01: "../process_map/process_map_list_user.html",
    tab_02: "../process_map/process_map_edit.html",
    tab_03: "../process_map/process_map_start.html",
  };

  let $newActiveTab;

  if ($prevTab.length) {
    $prevTab.addClass("active");
    $newActiveTab = $prevTab;
  } else {
    $newActiveTab = $(".main_tab_menu .tab_menu:first");
    $newActiveTab.addClass("active");
  }

  // iframe 내용 업데이트
  var tabId = $newActiveTab.attr("id");
  var newSrc = iframeSources[tabId];
  if (newSrc) {
    $(".main_content iframe").attr("src", newSrc);
  }
}
