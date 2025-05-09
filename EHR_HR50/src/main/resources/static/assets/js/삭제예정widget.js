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
];

document.addEventListener("DOMContentLoaded", function () {
  const calendarEl = document.getElementById("today_calendar");
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
      // 빈날자 선택시
      select: function (arg) {},
      // 일정 선택시
      eventClick: function (calEvent, jsEvent) {
        // 개발시 수정 로직 적용
      },
      dateClick: (info) => {
	    var prevClickedDate = document.querySelector(".clicked_date");
	    if (prevClickedDate) {
	      prevClickedDate.classList.remove("clicked_date");
	    }
	    info.dayEl.classList.add("clicked_date");
       },
      moreLinkClick: (e) => {
        return { click: "disable" };
      },
      editable: true,
      dayMaxEvents: true,
      events: schedules,
      datesSet: setMonthTitle,
    });

  calendar.render();

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

  $(".renewal_table tbody td").each(function () {
    if ($(this).text().trim().match(/^\d+$/)) {
      $(this).addClass("number_font");
    }
  });

  $(".fc-daygrid-day-top").click(function ({ target }) {
    const date = target.getAttribute("aria-label");
    const getDate = addOneDay(date);
    console.log(getDate);
    // getDate로 api 로직 적용
  });
});

/* 인사 담당자 short */
var managerSwiper = new Swiper(".management_short", {
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

/* 인사 담당자 wide */
var managerSwiper = new Swiper(".management_wide", {
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
