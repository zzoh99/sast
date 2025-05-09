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

<!-- 개별 화면 script -->
<script type="text/javascript">
    $(function () {
        initEvent();
        searchWorkSchedule();
    });

    /**
     *  캘린더 데이터 관련 함수 모듈화
     */
    const WtmCalendar = (function (){
        // private 변수
        let calData = []; // 달력에 표기하기 위한 모든 근무,근태 스케줄
        let calInsData = []; // 신청한 근무스케줄
        let workClassInfo = null;
        let gntCdList = null;
        let workCdList = null;
        let holidays = [];
        let monthlyCalendar = null;
        let calendarType = null;
        let inputDates = [];
        let preventSymd = null;
        let preventEymd = null;
		let baseWorkCd = null; // 기본근무 코드
		let breakWorkCd = null; // 휴게시간 코드

        // 요일 배열 정의
        const weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

        /* 주간캘린더 헤더 그리기 */
        function drawWeeklyCalendarHeader() {
            calendarType = 'W';

            initWeeklyEvent(); // 주단위 캘린더 전용 함수 초기화

            const $monthlyCalendarWrap = $('#monthlyCalendarWrap');
            const $weeklyCalendarWrap = $('#weeklyCalendarWrap');
            $monthlyCalendarWrap.hide() // 월단위 캘린더 숨기기
            $weeklyCalendarWrap.show() // 주단위 캘린더 보이기

            // 00시 부터 24시까지 시간 셀 그리기
            const times = Array.from({ length: 24 }, (_, i) => {
                return {
                    time: String(i).padStart(2, '0'), // 0부터 23까지의 time 값
                    day: '시',                        // day 값은 고정
                };
            });

            const $weeklyCalendarHeader = $('#weeklyCalendarHeader');
            $weeklyCalendarHeader.empty();
            times.forEach(obj => {
                const $col = $('<div class="col"></div>');
                const $timeP = $('<p class="time">'+obj.time+'</p>');
                const $dayP = $('<p class="unit">'+obj.day+'</p>');

                $col.append($timeP);
                $col.append($dayP);
                $weeklyCalendarHeader.append($col);
            });
        }

        /* 월간캘린더 그리기 */
        function drawMonthlyCalendar() {
            calendarType = 'M';

            const $monthlyCalendarWrap = $('#monthlyCalendarWrap');
            const $weeklyCalendarWrap = $('#weeklyCalendarWrap');
            $weeklyCalendarWrap.hide() // 주단위 캘린더 숨기기
            $monthlyCalendarWrap.show() // 월단위 캘린더 보이기

            const sYmd = makeDateFormat($('#searchYmd').val());
            sYmd.setDate(1)

            // 년월 텍스트 표시
            $('#year').text(sYmd.getFullYear())
            $('#month').text(sYmd.getMonth()+1)

            // 입력 불가능 날짜 범위 설정(오늘이전)
            const today = new Date();
            const yesterday = new Date(today);
            yesterday.setDate(yesterday.getDate() - 1);

            if(sYmd.setHours(0,0,0,0) < today.setHours(0,0,0,0)) {
                preventSymd = new Date(sYmd);
                preventEymd = new Date(yesterday);

                if(workClassInfo.sameDayChgYn === 'N') {
                    preventEymd = new Date(today);
                }
            }

            // 캘린더 생성
            const calendarEl = document.getElementById("monthlyCalendar");
            monthlyCalendar = new FullCalendar.Calendar(calendarEl, {
                headerToolbar: false,
                locale: "ko",
                initialDate: sYmd,
                navLinks: false,
                selectable: true,
                selectMirror: true,
                showNonCurrentDates: false,
                fixedWeekCount: false,
                selectAllow: function(selectInfo) {
                    const selectedDate = selectInfo.start;
                    return getAllowDate(selectedDate)
                },
                dayCellDidMount: function(arg) {
                    const cellDate = arg.date.getTime();

                    if (!getAllowDate(cellDate)) {
                        $(arg.el).addClass('fc-unselectable-date')
                        $(arg.el).attr('data-holiday', 'Y')
                    }
                },
                select: function(selectionInfo) {
                    // 드래그 종료 후 선택된 날짜 범위 정보
                    const selSymd = dateFormatToString(selectionInfo.start);
                    const eDate = new Date(selectionInfo.end);
                    eDate.setDate(eDate.getDate() -1)
                    const selEymd = dateFormatToString(eDate);

					WtmCalendar.clearInputDates();
					WtmCalendar.setInputDates(selSymd, selEymd);

                    showContextMenu(selectionInfo.jsEvent); // 컨텍스트 메뉴 오픈

					// context 에 날짜 타이틀 추가
					const daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
					if(selSymd === selEymd) {
						const day = selectionInfo.start.getDay();
						$("#dateTitle").html(formatDate(selSymd, '.') + ' (' +daysOfWeek[day] + ')');
					} else {
						const sday = selectionInfo.start.getDay();
						const eday = selectionInfo.end.getDay();
						$("#dateTitle").html(formatDate(selSymd, '.') + ' (' +daysOfWeek[sday] + ')' + ' - ' + formatDate(selEymd, '.') + ' (' +daysOfWeek[eday] + ')');
					}

                    // 기존 근무 스케줄이 있으면 해당값으로 세팅
                    const existData = WtmCalendar.getCalData(selSymd, WtmCalendar.getBaseWorkCd());
                    if(existData && existData.length > 0) {
                        $('#workShm').val(existData[0].shh+':'+existData[0].smm);
                        $('#workEhm').val(existData[0].ehh+':'+existData[0].emm);
                        // 휴게시간설정
                        setAutoBreakTimes(existData[0], true); // 휴게시간 설정
                    } else {
                        $('#workShm').val('');
                        $('#workEhm').val('')
                        setAutoBreakTimes({ymd: selSymd}, false); // 휴게시간 설정
                    }
                },
            });
            monthlyCalendar.render();
            initMonthlyEvent(monthlyCalendar);
        }

        /* 입력 불가능한날짜 탐색 */
        function getAllowDate(targetDate) {
            if(preventSymd != null &&  preventEymd != null) {
                let result;
                const start = preventSymd.setHours(0,0,0,0);
                const end = preventEymd.setHours(0,0,0,0);

                // 단위기간 시작 ~ 종료일에 해당하는 날짜인지 체크.
                const calendarSdate = makeDateFormat(workClassInfo.sdate);
                const calendarEdate = makeDateFormat(workClassInfo.edate);
                result = (targetDate >= calendarSdate && targetDate <= calendarEdate)

                // 입력 불가능한 범위의 날짜인지 체크
                if(result)
                    result = !(targetDate >= start && targetDate <= end)

                // 휴일인지 확인
                const holidayYn = WtmCalendar.isHolidayYn(dateFormatToString(new Date(targetDate)));
                if (holidayYn[0]) {
                    result = false;
                }
                return result;
            }
            return true;
        }

        /* 근태,근무 코드 정보 세팅 */
        function setCodeList() {
            const gntCdData = ajaxCall("${ctx}/WtmWorkCalendar.do?cmd=getWtmWorkCalendarGntCdList", $("#wtmReqWorkScheduleFrm").serialize(), false).DATA;
            gntCdList = new Map(gntCdData.map(data => [data.gntCd, data]));

            const workCdData = ajaxCall("${ctx}/WtmWorkCalendar.do?cmd=getWtmWorkCalendarWorkCdList", $("#wtmReqWorkScheduleFrm").serialize(), false).DATA;
            workCdList = new Map(workCdData.map(data => [data.workCd, data]));

			const baseCdData = ajaxCall("${ctx}/WtmWorkCalendar.do?cmd=getWtmWorkCalendarBaseCd", $("#wtmReqWorkScheduleFrm").serialize(), false).DATA;

			baseWorkCd = baseCdData.stdWorkCd;
			breakWorkCd = baseCdData.stdBreakCd;
        }

        /* 근무 유형 정보 세팅 */
        function setWorkClassInfo(sdate, edate) {
            workClassInfo = ajaxCall("${ctx}/WtmWorkCalendar.do?cmd=getWtmWorkCalendarWorkClass", $("#wtmReqWorkScheduleFrm").serialize(), false).DATA;
            if(!workClassInfo) {
                alert('근무스케줄 신청 대상이 아닙니다.');
            } else {
				if(workClassInfo.intervalCd === '') {
					workClassInfo.applMinUnit = '1';
				}
			}

            if(sdate && edate) {
                workClassInfo.sdate = sdate;
                workClassInfo.edate = edate;
            }
        }

        /* 휴일 정보 세팅 */
        function setHolidays() {
            holidays = ajaxCall("${ctx}/WtmWorkCalendar.do?cmd=getWtmWorkCalendarHolidays", $("#wtmReqWorkScheduleFrm").serialize(), false).DATA;
        }

        /* ymd의 요일 영문 약자 가져오기 */
        function getWeekday(ymd) {
            return weekdays[makeDateFormat(ymd).getDay()];
        }

        /* array 값 공통 업데이트 로직 */
        function updateData(array, rowData, insDataYn) {
            // 동일한 일자에 근무 스케줄이 존재하는지 확인
            const existingEntry = array.find(entry => entry.sabun === rowData.sabun && entry.ymd === rowData.ymd && entry.type === rowData.type && entry.attCd === rowData.attCd);
            if(insDataYn && existingEntry && rowData.attCd === WtmCalendar.getBaseWorkCd()) {

                // 근무코드가 기본근무인 경우, 기존 값 범위 내의 휴게 스케줄 삭제 처리
                for(let i = array.length - 1; i >= 0; i--) {
                    if(array[i].sabun === existingEntry.sabun
                        && array[i].ymd === existingEntry.ymd
                        && array[i].type === existingEntry.type
                        && array[i].attCd === WtmCalendar.getBreakWorkCd()
                        && array[i].symd + array[i].shh + array[i].smm >= existingEntry.symd + existingEntry.shh + existingEntry.smm
                        && array[i].eymd + array[i].ehh + array[i].emm <= existingEntry.eymd + existingEntry.ehh + existingEntry.emm) {
                        array.splice(i, 1);
                    }
                }
            }

			if(rowData.type === 'WORK') {
            	rowData.mm = calcMinutes(rowData); // 분 차이 계산
			}

            if(rowData.attCd === WtmCalendar.getBaseWorkCd()) {
                if (existingEntry) {
                    // 동일 근무코드 스케줄이 있으면 기존 값 업데이트
                    existingEntry.symd = rowData.symd;
                    existingEntry.shh = rowData.shh;
                    existingEntry.smm = rowData.smm;
                    existingEntry.eymd = rowData.eymd;
                    existingEntry.ehh = rowData.ehh;
                    existingEntry.emm = rowData.emm;
                    existingEntry.mm = rowData.mm;
                } else {
                    // 없으면 새로운 데이터 추가
                    array.push(rowData);
                }
            } else {
                array.push(rowData);
            }
        }

        /* 근무시간이 변경되었을 때, 휴게시간 업데이트 */
        function updateBreakTime(rowData) {
            // 휴게시간 가져오기
            const breakDatas = getBreakTimes(rowData)
            breakDatas.forEach(breakData => {
                updateData(calData, breakData, true);
                updateData(calInsData, breakData, true);
            })
        }

        /* 근무유형을 확인하여 휴게시간 조회하기 */
        function getBreakTimes(rowData) {
            let breakDatas = [];
            if(workClassInfo.breakTimeType === 'A') {
                // 지정 휴게인 경우,
                const breakTimeDet = workClassInfo.breakTimeDet;
                if(breakTimeDet) {
                    const breakTimeArr = breakTimeDet.split(',');
                    const breakTimes = breakTimeArr.map(time => time.split('-'));
                    breakTimes.forEach(([breakShm, breakEhm]) => {
                        let eymdDate, symd, eymd;

                        // 휴게 시작시간이 종료시간보다 이후인 경우, eymd는 ymd + 1 일
                        eymdDate = makeDateFormat(rowData.ymd);
                        if(breakShm > breakEhm) {
                            eymdDate.setDate(eymdDate.getDate() + 1)
                        }
                        symd = rowData.ymd;
                        eymd = dateFormatToString(eymdDate);

                        // 휴게 시작시간이 업무 시작 시간보다 이전인 경우, symd/eymd는 ymd + 1 일
                        if(rowData.shh + rowData.smm > breakShm) {
                            eymdDate = makeDateFormat(rowData.ymd);
                            eymdDate.setDate(eymdDate.getDate() + 1);
                            eymd = dateFormatToString(eymdDate);
                            symd = eymd;
                        }

                        const breakData = {
                            sabun: '${applSabun}',
                            name: '${applSabunName}',
                            ymd: rowData.ymd,
                            type: 'WORK',
                            attCd: WtmCalendar.getBreakWorkCd(),
                            attNm: '휴게',
                            symd: symd,
                            shh: breakShm.substring(0, 2),
                            smm: breakShm.substring(2, 4),
                            eymd: eymd,
                            ehh: breakEhm.substring(0, 2),
                            emm: breakEhm.substring(2, 4),
                        }
                        breakDatas.push(breakData);
                    })
                }
            } else if (workClassInfo.breakTimeType === 'B') {
                // 근무시간 기준인 경우

                // 날짜 객체로 변환하는 헬퍼 함수
                const convertToDate = (ymd, hh, mm) => {
                    // 문자열에서 각 부분을 추출
                    const year = ymd.substring(0, 4);
                    const month = ymd.substring(4, 6);
                    const day = ymd.substring(6, 8);

                    // Date 객체 생성 (월은 0부터 시작하므로 -1)
                    return new Date(year, parseInt(month) - 1, day, hh, mm);
                }

                // 기준 시간 간격으로 새로운 Date 객체를 생성하는 헬퍼 함수
                const addMinutes = (date, minutes) => {
                    const newDate = new Date(date);
                    newDate.setMinutes(date.getMinutes() + minutes);
                    return newDate;
                };

                // rowData에 필요한 key 값이 존재하는 경우에만 휴게시간 계산 로직 수행
                if(rowData && ['ymd', 'symd', 'shh', 'smm', 'eymd', 'ehh', 'emm'].every(key => key in rowData)) {
                    const startWorkTime = convertToDate(rowData.symd, rowData.shh, rowData.smm)
                    const endWorkTime = convertToDate(rowData.eymd, rowData.ehh, rowData.emm)

                    // 4시간(240분) 간격으로 휴게시간 계산
                    let currentWorkTime = new Date(startWorkTime);
                    while (currentWorkTime < endWorkTime) {
                        // 다음 휴게시간 시작점 계산 (현재시간 + 4시간)
                        const breakStart = addMinutes(currentWorkTime, 240);

                        // 종료시간을 넘어가면 중단
                        if (breakStart >= endWorkTime) break;

                        // 휴게시간 종료점 계산 (휴게시작 + 30분)
                        const breakEnd = addMinutes(breakStart, 30);

                        // 휴게시간이 근무종료시간을 초과하지 않는 경우에만 추가
                        if (breakEnd <= endWorkTime) {
                            const breakData = {
                                sabun: '${applSabun}',
                                name: '${applSabunName}',
                                ymd: rowData.ymd,
                                type: 'WORK',
                                attCd: WtmCalendar.getBreakWorkCd(),
                                attNm: '휴게',
                                symd: dateFormatToString(breakStart, ''),
                                shh: breakStart.getHours().toString().padStart(2, '0'),
                                smm: breakStart.getMinutes().toString().padStart(2, '0'),
                                eymd: dateFormatToString(breakEnd, ''),
                                ehh: breakEnd.getHours().toString().padStart(2, '0'),
                                emm: breakEnd.getMinutes().toString().padStart(2, '0'),
                            }
                            breakDatas.push(breakData);
                        }
                        currentWorkTime = breakEnd;
                    }
                }
            } else if (workClassInfo.breakTimeType === 'C') {
                /* 직접입력인 경우 */

                // rowData에 필요한 key 값이 존재하는 경우에만 휴게시간 계산 로직 수행
                if(rowData && ['ymd', 'symd', 'shh', 'smm', 'eymd', 'ehh', 'emm'].every(key => key in rowData)) {
                    // 근무시간 범위 내의 모든 휴게(05) 스케줄 삭제 처리
                    calData = calData.filter(data => {
                        return !(data.sabun === rowData.sabun
                                && data.ymd === rowData.ymd
                                && data.attCd === WtmCalendar.getBreakWorkCd()
                                && data.symd + data.shh + data.smm >= rowData.symd + rowData.shh + rowData.smm
                                && data.eymd + data.ehh + data.emm <= rowData.eymd + rowData.ehh + rowData.emm
                                )
                    });

                    calInsData = calInsData.filter(data => {
                        return !(data.sabun === rowData.sabun
                                && data.ymd === rowData.ymd
                                && data.attCd === WtmCalendar.getBreakWorkCd()
                                && data.symd + data.shh + data.smm >= rowData.symd + rowData.shh + rowData.smm
                                && data.eymd + data.ehh + data.emm <= rowData.eymd + rowData.ehh + rowData.emm
                                )
                    });

                    // breaktime-wrap 내의 모든 breakDiv를 순회
                    $('#breaktime-wrap .breakDiv').each(function() {
                        const breakShm = $(this).find('input[name="breakShm"]').val().replace(/:/gi, "");
                        const breakEhm = $(this).find('input[name="breakEhm"]').val().replace(/:/gi, "");

                        // 휴게 시작시간, 종료시간이 모두 입력 되었을때, data 세팅
                        if(breakShm && breakEhm) {
                            let eymdDate, symd, eymd;

                            // 휴게 시작시간이 종료시간보다 이후인 경우, eymd는 ymd + 1 일
                            eymdDate = makeDateFormat(rowData.ymd);
                            if(breakShm > breakEhm) {
                                eymdDate.setDate(eymdDate.getDate() + 1)
                            }
                            symd = rowData.ymd;
                            eymd = dateFormatToString(eymdDate);

                            // 휴게 시작시간이 업무 시작 시간보다 이전인 경우, symd/eymd는 ymd + 1 일
                            if(rowData.shh + rowData.smm > breakShm) {
                                eymdDate = makeDateFormat(rowData.ymd);
                                eymdDate.setDate(eymdDate.getDate() + 1);
                                eymd = dateFormatToString(eymdDate);
                                symd = eymd;
                            }

                            const breakData = {
                                sabun: '${applSabun}',
                                name: '${applSabunName}',
                                ymd: rowData.ymd,
                                type: 'WORK',
                                attCd: WtmCalendar.getBreakWorkCd(),
                                attNm: '휴게',
                                symd: symd,
                                shh: breakShm.substring(0, 2),
                                smm: breakShm.substring(2, 4),
                                eymd: eymd,
                                ehh: breakEhm.substring(0, 2),
                                emm: breakEhm.substring(2, 4),
                            }
                            breakDatas.push(breakData);
                        }
                    });
                }
            }

            // 중복값 제거
            breakDatas = Array.from(new Map(
                breakDatas.map(data => [
                    [data.symd, data.shh, data.smm, data.eymd, data.ehh, data.emm].join('|'),
                    data
                ])
            ).values());
            return breakDatas;
        }

        function deleteBreakTime(rowData) {
            // 선택한 휴게 스케줄 삭제 처리
            calData = calData.filter(data => {
                return !(data.sabun === rowData.sabun
                        && data.ymd === rowData.ymd
                        && data.attCd === WtmCalendar.getBreakWorkCd()
                        && data.shh === rowData.shh
                        && data.smm === rowData.smm
                        && data.ehh === rowData.ehh
                        && data.emm === rowData.emm
                        )
            });

            calInsData = calInsData.filter(data => {
                return !(data.sabun === rowData.sabun
                        && data.ymd === rowData.ymd
                        && data.attCd === WtmCalendar.getBreakWorkCd()
                        && data.shh === rowData.shh
                        && data.smm === rowData.smm
                        && data.ehh === rowData.ehh
                        && data.emm === rowData.emm
                        )
            });
        }

        /* 선택한 날짜의 주간 캘린더 근무,근태 스케줄 다시 그리기 */
        function drawWtmWeeklyCalendar(ymd) {
            if(ymd) {
                $(`[data-drawYmd="${'${ymd}'}"]`).remove() // 선택한 날짜에 그려진 모든 스케줄 지우기
                const entries = calData.filter(entry => entry.ymd === ymd);

                // 선택한 날짜의 스케줄 전부 다시 그리기
                entries.forEach(entry => {
                    // 원본 데이터 복사(변경한 data값이 원본에 적용되지 않도록 하기 위함)
                    const data = { ...entry };
                    const $td = $(`#td_${'${data.sabun}'}_${'${data.symd}'}`); // td 가져오기
                    let $chip;
                    if(data.attCd === WtmCalendar.getBaseWorkCd()) {
                        // 기본근무
                        $chip = $('<div class="attend-chip time-day" data-drawYmd="'+data.ymd+'"><span class="text">근무</span></div>')
                    } else if (data.attCd === WtmCalendar.getBreakWorkCd()) {
                        // 휴게
                        $chip = $('<div class="attend-chip break-time" data-drawYmd="'+data.ymd+'"></div>')
                    } else {
                        // 시작,종료 시간은 없고 반영 시간만 있는 경우
                        if(data.shh === '' && data.ehh === '') {
                            const codeInfo = data.type === 'GNT' ? gntCdList.get(data.attCd) : workCdList.get(data.attCd);

                            // 동일한 날짜에 기본근무 시간이 입력되어있는지 확인
                            const workData = entries.find(item => item.ymd === data.ymd);
                            // 기본 근무가 등록 되어있다면
                            if(workData && codeInfo) {
                                // 종일 단위인경우.
                                if(codeInfo.requestUseType === 'D') {
                                    data.shh = workData.shh;
                                    data.smm = workData.smm;
                                    data.ehh = workData.ehh;
                                    data.emm = workData.emm;
                                    data.mm = workData.mm;
                                } else if(codeInfo.requestUseType === 'AM' || codeInfo.requestUseType === 'HAM1') {
                                    // 오전단위, 오전반반차1
                                    data.shh = workData.shh;
                                    data.smm = workData.smm;
                                    const calcDate = calcTimeByMm(data.symd, data.shh, data.smm, data.mm)
                                    data.ehh = calcDate.hh;
                                    data.emm = calcDate.mm;
                                } else if(codeInfo.requestUseType === 'PM' || codeInfo.requestUseType === 'HPM2') {
                                    // 오후단위, 오후반반차2
                                    data.ehh = workData.ehh;
                                    data.emm = workData.emm;
                                    const calcDate = calcTimeByMm(data.eymd, data.ehh, data.emm, -data.mm)
                                    data.shh = calcDate.hh;
                                    data.smm = calcDate.mm;
                                } else if(codeInfo.requestUseType === 'HAM2') {
                                    // 오전반반차2
                                    const ham1Date = calcTimeByMm(data.symd, data.shh, data.smm, data.mm)
                                    data.shh = ham1Date.shh;
                                    data.smm = ham1Date.smm;
                                    const calcDate = calcTimeByMm(ham1Date.ymd, ham1Date.hh, ham1Date.mm, data.mm)
                                    data.ehh = calcDate.hh;
                                    data.emm = calcDate.mm;
                                } else if(codeInfo.requestUseType === 'HPM1') {
                                    // 오후반반차1
                                    const hpm2Date = calcTimeByMm(data.eymd, data.ehh, data.emm, -data.mm)
                                    data.ehh = hpm2Date.hh;
                                    data.emm = hpm2Date.mm;
                                    const calcDate = calcTimeByMm(hpm2Date.ymd, hpm2Date.hh, hpm2Date.mm, -data.mm)
                                    data.shh = calcDate.hh;
                                    data.smm = calcDate.mm;
                                }
                            }
                        }
                        $chip = $('<div class="attend-chip leave" data-drawYmd="'+data.ymd+'"><span class="text">'+data.attNm+'</span></div>')
                    }
                    const $col = $td.find(`[data-time="${'${data.shh}'}"]`); // 시작시간과 일치하는 셀 가져오기
                    const colWidth = $col.css('width');

                    if(data.symd < data.eymd) {
                        // 시간이 다음날로 넘어가는 경우 2개로 쪼개서 생성

                        // 1. 시작시간~자정까지의 chip 생성
                        // 시작시간부터 다음날 00시 까지의 분차이 계산
                        const dayMm = calcMinutes({
                            symd: data.symd,
                            shh: data.shh,
                            smm: data.smm,
                            eymd: data.symd,
                            ehh: '24',
                            emm: '00'
                        });
                        const hours = dayMm / 60; // 시작시간 ~ 24시까지의 시간
                        const smm = data.smm / 60;
                        $chip.css({
                            'width': `calc(${'${colWidth}'} * ${'${hours}'})`,
                            'margin-left': `calc((${'${colWidth}'} * ${'${hours-1}'}) + (${'${colWidth} * 2'} * ${'${smm}'}))`
                        });
                        $col.append($chip)

                        // 2. 다음날 자정~종료시간까지의 chip 생성
                        // 다음날 00시 부터 종료시간까지의 분차이 계산
                        const nextDayMm = calcMinutes({
                            symd: data.eymd,
                            shh: '00',
                            smm: '00',
                            eymd: data.eymd,
                            ehh: data.ehh,
                            emm: data.emm
                        });
                        const $nextDayChip = $chip.clone();
                        const $nextDayTd = $(`#td_${'${data.sabun}'}_${'${data.eymd}'}`); // 종료일자의 td 가져오기
                        const $nextDayCol = $nextDayTd.find(`[data-time="00"]`); // 자정(00시) 셀 가져오기
                        const nextDayHours = nextDayMm / 60; // 시작시간 ~ 24시까지의 시간
                        const emm = 0;
                        $nextDayChip.css({
                            'width': `calc(${'${colWidth}'} * ${'${nextDayHours}'})`,
                            'margin-left': `calc((${'${colWidth}'} * ${'${nextDayHours-1}'}))`
                        });
                        $nextDayCol.append($nextDayChip)
                    } else {
                        const hours = data.mm / 60;
                        const smm = data.smm / 60;
                        $chip.css({
                            'width': `calc(${'${colWidth}'} * ${'${hours}'})`,
                            'margin-left': `calc((${'${colWidth}'} * ${'${hours-1}'}) + (${'${colWidth} * 2'} * ${'${smm}'}))`
                        });
                        $col.append($chip)
                    }
                })
            }
        }

        /* 선택한 날짜의 월간 캘린더 근무,근태 스케줄 다시 그리기 */
        function drawWtmMonthlyCalendar(ymd) {
            if(ymd) {
                // 캘린더의 모든 일정 가져오기
                const events = monthlyCalendar.getEvents();

                // 선택한 날짜에 그려진 모든 스케줄 지우기
                events.forEach(event => {
                    const eventYmd = dateFormatToString(event.start)
                    if (eventYmd === ymd) {
                        event.remove();
                    }
                });

                // 선택한 날짜의 스케줄 전부 다시 그리기
                const entries = calData.filter(entry => entry.ymd === ymd);
                let addEvent = [];
                entries.forEach(entry => {
                    // 원본 데이터 복사(변경한 data값이 원본에 적용되지 않도록 하기 위함)
                    const data = { ...entry };
                    if(data.type === 'WORK' && data.attCd === WtmCalendar.getBaseWorkCd()) {
                        // 기본근무
                        monthlyCalendar.addEvent({
                            title: formatTime(data.shh+data.smm) + '-' + formatTime(data.ehh+data.emm) + ' (근무)',
                            start: formatDate(data.ymd, '-'),
                            allDay: true
                        });
                    }
                })
            }
        }

        // public API
        return {
            initCalendar: function(sdate, edate) {
                calData = [];
                calInsData = [];
                setCodeList();
                setWorkClassInfo(sdate, edate);
                setHolidays();
            },
			getBaseWorkCd: function() {
				return baseWorkCd;
			},
			getBreakWorkCd: function() {
				return breakWorkCd;
			},
            drawWeeklyCalendarHeader: function() {
                drawWeeklyCalendarHeader();
            },
            drawMonthlyCalendar: function() {
                drawMonthlyCalendar();
            },
            getMonthlyCalendar: function() {
                return monthlyCalendar;
            },
            getAllowDate: function(date) {
                return getAllowDate(date)
            },
            clearInputDates: function() {
                inputDates = [];
            },
            setInputDates: function(symd, eymd) {
                const edate = makeDateFormat(eymd);
                let cdate = makeDateFormat(symd);
                while (cdate <= edate) {
                    inputDates.push(dateFormatToString(cdate))
                    cdate.setDate(cdate.getDate() + 1);
                }
            },
            getCalendarType: function () {
                return calendarType;
            },
            getInputDates: function() {
                return inputDates;
            },
            getWorkClassInfo: function() {
                return workClassInfo;
            },
            updateWtmCalendar: function (rowData, insDataYn) {
                // 캘린더 데이터 업데이트
                updateData(calData, rowData, insDataYn);
                if(insDataYn) {
                    updateData(calInsData, rowData, insDataYn);
                    updateBreakTime(rowData);
                }

                // 캘린더 내부 다시 그리기
                if(calendarType === 'W') {
                    drawWtmWeeklyCalendar(rowData.ymd)
                } else if (calendarType === 'M') {
                    drawWtmMonthlyCalendar(rowData.ymd)
                }
            },
            updateBreakTime: function(ymd) {
                const rowData = this.getCalData(ymd, WtmCalendar.getBaseWorkCd())
                if(rowData[0]) updateBreakTime(rowData[0])
                if(calendarType === 'W') {
                    drawWtmWeeklyCalendar(ymd)
                } else if (calendarType === 'M') {
                    drawWtmMonthlyCalendar(ymd)
                }
            },
            deleteBreakTime: function(rowData) {
                deleteBreakTime(rowData)
                if(calendarType === 'W') {
                    drawWtmWeeklyCalendar(rowData.ymd)
                } else if (calendarType === 'M') {
                    drawWtmMonthlyCalendar(rowData.ymd)
                }
            },
            getBreakTimes: function(rowData) {
                return getBreakTimes(rowData)
            },
            getCalInsData: function(ymd) {
                return calInsData;
            },
            getCalData: function(ymd, attCd) {
                if(ymd) {
                    return calData.filter(data => data.ymd === ymd && data.attCd === attCd)
                } else {
                    return calData;
                }
            },
            getRealWorkMin: function(sabun, ymd) {
                // 해당 ymd의 데이터만 필터링
                const ymdData = calData.filter(item => item.sabun === sabun && item.ymd === ymd);

                // 기본근무 항목의 mm 합계
                const workMm = ymdData.filter(item => item.attCd === WtmCalendar.getBaseWorkCd()).reduce((sum, item) => sum + item.mm, 0);

                // 휴게 항목의 mm 합계
                const breakMm = ymdData.filter(item => item.attCd === WtmCalendar.getBreakWorkCd()).reduce((sum, item) => sum + item.mm, 0);

                // 차이 계산
                return workMm - breakMm;
            },
            getHoliday: function(ymd) {
                return holidays.find(holiday => holiday.ymd === ymd);
            },
            isHolidayYn: function(ymd) { // 휴일여부 확인 함수
                let result = [false, '', false]; // 휴일또는휴무일여부, 휴일명, 휴무일여부

                // 회사 휴일에 해당하는지 먼저 확인
                const found = holidays.find(holiday => holiday.ymd === ymd);
                result[0] = !!found
                result[1] = found ? found.holidayNm : ''

                const weekday = getWeekday(ymd);
                if(!result[0]) {
                    // 주휴일에 해당하는지 확인.
                    result[0] = workClassInfo.weekRestDay.split(',').includes(weekday)
                    result[1] = result[0] ? '주휴일' : ''
                }

                if(!result[0]) {
                    // 근무요일에 해당하는지 확인.
                    result[0] = !(workClassInfo.workDay.split(',').includes(weekday))
                    result[1] = result[0] ? '휴무일' : ''
                    result[2] = !!result[0];
                }

                return result;
            },
			setWorkClassInfo: function(sdate, edate) {
				setWorkClassInfo(sdate, edate);
			},
        }

    })();


    /**
     * 초기 이벤트 바인딩
     */
    function initEvent() {
        /* 근무캘린더 버튼 클릭 이벤트 */
        $("#toCalendar").on('click', function (){
            window.location.href = '/WtmWorkCalendar.do?cmd=viewWtmWorkCalendar';
        });

        /* 조회조건 기준일자 이벤트 */
        $("#searchYmd").datepicker2({
            enddate:"today",
            onReturn: chkSearchCon
        });

        $("#searchYmd").on("keyup",function(event){
            if( event.keyCode == 13){
                chkSearchCon();
                $(this).focus();
            }
        });

        $("#searchYmd").on('blur', function () {
            chkSearchCon();
        });

        /* 신청 단위 변경 이벤트 */
        $('#searchApplUnit').on('change', function() {
            drawCalendar();
        });

		//컨텐츠 탭 메뉴
		$(".tab_menu").on("click", function () {
			$(this).siblings().removeClass("active");
			$(this).addClass("active");
		});

		/* 휴게시간 추가 버튼 클릭 이벤트 추가 */
		$(document).on('click', '#addBreakBtn', function() {
			const html =
					`<div class="d-flex align-center breakDiv py-2">
                    <div class="input-wrap wid-60px">
                        <input id="breakShm" name="breakShm" type="text" class="form-input center" maxlength="5"/>
                    </div>
                    <span class="input-divider">-</span>
                    <div class="input-wrap wid-60px">
                        <input id="breakEhm" name="breakEhm" type="text" class="form-input center" maxlength="5"/>
                    </div>
                    <button type="button" class="btn outline_gray ml-auto delete-break">삭제</button>
                </div>`
			$('#breaktime-wrap').append(html)

			setBreakTimeMask();
		});

		/* 휴게시간 삭제 클릭 이벤트 */
		$(document).on('click', '.delete-break', function() {
			const dates = WtmCalendar.getInputDates(); // 입력 활성화 된 날짜
			const $breakDiv = $(this).closest('.breakDiv');
			const breakShm = $breakDiv.find('input[name="breakShm"]').val();
			const breakEhm = $breakDiv.find('input[name="breakEhm"]').val();

			dates.forEach(ymd => {
				WtmCalendar.deleteBreakTime({
					sabun: '${applSabun}',
					name: '${applSabunName}',
					ymd: ymd,
					type: 'WORK',
					attCd: WtmCalendar.getBreakWorkCd(),
					shh: breakShm.substring(0, 2),
					smm: breakShm.substring(2, 4),
					ehh: breakEhm.substring(0, 2),
					emm: breakEhm.substring(2, 4),
				});
			});

			$breakDiv.remove();
		});

		// 휴게시간, 근무시간 입력 이벤트
		setBreakTimeMask();
		setWorkTimeMask();

		// 스케줄 등록 창 닫기 버튼
		$(".closeContextBtn").on('click', function() {
			const $context = $('#reqContext');
			$context.css({
				display: 'none'
			});
		})

        /* 주간,월간 토글 이벤트 */
        $("#applUnitToggleTab li").click(function() {
            if($(this).attr("rel") == "monthly"){
                $('#applUnitToggleWrap').addClass('slide');
                $('#applUnit').val("M");
            }else{
                $('#applUnitToggleWrap').removeClass('slide');
                $('#applUnit').val("W");
            }
            $("#applUnitToggleTab li").removeClass("active");
            $(this).addClass("active");

            // 신청 단위에 맞는 캘린더 그리기
            drawCalendar();
        });

        /* 신청 버튼 클릭 이벤트 */
        $("#applBtn").off('click').on('click', async function (){

            try {
                progressBar('근무스케줄을 저장 중입니다.');

                // 저장 처리
                const response = await fetch("/WtmWorkCalendar.do?cmd=saveWtmReqWorkSchedule", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({"insSchedules": WtmCalendar.getCalInsData(), "schedules": WtmCalendar.getCalData(), ...Object.fromEntries(new FormData($("#wtmReqWorkScheduleFrm")[0]))}),
                });

                const result = (await response.json()).Result;
                if (result.Code > 0) {
                    const applSeq = result.Data.applSeq;
                    if(!isPopup()) {return;}
                    let approvalMgrLayer = new window.top.document.LayerModal({
                        id: 'approvalMgrLayer',
                        url: '/ApprovalMgr.do?cmd=viewWtmApprovalMgrLayer',
                        parameters: {
                            adminYn : 'N'
                            , authPg : 'A'
                            , searchApplCd : WtmCalendar.getWorkClassInfo().applCd
                            , searchApplSabun : '${applSabun}'
                            , searchApplSeq : applSeq
                            , searchApplYmd : '${curSysYyyyMMdd}'
                            , searchSabun : '${ssnSabun}'
                        },
                        width: 1230,
                        height: 815,
                        title: '근무스케줄 신청',
                        trigger: [
                            {
                                name: 'approvalMgrLayerTrigger',
                                callback: function(rv) {
                                    window.location.href = '/WtmWorkCalendar.do?cmd=viewWtmWorkCalendar';
                                }
                            }
                        ]
                    });
                    approvalMgrLayer.show();
                } else {
                    if (result.Message) {
                        alert(result.Message);
                    }
                }
            } catch (error) {
                console.error('저장 중 오류 발생:', error);
                alert('저장 중 오류가 발생했습니다.');
            } finally {
                progressBar(false);
            }
        });
    }

    /**
    * 주간캘린더용 이벤트 초기화
    */
    function initWeeklyEvent(){
        /* ===================================*/
        /* ======= 주간 캘린더 전용 이벤트 =======*/
        /* ===================================*/
        /* 주간 캘린더 cell 클릭 이벤트 */
        $(document).off('click').on('click', '.col', function(event) {
            event.preventDefault();

            // 휴일인 경우, 설정창 띄우지 않기.
            if($(this).parent().data('holiday') === 'Y') return;

            // 클릭한 위치의 날짜 및 시간 정보 가져오기
            const ymd = $(this).data('ymd').toString();
            const selTime = $(this).data('time');

            WtmCalendar.clearInputDates();
            WtmCalendar.setInputDates(ymd, ymd);

            showContextMenu(event);

            // 기존 근무 스케줄이 있으면 해당값으로, 없으면 클릭한 위치의 시간으로 근무 시작시간 세팅
            const existData = WtmCalendar.getCalData(ymd, WtmCalendar.getBaseWorkCd());
            if(existData && existData.length > 0) {
                $('#workShm').val(existData[0].shh+':'+existData[0].smm);
                $('#workEhm').val(existData[0].ehh+':'+existData[0].emm);
                // 휴게시간설정
                setAutoBreakTimes(existData[0], true); // 휴게시간 설정
            } else {
                $('#workShm').val(selTime+':00');
                $('#workEhm').val('')
                setAutoBreakTimes({ymd: ymd}, false); // 휴게시간 설정
            }
        });

        /* 주간 캘린더 cell size 계산 함수 바인딩 */
        updateTableWidth();
        $(window).off('resize').on('resize', updateTableWidth);
    }

    /**
    * 월간캘린더용 이벤트 초기화
    * @param calendar
    */
    function initMonthlyEvent(calendar){
        if(!checkMonthLimit(calendar, 1)) $("#nextMonthBtn").hide();
        else $("#nextMonthBtn").show()
        if(!checkMonthLimit(calendar, -1)) $("#prevMonthBtn").hide();
        else $("#prevMonthBtn").show();

        /* 달력 다음 버튼 클릭 이벤트 */
        $("#nextMonthBtn").on("click", function () {
            if(!checkMonthLimit(calendar, 1)) return; // 다음달로 이동하기 전 월 선택 범위 체크
            calendar.next(); // 캘린더를 다음 달로 이동시킵니다.
            handleClickGetCurrentDate(calendar);
            if(!checkMonthLimit(calendar, 1)) $("#nextMonthBtn").hide(); // 다음달로 이동 후 월 선택 범위 체크해서 다음달 이동 버튼 display 변경
            $("#prevMonthBtn").show();
        });

        /* 달력 이전 버튼 클릭 이벤트 */
        $("#prevMonthBtn").on("click", function () {
            if(!checkMonthLimit(calendar, -1)) return;
            calendar.prev(); // 캘린더를 이전 달로 이동시킵니다.
            handleClickGetCurrentDate(calendar, -1);
            if(!checkMonthLimit(calendar, -1)) $("#prevMonthBtn").hide();
            $("#nextMonthBtn").show();
        });

        /**
        * 월 선택 범위 체크
        * @param calendar
        * @param addMonth
        */
        function checkMonthLimit(calendar, addMonth) {
            const { viewTitle, currentDate } = calendar.currentData;

            // targetDate : 변경하려는 날짜
            const targetDate = new Date(currentDate);
            targetDate.setMonth(targetDate.getMonth() + addMonth);

            // baseDate : 기준일자가 속하는 년월의 1일
            const baseDate = makeDateFormat($('#searchYmd').val());
            baseDate.setDate(1)

            // limitDate : baseDate + 선택한 unit 개월
            const applMinUnit = WtmCalendar.getWorkClassInfo().applMinUnit;
            const limitDate = new Date(baseDate);
            limitDate.setMonth(limitDate.getMonth() + Number($('#searchApplUnit').val() * applMinUnit));
            limitDate.setDate(limitDate.getDate() - 1);

            // targetDate 가 baseDate 와 limitDate 사이에 속하는지 체크
            return targetDate.getTime() >= baseDate.getTime() && targetDate.getTime() <= limitDate.getTime();
        }

        /**
         * 이전, 다음달 이벤트 발생시 현재 년월을 변경한다
         * @param calendar
         */
        function handleClickGetCurrentDate(calendar) {
            const { viewTitle, currentDate } = calendar.currentData;
            const today = Utils.parseDate(new Date());
            let selDate = Utils.parseDate(calendar.getDate());

            if(Utils.parseDate(calendar.getDate()) >= today){
                const currentDate = calendar.currentData.currentDate;
                selDate = Utils.parseDate(new Date(currentDate.getFullYear(), currentDate.getMonth(), 0));
            }
            $('#year').text(currentDate.getFullYear())
            $('#month').text(currentDate.getMonth()+1)
        }
    }

    /**
    * 근무스케줄 입력 이벤트
    */
	function setWorkTimeMask() {
		$('#workShm, #workEhm').not('.masked').addClass('masked').mask("00:00", {
			onKeyPress: function(val, e, field, options) {
				var hour = parseInt(val.substring(0, 2));
				var min = parseInt(val.substring(3, 5));

				// 시간 유효성 검사
				if(hour > 23) {
					field.val('23' + val.substring(2));
				}
				// 분 유효성 검사
				if(min > 59) {
					field.val(val.substring(0, 3) + '59');
				}

				// 완전한 시간 입력 확인
				if($('#workShm').val() && $('#workShm').val().length === 5 && $('#workEhm').val() && $('#workEhm').val().length === 5) {
					const workSHh = $('#workShm').val().substring(0, 2)
					const workSMm = $('#workShm').val().substring(3, 5)
					const workEHh = $('#workEhm').val().substring(0, 2)
					const workEMm = $('#workEhm').val().substring(3, 5)
					const calendarType = WtmCalendar.getCalendarType();
					const dates = WtmCalendar.getInputDates(); // 입력 활성화 된 날짜

					dates.forEach(ymd => {
						// 월간 캘린더인경우, 입력 제한 범위에 속하는 날짜라면 근무스케줄 입력 방지처리
						if(calendarType === 'M' && !WtmCalendar.getAllowDate(makeDateFormat(ymd))) {
							return;
						}

						// 근무 시작시간이 종료시간보다 이후인 경우, eymd는 ymd + 1 일
						let eymdDate = makeDateFormat(ymd);
						if(workSHh+workSMm > workEHh +workEMm) {
							eymdDate.setDate(eymdDate.getDate() + 1)
						}

						const eymd = dateFormatToString(eymdDate);
						const insData = {
							sabun: '${applSabun}',
							name: '${applSabunName}',
							ymd: ymd,
							type: 'WORK',
							attCd: WtmCalendar.getBaseWorkCd(),
							attNm: '근무',
							symd: ymd,
							shh: workSHh,
							smm: workSMm,
							eymd: eymd,
							ehh: workEHh,
							emm: workEMm,
						};

						if(!chkInsCalDataCon(insData)) {return;} // 조건체크

						// 휴게시간 설정
						setAutoBreakTimes(insData, false);

						// data 세팅
						WtmCalendar.updateWtmCalendar(insData, true)
					});
				}
			}
		});
	}

	/**
	 * 휴게시간 입력 이벤트
	 */
	function setBreakTimeMask() {
		// 새로 추가된 입력 필드에만 마스크 적용
		$('input[name="breakShm"], input[name="breakEhm"]').not('.masked').addClass('masked').mask("00:00", {
			onKeyPress: function(val, e, field, options) {
				var hour = parseInt(val.substring(0, 2));
				var min = parseInt(val.substring(3, 5));

				// 시간 유효성 검사
				if(hour > 23) {
					field.val('23' + val.substring(2));
				}
				// 분 유효성 검사
				if(min > 59) {
					field.val(val.substring(0, 3) + '59');
				}

				const fieldVal = field.val();
				if(fieldVal && fieldVal.length === 5) { // 완전한 시간 입력 확인
					const dates = WtmCalendar.getInputDates(); // 입력 활성화 된 날짜
					dates.forEach(ymd => {
						WtmCalendar.updateBreakTime(ymd);
					});
				}
			}
		});
	}

    /**
     * 조회
     */
    async function searchWorkSchedule() {
		if(!chkSearchCon()) {
			return false;
		}
    }

    /**
     * 조회 전 유효성 체크
     */
    function chkSearchCon() {
        // 오늘 이전 날짜는 처리 할 수 없도록 함.
        const searchDate = new Date($("#searchYmd").val());
        const today = new Date();

        searchDate.setHours(0, 0, 0, 0);
        today.setHours(0, 0, 0, 0);

        if (searchDate < today) {
            alert("오늘 이전 일자는 신청 할 수 없습니다.");
            $("#searchYmd").val("${curSysYyyyMMddHyphen}")
            return false;
        }

        // 캘린더 초기화
        // WtmCalendar.initCalendar();

        // 근무스케줄 신청이 가능한 근무유형인지 확인
		WtmCalendar.setWorkClassInfo();
        const workClassInfo = WtmCalendar.getWorkClassInfo();
        if(workClassInfo) {
            if(workClassInfo.applCd === '') {
                alert("근무유형 " + workClassInfo.workClassNm + "은 근무스케줄 신청 대상이 아닙니다.");
                return false;
            } else {
                // 신청단위 항목 설정 및 주/월 토글 버튼 조작
                setApplUnit(workClassInfo);
            }
        }

        return true;
    }

    /**
     *  근무시간 입력시 조건 체크
     */
    function chkInsCalDataCon(insData) {
        const workClassInfo = WtmCalendar.getWorkClassInfo();
        const workShm = $('#workShm').val().replace(/:/gi, "");
        const workEhm = $('#workEhm').val().replace(/:/gi, "");

        /* 1. 근무 시작 시간 유효성 체크 */
        // 1-1.근무유형의 근무시작시간과 입력한 근무시작시간의 값이 다른 경우 오류.
        let msg = '근무시작시간은 근무유형의 근무시작시간('+formatTime(workClassInfo.workTimeF)+')과 동일해야 합니다.'
        if(workClassInfo.workTimeF && workClassInfo.workTimeF !== workShm) {
            alert(msg);
            $('#workShm').val(formatTime(workClassInfo.workTimeF))
            $('#workEhm').val('').focus()
            return false;
        }
        // 1-2. 근무유형의 출근가능시간 범위를 벗어난 경우 오류.
        msg = '출근가능시간 범위('+formatTime(workClassInfo.startWorkTimeF) + '-' + formatTime(workClassInfo.startWorkTimeT) +')를 벗어났습니다.';
        if(workClassInfo.startWorkTimeF && workClassInfo.startWorkTimeF > workShm) {
            alert(msg);
            $('#workShm').val(formatTime(workClassInfo.startWorkTimeF))
            $('#workEhm').val('').focus()
            return false;
        }
        if(workClassInfo.startWorkTimeT && workClassInfo.startWorkTimeT < workShm) {
            alert(msg);
            $('#workShm').val(formatTime(workClassInfo.startWorkTimeF))
            $('#workEhm').val('').focus()
            return false;
        }

        /* 2. 코어타임 유효성 체크 */
        msg = '근무시간이 코어타임 범위('+formatTime(workClassInfo.coreTimeF) + '-' + formatTime(workClassInfo.coreTimeT) +')를 벗어났습니다.';
        if(workClassInfo.coreTimeF && workClassInfo.coreTimeT
            && !(workClassInfo.coreTimeF > workShm && workClassInfo.coreTimeT < workEhm)) {
            alert(msg);
            $('#workShm').val('').focus()
            $('#workEhm').val('')
            return false;
        }

        /* 3. 근무시간 체크 */
        // 근무유형관리-근무시간기준에 단위기간 값이 없는 근무유형은 입력한 근무시간이 표준근무시간과 일치해야한다.
        // => 근무시간기준에 단위기간이 없다는건 하루에 표준 근무시간을 무조건 충족 해야한다는 말과 동일.
        msg = '일 표준 근무시간('+workClassInfo.workHours+'시간)을 충족하지 못했습니다.'
        if(!workClassInfo.intervalCd || workClassInfo.intervalCd === '') {
            const workMm = workClassInfo.workHours * 60;
            const planWorkMm = calcMinutes(insData);
            if(workMm > planWorkMm) {
                alert(msg)
                $('#workEhm').val('').focus()
                return false;
            }
        }

        /* 4.근무 종료시간 체크 */
        // 근무유형의 근무종료시간과 입력한 근무종료시간의 값이 다른 경우 오류.
        msg = '근무종료시간은 근무유형의 근무종료시간('+formatTime(workClassInfo.workTimeT)+')과 동일해야 합니다.'
        if(workClassInfo.workTimeT && workClassInfo.workTimeT !== workEhm) {
            alert(msg);
            $('#workEhm').val(formatTime(workClassInfo.workTimeT))
            return false;
        }

        return true;
    }

    /**
     * 신청단위 항목 set 및 그 외 조건 처리
     */
    async function setApplUnit(workClassInfo) {
		try {
			progressBar(true);
			const applUnit = workClassInfo.applUnit;
			const intervalCd = workClassInfo.intervalCd;

			$('#searchApplUnit').empty();
			if(intervalCd === '') {
				// 신청 단위 값이 null 인 경우에만 주간/월간 토글버튼 활성화 처리
				$('#applUnitToggleWrap').show();

				if($('#applUnit').val() === '') {
					// 월간을 디폴트로 설정
					$("#applUnitToggleTab li").removeClass("active");
					$('#applUnitToggleWrap').addClass('slide');
					$("#applUnitToggleTab li[rel='monthly']").addClass("active");
					$('#applUnit').val("M");
				}
				$(".appl-unit").hide()
				$("#searchApplUnit").html("<option value='1'>1</option>");
				await drawCalendar();
			} else {
				$('#applUnit').val(applUnit);
				$('#applUnitToggleWrap').hide();
				$("#applUnitToggleTab li").removeClass("active");
				if(applUnit === 'W') {
					$('#applUnitToggleWrap').removeClass('slide');
					$("#applUnitToggleTab li[rel='weekly']").addClass("active");
				} else {
					$('#applUnitToggleWrap').addClass('slide');
					$("#applUnitToggleTab li[rel='monthly']").addClass("active");
				}

				// 신청단위 항목 option 추가
				$(".appl-unit").show();
				const params = "searchWorkClassCd=" + workClassInfo.workClassCd;
				var applUnitList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWtmWorkCalendarApplUnit&"+params, false).codeList, "");
				$("#searchApplUnit").html(applUnitList[2]);

				// 신청 단위에 맞는 캘린더 그리기
				await drawCalendar();
			}
		} catch(err) {
			console.error(err);
		} finally {
			progressBar(false);
		}
    }

    /**
    * 근무유형 신청 단위에 맞는 캘린더 그리기
    */
    async function drawCalendar() {

        // 기준일자가 속하는 날의 모든 일자 및 근무스케줄 상세 조회.
        const response = await fetch("/WtmWorkCalendar.do?cmd=getReqWorkScheduleDayList", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: $("#wtmReqWorkScheduleFrm").serialize()
        });
        const result = await response.json();

        // 달력 그리기
        const applUnit = $('#applUnit').val()
        switch (applUnit) {
            // 주단위 달력 그리기
            case 'W' :
                try {
                    WtmCalendar.drawWeeklyCalendarHeader(); // 주단위 달력 그리기

                    // 주 달력 그리기
                    if (result.DAY.length > 0) {
                        const dayData = result.DAY;
                        // sdate, edate 설정
                        $('#sdate').val(formatDate(dayData[0].ymd, '-'))
                        $('#edate').val(formatDate(dayData[dayData.length-1].ymd, '-'))

                        // 캘린더 초기화
                        WtmCalendar.initCalendar(dayData[0].ymd, dayData[dayData.length-1].ymd);

                        // 일주일 그리기
                        const $weekTableBody = $('#weekTableBody');
                        $weekTableBody.empty();
                        dayData.forEach(data => {
                            let rowData = {
                                sabun: '${applSabun}',
                                name: '${applSabunName}',
                                ymd: data.ymd,
                                date: data.date,
                                day: data.day
                            };
                            $weekTableBody.append(createWeekCalRow(rowData))
                        })
                        setFixTable();

						// 페이징 탭 설정
						const maxPage = Math.ceil(result.DAY.length / 7);
						let pageTabHtml = `<div class="tab_menu active" onclick="showCalendarPage(1)">1주차</div>`;
						for(let i=2 ; i <= maxPage; i++) {
							pageTabHtml += `<div class="tab_menu" onclick="showCalendarPage(${'${i}'})">${'${i}'}주차</div>`
						}

						$("#pageDiv").append(pageTabHtml);
						$(".tab_menu").on("click", function () {
							$(this).siblings().removeClass("active");
							$(this).addClass("active");
						});
						showCalendarPage(1)
                    }

                    // 근무스케줄 데이터 출력
                    if (result.SCHEDULE.length > 0) {
                        const scheduleData = result.SCHEDULE;
                        scheduleData.forEach(data => {
                            WtmCalendar.updateWtmCalendar({
                                sabun: data.sabun,
                                name: data.name,
                                ymd: data.ymd,
                                type: data.type,
                                attCd: data.attCd,
                                attNm: data.attNm,
                                symd: data.symd,
                                shh: data.shm.substring(0, 2),
                                smm: data.shm.substring(2, 4),
                                eymd: data.eymd,
                                ehh: data.ehm.substring(0, 2),
                                emm: data.ehm.substring(2, 4),
                                mm: data.mm
                            }, false)
                        })
                    }
                } catch (error) {
                    console.error('조회 중 오류 발생:', error);
                    alert('근무스케줄 신청 대상이 아닙니다.');
                }
                break;
            case 'M' :
				$("#pageDiv").empty();

                // 달력 시작, 종료일 설정
                if (result.DAY.length > 0) {
                    const data = result.DAY;

                    // sdate, edate 설정
                    $('#sdate').val(formatDate(data[0].sYmd, '-'))
                    $('#edate').val(formatDate(data[0].eYmd, '-'))

                    // 캘린더 초기화
                    WtmCalendar.initCalendar(data[0].sYmd, data[0].eYmd);
                }

                // 풀캘린더로 월단위 달력 그리기
                WtmCalendar.drawMonthlyCalendar();

                // 근무스케줄 데이터 출력
                if (result.SCHEDULE.length > 0) {
                    const scheduleData = result.SCHEDULE;
                    scheduleData.forEach(data => {
                        WtmCalendar.updateWtmCalendar({
                            sabun: data.sabun,
                            name: data.name,
                            ymd: data.ymd,
                            type: data.type,
                            attCd: data.attCd,
                            attNm: data.attNm,
                            symd: data.symd,
                            shh: data.shm.substring(0, 2),
                            smm: data.shm.substring(2, 4),
                            eymd: data.eymd,
                            ehh: data.ehm.substring(0, 2),
                            emm: data.ehm.substring(2, 4),
                            mm: data.mm
                        }, false)
                    })
                }
                break;
        }
    }

    /**
     * 주단위 달력 row 생성 함수
     */
    function createWeekCalRow(rowData) {
        const $row = $('<div class="row calendarDayRow" width="2770px"></div>')
        const $fixTableTd = $('<div class="fixTable_td type_fix"></div>')
        const $dateWrap = $('<div class="date-wrap"></div>')
        const $dateSpan = $('<span class="date">'+rowData.date+'</span>')
        const $daySpan = $('<span class="day">'+rowData.day+'</span>')
        const holidayYn = WtmCalendar.isHolidayYn(rowData.ymd);
        const $holidaySpan = $('<span class="text weekend">'+holidayYn[1]+'</span>')

        if (holidayYn[0]) {
            $dateSpan.addClass('weekend')
            $daySpan.addClass('weekend')

            if(holidayYn[2]) {
                $dateSpan.addClass('sat')
                $daySpan.addClass('sat')
                $holidaySpan.addClass('sat')
            }
        }

        $dateWrap.append($dateSpan);
        $dateWrap.append($holidaySpan);
        $dateWrap.append($daySpan);

        $fixTableTd.append($dateWrap);
        const $moveTableTd = $(`<div id="td_${'${rowData.sabun}'}_${'${rowData.ymd}'}" class="fixTable_td type_move"></div>`)
        if(holidayYn[0]) {
            // 휴일인 경우, 배경색 변경
            $moveTableTd.css('background-color', '#f5f5f5')
            $moveTableTd.css('cursor', 'not-allowed')
            $moveTableTd.attr('data-holiday', 'Y')
        }

        // 입력 불가능 날짜인 경우(오늘이전)
        const today = new Date();
        if(makeDateFormat(rowData.ymd).setHours(0,0,0,0) < today.setHours(0,0,0,0)) {
            $moveTableTd.css('background-color', '#f5f5f5')
            $moveTableTd.css('cursor', 'not-allowed')
            $moveTableTd.attr('data-holiday', 'Y')
        }

        if(WtmCalendar.getWorkClassInfo().sameDayChgYn === 'N' && dateFormatToString(today) === rowData.ymd) {
            $moveTableTd.css('background-color', '#f5f5f5')
            $moveTableTd.css('cursor', 'not-allowed')
            $moveTableTd.attr('data-holiday', 'Y')
        }

        const times = Array.from({ length: 24 }, (_, i) => {
            return {
                time: String(i).padStart(2, '0'), // 00시부터 23시까지의 time 값
            };
        });

        times.forEach(obj => {
            const $col = $('<div class="col"></div>');
            $col.attr('data-ymd', rowData.ymd)
            $col.attr('data-time', obj.time)
            $moveTableTd.append($col);
        });

        $row.append($fixTableTd);
        $row.append($moveTableTd);

        return $row;
    }

    /**
    * 휴게시간 값 설정 및 그리기
    * @param insData 근무시간 데이터
    * @param existYn 기존 데이터 호출 유무
     */
    function setAutoBreakTimes(insData, existYn) {
        const workClassInfo = WtmCalendar.getWorkClassInfo();
        let breakTimes;
        let drawYn = false;
        let readonlyYn = false;

        $('#breaktime-wrap').children(':not(#add-btn-wrap)').remove(); // 버튼을 제외한 모든 내용을 비움

        // 기본 휴게시간 타입이 지정휴게이거나 근무시간 기준 경우
        if(workClassInfo.breakTimeType === 'A' || workClassInfo.breakTimeType === 'B') {
            breakTimes = WtmCalendar.getBreakTimes(insData);
            // 휴게시간 추가 버튼 비활성화
            $('#addBreakBtn').hide();
            drawYn = true;
            readonlyYn = true;
        } else {
            $('#addBreakBtn').show();
            readonlyYn = false;
        }

        // 이미 설정된 값이 있는 경우, 해당 값을 가져온다.
        if(existYn) {
            breakTimes = WtmCalendar.getCalData(insData.ymd, WtmCalendar.getBreakWorkCd());
            if(breakTimes.length > 0)
                drawYn = true;
            else
                drawYn = false;
        }

        if(drawYn) {
            breakTimes.forEach((breakTime) => {
                let html =
                    `<div class="d-flex align-center breakDiv py-2">
                        <div class="input-wrap wid-60px">
                            <input id="breakShm" name="breakShm" type="text" class="form-input center" maxlength="5" value="${'${breakTime.shh}'}${'${breakTime.smm}'}"/>
                        </div>
                        <span class="input-divider">-</span>
                        <div class="input-wrap wid-60px">
                            <input id="breakEhm" name="breakEhm" type="text" class="form-input center" maxlength="5" value="${'${breakTime.ehh}'}${'${breakTime.emm}'}"/>
                        </div>`
                if(WtmCalendar.getWorkClassInfo().breakTimeType === 'C') {
                    html += `<button type="button" class="btn outline_gray ml-auto delete-break">삭제</button>`
                }
                html += `</div>`
                $('#breaktime-wrap').append(html)
            });
        } else {
            const html =
                `
                <div class="d-flex align-center breakDiv py-2">
                    <div class="input-wrap wid-60px">
                        <input id="breakShm" name="breakShm" type="text" class="form-input center" maxlength="5" value=""/>
                    </div>
                    <span class="input-divider">-</span>
                    <div class="input-wrap wid-60px">
                        <input id="breakEhm" name="breakEhm" type="text" class="form-input center" maxlength="5" value=""/>
                    </div>
                    <button type="button" class="btn outline_gray ml-auto delete-break">삭제</button>
                </div>`
            $('#breaktime-wrap').append(html)
        }

		setBreakTimeMask();
        $('input[name="breakShm"]').attr('readonly', readonlyYn)
        $('input[name="breakEhm"]').attr('readonly', readonlyYn)
    }

    /**
     * 페이지 버튼 처리
     */
    function showCalendarPage(page) {
        // 선택한 페이지에 해당하는 주차의 row만 보여준다.
        const start = (page-1)*7;
        const end = page*7;

        $('.calendarDayRow').hide().slice(start, end).show();
    }

    /**
     *  두 시간 사이의 분차이 구하기
     */
    function calcMinutes(rowData) {
        // 시작 날짜 파싱
        const symd = rowData.symd.toString();
        const sYear = parseInt(symd.substring(0, 4));
        const sMonth = parseInt(symd.substring(4, 6));
        const sDay = parseInt(symd.substring(6, 8));

        // 종료 날짜 파싱
        const eymd = rowData.eymd.toString();
        const eYear = parseInt(eymd.substring(0, 4));
        const eMonth = parseInt(eymd.substring(4, 6));
        const eDay = parseInt(eymd.substring(6, 8));

        const startTime = new Date(sYear, sMonth-1, sDay, rowData.shh, rowData.smm);
        const endTime = new Date(eYear, eMonth-1, eDay, rowData.ehh, rowData.emm);

        // 차이를 밀리초로 구한 후 분으로 변환
        return (endTime - startTime) / (1000 * 60);
    }

    /**
     *  적용시간으로 시작시간 or 종료시간 계산
     */
    function calcTimeByMm(ymd, hh, mm, addMm) {
        const year = ymd.substring(0, 4);
        const month = ymd.substring(4, 6);
        const day = ymd.substring(6, 8);

        const date = new Date(year, month - 1, day, hh, mm);

        date.setMinutes(date.getMinutes() + addMm);

        const resYmd = date.getFullYear().toString() +
            String(date.getMonth() + 1).padStart(2, '0') +
            String(date.getDate()).padStart(2, '0');

        const resHh = String(date.getHours()).padStart(2, '0')
        const resMm = String(date.getMinutes()).padStart(2, '0');

        return { ymd: resYmd, hh: resHh, mm: resMm };
    }

    /**
     * 캘린더 틀고정 좌우 스크롤 너비 계산
     */
    function setFixTable() {
        var th_boxWidth = $(".fixTable_header .type_fix").outerWidth();
        var td_boxWidth = $(".fixTable_body .type_move").outerWidth();
        $('.fixTable_body .row').width(th_boxWidth + td_boxWidth + 'px');
        $('.fixTable_header .th_row').width(th_boxWidth + td_boxWidth + 'px');

        // ie 대응 스크롤
        var agent = navigator.userAgent.toLowerCase();

        // ie 브라우저 타겟팅
        if( navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1 || (agent.indexOf("msie") != -1)) {
            $('.fixTable_wrap').addClass('ie');
        }

        const container = document.querySelector('.fixTable_body'); //부모 박스
        const fixBox = document.querySelector('.type_fix'); // 고정 박스

        container.addEventListener('scroll', function() {
            var scrollnum = container.scrollLeft + 'px'; //스크롤 위치값 px값으로 가져오기

            if(container.scrollLeft != 0 ){
                $('.fixTable_body .type_fix').css({"transform": 'translateX' + '(' + scrollnum + ')'}); // 스크롤이 위치값이 0이 아닐때 transform 값 변경
                $('.fixTable_th.type_move').css({"transform": 'translateX' + '(-' + scrollnum + ')'});
            } else{
                $('.fixTable_body .type_fix').css("transform", "translateX(0)");
                $('.fixTable_th.type_move').css("transform", "translateX(0)");
            }
        })
    }

    /**
     * 캘린더에서 Context 창 위치 계산
     */
    function showContextMenu(event) {
        const $context = $('#reqContext');
        // 먼저 요소를 보이게 만듭니다
        $context.css({
            display: 'block',
            visibility: 'hidden'  // 잠시 숨긴 상태로 크기 계산
        });
        // 실제 크기를 가져옵니다
        const contextWidth = $context.outerWidth();
        const contextHeight = $context.outerHeight();
        const windowWidth = $(window).width();
        const windowHeight = $(window).height();
        // 위치 계산
        let leftPosition = event.pageX;
        let topPosition = event.pageY;
        // 오른쪽 경계 체크
        if (leftPosition + contextWidth > windowWidth) {
            leftPosition = event.pageX - contextWidth;
        }
        // 아래쪽 경계 체크
        if (topPosition + contextHeight > windowHeight) {
            topPosition = event.pageY - contextHeight;
        }
        // 계산된 위치로 요소를 이동하고 보이게 만듭니다
        $context.css({
            left: leftPosition + 'px',
            top: topPosition + 'px',
            visibility: 'visible'  // 이제 보이게 설정
        });
    }

    /**
     * 주간 캘린더 cell size 계산
     */
    function updateTableWidth() {
        const $container = $('#weeklyCalendarWrap');
        const containerWidth = $container.width(); // padding 제외한 너비
        const fixedWidth = 120;
        const moveableWidth = containerWidth - fixedWidth;

        // col 하나의 너비 계산 (24등분)
        const colWidth = Math.floor(moveableWidth / 24);

        // 기존 스타일 제거
        $('#dynamic-table-style').remove();
        // 스타일 동적 생성 - header와 body의 col 너비를 동일하게 설정
        $('<style>').attr('id', 'dynamic-table-style')
            .text(`.fixTable_wrap.time .col {
                                        width: ${'${colWidth}'}px;
                                        min-width: ${'${colWidth}'}px;
                                    }

                                    .th_row, .row {
                                        width: ${'${containerWidth}'}px !important;
                                    }

                                    .fixTable_wrap.time .fixTable_body .row .fixTable_td.type_move,
                                    .fixTable_wrap.time .fixTable_header .fixTable_th.type_move {
                                        width: ${'${moveableWidth}'}px;
                                    }

                                    .fixTable_wrap.time .fixTable_body .row .fixTable_td.type_move .col .attend-chip {
                                        width: ${'${colWidth * 9}'}px;
                                        margin-left: ${'${colWidth * 8}'}px;
                                    }`)
            .appendTo('head');

    }
</script>
</head>
<body class="iframe_content white attendanceNew">
<ul class="tab_bottom" style="padding-left: 24px;">
    <li class="tab_menu active">내 근무</li>
    <%-- 임직원 공통 권한이거나, 본인만 조회 권한인 경우 구성원 근무 탭 숨김 --%>
    <c:if test='${ grpCd == "99" || ssnSearchType == "P" }'>
    <li class="tab_menu">구성원 근무</li>
    </c:if>
    <button type="button" class="btn outline_gray" id="toCalendar" style="margin-left: 12px;">근무캘린더</button>
</ul>
<div class="inner">
	<div class="sheet_title">
		<ul>
			<li class="txt">근무스케줄 신청</li>
			<li class="btn">
			</li>
		</ul>
	</div>
</div>
<form name="wtmReqWorkScheduleFrm" id="wtmReqWorkScheduleFrm">
<input type="hidden" id="searchApplSabun" name="searchApplSabun" value="${applSabun}"/>
<input type="hidden" id="searchSabun" name="searchSabun" value="${applSabun}"/>
<div class="sheet_search outer">
	<div>
		<table>
			<colgroup>
				<col width="10%">
				<col width="40%">
				<col width="10%">
				<col width="48%">
			</colgroup>
			<tr>
				<th class="req">기준일자</th>
				<td>
					<input type="text" id="searchYmd" name="searchYmd" class="date2 w80" value="${curSysYyyyMMddHyphen}"/>
			        <input type="hidden" id="today" name="today" class="date2 w80" value="${curSysYyyyMMddHyphen}"/>
			        <input type="hidden" id="applUnit" name="applUnit"/>
		            <span class="date-wrap">
		                <input type="text" id="sdate" name="sdate" class="form-input date2 w80 readonly" value=""/>
		                <i class="date-divider">-</i>
		                <input type="text" id="edate" name="edate" class="form-input date2 w80 readonly" value=""/>
		            </span>
				</td>
				<th class="req appl-unit">신청단위</th>
				<td>
					<div class="select-wrap appl-unit" style="width: 236px;">
			            <select class="custom_select" id="searchApplUnit" name="searchApplUnit"></select>
			        </div>
				</td>
			</tr>
		</table>
	</div>
</div>
<%-- <div id="divDrag" class="drag-item-wrap wide search-wrap">
    <div class="btn-group btn-group-toggle" data-toggle="buttons" id="searchPage">
        <label class="btn btn-primary active">
            <input type="radio" name="weeks" value="첫째주" autocomplete="off" checked> 첫째주
        </label>
        <label class="btn btn-primary">
            <input type="radio" name="weeks" value="둘째주" autocomplete="off"> 둘째주
        </label>
        <label class="btn btn-primary">
            <input type="radio" name="weeks" value="셋째주" autocomplete="off"> 셋째주
        </label>
        <label class="btn btn-primary">
            <input type="radio" name="weeks" value="넷째주" autocomplete="off"> 넷째주
        </label>
    </div>
    <div class="inner-wrap ml-24">
        <span class="label mr-2">기준일자</span>
        <input type="text" id="searchYmd" name="searchYmd" class="date2 w80" value="${curSysYyyyMMddHyphen}"/>
        <input type="hidden" id="today" name="today" class="date2 w80" value="${curSysYyyyMMddHyphen}"/>
        <input type="hidden" id="applUnit" name="applUnit"/>
        <div class="select-wrap">
            <select class="custom_select" id="searchApplUnit" name="searchApplUnit"></select>
        </div>
        <span class="label ml-12 mr-2">근무기간</span>
        <div class="input-wrap">
            <div class="date-wrap">
                <input type="text" id="sdate" name="sdate" class="form-input date2 w80 readonly" value=""/>
            </div>
            <span class="date-divider">-</span>
            <div class="date-wrap">
                <input type="text" id="edate" name="edate" class="form-input date2 w80 readonly" value=""/>
            </div>
        </div>
        <div class="btn-wrap">
            <button type="button" id="applBtn" class="btn filled">신청</button>
        </div>
    </div>
</div> --%>
</form>
<div class="bg-grey">
	<div class="attendance-calendar schedule">
	    <div class="fullcalendar-wrap">
	    	<div class="schedule-wrap">
	          <div id="pageDiv" class="tab_wrap">
<%--	            <div class="tab_menu active">첫째주 <span class="time-chip none">미완료</span></div>--%>
<%--	            <div class="tab_menu">둘째주 <span class="time-chip none">미완료</span></div>--%>
<%--	            <div class="tab_menu">셋째주 <span class="time-chip">완료</span></div>--%>
<%--	            <div class="tab_menu">넷째주 <span class="time-chip">완료</span></div>--%>
	          </div>
	          <div class="btn-wrap ml-auto">
<%--	            <button type="button" class="btn soft" id="">임시저장</button>--%>
<%--	            <button type="button" class="btn filled" id="">스케줄 반영</button>--%>
				<button type="button" id="applBtn" class="btn filled">신청</button>
	          </div>
	        </div>
	        <div class="calendar-head top-40">
	            <div class="status-wrap time-wrap"></div>
	            <div class="year-wrap">
	                <button type="button" id="prevMonthBtn"><i class="mdi-ico">chevron_left</i></button>
	                <span id="year" class="year">${curSysYear}</span>
	                <span class="unit">년</span>
	                <span id="month" class="year ml-0">${curSysMon}</span>
	                <span class="unit">월</span>
	                <button type="button" id="nextMonthBtn"><i class="mdi-ico">chevron_right</i></button>
	            </div>
	            <div id="applUnitToggleWrap" class="toggle-tab-wrap ml-auto">
	                <ul id="applUnitToggleTab" class="toggle-tab">
	                    <li class="tab-slider active" rel="weekly">주간</li>
	                    <li class="tab-slider" rel="monthly">월간</li>
	                </ul>
	            </div>
	        </div>
	        <div id="weeklyCalendarWrap" class="fixTable_wrap time" style="position:absolute; top: 92px; height: calc(100vh - 205px)">
	            <div class="fixTable_header">
	                <div class="th_row">
	                    <div class="fixTable_th type_fix"></div>
	                    <div class="fixTable_th type_move" id="weeklyCalendarHeader"></div>
	                </div>
	            </div>
	            <div class="fixTable_body" id="weekTableBody"></div>
	        </div>
	        <div id="monthlyCalendarWrap">
	            <div class="monthlyCalendar calendar custom-header" id="monthlyCalendar"></div>
	        </div>
	    </div>
	</div>
</div>
<div id="reqContext" class="custom-context-menu" style="display: none">
	<div class="context-header">
		<span class="header-title">스케줄 등록</span>
		<button class="btn icon ml-auto closeContextBtn">
		  <i class="mdi-ico">close</i>
		</button>
	</div>
	<div class="context-body">
	    <div id="dateTitle" class="date-title"></div>
	    <table class="basic type5 line-grey">
	        <colgroup>
	            <col width="10%" />
	            <col width="90%" />
	        </colgroup>
	        <tbody>
	        <tr>
	            <th class="text-center">근무시간</th>
	            <td>
	                <div class="d-flex align-center">
	                    <div class="input-wrap wid-60px">
	                        <input id="workShm" name="workShm" type="text" class="form-input center" maxlength="5"/>
	                    </div>
	                    <span class="input-divider">-</span>
	                    <div class="input-wrap wid-60px">
	                        <input id="workEhm" name="workEhm" type="text" class="form-input center" maxlength="5"/>
	                    </div>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <th class="text-center">휴게시간
				<button class="btn icon_text text f_blue" id="addBreakBtn">
				  <i class="mdi-ico filled ">add_circle</i>추가
				</button>
	            <td id="breaktime-wrap">
	                <div id="add-btn-wrap"><p style="font-size: 12px; font-weight: 400; line-height: 1.29; color: #9f9f9f;">*휴게시간 추가 가능</p></div>
	            </td>
	        </tr>
	        </tbody>
	    </table>
	</div>
	<div class="context-footer">
		<button type="button" class="btn outline_gray ml-auto closeContextBtn">닫기</button>
	</div>
</div>
</body>
</html>
