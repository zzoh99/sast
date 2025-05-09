<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget20 = {
	selectYear: null,
	selectMonth: null,
	size: null,
	seq: null
};

function init_listBox20(size) {
	widget20.size = size;
	loadWidget20();
}

function loadWidget20() {
	const today = new Date();
	widget20.selectYear = today.getFullYear();
	widget20.selectMonth = (today.getMonth() + 1);
	
	var base = '';
	if (widget20.size != 'bwide') {
		base += '<div class="today_task_select_box">';
		base += '	<div class="custom_select no_style">';
		base += '	  <button class="select_toggle" >';
		base += '		<span id="widget20SelectYear"></span><i class="mdi-ico">arrow_drop_down</i>';
		base += '	  </button>';
		base += '	  <div id="widget20SelectYearOption" class="select_options numbers">';
		base += '	  </div>';
		base += '	</div>';
		base += '	<div class="custom_select no_style">';
		base += '	  <button class="select_toggle">';
		base += '		<span id="widget20SelectMonth"></span><i class="mdi-ico">arrow_drop_down</i>';
		base += '	  </button>';
		base += '	  <div id="widget20SelectMonthOption" class="select_options numbers">';
		base += '		<div class="option">1월</div>';
		base += '		<div class="option">2월</div>';
		base += '		<div class="option">3월</div>';
		base += '		<div class="option">4월</div>';
		base += '		<div class="option">5월</div>';
		base += '		<div class="option">6월</div>';
		base += '		<div class="option">7월</div>';
		base += '		<div class="option">8월</div>';
		base += '		<div class="option">9월</div>';
		base += '		<div class="option">10월</div>';
		base += '		<div class="option">11월</div>';
		base += '		<div class="option">12월</div>';
		base += '	  </div>';
		base += '	</div>';
		base += '</div>';
		base += '<div id="widget20TaskTable" class="today_task_table"></div>';

		$('#widget20Body').html(base);

		//현재 날짜 정보를 바탕으로 year, month 정보 셋팅
		const yearOptions = '<div class="option">' + ( today.getFullYear() - 1 ) + '년</div>\n'
						  + '<div class="option">' + ( today.getFullYear() + 1 ) + '년</div>\n';

		$('#widget20SelectYearOption').html(yearOptions);
		$('#widget20SelectYear').text(widget20.selectYear + '년');
		$('#widget20SelectMonth').text(widget20.selectMonth + '월');
		onDropDown();
		onDropDownOptionClick();
		onSelectionEvent();
	} else {
		$('#widget20Contents').addClass('today_calendar');
		base += '<div class="calendar_wrap">\n';
		base += '	<div class="calendar" id="widget20Calendar" ></div>\n';
		base += '</div>\n';
		base += '<div class="line"></div>\n';
		base += '<div class="attendance_box">\n';
		base += '	<div class="attendance_box_title">\n';
		base += '		<time id="widget20CalSelTime">' + widget20.selectYear + '년 ' + widget20.selectMonth + '월' + '</time>\n';
		base += '		<span>일정</span>\n';
		base += '		<div>\n';
		base += '			<span id="widget20SelBirth"></span>\n';
		base += '			<span id="widget20SelApply"></span>\n';
		base += '			<span id="widget20SelSched"></span>\n';
		base += '		</div>\n';
		base += '	</div>\n';
		base += '	<ul id="widget20CalContent" class="desc_content"></ul>\n';
		base += '</div>\n';
		$('#widget20Contents').append(base);
	}
	getContents();
}

function onSelectionEvent() {
	const regex = /[^0-9]/g;
	$('#widget20SelectYearOption div.option').click((e) => {
		widget20.selectYear = Number($(e.target).text().replace(regex, ''));
		$('#widget20SelectYear').text(widget20.selectYear + '년');

		const yearOptions = '<div class="option">' + ( widget20.selectYear - 1 ) + '년</div>\n'
		  + '<div class="option">' + ( widget20.selectYear + 1 ) + '년</div>\n';
		  $('#widget20SelectYear').text(widget20.selectYear + '년');
		$('#widget20SelectYearOption').html(yearOptions);
		onDropDownOptionClick();
		onSelectionEvent();	
		getContents();
	});

	$('#widget20SelectMonthOption div.option').click((e) => {
		widget20.selectMonth = Number($(e.target).text().replace(regex, ''));
		$('#widget20SelectMonth').text(widget20.selectMonth + '월');
		getContents();
	});
	
}

function getContents() {
	const param = 'mainDate=' + widget20.selectYear + lpad(widget20.selectMonth.toString(), '0', 2);
	var data = ajaxCall('/getMainCalendarMap3.do', param, false).list;
	//일정 시작일로 정렬
	data.sort((a, b) => (a.sYmd > b.sYmd ? 1:-1));
	
	if (widget20.size != 'bwide') {
		$('#widget20TaskTable').empty();
		var html = '';
		if (!data || data.length == 0) {
			html = '<div class="no_list">\n'
				 + '	<i class="icon-calendar-dark"></i>\n'
				 + '	<p>등록된 일정이 없습니다.</p>'
	             + '</div>';
		} else {
			if ( widget20.size == 'wide' ) {
				$('#widget20TaskTable').addClass('long');
				var ltable = '<table>\n';
				var rtable = '<table>\n';
				data.forEach((d, i) => {
					const color = d.type == 1 ? 'blue'
								: d.type == 2 ? 'green':'purple';
					const name = d.title;
					const period = d.period;
					if (i % 2 == 0) {
						ltable += '<tr>\n'
							    + '	<td><span class="tag_icon task ' + color +'">' + d.gntNm + '</span></td>\n'
							    + '	<td>' + name + '</td>\n'
							    + '	<td class="number_font">' + period + '</td>\n'
							    + '</tr>\n';
					} else {
						rtable += '<tr>\n'
						    + '	<td><span class="tag_icon task ' + color +'">' + d.gntNm + '</span></td>\n'
						    + '	<td>' + name + '</td>\n'
						    + '	<td class="number_font">' + period + '</td>\n'
						    + '</tr>\n';
					}
					if ((i + 1) == data.length) {
						ltable += '</table>';
						rtable += '</table>';
					}
				});

				html += ltable + rtable;
			} else {
				$('#widget20TaskTable').removeClass('long');
				html = data.reduce((a, c, i) => {
					const color = c.type == 1 ? 'blue'
								: c.type == 2 ? 'green':'purple';
					const name = c.title;
					const period = c.period;
					a += '<tr>\n'
					    + '	<td><span class="tag_icon task ' + color +'">' + c.gntNm + '</span></td>\n'
					    + '	<td>' + name + '</td>\n'
					    + '	<td class="number_font">' + period + '</td>\n'
					    + '</tr>\n';
					    
					if ((i + 1) == data.length) {
						a += '</table>';
					}
					return a;
				}, '');
			}
		}
		$('#widget20TaskTable').html(html);
	} else {
		const schedules = data.map(d => ({ title: d.title + ' ' + d.period, start: d.sYmd, end: d.eYmd, className: 'type_' + d.type }));
		const schedcnt = data.filter(d => d.type == 1).length;
		const birthcnt = data.filter(d => d.type == 2).length;
		const applycnt = data.filter(d => d.type == 3).length;
		$('#widget20SelSched').html('<span class="state_icon blue"></span>일정 ' + schedcnt);
		$('#widget20SelBirth').html('<span class="state_icon green"></span>생일 ' + birthcnt);
		$('#widget20SelApply').html('<span class="state_icon purple"></span>근태 ' + applycnt);

		const desc = data.reduce((a, c) => {
				const color = c.type == 1 ? 'blue' : c.type == 2 ? 'green':'purple';
				const content = c.gntNm + ' ' + c.title + ' ' + c.period
				a += '<li><span class="state_line ' + color + '"></span><span class="text_content">' + content + '</span></li>\n'; 
				return a;
			}, '');

		$('#widget20CalContent').html(desc);
		widget20DrawCalendar(schedules);
	}
}

function widget20DrawCalendar(schedules) {
	const calendar = new FullCalendar.Calendar(document.getElementById("widget20Calendar"), {
	      headerToolbar: {
	        start: "prev", // will normally be on the left. if RTL, will be on the right
	        center: "title",
	        end: "next", // will normally be on the right. if RTL, will be on the left
	      },
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
	      dateClick: () => {
	        // 날자 선택시 이벤트 개발시 참조하세요
	      },
	      moreLinkClick: (e) => {
	        return { click: "disable" };
	      },
	      editable: true,
	      dayMaxEvents: true,
	      events: schedules,
	      datesSet: ({ view }) => {
			 var datestring = view.title;
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

			  const parts = datestring.split(" ");
			  const month = monthMap[parts[0]];
			  const year = parts[1];

			  monthTitle.innerHTML = '<span>' + year + '</span>년 <span>' + month + '</span>월';
		  },
	    });
    
	calendar.render();
}

</script>
<div id="widget20Contents" class="widget_content">
	<div class="widget_header">
	  <div class="widget_title">
		<i class="mdi-ico filled">calendar_month</i>오늘의 일정
	  </div>
	</div>
	<div id="widget20Body" class="widget_body">
	</div>
</div>