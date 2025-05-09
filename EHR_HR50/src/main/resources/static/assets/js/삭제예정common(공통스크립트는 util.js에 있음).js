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
  $(".search_modal").find(".modal, .modal_background").fadeIn(200);
}

function closeSearchModal() {
  /* $(".search_modal .modal, .search_modal .modal_background").removeClass(
    "fade-in"
  ); */
  $(".search_modal").find(".modal, .modal_background").fadeOut(200);
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

// window.addEventListener("load", function () {
//   var allElements = document.getElementsByTagName("*");
//   Array.prototype.forEach.call(allElements, function (el) {
//     var includeHtml = el.dataset.includeHtml;
//     if (includeHtml) {
//       var xhttp = new XMLHttpRequest();
//       xhttp.onreadystatechange = function () {
//         if (this.readyState == 4 && this.status == 200) {
//           el.outerHTML = this.responseText;
//         }
//       };
//       xhttp.open("GET", includeHtml, true);
//       xhttp.send();
//     }
//   });
// });

// function includeLayout() {
//   var includeArea = $("[data-include]");
//   var self, url;
//   $.each(includeArea, function () {
//     self = $(this);
//     url = self.data("include");
//     self.load(url, function () {
//       self.removeAttr("data-include");
//     });
//   });
// }

$(function () {
  includeHTML();
  // includeLayout();

  setTimeout(setUI, 500);
});

function setUI() {
  // includeHTML();

  // include html
  // var allElements = document.getElementsByTagName("*");
  // Array.prototype.forEach.call(allElements, function (el) {
  //   var includeHtml = el.dataset.includeHtml;
  //   if (includeHtml) {
  //     var xhttp = new XMLHttpRequest();
  //     xhttp.onreadystatechange = function () {
  //       if (this.readyState == 4 && this.status == 200) {
  //         el.outerHTML = this.responseText;
  //       }
  //     };
  //     xhttp.open("GET", includeHtml, true);
  //     xhttp.send();
  //   }
  // });
	
  $(".btn input.bbit-dp-input + img.ui-datepicker-trigger").each(function () {
    $(this)
      .add($(this).prev("input.bbit-dp-input"))
      .wrapAll('<div class="date_form"></div>');
  });

  $(".btn .date_form .ui-datepicker-trigger").css({
    display: "block",
  });
	
  /**
   * 메뉴 관련 스크립트 개발 common.js 에서 삭제 예정, util.js에서 구현됨
   */ 
  // main_menu 클릭 테스트
//  $(".main_menu .menu_item").click(function (e) {
//    mainMenuItemClick(this);
//  });
//  function mainMenuItemClick(target) {
//    $(target).siblings().removeClass("on");
//
//    if ($("body").hasClass("main_menu_on")) {
//      $("body").removeClass("main_menu_on");
//      $(target).removeClass("on");
//    } else {
//      $("body").addClass("main_menu_on");
//      $(target).toggleClass("on");
//    }
//  }

//  $(".sub_menu .sub_menu_header .open_close_btn").click(function () {
//    console.log("open_close_btn  click");
//
//    // $('.sub_menu').toggleClass('off');
//    $("body").toggleClass("sub_menu_off");
//  });

  // 서브메뉴 클릭 테스트
//  $(".sub_menu .sub_menu_body li > a").click(function (e) {
//    $(this).parent().toggleClass("open");
//    $(this).siblings().slideToggle(200);
//  });
//
//  $(".sub_menu .sub_menu_body dt > a").click(function (e) {
//    $(this).parent().parent().toggleClass("open");
//    $(this).parent().siblings("dd").slideToggle(200);
//  });

  // 드롭다운 이벤트
  // $(".select_toggle").click(function (e) {
  //   e.stopPropagation();
  //   $(".select_options").not($(this).next()).hide();
  //   $(".select_toggle i").not($(this).find("i")).text("keyboard_arrow_down");
  //   $(this).next(".select_options").toggle();
  //   let icon = $(this).find("i");
  //   if (icon.text() === "keyboard_arrow_down") {
  //     icon.text("keyboard_arrow_up");
  //   } else {
  //     icon.text("keyboard_arrow_down");
  //   }
  // });

  // $(document).click(function () {
  //   $(".select_options").hide();
  //   $(".select_toggle i").each(function () {
  //     if (
  //       $(this).closest(".select_toggle").next(".select_options").is(":visible")
  //     ) {
  //       $(this).text("keyboard_arrow_up");
  //     } else {
  //       $(this).text("keyboard_arrow_down");
  //     }
  //   });
  // });

  // $(".select_options").click(function (e) {
  //   e.stopPropagation();
  // });

  // $(".select_options .option").click(function () {
  //   $(this).closest(".select_options").hide();
  //   let icon = $(this).closest(".custom_select").find(".select_toggle i");
  //   icon.text("keyboard_arrow_down");
  // });

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

  // 드롭다운 옵션 선택 시 닫히는 함수 주석
  // $(".select_options .option").click(function () {
  //   if ($(this).closest(".custom_select").hasClass("disabled")) return;

  //   $(this).closest(".select_options").css("visibility", "hidden");
  //   let icon = $(this).closest(".custom_select").find(".select_toggle i");

  //   if (icon.text() === "keyboard_arrow_up") {
  //     icon.text("keyboard_arrow_down");
  //   } else if (icon.text() === "arrow_drop_up") {
  //     icon.text("arrow_drop_down");
  //   }
  // });
  $(".tab_menu > i").on("mousedown", function (e) {
    e.stopPropagation();
  });

  // 컨텐츠 탭 메뉴
  $(".tab_menu").on("click", function () {
    $(".tab_menu").removeClass("active");
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
      ".search_modal #menu_result, .search_modal #process_map_result, .search_modal #employee_result"
    ).hide();
    if ($(this).attr("id") == "menu") {
      $(".search_modal #menu_result").show();
    } else if ($(this).attr("id") == "process_map") {
      $(".search_modal #process_map_result").show();
    } else if ($(this).attr("id") == "employee") {
      $(".search_modal #employee_result").show();
    }
  });

  //select태그 커스텀
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
  
  //위로 이동 버튼
  $(".btn.top").click(function () {
    $("html, body").animate({ scrollTop: 0 }, "fast");
  });
  
}

// no_content 이미지 랜덤
const imageUrls = [
   "/assets/images/img_no_contents01.png",
   "/assets/images/img_no_contents02.png",
];

function getRandomImageUrl() {
    const randomIndex = Math.floor(Math.random() * imageUrls.length);
    return imageUrls[randomIndex];
}

function setRandomImage() {
    const randomImageUrl = getRandomImageUrl();
    $(".no_content img").attr("src", randomImageUrl);
}
