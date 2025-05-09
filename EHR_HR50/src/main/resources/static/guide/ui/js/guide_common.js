/**
 * html include
 * ex) <div data-include-html="footer.html"></div>
 */

function includeHTML() {
  var z, i, elmnt, file, xhttp;
  /* Loop through a collection of all HTML elements: */
  z = document.getElementsByTagName("*");
  for (i = 0; i < z.length; i++) {
    elmnt = z[i];
    /*search for elements with a certain atrribute:*/
    file = elmnt.getAttribute("include-html");
    if (file) {
      /* Make an HTTP request using the attribute value as the file name: */
      xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function () {
        if (this.readyState == 4) {
          if (this.status == 200) {
            elmnt.innerHTML = this.responseText;
          }
          if (this.status == 404) {
            elmnt.innerHTML = "Page not found.";
          }
          /* Remove the attribute, and call this function once more: */
          elmnt.removeAttribute("include-html");
          includeHTML();
        }
      };
      xhttp.open("GET", file, true);
      xhttp.send();
      /* Exit the function: */
      return;
    }
  }
}

// 헤더 검색 모달
function openSearchModal() {
  // $(".search_modal").find(".modal, .modal_background").addClass("fade-in");
  $(".search_modal").find(".modal, .modal_background").fadeIn(150);
}

function closeSearchModal() {
  /* $(".search_modal .modal, .search_modal .modal_background").removeClass(
    "fade-in"
  ); */
  $(".search_modal").find(".modal, .modal_background").fadeOut(150);
}

function applySearchHighlight() {
  const keyword = $(".search_modal .search input").val();
  $(".search_modal .result span, .search_modal .process_map span").each(
    function () {
      const text = $(this).text();
      if (keyword) {
        const highlightedText = text.replace(
          new RegExp(`(${keyword})`, "gi"),
          "<strong>$1</strong>"
        );
        $(this).html(highlightedText);
      } else {
        $(this).html(text);
      }
    }
  );
}

$(document).ready(function () {
  // includeHTML();
  // includeLayout();

  setTimeout(setUI, 500);
  setRandomImage();

  // 위젯(마스터 화면) 슬라이더
  if (typeof Swiper !== "undefined") {
    var swiper = new Swiper(".widgetSwiper", {
      // direction: "vertical",
      slidesPerView: 1,
      // spaceBetween: 30,
      mousewheel: true,
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

    // 마우스 포인트가 위젯 안에 있을때 마우스 스크롤 안되게
    var scrollContainers = document.querySelectorAll(".widget");
    scrollContainers.forEach(function (container) {
      container.addEventListener("mousewheel", function (event) {
        event.stopPropagation();
      });
    });
  }
});

function setUI() {
  // includeHTML();

  // main_menu 클릭 시
  $(".main_menu .menu_item").click(function (e) {
    mainMenuItemClick(this);
  });

  function mainMenuItemClick(target) {
    $(target).siblings().removeClass("on");
    $(target).addClass("on");
    // $(target).toggleClass("on");

    if ($("body").hasClass("main_menu_on")) {
      // $("body").removeClass("main_menu_on");
      // $(target).removeClass("on");
    } else {
      $("body").addClass("main_menu_on");
      // $(target).toggleClass("on");
      // $(target).addClass("on");
    }
  }

  // 메인 메뉴 hover 시 타이틀 말풍선 표시
  $(".main_menu .menu_item a").hover(
    function () {
      if ($("body").hasClass("main_menu_on")) {
        $this = $(this);
        // console.log("hover in $this", $this, $this.position(), $this.offset());
        var menu_title = $this.find(".menu_title").text();
        var position = $this.position();

        $(".main_menu_hover_title")
          .text(menu_title)
          .css({ visibility: "visible", top: position.top - 31 });
      }
    },
    function () {
      if ($("body").hasClass("main_menu_on")) {
        $this = $(this);

        $(".main_menu_hover_title").css({ visibility: "hidden" });
      }
    }
  );

  // 서브 메뉴 가로로 감추기 보이기
  $(".sub_menu .sub_menu_header .open_close_btn").click(function () {
    console.log("open_close_btn  click");

    // $('.sub_menu').toggleClass('off');
    $("body").toggleClass("sub_menu_off");
  });

  // 서브메뉴 상단 전체, 뎁스별 열고 닫기 버튼
  $(".sub_menu .sub_menu_header > a").click(function () {
    const $this = $(this);
    const btnIdx = $this.index();

    if (btnIdx == 0) {
      // 전체 열기 닫기
      $this.hasClass("open") ? closeSubmenuAll() : openSubmenuAll();
      $this.toggleClass("open");
    } else if (btnIdx == 1) {
      // 뎁스 3까지 열기
      openSubmenuAll();

      $this.siblings(".all").addClass("open");
    } else if (btnIdx == 2) {
      // 뎁스 2까지 열기
      openSubmenuDepth1All();
      closeSubmenuDepth2All();

      $this.siblings(".all").addClass("open");
    } else if (btnIdx == 3) {
      // 뎁스 1만 열기
      closeSubmenuAll();

      $this.siblings(".all").removeClass("open");
    }
  });

  function openSubmenuAll() {
    openSubmenuDepth1All();
    openSubmenuDepth2All();
  }
  function closeSubmenuAll() {
    closeSubmenuDepth1All();
    closeSubmenuDepth2All();
  }

  function openSubmenuDepth1All() {
    const $elems = $(".sub_menu .sub_menu_body li > a");

    for (let index = 0; index < $elems.length; index++) {
      const $elem = $($elems[index]);
      openSubmenuDepth1($elem);
    }
  }
  function closeSubmenuDepth1All() {
    const $elems = $(".sub_menu .sub_menu_body li > a");

    for (let index = 0; index < $elems.length; index++) {
      const $elem = $($elems[index]);
      closeSubmenuDepth1($elem);
    }
  }

  function openSubmenuDepth1($elem) {
    $elem.parent().addClass("open");
    $elem.siblings().slideDown(200);
  }
  function closeSubmenuDepth1($elem) {
    $elem.parent().removeClass("open");
    $elem.siblings().slideUp(200);
  }

  function toggleSubmenuDepth1($elem) {
    $elem.parent().toggleClass("open");
    $elem.siblings().slideToggle(200);
  }

  function openSubmenuDepth2All() {
    const $elems = $(".sub_menu .sub_menu_body dl dt > a");

    for (let index = 0; index < $elems.length; index++) {
      const $elem = $($elems[index]);
      openSubmenuDepth2($elem);
    }
  }
  function closeSubmenuDepth2All() {
    const $elems = $(".sub_menu .sub_menu_body dl dt > a");

    for (let index = 0; index < $elems.length; index++) {
      const $elem = $($elems[index]);
      closeSubmenuDepth2($elem);
    }
  }

  function openSubmenuDepth2($elem) {
    const $siblings_dd = $elem.parent().siblings("dd");
    if ($siblings_dd.length > 0) {
      $elem.parent().parent().addClass("open");
      $siblings_dd.slideDown(200);
    }
  }
  function closeSubmenuDepth2($elem) {
    const $siblings_dd = $elem.parent().siblings("dd");
    if ($siblings_dd.length > 0) {
      $elem.parent().parent().removeClass("open");
      $siblings_dd.slideUp(200);
    }
  }

  function toggleSubmenuDepth2($elem) {
    const $siblings_dd = $elem.parent().siblings("dd");
    if ($siblings_dd.length > 0) {
      $elem.parent().parent().toggleClass("open");
      $siblings_dd.slideToggle(200);
    }
  }

  // 서브메뉴 클릭
  // depth 1
  $(".sub_menu .sub_menu_body li > a").click(function (e) {
    toggleSubmenuDepth1($(this));
  });

  // depth 2
  $(".sub_menu .sub_menu_body dl dt > a").click(function (e) {
    toggleSubmenuDepth2($(this));
  });

  // 드롭다운 이벤트
  $(".select_toggle").click(function (e) {
    if ($(this).closest(".custom_select").hasClass("disabled")) return;
    if ($(this).closest(".custom_select").hasClass("readonly")) return;

    e.stopPropagation();

    $(".select_options").not($(this).next()).css("visibility", "hidden");
    $(".select_toggle i")
      .not($(this).find("i"))
      .each(function () {
        if ($(this).text() === "keyboard_arrow_up") {
          $(this).text("keyboard_arrow_down");
        } else if ($(this).text() === "arrow_drop_up") {
          $(this).text("arrow_drop_down");
        }
      });

    let optionsVisibility = $(this).next(".select_options").css("visibility");
    $(this)
      .next(".select_options")
      .css(
        "visibility",
        optionsVisibility === "visible" ? "hidden" : "visible"
      );

    let icon = $(this).find("i");
    switch (icon.text()) {
      case "keyboard_arrow_down":
        icon.text("keyboard_arrow_up");
        break;
      case "keyboard_arrow_up":
        icon.text("keyboard_arrow_down");
        break;
      case "arrow_drop_down":
        icon.text("arrow_drop_up");
        break;
      case "arrow_drop_up":
        icon.text("arrow_drop_down");
        break;
    }
  });

  $(document).click(function () {
    $(".select_options").css("visibility", "hidden");
    $(".select_toggle i").each(function () {
      if (
        $(this)
          .closest(".select_toggle")
          .next(".select_options")
          .css("visibility") !== "hidden"
      ) {
        if ($(this).text() === "keyboard_arrow_down") {
          $(this).text("keyboard_arrow_up");
        } else if ($(this).text() === "arrow_drop_down") {
          $(this).text("arrow_drop_up");
        }
      } else {
        if ($(this).text() === "keyboard_arrow_up") {
          $(this).text("keyboard_arrow_down");
        } else if ($(this).text() === "arrow_drop_up") {
          $(this).text("arrow_drop_down");
        }
      }
    });
  });

  $(".select_options").click(function (e) {
    e.stopPropagation();
  });

  //드롭다운 옵션 선택 시 닫히는 함수 주석
  $(".select_options .option").click(function () {
    if ($(this).closest(".custom_select").hasClass("disabled")) return;

    var hasITag = $(this).find("i").length > 0;
    if (!hasITag) {
      var selectedOptionText = $(this).text();
      $(this)
        .closest(".custom_select")
        .find(".select_toggle span")
        .text(selectedOptionText);
    }

    $(this).closest(".select_options").css("visibility", "hidden");
    let icon = $(this).closest(".custom_select").find(".select_toggle i");

    if (icon.text() === "keyboard_arrow_up") {
      icon.text("keyboard_arrow_down");
    } else if (icon.text() === "arrow_drop_up") {
      icon.text("arrow_drop_down");
    }
  });

  $(".tab_menu > i").on("mousedown", function (e) {
    e.stopPropagation();
  });

  // 컨텐츠 탭 메뉴
  $(".tab_menu").on("click", function () {
    console.log("???");
    $(this).siblings().removeClass("active");
    $(this).addClass("active");
  });

  // iframe 안에서 클릭 시 드롭다운 닫히지 않는 이유로 추가
  $(document).on("click", function () {
    window.parent.postMessage("iframeClicked", "*");
  });

  window.addEventListener(
    "message",
    function (event) {
      if (event.data === "iframeClicked") {
        $(".select_options").css("visibility", "hidden");
      }
    },
    false
  );

  // 헤더 검색 모달
  $(".search_modal .tab_wrap .tab_menu").on("click", function () {
    $(".search_modal .tab_wrap .tab_menu").removeClass("active");
    $(this).addClass("active");
    $(
      ".search_modal .menu_result, .search_modal .process_map_result, .search_modal .employee_result"
    ).hide();
    if ($(this).hasClass("menu")) {
      $(".search_modal .menu_result").show();
    } else if ($(this).hasClass("process_map")) {
      $(".search_modal .process_map_result").show();
    } else if ($(this).hasClass("employee")) {
      $(".search_modal .employee_result").show();
    }
  });

  // select태그 커스텀
  initializeTextColor();

  $("select.custom_select").on("change", function () {
    initializeTextColor(this);
  });

  function initializeTextColor(selectElement) {
    var firstOptionValue = $(selectElement).find("option:first-child").val();

    var selectedValue = $(selectElement).val();

    if (selectedValue === firstOptionValue) {
      $(selectElement).css("color", "#9f9f9f");
    } else {
      $(selectElement).css("color", "#323232");
    }
  }

  $("select.custom_select").on("click", function () {
    if ($(this).hasClass("opened")) {
      $(this).removeClass("opened");
    } else {
      $("select.custom_select.opened").not(this).removeClass("opened");
      $(this).addClass("opened");
    }
  });

  $(document).on("click", function (e) {
    if (!$(e.target).is("select.custom_select")) {
      $("select.custom_select").removeClass("opened");
    }
  });

  $("table.default td select").on("change", function () {
    initializeTextColor(this);
  });

  function initializeTextColor(selectElement) {
    var firstOptionValue = $(selectElement).find("option:first-child").val();

    var selectedValue = $(selectElement).val();

    if (selectedValue === firstOptionValue) {
      $(selectElement).css("color", "#9f9f9f");
    } else {
      $(selectElement).css("color", "#323232");
    }
  }

  $("table.default td select").on("click", function () {
    if ($(this).hasClass("opened")) {
      $(this).removeClass("opened");
    } else {
      $(this).addClass("opened");
    }
  });

  $(document).on("click", function (e) {
    if (!$(e.target).is("table.default td select")) {
      $("table.default td select").removeClass("opened");
    }
  });

  $(".sheet_title select").on("click", function () {
    if ($(this).hasClass("opened")) {
      $(this).removeClass("opened");
    } else {
      $(this).addClass("opened");
    }
  });

  $(document).on("click", function (e) {
    if (!$(e.target).is(".sheet_title select")) {
      $(".sheet_title select").removeClass("opened");
    }
  });

  // 페이지네이션 버튼 클릭 이벤트
  $(".pagenation_wrap").on("click", ".btn_page", function () {
    let $paginationWrap = $(this).closest(".pagenation_wrap"); // 현재 클릭된 버튼의 부모 .pagenation_wrap 선택
    let activeIndex;
    let totalNumIndex = $paginationWrap.find(".btn_page.number").length - 1;

    if ($(this).hasClass("number")) {
      $paginationWrap.find(".btn_page").removeClass("active");
      $(this).addClass("active");
      activeIndex = $(this).index(".btn_page.number");
    } else if ($(this).hasClass("btn_left")) {
      activeIndex = $paginationWrap.find(".btn_page.active").index();
      if (activeIndex - 1 > -1) {
        $paginationWrap.find(".btn_page").removeClass("active");
        $paginationWrap
          .find(".btn_page.number")
          .eq(activeIndex - 1)
          .addClass("active");
      }
    } else if ($(this).hasClass("btn_right")) {
      activeIndex = $paginationWrap.find(".btn_page.active").index();
      if (activeIndex < totalNumIndex) {
        $paginationWrap.find(".btn_page").removeClass("active");
        $paginationWrap
          .find(".btn_page.number")
          .eq(activeIndex + 1)
          .addClass("active");
      }
    } else if ($(this).hasClass("btn_first")) {
      $paginationWrap.find(".btn_page").removeClass("active");
      $paginationWrap.find(".btn_page.number").eq(0).addClass("active");
    } else if ($(this).hasClass("btn_last")) {
      $paginationWrap.find(".btn_page").removeClass("active");
      $paginationWrap
        .find(".btn_page.number")
        .eq(totalNumIndex)
        .addClass("active");
    }
  });

  // 위로 이동 버튼
  $(".btn.top").click(function () {
    $("html, body").animate({ scrollTop: 0 }, "fast");
  });
}

// no_content 이미지 랜덤
const imageUrls = [
  "../../html-hr50/assets/images/img_no_contents01.png",
  "../../html-hr50/assets/images/img_no_contents02.png",
];

function getRandomImageUrl() {
  const randomIndex = Math.floor(sRandom() * imageUrls.length);
  return imageUrls[randomIndex];
}

function sRandom() {
  return (window.crypto || window.msCrypto).getRandomValues(new Uint32Array(1))[0]/4294967296;
}

function setRandomImage() {
  const randomImageUrl = getRandomImageUrl();
  $(".no_content img").attr("src", randomImageUrl);
}

/**
 * 모달 관련
 */
function openModal(id) {
  $elem = $(id);
  $elem.find(".modal, .modal_background").fadeIn(150);
}

function closeModal(elem) {
  // console.log("closeModal elem", elem);
  $elem = $(elem);

  if ($elem.hasClass("modal_background")) {
    $(elem).hide().next().hide();
  } else {
    $elem.parents(".modal").hide().prev().hide();
  }
}
