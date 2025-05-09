/**
 * 근태 신청 현황 구분
 * type_1: 연차, 오전반차, 오후반차, 오전반반차, 오후반반차, 시간차휴가
 * type_2: 배우자출산, 청원휴가, 보건휴가, 경조휴가, 포상휴가, 산전후휴가, 배우자출산, 기타공가, 기타공가(오전), 기타공가(오후)
 * type_3: 외출, 외근, 출장
 * type_4: 재택근무
 * type_5: 교육, 오전교육, 오후교육
 * type_6: 민방위훈련, 동원훈련, 민방위(오전), 민방위(오후), 예비군훈련, 예비군훈련(오전), 예비군훈련(오후)
 * type_7: 병가(무급), 병가(유급), 공상, 산재
 */

const schedules = [
  {
    title: "교육",
    start: "2023-10-01",
    end: "2023-10-01",
  },
  {
    title: "유연근무(09:00-18:00)",
    start: "2023-10-03",
  },
  {
    title: "오후반차",
    start: "2023-10-05",
  },
  {
    title: "오후반차",
    start: "2023-10-06",
  },
  {
    title: "외근",
    start: "2023-10-24",
  },
];

function renderCalendarWidget(calendarEl) {
  if (!calendarEl) {
    return;
  }

  const calendar = new FullCalendar.Calendar(calendarEl, {
    headerToolbar: {
      start: "prev", // will normally be on the left. if RTL, will be on the right
      center: "title",
      end: "next", // will normally be on the right. if RTL, will be on the left
    },
    minTime: "07:00:00",
    maxTime: "24:00:00",
    locale: "en",
    initialDate: new Date(),
    navLinks: false,
    selectable: true,
    selectMirror: false,
    dayPopoverFormat: "",
    // 빈날자 선택시
    select: function (arg) {},
    // 일정 선택시
    eventClick: function (calEvent, jsEvent) {
      // 개발시 수정 로직 적용
    },
    dateClick: (info) => {},
    moreLinkClick: (e) => {
      return { click: "disable" };
    },
    editable: true,
    dayMaxEvents: true,
    events: schedules,
    datesSet: setMonthTitle,
  });

  calendar.render();
}

document.addEventListener("DOMContentLoaded", function () {
  $("#today_calendar.calendar").each(function (index, elem) {
    renderCalendarWidget(elem);
  });

  $(".tab_menu").on("click", function () {
    $(".tab_menu").removeClass("active");
    $(this).addClass("active");
  });

  /* 내결재 말풍선 이동 */
  $(".widget_approval .approval_list .progress_circle").mouseover(function (
    event
  ) {
    const xpos = $(this).position().left + 16;
    const ypos =
      $(this).position().top + $(this).parent().parent().position().top - 50;
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

  $(".renewal_table tbody td").each(function () {
    if ($(this).text().trim().match(/^\d+$/)) {
      $(this).addClass("number_font");
    }
  });

  // $(".fc-daygrid-day-top").click(function ({ target }) {
  //   const date = target.getAttribute("aria-label");
  //   const getDate = addOneDay(date);
  //   console.log(getDate);
  // });

  // $(".fc-daygrid-day-frame").click(function () {
  //   var prevClickedDate = document.querySelector(".clicked_date");
  //   if (prevClickedDate) {
  //     prevClickedDate.classList.remove("clicked_date");
  //   }
  //   $(this).addClass("clicked_date");
  // });

  $("#today_calendar").on(
    "click",
    ".fc-daygrid-day-top",
    function ({ target }) {
      const date = target.getAttribute("aria-label");
      const getDate = addOneDay(date);
      console.log(getDate);
    }
  );

  $("#today_calendar").on("click", ".fc-daygrid-day-frame", function () {
    var prevClickedDate = document.querySelector(".clicked_date");
    if (prevClickedDate) {
      prevClickedDate.classList.remove("clicked_date");
    }
    $(this).addClass("clicked_date");
  });

  /**
   * 근태신청현황 위젯
   */
  $(".select_toggle_people").click(function (e) {
    const targetId = $(this).data("target");
    const target = $("#" + targetId);
    const visibility = target.css("visibility");
    const x = e.clientX;
    const y = e.clientY;
    target.css("style", "fixed");
    target.css("left", x + "px");
    target.css("top", y + "px");
    if (visibility === "hidden") {
      target.addClass("active");
    } else {
      target.removeClass("active");
    }
    event.stopPropagation();
  });

  // 다른 곳을 클릭했을 때의 로직
  $(document).click(function () {
    $("#people_status").removeClass("active");
  });
  /** 근태신청현황 위젯 */
});

/* 인사 담당자 short */
try {
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
  });
} catch (error) {}

/* 인사 담당자 wide */
try {
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
  });
} catch (error) {}

const setMonthTitle = ({ view }) => {
  convertToKoreanDateFormat(view.title);
};

function convertToKoreanDateFormat(dateStr) {
  const monthTitle = document.querySelector(".calendar_wrap #fc-dom-1");
  const monthMap = {
    January: "1",
    February: "2",
    March: "3",
    April: "4",
    May: "5",
    June: "6",
    July: "7",
    August: "8",
    September: "9",
    October: "10",
    November: "11",
    December: "12",
  };

  const parts = dateStr.split(" ");
  const month = monthMap[parts[0]];
  const year = parts[1];

  monthTitle.innerHTML = `<span>${year}</span>년 <span>${month}</span>월`;
}

function addOneDay(date) {
  const result = new Date(date);
  result.setDate(result.getDate() + 1);
  return result.toISOString().split("T")[0];
}
