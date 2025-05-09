<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112863' mdef='근태신청'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%--<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>--%>
<script defer src="/assets/plugins/fullcalendar-6.1.8/main.js"></script>
<link rel="stylesheet" href="/common/css/fullCalendar_5.3.0.css" />
<script src="/assets/js/util.js"></script>
<script src="/assets/js/utility-script.js?ver=3"></script>
<script type="text/javascript">

	//functions
	/**
	 * 내 휴가 현황 날짜를 변경한다
	 */
	function myVacationDate(calendar){
		const currentDate = calendar.currentData.currentDate;
		const date = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate());
		const firstDayYear = normalDateFormat(date, '.');//현재년도 1월 1일
		const currentDayMonth = normalDateFormat(date, '.');//현재년월 마지막일
// 		document.getElementById('vacation_date').innerHTML = firstDayYear + ' ~ ' + currentDayMonth;
	}
	/**
	 * 현재 년월을 초기화한다
	 */
	function initialDate(calendar) {
		const currentDate = calendar.currentData.currentDate;
		const date = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate());
		document.getElementById("current_year").innerHTML = date.getFullYear();
		document.getElementById("current_month").innerHTML = date.getMonth() + 1;
		myVacationDate(calendar);
	}
	/**
	 * 이전,다음달 이벤트 발생시 현재 년월을 변경한다
	 * @param calendar
	 */
	function handleClickGetCurrentDate(calendar) {
		const { viewTitle, currentDate } = calendar.currentData;
		const getYear = viewTitle.split(" ")[1];
		const getMonth = new Date(currentDate).getMonth();
		document.getElementById("current_year").innerHTML = getYear;
		document.getElementById("current_month").innerHTML = getMonth + 1;

		myVacationDate(calendar);
		const today = Utils.parseDate(new Date());
		let selDate = Utils.parseDate(calendar.getDate());
		
		if(Utils.parseDate(calendar.getDate()) >= today){
			const currentDate = calendar.currentData.currentDate;
			selDate = Utils.parseDate(new Date(currentDate.getFullYear(), currentDate.getMonth(), 0));
		}
		searchWorktime(selDate);
		searchVacationList(selDate);
	}
	/**
	 * 레이어 팝업 열기
	 * @param url
	 * @param param
	 * @param calendar
	 */
	function showLayer(url, param, calendar){
		if(!isPopup()) {return;}
		//window.top.openLayer(url, param, 800, 815, 'initLayer');
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: param,
			width: 800,
			height: 815,
			title: '근태신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						searchWorkday(calendar);
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
	}
	/**
	 * 근태 상세 모달을 활성화 한다 : 상세/변경/취소
	 */
	function showAttendDetailModal(calendar, calendarEvent, type){
		 		 
		//변경 : 24, 취소 : 23, 상세 : 22
		//id로 캘린더의 리소스 데이터를 검색한다
		const data = Utils.resource(calendar, calendarEvent.event.id);
		let url = '/ApprovalMgr.do?cmd=viewApprovalMgrLayer'

		let arg = {
			searchApplCd : type
			, searchApplSeq : ''
			, adminYn : 'N'
			, authPg : 'A'
			, searchSabun : '${ssnSabun}'
			, searchApplSabun : '${ssnSabun}'
			, searchApplYmd : '${curSysYyyyMMdd}'
		};
		//상세인 경우 searchApplSeq 를 변경한다
		if(type === '22') {
			arg.searchApplSeq = data.applSeq;
			if(data.applStatusCd != '11') {
				arg.authPg = 'R';
				url = '/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer';
			}
		} else{ // 취소, 변경 신청
			if(data.applStatusCd2 != '11' && data.applStatusCd2 != '') {
				arg.authPg = 'R';
				url = '/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer';
			}
			arg.etc01 = data.applSeq;
			arg.searchApplSeq = data.applSeq2;
			arg.searchSabun = data.applSabun2;
			arg.searchApplYmd = data.applYmd;
			
		}

		if(data.applSeq) showLayer(url, arg, calendar);
	}
	/**
	 * 근태신청 모달을 활성화 한다
	 */
	function showAttendModal(calendar, event) {
		
		if(event.jsEvent.toElement.tagName.toUpperCase() === 'BUTTON') return;

		searchWorktime(event.endStr.replace(/-/gi,""));
		searchVacationList(event.endStr.replace(/-/gi,""));
		
		if(isShowTooltip()) hideTooltip();
		const date = new Date(event.endStr);
		date.setDate(date.getDate() - 1);
		const calcDate = normalDateFormat(date, '-');
		showLayer('/ApprovalMgr.do?cmd=viewApprovalMgrWorkdayLayer', {
			adminYn : 'N'
			, authPg : 'A'
			, searchApplCd : '22'
			, searchApplSabun : '${ssnSabun}'
			, searchApplSeq : ''
			, searchApplYmd : '${curSysYyyyMMdd}'
			, searchSabun : '${ssnSabun}'
			, startYmd : event.startStr
			, endYmd : calcDate
		}, calendar);
	}

	function getReturnValue(returnValue) {
	}

	// function onClickAddSchedule(arg, calendar) {
	// 	$(".attendance_submit")
	// 			.off()
	// 			.on("click", function () {
	// 				handleSubmitAddAttendance(arg, calendar);
	// 			});
	// 	calendar.unselect();
	// }
	// function handleSubmitAddAttendance(arg, calendar) {
	// 	calendar.addEvent({
	// 		title: "추가된 일정",
	// 		start: arg.start,
	// 		end: arg.end,
	// 		allDay: arg.allDay,
	// 		className: "success",
	// 	});
	// 	closeAttendanceModal();
	// }
	/**
	 * 근태신청 모달을 비활성화 한다
	 */
	function closeAttendanceModal() {
		$(".attendance_modal .modal, .attendance_modal .modal_background").fadeOut(150);
	}
	/**
	 * 잔여 휴가 내역을 조회한다
	 */
	function searchVacationList(selDate){
// 		const currentDate = Utils.parseDate(new Date(), '-');
		let currentDate = selDate;
		const sabun = '${ssnSabun}';

		$.ajax({
			url: '${ctx}/WorkdayApp.do?cmd=getWorkdayAppList'
			, type : "post"
			, dataType: 'json'
			, data: {
				searchBaseYmd : currentDate
				, searchSabun : sabun
			}
			, error : function(){}
			, success : function(response){
				bindVacation(response.DATA);
			}
		});
	}
	/**
	 * 잔여 휴가 내역을 바인딩 한다
	 */
	function bindVacation(data){
		let allVacation = 0;//전체
		let usedVacation = 0;//사용
		let useSYmd = "";
		let useEYmd = "";
		for(let i=0; i<data.length; i++){
			allVacation += data[i].creCnt;
			usedVacation += data[i].usedCnt;
			useSYmd = data[i].useSYmd;
			useEYmd = data[i].useEYmd;
		}
		$('#allVacation').text(allVacation + ' |');
		$('#restVacation').text(allVacation - usedVacation);
		$('#vacation_date').text(useSYmd + ' ~ ' + useEYmd);
	}
	/**
	 * 캘린더의 현재 년/월 1일~마지막일 까지 근태 목록을 조회한다
	 */
	function searchWorkday(calendar){
		const currentDate = Utils.currentDate('-');
		const startDate = Utils.parseFirstDayMonth(calendar.currentData.currentDate, '-');
		const endDate = Utils.parseLastDayMonth(calendar.currentData.currentDate, '-');
		const sabun = '${ssnSabun}';

		$.ajax({
			url: '${ctx}/WorkdayApp.do?cmd=getWorkdayAppExList'
			, type : "post"
			, dataType: 'json'
			, data: {
				searchBaseYmd : currentDate
				, searchSabun : sabun
				, searchAppSYmd : startDate
				, searchAppEYmd : endDate
			}
			, error : function(){}
			, success : function(response){
				const events = parseCalendarEvent(response.DATA);
				calendar.removeAllEventSources();
				calendar.addEventSource(events);
			}
		});
	}
	/**
	 * 캘린더 데이터 구조체에 맞게 파싱한다
	 * @param data
	 * @returns {*[]}
	 */
	function parseCalendarEvent(data){
		for(let i=0; i<data.length; i++){
			let start = Utils.addDateSeparator(data[i].sYmd, '-');

			let eYmd = new Date(Utils.addDateSeparator(data[i].eYmd, '-'));
			eYmd = new Date(eYmd.setDate(eYmd.getDate() + 1));
			let end = Utils.parseDate(eYmd, '-');

			// 신청 완료된 건과 신청 진행중인 건의 bgcolor 구분
			if(data[i].applStatusCd == "99") {
				if(data[i].applStatusCd2 == "99" || data[i].applStatusCd2 == "") {
					// 변경신청 완료건 달력 표시일자 변경 일자로 표시
					if(data[i].applStatusCd2 == "99") {
						start = Utils.addDateSeparator(data[i].sYmd2, '-');
						eYmd = new Date(Utils.addDateSeparator(data[i].eYmd2, '-'));
						eYmd = new Date(eYmd.setDate(eYmd.getDate() + 1));
						end = Utils.parseDate(eYmd, '-');
					}
					data[i].className = ['success', 'type_1'];
				} else {
					data[i].title = data[i].gntNm + " " + data[i].typeNm;
					data[i].className = ['success', 'type_8'];
				}
			} else {
				data[i].className = ['success', 'type_8'];
			}

			data[i].id = data[i].applSeq;
			data[i].title = data[i].gntNm;
			data[i].start = start;
			data[i].end = end;
		}
		// return calendarList;
		return data;
	}
	/**
	 * 총 근무시간 표시
	 */
	function searchWorktime(selDate){
		
		let currentDate = selDate;
// 		const today = Utils.parseDate(new Date());
// 		const month = today.substr(0,6);
// 		debugger;
		
// 		if(currentDate.substr(0,6) == month){
// 			currentDate = today;
// 		}
	    
		$.ajax({
			url: '${ctx}/WorkdayApp.do?cmd=getWorktimeAppPlan'
			, type : 'GET'
			, dataType: 'JSON'
			, data: {
				searchSabun : '${ssnSabun}'
				,searchBaseYmd: currentDate
			}
			, error : function(err){}
			, success : function(response){
			    if(response.DATA != null ){
			    	$('#worktimeDefault').text(response.DATA.worktimeDefault + ' |');
					$('#worktime').text(response.DATA.worktime);
					$('#worktimeOver').text(response.DATA.worktimeOver);
					$('#term_date').text(response.DATA.sYmd + " ~ " + response.DATA.eYmd);
			    } else {
			    	$('#worktimeDefault').text('0' + ' |');
					$('#worktime').text('0');
					$('#worktimeOver').text('0');
					$('#term_date').text("0000.00.00" + " ~ " + "0000.00.00");
			    }
				
			}
		});
	}
	/**
	 * 캘린더 툴팁 숨기기
	 */
	function hideTooltip(){
		const buttons = document.getElementsByClassName('tooltip-buttons');
		for(let i=0; i<buttons.length; i++){
			let parentNode = buttons[i].parentNode;
			parentNode.removeChild(buttons[i]);
		}
	}
	function searchShowingTooltip(){
		const tooltips = document.getElementsByClassName('tooltip-buttons');
		return (tooltips.length === 1) ? tooltips[0] : null;
	}
	/**
	 * 캘린더 툴팁 보기
	 * @param calendar
	 * @param e
	 */
	function showTooltip(calendar, e){
		const currentData = Utils.resource(calendar, e.event.id);

		//열린 툴팁이 있고 툴팁의 id 가 동일한 경우 > 툴팁만 닫기
		const showingTooltip = searchShowingTooltip();
		if(isShowTooltip() && (showingTooltip && showingTooltip.getAttribute('id') === e.event.id)){
			hideTooltip();
			return;
		}

		//열린 툴팁이 있고 툴팁의 id 가 다른 경우 > 모든 툴팁 닫고 새 툴팁 열기
		if(isShowTooltip() && (showingTooltip && showingTooltip.getAttribute('id') !== e.event.id)){
			hideTooltip();
		}

		//열린 툴팁이 없는 경우 > 툴팁 열기
		let tooltip = document.createElement('div');
		tooltip.setAttribute('class', 'tooltip-buttons');
		tooltip.setAttribute('id', e.event.id);

		//세부내역
		let detailButton = document.createElement('button');
		detailButton.setAttribute('type', 'button');
		detailButton.setAttribute('class', 'btn outline_gray');
		detailButton.innerText = '세부내역';
		detailButton.addEventListener('click', function(event){
			showAttendDetailModal(calendar, e, '22');
		});
		tooltip.appendChild(detailButton);
		tooltip.style.top = '-54px';

		if(currentData.applStatusCd === '99'){

			//변경신청
			if(currentData.cancleApplCd == '' || currentData.cancleApplCd == '24') {
				let modifyButton = document.createElement('button');
				modifyButton.setAttribute('type', 'button');
				modifyButton.setAttribute('class', 'btn outline_gray');
				modifyButton.innerText = '변경신청';
				modifyButton.addEventListener('click', function(event){
					showAttendDetailModal(calendar, e, '24');
				});
				tooltip.appendChild(modifyButton);
			}

			//취소신청
			if(currentData.cancleApplCd == '' || currentData.cancleApplCd == '23') {
				let removeButton = document.createElement('button');
				removeButton.setAttribute('type', 'button');
				removeButton.setAttribute('class', 'btn outline_gray');
				removeButton.innerText = '취소신청';
				removeButton.addEventListener('click', function(event){
					showAttendDetailModal(calendar, e, '23');
				});
				tooltip.appendChild(removeButton);
			}

			if(currentData.cancleApplCd == '') {
				tooltip.style.top = '-120px';
			} else {
				tooltip.style.top = '-85px';
			}

		}

		e.el.parentNode.appendChild(tooltip);
	}
	/**
	 * 툴팁 열려있는지 확인
	 * @returns {boolean}
	 */
	function isShowTooltip(){
		const buttons = document.getElementsByClassName('tooltip-buttons');
		return (buttons.length > 0);
	}


	$(function(){

		//local variables
		const calendar = new FullCalendar.Calendar(document.getElementById('calendar'), {
			headerToolbar: null,
			minTime: "07:00:00",
			maxTime: "24:00:00",
			locale: "en",
			initialDate: new Date(),
			navLinks: false,
			selectable: true,
			selectMirror: false,
			//일정 이동 방지
			eventDrop: function(info){
				info.revert();
			},
			dropable:false,
			// 빈날자 선택시
			select: function (e) {
				showAttendModal(calendar, e);
			},
			eventClick: function (e) {
				showTooltip(calendar, e);
			},
			editable: true,
			dayMaxEvents: true,
			events: []
		});

		//methods
		/**
		 * 달력 이전 버튼 이벤트
		 */
		$("#left_month_btn").on("click", function () {
			calendar.prev(); // 캘린더를 이전 달로 이동시킵니다.
			handleClickGetCurrentDate(calendar);
			searchWorkday(calendar);
			searchHoliday(calendar);
		});
		/**
		 * 달력 다음 버튼 이벤트
		 */
		$("#right_month_btn").on("click", function () {
			calendar.next(); // 캘린더를 다음 달로 이동시킵니다.
			handleClickGetCurrentDate(calendar);
			searchWorkday(calendar);
			searchHoliday(calendar);
		});
		/**
		 * 근태 모달 비활성화 이벤트
		 */
		$('.close-modal-event').on('click', function(){
			closeAttendanceModal();
		});



		//default function call
		calendar.render();
		initialDate(calendar);
		searchVacationList(Utils.parseDate(calendar.getDate()));
		searchWorkday(calendar);
		searchWorktime(Utils.parseDate(calendar.getDate()));
		searchHoliday(calendar);
	});

	function searchHoliday(calendar) {
		const startDate = Utils.parseFirstDayMonth(calendar.currentData.currentDate, '-');
		const endDate = Utils.parseLastDayMonth(calendar.currentData.currentDate, '-');
		$.ajax({
			url: '${ctx}/WorkdayApp.do?cmd=getHolidayList'
			, type : "post"
			, dataType: 'json'
			, data: {
				searchAppSYmd : startDate
				, searchAppEYmd : endDate
			}
			, error : function(){}
			, success : function(response) {
				let holidayList = response.DATA;
				let dateList = $('.fc-daygrid-day-top');
				holidayList.filter(holiday => {
					dateList.filter(param => {
						let obj = $($(dateList[param]).children());
						let happyNewYear = new Date(obj.attr('aria-label'));
						const year = happyNewYear.getFullYear();
						const month = happyNewYear.getMonth() >= 10 ? happyNewYear.getMonth() + 1 : '0' + (happyNewYear.getMonth() + 1);
						const date = happyNewYear.getDate() >= 10 ? happyNewYear.getDate() : '0' + happyNewYear.getDate();
						const fullDate = year + '-' + month + '-' + date;
						if(Utils.addDateSeparator(holiday.holidayDate, '-') === fullDate) {
							obj.text(holiday.holidayNm + ' ' + happyNewYear.getDate());
							if(holiday.holidayYn === 'Y') {
								obj.css('color', '#ff0000');
							}
						}
					});
				});
			}
		});
	}

</script>
	<style>
		div.tooltip-buttons{
			display: flex;
			flex-direction: column;
			justify-content: center;
			position: absolute;
			/*top: -120px;*/
			left:24px;
			z-index: 99999;
			background: #FFF;
			padding: 5px;
			border: 1px solid #ddd;
		}
		div.tooltip-buttons::after{
			content: '';
			position: absolute;
			bottom: -3px;
			margin: 0 auto;
			left: 43px;
			width: 0;
			height: 0;
			border-top: 5px solid #fff;
			border-left: 5px solid transparent;
			border-right: 5px solid transparent;
		}
		div.tooltip-buttons::before{
			content: '';
			position: absolute;
			bottom: -5px;
			margin: 0 auto;
			left: 43px;
			width: 0;
			height: 0;
			border-top: 5px solid #ddd;
			border-left: 5px solid transparent;
			border-right: 5px solid transparent;
		}
		div.tooltip-buttons button.btn.outline_gray{
			margin:0 0 2px 0;
			background:#fff;
		}
	</style>
</head>
<body>
	<main class="main_content attendance_calendar">
<%--		<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>--%>

<%--		<div id="tooltip">--%>
<%--			<button type="button" id="btnApplModify" class="btn outline_gray">변경신청</button>--%>
<%--			<button type="button" id="btnApplRemove" class="btn outline_gray">취소신청</button>--%>
<%--		</div>--%>

		<!-- main_tab_content -->
		<section class="main_tab_content bg_gray">
			<!-- attendance_calendar -->
			<div class="calendar_wrap">
				<header class="calendar_header">
					<!-- 날자,pagination 영역 -->
					<div class="select_month_field">
						<i class="mdi-ico" id="left_month_btn">keyboard_arrow_left</i>
						<div class="month_text">
							<span class="date" id="current_year">2023</span>
							<span>년</span>
							<span class="date" id="current_month">6</span>
							<span>월</span>
						</div>
						<i class="mdi-ico" id="right_month_btn">keyboard_arrow_right</i>
					</div>
					<!-- // 날자,pagination 영역 -->

					<!-- progress bar 영역 -->
					<div class="vacation_information">
						<div>
							<div class="work_plan_box">
								<!-- todo : 근무시간 조회 필요함 -->
							    <div>
							        <span>단위근무기간</span>
							    	<span id="term_date" class="term_date" style="font-size: 16px; margin-left: 8px; font-weight: normal;">0000.00.00 ~ 0000.00.00</span>
							    </div>
								<div>
									<span>총 근무시간/계획</span>
								</div>
								<div>
									<span>기본근무</span>
									<span class="gray_text" id="worktimeDefault">0 |</span>
									<span class="main_number" id="worktime">0</span>
								</div>
								<div>
									<span>연장근무</span> <span class="main_number" id="worktimeOver" style=" margin-left: 8px;">0</span>
								</div>
							</div>
							<div class="progress_container progress_bar_month plan_progress">
								<div class="progress_bar bar_blue" style="width: 40%"></div>
							</div>
						</div>
						<div>
							<div class="vacation_number_field">
								<div>
									<span>내 휴가 현황</span>
									<span id="vacation_date" class="vacation_date">0000.00.00 ~ 0000.00.00</span>
								</div>
								<div>
									<span>잔여휴가</span>
									<span class="gray_text" id="allVacation">0 |</span>
									<span class="main_number" id="restVacation">0</span>
								</div>
							</div>
							<div class="progress_container progress_bar_month">
								<div class="progress_bar bar_blue" style="width: 40%"></div>
							</div>
						</div>
					</div>
					<!-- // progress bar 영역 -->
				</header>

				<!-- 달력 영역 -->
				<div class="calendar" id="calendar"></div>
				<!-- // 달력 영역 -->

			</div>
			<!-- // attendance_calendar -->
		</section>
		<!-- // main_tab_content -->
	</main>

</body>
</html>