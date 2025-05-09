const schedules = [
  {
    title: "교육",
    start: "2023-09-01",
    end: "2023-09-03",
    className: "success",
  },
  {
    title: "연차",
    start: "2023-08-30",
    end: "2023-09-03",
    className: "proceeding",
  },
  {
    title: "유연근무(09:00-18:00)",
    start: "2023-09-01",
    end: "2023-09-05",
    className: "success",
  },
  {
    title: "오후반차",
    start: "2023-09-01",
    end: "2023-09-06",
    className: "success",
  },
  {
    title: "오후반차",
    start: "2023-09-06",
    end: "2023-09-09",
    className: "rejected",
  },
  {
    title: "연차",
    start: "2023-09-21",
    className: "success",
  },
  {
    title: "오후반차",
    start: "2023-09-21",
    className: "proceeding",
  },
  {
    title: "오후반차",
    start: "2023-09-21",
    className: "rejected",
  },
  {
    title: "오후반차",
    start: "2023-09-21",
    className: "rejected",
  },
  {
    title: "오후반차",
    start: "2023-09-21",
    className: "rejected",
  },
  {
    title: "오후반차",
    start: "2023-09-21",
    className: "rejected",
  },
];

document.addEventListener("DOMContentLoaded", function () {

  $("#searchInput1").datepicker2({ ymonly: false });
  $("#searchInput2").datepicker2({ ymonly: false });
  $("#searchInput3").datepicker2({ ymonly: false });
  $("#searchInput4").datepicker2({ ymonly: false });
  $("#searchInput5").datepicker2({ ymonly: false });
  $("#searchInput6").datepicker2({ ymonly: false });
  $("#searchInput7").datepicker2({ ymonly: false });
  $("#searchInput8").datepicker2({ ymonly: false });
  $("#searchInput9").datepicker2({ ymonly: false });
  $("#searchInput10").datepicker2({ ymonly: false });

  const calendarEl = document.getElementById("calendar");
  const calendar = new FullCalendar.Calendar(calendarEl, {
    headerToolbar: null,
    minTime: "07:00:00",
    maxTime: "24:00:00",
    locale: "en",
    initialDate: new Date(),
    navLinks: false,
    selectable: true,
    selectMirror: false,
    // 빈날자 선택시
    select: function (arg) {
      openAttendanceModal();
      onClickAddSchedule(arg, calendar);
    },
    // 일정 선택시
    eventClick: function (calEvent, jsEvent) {
      openAttendanceChangeModal();
      // 개발시 수정 로직 적용
    },
    editable: true,
    dayMaxEvents: true,
    events: schedules,
  });

  initialDate();
  calendar.render();

  $('#left_month_btn').on('click', function () {
    calendar.prev(); // 캘린더를 이전 달로 이동시킵니다.
    handleClickGetCurrentDate(calendar);
  })

  $('#right_month_btn').on('click', function () {
    calendar.next(); // 캘린더를 다음 달로 이동시킵니다.
    handleClickGetCurrentDate(calendar);
  })

  $('.dropdown-icon').on('click', function (e) {
    $(this).toggleClass("active");
    const isActive = $(this).hasClass("active");
    if (isActive) {
      $(".basic.toggle_table").hide();
      $(".no_table").show();
      $(".rotate").css("transform", "rotate(180deg)");
    } else {
      $(".basic.toggle_table").show();
      $(".no_table").hide();
      $(".rotate").css("transform", "rotate(0deg)");
    }
    e.stopPropagation();
  })

  // 다른 곳을 클릭했을 때의 로직
  $(document).click(function () {
    $("#select_item").css("visibility", "hidden");
  });
});

function openAttendanceModal() {
  $("#attendance_modal").find(".modal, .modal_background").fadeIn(200);
}

function closeAttendanceModal() {
  $(
    "#attendance_modal .modal, #attendance_modal .modal_background"
  ).fadeOut(200);
}

function openAttendanceChangeModal() {
  $("#attendance_change_modal")
    .find(".modal, .modal_background")
    .fadeIn(200);
}

function closeAttendanceChangeModal() {
  $(
    "#attendance_change_modal .modal, #attendance_change_modal .modal_background"
  ).fadeOut(200);
}

function openAttendanceCancelModal() {
  $("#attendance_cancel_modal")
    .find(".modal, .modal_background")
    .fadeIn(200);
}

function closeAttendanceCancelModal() {
  $(
    "#attendance_cancel_modal .modal, #attendance_cancel_modal .modal_background"
  ).fadeOut(200);
}

function handleSubmitAddAttendance(arg, calendar) {
  calendar.addEvent({
    title: "추가된 일정",
    start: arg.start,
    end: arg.end,
    allDay: arg.allDay,
    className: "success",
  });
  closeAttendanceModal();
}

function initialDate() {
  const yearDate = new Date().getFullYear();
  const monthDate = new Date().getMonth() + 1;
  document.getElementById("current_year").innerHTML = yearDate;
  document.getElementById("current_month").innerHTML = monthDate;
}

function handleClickGetCurrentDate(calendar) {
  const { viewTitle, currentDate } = calendar.currentData;
  const getYear = viewTitle.split(" ")[1];
  const getMonth = new Date(currentDate).getMonth();
  document.getElementById("current_year").innerHTML = getYear;
  document.getElementById("current_month").innerHTML = getMonth + 1;
}

function onClickAddSchedule(arg, calendar) {
  $(".attendance_submit")
    .off()
    .on("click", function () {
      handleSubmitAddAttendance(arg, calendar);
    });
  calendar.unselect();
}

window.oncontextmenu = function (e) {
  const optionsVisibility = $("#select_item").css("visibility");
  if (e.target.tagName !== "A") return false;
  const x = e.clientX;
  const y = e.clientY;
  const newItem = document.getElementById("select_item");
  newItem.style.position = "fixed";
  newItem.style.width = "200px";
  newItem.style.left = x + "px";
  newItem.style.top = y + "px";
  $("#select_item").css(
    "visibility",
    optionsVisibility === "visible" ? "hidden" : "visible"
  );
  return false;
};
