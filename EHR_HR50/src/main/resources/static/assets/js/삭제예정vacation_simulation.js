document.addEventListener("DOMContentLoaded", function () {
  $("#datePicker1").datepicker2({ ymonly: false });
  $("#datePicker2").datepicker2({ ymonly: false }); // true면 년월만 선택 가능

  $(".tab_menu").click(function () {
    const activeTab = $(this).attr("data-tab");
    $(".tab_menu").removeClass("active");
    $(".tab_content").removeClass("on");
    
    $(this).addClass("active");
    $(`#${activeTab}`).addClass("on");
    toggleButtonsVisibility(activeTab);
  });

  function toggleButtonsVisibility(tabId) {
    if (tabId === "executives") {
      $(".button_wrap.simulation").removeClass("hide");
    } else {
      $(".button_wrap.simulation").addClass("hide");
    }
  }
});
