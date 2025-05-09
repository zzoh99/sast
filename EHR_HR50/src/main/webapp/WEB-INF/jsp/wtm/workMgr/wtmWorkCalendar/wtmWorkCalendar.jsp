<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112863' mdef='근태/근무캘린더'/></title>
<!-- bootstrap -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>
<script src="/common/plugin/bootstrap/js/bootstrap.min.js"></script>
<script defer src="/assets/plugins/fullcalendar-6.1.8/main.js"></script>
<script src="/assets/js/util.js"></script>
<script src="/assets/js/utility-script.js?ver=7"></script>
<script src="/assets/plugins/moment.js-2.30.1/moment-with-locales.js"></script>

<script type="text/javascript">

	$(function(){
		const calendarEl = document.getElementById("calendar");
		let selectedStartDate = null;
		let selectedEndDate = null;
		const calendar = new FullCalendar.Calendar(calendarEl, {
			customButtons: {
				prev: {
					text: 'prev',
					// 달력 이전 버튼 클릭 이벤트
					click: function() {
						calendar.prev(); // 캘린더를 이전 달로 이동시킵니다.
						handleClickGetCurrentDate(calendar);
						searchWorkday(calendar);
						searchWorktime(calendar);
						searchVacation();
					}
				},
				next: {
					text: 'next',
					// 달력 다음 버튼 클릭 이벤트
					click: function() {
						calendar.next(); // 캘린더를 다음 달로 이동시킵니다.
						handleClickGetCurrentDate(calendar);
						searchWorkday(calendar);
						searchWorktime(calendar);
						searchVacation();
					}
				}
			},
			headerToolbar: {
				left: null,
				center: 'prev title next',
				right: null,
			},
			locale: "ko",
			initialDate: new Date(),
			navLinks: false,
			selectable: true,
			selectMirror: false,
			editable: true,
			dayMaxEvents: true,
			droppable: false, // 이벤트 이동 가능 여부
			eventOrder: "order", // 동일한 일자에서 2개 이상의 이벤트가 표시 될 경우 이벤트 정렬 방법
			unselectCancel: ".fcUnselectCancel", // 특정 selector 에서 선택된 날짜가 초기화되지 않게 하는 옵션
			moreLinkText: function(num) {
				return num + '개 더보기';
			},
			//일정 이동 방지
			eventDrop: function(info){
				info.revert();
			},
			// 빈날자 선택시
			select: function (e) {
				selectedStartDate = e.startStr;
				selectedEndDate = e.endStr;
			},
			unselect: function () {
				selectedStartDate = '';
				selectedEndDate = '';
			},
			// 일정 클릭 시
			eventClick: function(e) {
				showTooltip(calendar, e);
			},
			// 날짜 우클릭 컨텍스트 메뉴
			datesSet: function() {
				// 날짜 셀에 컨텍스트 메뉴 이벤트 리스너 추가
				$('.fc-daygrid-day').on('contextmenu', function(event) {
					event.preventDefault();
					// 우클릭 한 위치의 날짜 정보 가져오기
					const dateStr = $(this).data('date');

					// 드래그로 선택한 날짜 범위 정보 표시
					if (selectedStartDate && selectedEndDate) {
						const endYmd = new Date(selectedEndDate);
						endYmd.setDate(endYmd.getDate() - 1);
						const realEndYmd = normalDateFormat(endYmd, '-');

						const chkDate = new Date(dateStr);
						const startYmd = new Date(selectedStartDate);
						if( chkDate >= startYmd && chkDate <= endYmd) {
							// 범위 날짜 정보를 컨텍스트 메뉴에 저장
							$('#contextMenu').data('startYmd', dateFormatToString(startYmd, '-'));
							$('#contextMenu').data('endYmd', dateFormatToString(endYmd, '-'));
							selectedStartDate === realEndYmd ? $('#menuDate').text(dateFormatToString(startYmd, '-')) : $('#menuDate').text(dateFormatToString(startYmd, '-') + ' ~ ' + dateFormatToString(endYmd, '-'));
						} else {
							// 우클릭 위치의 날짜가 드래그 범위를 벗어나는 경우, select 위치 조정
							calendar.unselect();
							calendar.select(dateStr);
							// 클릭한 날짜 정보를 컨텍스트 메뉴에 저장
							$('#contextMenu').data('startYmd', dateFormatToString(chkDate, '-'));
							$('#contextMenu').data('endYmd', dateFormatToString(chkDate, '-'));
							$('#menuDate').text(dateFormatToString(chkDate, '-'));
						}
					} else {
						// 날짜 선택 표시
						calendar.select(dateStr);
						// 클릭한 날짜 정보를 컨텍스트 메뉴에 저장
						$('#contextMenu').data('startYmd', dateStr);
						$('#contextMenu').data('endYmd', dateStr);
						$('#menuDate').text(dateStr);
					}

					$('#contextMenu').css({
						display: 'block',
						left: event.pageX + 'px',
						top: event.pageY + 'px'
					});

					if($('#contextMenu').data('startYmd') === dateStr && $('#contextMenu').data('endYmd') === dateStr) {
						$('#reqInOutTime').show(); // 출퇴근시간변경신청 보이기
					} else {
						$('#reqInOutTime').hide(); // 출퇴근시간변경신청 감추기
					}
				});

			}
		});

		/**
		 * 이번달 버튼 이벤트
		 */
		$("#thisMonth").on("click", function () {
			initialDate(calendar);
			handleClickGetCurrentDate(calendar);
			searchWorkday(calendar);
			searchWorktime(calendar);
			searchVacation();
		});

		/**
		 * 근태 모달 비활성화 이벤트
		 */
		$('.close-modal-event').on('click', function(){
			closeAttendanceModal();
		});

		/**
		 * 컨텍스트 메뉴 이벤트
		 */
		// 컨텍스트 메뉴가 외부를 클릭했을 때 숨기기
		$(document).on('click', function(event) {

			if (!$(event.target).closest('#contextMenu').length) {
				$('#contextMenu').hide();
			}

			if (!$(event.target).closest('.tooltip-buttons').length) {

				if (isShowTooltip() && !isClickEvent(event))
					hideTooltip();
			}
		});

		// 컨텍스트 메뉴 옵션 클릭 처리
		// 휴가신청
		$('#reqAttend, #reqAttendBtn').on('click', function() {
			showAttendModal(calendar, null, "I");
			$('#contextMenu').hide();
		});

		// 근무신청
		$('#reqWork, #reqWorkBtn').on('click', function() {
			showWorkModal(calendar, null, "I");
			$('#contextMenu').hide();
		});

		// 근무스케줄신청
		$('#reqWorkSchBtn').on('click', function() {
			openReqWorkSchedule(calendar);
			$('#contextMenu').hide();
		});

		// 출퇴근시간 변경 신청
		$('#reqInOutTime, #reqInOutTimeBtn').on('click', function() {
			showAttendTimeAdjModal(calendar)
			$('#contextMenu').hide();
		});

		// 닫기
		$('#menuClose').on('click', function() {
			$('#contextMenu').hide();
		});

		/**
		 * 상단 버튼 클릭 이벤트
		 */

		// 초기 설정
		calendar.render();
		initialDate(calendar);
		searchWorkday(calendar);
		searchWorktime(calendar);
		searchVacation();

		$('#searchOrgCd').click(function (){
			if($('#searchOrgCd').is(':checked')){
				$('.searchOrgType').show();
			}else{
				$('#searchOrgType').prop('checked', false);
				$('.searchOrgType').hide();
			}
			searchWorkday(calendar);
		})
		$('#searchOrgType').click(function (){
			searchWorkday(calendar);
		})
	});

	/**
	 * 달력 이벤트 클릭 여부
	 * @param _event
	 * @returns {*|jQuery|boolean}
	 */
	function isClickEvent(_event) {
		return ($(_event.target).is(".fc-event") || $(_event.target).closest(".fc-event").length > 0);
	}

	/**
	 * 4자리 숫자의 문자열을 HH:MM의 포맷으로 변경한다.
	 */
	function formatTime(time) {
		return time.replace(/(\d{2})(\d{2})/, "$1:$2");
	}

	/**
	 * 현재 년월을 초기화한다
	 */
	function initialDate(calendar) {
		calendar.gotoDate(new Date()); // 캘린더를 오늘 날짜로 이동
	}

	/**
	 * 이전,다음달 이벤트 발생시 현재 년월을 변경한다
	 * @param calendar
	 */
	function handleClickGetCurrentDate(calendar) {
		const { viewTitle, currentDate } = calendar.currentData;
		const getYear = viewTitle.split(" ")[1];
		const getMonth = new Date(currentDate).getMonth();

		const today = Utils.parseDate(new Date());
		let selDate = Utils.parseDate(calendar.getDate());
		
		if(Utils.parseDate(calendar.getDate()) >= today){
			const currentDate = calendar.currentData.currentDate;
			selDate = Utils.parseDate(new Date(currentDate.getFullYear(), currentDate.getMonth(), 0));
		}
	}

	/**
	 * 레이어 팝업 열기
	 * @param url {string} url 주소
	 * @param param {object} 파라미터
	 * @param calendar
	 * @param title {string} 제목
	 */
	function showLayer(url, param, calendar, title = ""){
		if(!isPopup()) {return;}
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: param,
			width: 1230,
			height: 815,
			title: title,
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						searchWorkday(calendar);
						searchWorktime(calendar);
						searchVacation();
					}
				}
			]
		});
		approvalMgrLayer.show();
	}

	/**
	 * 근무/근태/출퇴근시간변경신청 상세 모달을 활성화 한다 : 상세
	 * @param calendar {object} calendar 객체
	 * @param calendarEvent {object} 선택한 이벤트의 object
	 * @param type {string} 타입
	 */
	function showDetailModal(calendar, calendarEvent, type) {

		if (type !== "wtm401" && type !== "wtm301" && type !== "wtm201") {
			alert("접근할 수 없습니다.");
			return;
		}

		// 근무상세: wtm301, 근태상세 : wtm201, 출퇴근시간변경신청 : wtm401
		//id로 캘린더의 리소스 데이터를 검색한다
		const data = Utils.resource(calendar, calendarEvent.event.id);
		let url = '/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer'
		let title = '';
		if(type === "wtm201") {
			title = '근태신청'
		} else if (type === "wtm301") {
			 title = "근무신청";
		} else {
			title = "출퇴근시간변경신청";
		}
		let arg = {
			searchApplCd : type
			, searchApplSeq : data.applSeq
			, adminYn : 'N'
			, authPg : 'R'
			, searchSabun : '${ssnSabun}'
			, searchApplSabun : '${ssnSabun}'
			, searchApplYmd : '${curSysYyyyMMdd}'
		};
		if(isShowTooltip()) hideTooltip();
		if(data.applSeq) showLayer(url, arg, calendar, title);
	}

	/**
	 * 근태신청 모달을 활성화 한다
	 */
	function showAttendModal(calendar, calendarEvent, type) {

		const url = '/ApprovalMgr.do?cmd=viewApprovalMgrWorkdayLayer';
		let startStr, endStr, bfApplSeq, bfSeq, applSeq = "";
		if (calendarEvent) {
			// 변경/취소 또는 임시저장 후 신청 시
			// 선택한 이벤트에 대한 정보로 파라미터 데이터를 조회한다.
			const data = Utils.resource(calendar, calendarEvent.event.id);
			if (!((data.applStatusCd === "99" && type === "D")
					|| (data.applStatusCd === "11" && type === "I"))) {
				// 결재완료이면서 변경/취소 또는 임시저장이면서 신청이 아닌 경우
				alert("결재완료 상태가 아니기 때문에 변경/신청은 불가능합니다.");
				return;
			}

			if (data.applStatusCd === "99" && type === "D") {
				// 변경/취소일 경우에만 변경/취소에 대한 파라미터 넘김
				startStr = data.start;
				endStr = data.realEnd;
				bfApplSeq = data.applSeq;
				bfSeq = data.seq;
			} else {
				applSeq = data.applSeq;
			}
		} else {
			// 변경/취소가 아닌 신규 신청 건의 경우 선택한 일자 정보로 파라미터 데이터를 조회한다.
			if (calendar.currentData.dateSelection) {
				// 선택된 날짜가 있는 경우
				startStr = calendar.currentData.dateSelection.range.start.toISOString().split('T')[0];
				endStr = moment(calendar.currentData.dateSelection.range.end.toISOString().split('T')[0]).add(-1, "days").format("YYYY-MM-DD");
			}
		}

		const etc01 = (startStr && endStr) ? startStr + "_" + endStr : "";
		const etc02 = (bfApplSeq && bfSeq) ? bfApplSeq + "_" + bfSeq : "";

		if(isShowTooltip()) hideTooltip();
		showLayer(url, {
			adminYn : 'N'
			, authPg : 'A'
			, searchApplCd : 'wtm201'
			, searchApplSabun : '${ssnSabun}'
			, searchApplSeq : applSeq
			, searchApplYmd : '${curSysYyyyMMdd}'
			, searchSabun : '${ssnSabun}'
			, etc01 : etc01
			, etc02 : etc02
			, etc03 : type
		}, calendar);
	}
	/**
	 * 근태신청 모달을 비활성화 한다
	 */
	function closeAttendanceModal() {
		$(".attendance_modal .modal, .attendance_modal .modal_background").fadeOut(150);
	}

	/**
	 * 근무신청 모달을 활성화 한다
	 */
	function showWorkModal(calendar, calendarEvent, type) {

		const url= '/ApprovalMgr.do?cmd=viewApprovalMgrWorkdayLayer';
		let startStr, endStr, bfApplSeq, bfSeq, applSeq = "";

		if (calendarEvent) {
			// 변경/취소 신청 시 선택한 데이터의 정보로 파라미터 데이터를 조회한다.
			const data = Utils.resource(calendar, calendarEvent.event.id);
			if (!((data.applStatusCd === "99" && type === "D")
					|| (data.applStatusCd === "11" && type === "I"))) {
				// 결재완료이면서 변경/취소 또는 임시저장이면서 신청이 아닌 경우
				alert("결재완료 상태가 아니기 때문에 변경/신청은 불가능합니다.");
				return;
			}

			if (data.applStatusCd === "99" && type === "D") {
				// 변경/취소일 경우에만 변경/취소에 대한 파라미터 넘김
				startStr = data.start;
				endStr = data.realEnd;
				bfApplSeq = data.applSeq;
				bfSeq = data.seq;
			} else {
				applSeq = data.applSeq;
			}
		} else {
			if (calendar.currentData.dateSelection) {
				// 선택된 날짜가 있는 경우
				startStr = calendar.currentData.dateSelection.range.start.toISOString().split('T')[0];
				endStr = moment(calendar.currentData.dateSelection.range.end.toISOString().split('T')[0]).add(-1, "days").format("YYYY-MM-DD");
			}
		}

		const etc01 = (startStr && endStr) ? startStr + "_" + endStr : "";
		const etc02 = (bfApplSeq && bfSeq) ? bfApplSeq + "_" + bfSeq : "";

		if(isShowTooltip()) hideTooltip();
		showLayer(url, {
			adminYn : 'N'
			, authPg : 'A'
			, searchApplCd : 'wtm301'
			, searchApplSabun : '${ssnSabun}'
			, searchApplSeq : applSeq
			, searchApplYmd : '${curSysYyyyMMdd}'
			, searchSabun : '${ssnSabun}'
			, etc01 : etc01
			, etc02 : etc02
			, etc03 : type
		}, calendar);
	}
	/**
	 * 근무신청 모달을 비활성화 한다
	 */
	function closeWorkModal() {
		$(".attendance_modal .modal, .attendance_modal .modal_background").fadeOut(150);
	}


	/**
	 * 근무스케줄신청 화면으로 이동한다.
	 */
	function openReqWorkSchedule(calendar) {
		let startStr, endStr;
		if (calendar.currentData.dateSelection) {
			// 선택된 날짜가 있는 경우
			startStr = calendar.currentData.dateSelection.range.start.toISOString().split('T')[0];
			endStr = moment(calendar.currentData.dateSelection.range.end.toISOString().split('T')[0]).add(-1, "days").format("YYYY-MM-DD");
		}
		const param = '&startStr=' + startStr +
					  '&endStr=' + endStr +
					  '&applSabun=${ssnSabun}'
					  '&applSabunName=${ssnName}';
		window.location.href = '/WtmWorkCalendar.do?cmd=viewWtmReqWorkSchedule' + param;
	}

	/**
	 * 출퇴근시간 변경신청 모달을 활성화 한다
	 */
	function showAttendTimeAdjModal(calendar, calendarEvent) {

		let startStr, applSeq = '';
		if (calendarEvent) {
			const data = Utils.resource(calendar, calendarEvent.event.id);
			applSeq = data.applSeq;
			startStr = data.start;
		} else {
			if (calendar.currentData.dateSelection) {
				// 선택된 날짜가 있는 경우
				startStr = calendar.currentData.dateSelection.range.start.toISOString().split('T')[0];
			}
		}

		const etc01 = startStr;
		if(isShowTooltip()) hideTooltip();
		showLayer('/ApprovalMgr.do?cmd=viewApprovalMgrWorkdayLayer', {
			adminYn : 'N'
			, authPg : 'A'
			, searchApplCd : 'wtm401'
			, searchApplSabun : '${ssnSabun}'
			, searchApplSeq : applSeq
			, searchApplYmd : '${curSysYyyyMMdd}'
			, searchSabun : '${ssnSabun}'
			, etc01 : etc01
		}, calendar);
	}
	/**
	 * 출퇴근시간 변경신청 모달을 비활성화 한다
	 */
	function closeAttendTimeAdjModal() {
		$(".attendance_modal .modal, .attendance_modal .modal_background").fadeOut(150);
	}
	/**
	 * 출퇴근시간 변경신청 임시저장 건을 삭제
	 * @param calendar {object}
	 * @param calendarEvent {object}
	 */
	function deleteAttendTimeAdjApp(calendar, calendarEvent) {

		if (!calendar && !calendarEvent) return;

		const data = Utils.resource(calendar, calendarEvent.event.id);
		if (data.applStatusCd !== "11") {
			alert("임시저장만 삭제 가능합니다.");
			return;
		}

		const start = data.start;
		if (!confirm(start + data.title + " 을 삭제하시겠습니까?")) return;
		const param = "searchApplSeq=" + data.applSeq + "&searchSeq=" + data.seq;
		const result = ajaxCall("${ctx}/WtmWorkCalendar.do?cmd=deleteWtmCalendarAttendTimeAdjApp", param, false);
		if (result && result.Result) {
			alert(result.Result.Message);
			searchWorkday(calendar);
		} else {
			alert("삭제하는데 실패하였습니다. 담당자에게 문의바랍니다.");
		}
	}


	/**
	 * 잔여 휴가 내역을 조회한다
	 */
	function searchVacation(){
		const currentDate = Utils.currentDate('-');
		const sabun = '${ssnSabun}';

		$.ajax({
			url: '${ctx}/WtmWorkCalendar.do?cmd=getWtmWorkCalendarVacationMap'
			, type : "post"
			, dataType: 'json'
			, data: {
				searchBaseYmd : currentDate
				, searchSabun : sabun
			}
			, error : function(){}
			, success : function(response){
				if (response.DATA) {
					$('#useVacationCnt').text(response.DATA.useCnt);
					$('#restVacationCnt').text(response.DATA.restCnt);
					$('#usedVacationCnt').text(response.DATA.usedCnt);
				} else {
					$('#useVacationCnt').text("-");
					$('#restVacationCnt').text("-");
					$('#usedVacationCnt').text("-");
				}
			}
		});
	}

	/**
	 * 캘린더의 현재 년/월 1일~마지막일 까지 근무/근태 목록을 조회한다
	 */
	function searchWorkday(calendar){
		const currentDate = Utils.currentDate('-');
		const startDate = Utils.parseFirstDayMonth(calendar.currentData.currentDate, '-');
		const endDate = Utils.parseLastDayMonth(calendar.currentData.currentDate, '-');
		const sabun = '${ssnSabun}';
		const searchOrgCd = $('#searchOrgCd:checked').val()
		const searchOrgType = $('#searchOrgType:checked').val()

				$.ajax({
			url: '${ctx}/WtmWorkCalendar.do?cmd=getWtmWorkCalendarList'
			, type : "post"
			, dataType: 'json'
			, data: {
				searchBaseYmd : currentDate
				, searchSabun : sabun
				, searchSYmd : startDate
				, searchEYmd : endDate
				, searchOrgCd : searchOrgCd
				, searchOrgType : searchOrgType
			}
			, error : function() {}
			, success : function(response){
				const events = parseCalendarEvent(response);
				calendar.removeAllEventSources();
				calendar.addEventSource(events);
			}
		});
	}
	/**
	 * 캘린더 데이터 구조체에 맞게 파싱한다
	 * @param response
	 * @returns {*[]}
	 */
	function parseCalendarEvent(response){
		const inoutData = response.INOUT;
		const workData = response.WORK;
		const attendData = response.ATTEND;
		const sabun = '${ssnSabun}';

		let events = [];

		// 출퇴근기록
		for(let i=0; i<inoutData.length; i++){
			let start = Utils.addDateSeparator(inoutData[i].ymd, '-');
			let id = `inout${'${start}'}`;
			let inHm = formatTime(inoutData[i].inHm);
			let outHm = formatTime(inoutData[i].outHm);
			let applSeq = "";
			let applStatusCd = "";

			if(inHm || outHm) {
				let type = "";
				let title = `${'${inHm}'}~${'${outHm}'}`;
				let className = "default";
				if(inoutData[i].priority === '1') {
					className = "done";

					if(inoutData[i].lateYn === 'Y' )
						className = "late";
				} else if (inoutData[i].priority === '4') {
					id = `inout${'${applSeq}'}`;
					className = "default";
					type = "inout";
					title = "[" + inoutData[i].applStatusNm + "]" + title + "(출퇴근변경)";
					applSeq = inoutData[i].applSeq;
					applStatusCd = inoutData[i].applStatusCd;
				}
                console.log(inoutData[i])
                if(sabun != inoutData[i].sabun){	//팀원
                    title += ' - ' + inoutData[i].name;
                    events.push({"title": title, "start": start, "id": id, "className": className, });
                }else{
                    events.push({"title": title, "start": start, "id": id, "className": className, "type": type, "order": "01"+start, "applStatusCd": applStatusCd, "applSeq": applSeq});
                }
			}
		}

		// 근무리스트
		for (const obj of workData) {
			const start = Utils.addDateSeparator(obj.workSymd, '-');
            const realEnd = Utils.addDateSeparator(obj.workEymd, '-');
            const end = moment(realEnd).add(1, 'days').format("YYYY-MM-DD"); // fullCalendar 에서 종료일자까지 표시하기 위해서는 다음날짜로 종료일자를 설정해야 함.
			const sHm = formatTime(obj.workShm);
			const eHm = formatTime(obj.workEhm);
            const id = obj.workApplSeq + "_" + obj.workSeq;
			let title = '';
			let applSeq = obj.workApplSeq;
			let className = obj.workTimeType === '02' ? "overTime" : "bizTrip";
			const applStatusCd = obj.applStatusCd;

            if(sabun != obj.sabun){	//팀원
                console.log(obj)
                if(obj.applStatusCd == '99'){
					if(obj.workShm && obj.workEhm) {
						title = `${'${sHm}'}~${'${eHm}'}(${'${obj.workSNm}'})`;
					} else {
						title = `${'${obj.workSNm}'}`;
					}
                    title += ' - ' + obj.name;
                    events.push({"title": title, "start": start, "end": end, "id": id, "className": className, "end": end, "realEnd": realEnd, "sHm": sHm, "eHm": eHm});
                }
            }else{
				if(obj.workShm && obj.workEhm) {
					title = `[${'${obj.applStatusNm}'}] ${'${sHm}'}~${'${eHm}'}(${'${obj.workSNm}'})`;
				} else {
					title = `[${'${obj.applStatusNm}'}] ${'${obj.workSNm}'}`;
				}
                events.push({"title" : title, "start" : start, "id" : id, "className": className, "applSeq" : applSeq, "type": "work", "order": "02"+start, "end": end, "realEnd": realEnd, "applStatusCd": applStatusCd, "sHm": sHm, "eHm": eHm});
            }
		}

		// 근태리스트
		for (const obj of attendData) {
			const start = Utils.addDateSeparator(obj.attendSymd, '-');
			const realEnd = Utils.addDateSeparator(obj.attendEymd, '-');
			const end = moment(realEnd).add(1, 'days').format("YYYY-MM-DD"); // fullCalendar 에서 종료일자까지 표시하기 위해서는 다음날짜로 종료일자를 설정해야 함.
			const sHm = formatTime(obj.attendShm);
			const eHm = formatTime(obj.attendEhm);
			const id = obj.attendApplSeq + "_" + obj.attendSeq;
			let title = '';
			const applSeq = obj.attendApplSeq;
			const seq = obj.attendSeq;
			const className = "leave";
			const applStatusCd = obj.applStatusCd;

			if(sabun != obj.sabun){	//팀원
				if(obj.applStatusCd == '99'){
					if(obj.attendShm && obj.attendEhm) {
						title = `${'${sHm}'}~${'${eHm}'}(${'${obj.gntShortNm}'})`;
					} else {
						title = `${'${obj.gntShortNm}'}`;
					}
					title += ' - ' + obj.name;
					events.push({"title": title, "start": start, "end": end, "id": id, "className": className, "realEnd": realEnd, "sHm": sHm, "eHm": eHm});
				}
			}else{
				if(obj.attendShm && obj.attendEhm) {
					title = `[${'${obj.applStatusNm}'}] ${'${sHm}'}~${'${eHm}'}(${'${obj.gntShortNm}'})`;
				} else {
					title = `[${'${obj.applStatusNm}'}] ${'${obj.gntShortNm}'}`;
				}
				events.push({"title": title, "start": start, "end": end, "id": id, "className": className, "applSeq": applSeq, "seq": seq, "type": "attend", "period" : "N", "realEnd": realEnd, "order": "03"+start+title, "applStatusCd": applStatusCd, "sHm": sHm, "eHm": eHm});
			}
/*
			// 분할신청가능한 신청의 경우, 범위로 표현
			if(divCnt > 0) {
				// 현재 인덱스 이후 항목중 applSeq 값이 같은 항목의 index 추출
				let index = attendData.findLastIndex((item, index) => item.attendApplSeq === applSeq && index > i);

				if (index !== -1) {
					let eYmd = new Date(Utils.addDateSeparator(attendData[index].ymd, '-'));
					eYmd = new Date(eYmd.setDate(eYmd.getDate() + 1));
					let end = Utils.parseDate(eYmd, '-');

					events.push({"title": title, "start": start, "end": end, "id": id, "className": className, "applSeq": applSeq, "type": "attend", "period" : "Y"});
					// 다음 탐색 인덱스 값 변경. : 범위 종료일자 이후의 값 부터 재 탐색처리
					i = index;
					continue;
				}
			}
*/
		}
		return events;
	}
	/**
	 * 총 근무시간 표시
	 */
	function searchWorktime(calendar){
		const currentDate = Utils.currentDate('-');
		const startDate = Utils.parseFirstDayMonth(calendar.currentData.currentDate, '-');
		const endDate = Utils.parseLastDayMonth(calendar.currentData.currentDate, '-');
		const sabun = '${ssnSabun}';

		$.ajax({
			url: '${ctx}/WtmWorkCalendar.do?cmd=getWtmWorkCalendarWorkTimeMap'
			, type : 'post'
			, dataType: 'json'
			, data: {
				searchBaseYmd : currentDate
				, searchSabun : sabun
				, searchSYmd : startDate
				, searchEYmd : endDate
			}
			, error : function(request, status, error) {
				console.error(error);
				alert("근무시간 조회 시 알 수 없는 오류가 발생하였습니다.");
			}
			, success : function(response){
			    if(response.DATA != null ){
			    	$('#totalRealCnt').text(response.DATA.totalReal);
					$('#totalPlanCnt').text(response.DATA.totalPlan);
					$('#baseWorkPlanCnt').text(response.DATA.baseWorkPlan);
					$('#otWorkPlanCnt').text(response.DATA.otWorkPlan);
			    } else {
					$('#totalRealCnt').text('0');
					$('#totalPlanCnt').text('0');
					$('#baseWorkPlanCnt').text('0');
					$('#otWorkPlanCnt').text('0');
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
	function showTooltip(calendar, e) {

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

		// 툴팁 버튼 설정
		const data = Utils.resource(calendar, e.event.id);
		if(data.type === 'inout') {
			// 클릭한 이벤트가 출퇴근인경우, 출퇴근변경신청만 출력
			if(data.applSeq != null) {
				if (data.applStatusCd === "11") {
					// 임시저장일 경우
					// 신청버튼
					let appButton = document.createElement('button');
					appButton.setAttribute('type', 'button');
					appButton.setAttribute('class', 'btn outline_gray');
					appButton.innerText = '출퇴근시간변경신청';
					appButton.addEventListener('click', function(event){
						event.preventDefault();
						showAttendTimeAdjModal(calendar, e);
					});
					tooltip.appendChild(appButton);

					// 삭제버튼
					let delButton = document.createElement('button');
					delButton.setAttribute('type', 'button');
					delButton.setAttribute('class', 'btn outline_gray');
					delButton.innerText = '삭제';
					delButton.addEventListener('click', function(event){
						event.preventDefault();
						deleteAttendTimeAdjApp(calendar, e);
					});
					tooltip.appendChild(delButton);

					tooltip.style.top = '-74px';
				} else {
					// 세부사항
					let detailButton = document.createElement('button');
					detailButton.setAttribute('type', 'button');
					detailButton.setAttribute('class', 'btn outline_gray');
					detailButton.innerText = '세부내역';
					detailButton.addEventListener('click', function(event){
						event.preventDefault();
						showDetailModal(calendar, e, 'wtm401');
					});
					tooltip.appendChild(detailButton);

					tooltip.style.top = '-54px';
				}
			}

		} else if (data.type === 'work') {
			// 클릭한 이벤트가 근무내역인 경우
			// applSeq가 존재한다면 세부사항, 변경신청, 취소신청 버튼 추가
			if(data.applSeq != null) {
				// 세부사항
				let detailButton = document.createElement('button');
				detailButton.setAttribute('type', 'button');
				detailButton.setAttribute('class', 'btn outline_gray');
				detailButton.innerText = '세부내역';
				detailButton.addEventListener('click', function(event){
					event.preventDefault();
					showDetailModal(calendar, e, 'wtm301');
				});
				tooltip.appendChild(detailButton);

				tooltip.style.top = '-45px';

				if (data.applStatusCd === "11") {
					// 임시저장일 경우

					// 신청버튼
					let appButton = document.createElement('button');
					appButton.setAttribute('type', 'button');
					appButton.setAttribute('class', 'btn outline_gray');
					appButton.innerText = '근무신청';
					appButton.addEventListener('click', function(event){
						event.preventDefault();
						showWorkModal(calendar, e, 'I');
					});
					tooltip.appendChild(appButton);

					// 삭제버튼
					let delButton = document.createElement('button');
					delButton.setAttribute('type', 'button');
					delButton.setAttribute('class', 'btn outline_gray');
					delButton.innerText = '삭제';
					delButton.addEventListener('click', function(event){
						event.preventDefault();
						deleteWorkApp(calendar, e);
					});
					tooltip.appendChild(delButton);

					tooltip.style.top = '-135px';
				} else if (data.applStatusCd === "99") {
					// 결재완료일 경우

					// 변경/취소신청
					let removeButton = document.createElement('button');
					removeButton.setAttribute('type', 'button');
					removeButton.setAttribute('class', 'btn outline_gray');
					removeButton.innerText = '변경/취소신청';
					removeButton.addEventListener('click', function(event){
						event.preventDefault();
						showWorkModal(calendar, e, 'D');
					});
					tooltip.appendChild(removeButton);

					tooltip.style.top = '-75px';
				}
			}
		} else if (data.type === 'attend') {
			// 클릭한 이벤트가 근태내역인 경우
			// applSeq가 존재한다면 세부사항, 변경신청, 취소신청 버튼 추가
			if(data.applSeq != null) {
				// 세부사항
				let detailButton = document.createElement('button');
				detailButton.setAttribute('type', 'button');
				detailButton.setAttribute('class', 'btn outline_gray');
				detailButton.innerText = '세부내역';
				detailButton.addEventListener('click', function(event){
					event.preventDefault();
					showDetailModal(calendar, e, 'wtm201');
				});
				tooltip.appendChild(detailButton);

				tooltip.style.top = '-45px';

				if (data.applStatusCd === "11") {
					// 임시저장일 경우
					// 신청버튼
					let appButton = document.createElement('button');
					appButton.setAttribute('type', 'button');
					appButton.setAttribute('class', 'btn outline_gray');
					appButton.innerText = '휴가신청';
					appButton.addEventListener('click', function(event){
						event.preventDefault();
						showAttendModal(calendar, e, 'I');
					});
					tooltip.appendChild(appButton);

					// 삭제버튼
					let delButton = document.createElement('button');
					delButton.setAttribute('type', 'button');
					delButton.setAttribute('class', 'btn outline_gray');
					delButton.innerText = '삭제';
					delButton.addEventListener('click', function(event){
						event.preventDefault();
						deleteAttendApp(calendar, e);
					});
					tooltip.appendChild(delButton);

					tooltip.style.top = '-135px';
				} else if (data.applStatusCd === "99") {
					// 결재완료일 경우

					// 변경/취소신청
					let removeButton = document.createElement('button');
					removeButton.setAttribute('type', 'button');
					removeButton.setAttribute('class', 'btn outline_gray');
					removeButton.innerText = '변경/취소신청';
					removeButton.addEventListener('click', function(event){
						event.preventDefault();
						showAttendModal(calendar, e, 'D');
					});
					tooltip.appendChild(removeButton);

					tooltip.style.top = '-75px';
				}
			}
		} else {
			return;
		}
		e.el.parentNode.appendChild(tooltip);
	}

	/**
	 * 근태 임시저장 건을 삭제
	 * @param calendar {object}
	 * @param calendarEvent {object}
	 */
	function deleteAttendApp(calendar, calendarEvent) {

		if (!calendar && !calendarEvent) return;

		const data = Utils.resource(calendar, calendarEvent.event.id);
		if (data.applStatusCd !== "11") {
			alert("임시저장만 삭제 가능합니다.");
			return;
		}

		const start = data.start;
		if (!confirm(start + data.title + " 을 삭제하시겠습니까?")) return;
		const param = "searchApplSeq=" + data.applSeq + "&searchSeq=" + data.seq;
		const result = ajaxCall("${ctx}/WtmWorkCalendar.do?cmd=deleteWtmAttendCalendar", param, false);
		if (result && result.Result) {
			alert(result.Result.Message);
			searchWorkday(calendar);
		} else {
			alert("삭제하는데 실패하였습니다. 담당자에게 문의바랍니다.");
		}
	}

	/**
	 * 근무 임시저장 건을 삭제
	 * @param calendar {object}
	 * @param calendarEvent {object}
	 */
	function deleteWorkApp(calendar, calendarEvent) {

		if (!calendar && !calendarEvent) return;

		const data = Utils.resource(calendar, calendarEvent.event.id);
		if (data.applStatusCd !== "11") {
			alert("임시저장만 삭제 가능합니다.");
			return;
		}

		const start = data.start;
		if (!confirm(start + " 일의 " + data.title + " 을 삭제하시겠습니까?")) return;
		const param = "searchApplSeq=" + data.applSeq + "&searchSeq=" + data.seq;
		const result = ajaxCall("${ctx}/WtmWorkCalendar.do?cmd=deleteWtmWorkCalendar", param, false);
		if (result && result.Result) {
			alert(result.Result.Message);
			searchWorkday(calendar);
		} else {
			alert("삭제하는데 실패하였습니다. 담당자에게 문의바랍니다.");
		}
	}

	/**
	 * 툴팁 열려있는지 확인
	 * @returns {boolean}
	 */
	function isShowTooltip(){
		const buttons = document.getElementsByClassName('tooltip-buttons');
		return (buttons.length > 0);
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
<body class="iframe_content white attendanceNew">
	<div id="contextMenu" class="custom-context-menu fcUnselectCancel">
		<ul>
			<li id="menuDate" class="date"></li>
			<li id="reqAttend">휴가신청</li>
			<li id="reqWork">근무신청</li>
			<li id="reqInOutTime">출퇴근시간 변경신청</li>
			<li id="menuClose"><i class="mdi-ico">close</i>닫기</li>
		</ul>
	</div>
	<div class="bg-grey">
		<div class="calendar-status">
			<div class="title-wrap">
				<h2 class="page-title">근태캘린더</h2>
				<div class="btn-wrap">
					<div class="input-wrap">
						<div class="searchOrgCd checkbox-wrap">
							<input id="searchOrgCd" name="searchOrgCd" type="checkbox" class="form-checkbox" value="${ssnOrgCd}"/>
							<label for="searchOrgCd">팀원보기</label>
						</div>
					</div>
					<div class="input-wrap">
						<div class="searchOrgType checkbox-wrap" style="display:none;">
							<input id="searchOrgType" name="searchOrgType" type="checkbox" class="form-checkbox" value="Y"/>
							<label for="searchOrgType">하위포함</label>
						</div>
					</div>
					<button type="button" id="reqAttendBtn" class="btn outline_gray fcUnselectCancel">휴가신청</button>
					<button type="button" id="reqWorkBtn" class="btn outline_gray fcUnselectCancel">근무 신청</button>
					<button type="button" id="reqWorkSchBtn" class="btn outline_gray fcUnselectCancel">근무스케줄 신청</button>
					<button type="button" id="reqInOutTimeBtn" class="btn outline_gray fcUnselectCancel">출퇴근시간 변경신청</button>
				</div>
			</div>
			<div class="status-wrap">
				<div class="time-wrap">
					<div class="total">
						<span class="label">총근무</span>
						<span id="totalRealCnt" class="cnt"></span>
						<span class="unit">시간</span>
					</div>
					<div class="desc">
						<div class="plan">
							<span class="label">총계획</span>
							<span id="totalPlanCnt" class="cnt"></span>
						</div>
						<div class="base">
							<span class="label">기본</span>
							<span id="baseWorkPlanCnt" class="cnt"></span>
						</div>
						<div class="over">
							<span class="label">연장</span>
							<span id="otWorkPlanCnt" class="cnt"></span>
						</div>
					</div>
				</div>
				<div class="leave-wrap">
					<div class="remain">
						<span class="label">잔여연차</span>
						<span id="restVacationCnt" class="cnt">0</span>
						<span class="unit">일</span>
					</div>
					<div class="desc">
						<div class="total">
							<span class="label">총연차</span>
							<span id="useVacationCnt" class="cnt">0</span>
						</div>
						<div class="used">
							<span class="label">사용</span>
							<span id="usedVacationCnt" class="cnt">0</span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="attendance-calendar schedule">
			<!-- 달력 영역 -->
			<div class="fullcalendar-wrap">
				<!-- header 내부 -->
				<div class="calendar-head">
					<a id="thisMonth" class="thisMonth pointer">이번달</a>
				</div>
				<div class="calendar" id="calendar"></div>
			</div>
		</div>
	</div>
</body>
</html>