function openAddWorkTimeTable() {
  $(".modal_add_work_time_table").find(".modal, .modal_background").fadeIn(150);
}

function closeAddWorkTimeTable() {
  $(
    ".modal_add_work_time_table .modal, .modal_add_work_time_table .modal_background"
  ).fadeOut(150);
}

function openWorkCrewCheck() {
  $(".modal_work_crew_check").find(".modal, .modal_background").fadeIn(150);
}

function closeWorkCrewCheck() {
  $(
    ".modal_work_crew_check .modal, .modal_work_crew_check .modal_background"
  ).fadeOut(150);
}

$(document).ready(function () {
  $("#searchYmd1").datepicker2({ ymonly: false });
  $("#searchYmd2").datepicker2({ ymonly: false });
  $("#searchYmd3").datepicker2({ ymonly: false });
  $("#searchYmd4").datepicker2({ ymonly: false });
  $("#searchYmd5").datepicker2({ ymonly: false });
  $("#searchYmd6").datepicker2({ ymonly: false });
})
