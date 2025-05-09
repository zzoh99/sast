<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- bootstrap -->
<link rel="stylesheet" type="text/css" href="/common/plugin/bootstrap/css/bootstrap.min.css"/>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp" %>
<title>근무스케줄 상세설정</title>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>

<!-- 개별 화면 script -->

<script type="text/javascript">
    var calType = 'monthly';
    $(document).ready(function () {
        drawChips();
        drawTableBody();

        initEvent();
    });

    function drawChips() {
        const scheduleList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWorkScheduleList", "workClassCd=" + '${selectedWorkClassCd}', false).DATA;
        let chipHtml = '';

        for (let i = 0; i < scheduleList.length; i++) {
            const schedule = scheduleList[i];
            chipHtml += '<div class="attend-chip sch '+schedule.color+'" draggable="true" ondragstart="drag(event)" id="divDrag' + (i+2) + '" data-id="' + schedule.workSchCd + '"><span class="text ellipsis">' + schedule.workSchSrtNm + '</span><i class="mdi-ico">delete</i></div>'
        }
        $(".divider").before(chipHtml);
    }

    function initEvent() {
        // 기간 입력 input box
        $("#sdate").datepicker2({
            startdate:"edate",
            onReturn: drawTableBody
        });

        $("#edate").datepicker2({
            enddate:"sdate",
            onReturn: drawTableBody
        });

        const today = new Date();
        const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
        $("#edate").val(dateFormatToString(lastDay, '-'))

        // 교대설정 버튼 클릭 이벤트
        $("#goSetBtn").on('click', function () {
            const param = "&workClassCd=${selectedWorkClassCd}";
            window.location.href = '/WtmWorkTypeMgr.do?cmd=viewWtmWorkClassMgr' + param;
        });

        // 임시저장 버튼 클릭 이벤트
        $("#saveBtn").on('click', async function () {
            try {
                progressBar(true, '저장중입니다.');
                const schedules = $('#workClassSchDetailForm [id^="chip"]').map(function() {
                    if($(this).find('input[name="postYn"]').val() === 'N'){ // 스케줄 반영되지 않는 항목만
                        return {
                            workClassCd: $(this).find('input[name="workClassCd"]').val(),
                            workSchCd: $(this).find('input[name="workSchCd"]').val(),
                            sabun: $(this).find('input[name="sabun"]').val(),
                            ymd: $(this).find('input[name="ymd"]').val(),
                            wrkDtlId: $(this).find('input[name="wrkDtlId"]').val(),
                            postYn: $(this).find('input[name="postYn"]').val(),
                        };
                    }
                }).get();

                const sdate = $('#sdate').val().replace(/-/gi,"");
                const edate = $('#edate').val().replace(/-/gi,"");

                // 저장 처리
                const response = await fetch("/WtmWorkTypeMgr.do?cmd=saveWorkClassSchDetail", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({"schedules": schedules, "sdate": sdate, "edate": edate, "workClassCd": "${selectedWorkClassCd}"}),
                });

                const result = await response.json();
                if (result.Message) {
                    alert(result.Message);
                }
                if(result.Code > 0) {
                    drawTableBody()
                }
            } catch (error) {
                console.error('저장 중 오류 발생:', error);
                alert('저장 중 오류가 발생했습니다.');
            } finally {
                progressBar(false);
            }
        });

        // 스케줄 반영 버튼 클릭 이벤트
        $("#applyBtn").on('click', async function () {
            try {
                progressBar(true, '저장중입니다.');
                const sdate = $('#sdate').val().replace(/-/gi,"");
                const edate = $('#edate').val().replace(/-/gi,"");

                const param = "&workClassCd=" + '${selectedWorkClassCd}'
                    + "&sdate=" + sdate
                    + "&edate=" + edate
                    + "&searchSabunName=" + $('#searchSabunName').val();

                // 저장 처리
                const response = await fetch("/WtmWorkTypeMgr.do?cmd=saveWorkClassSchDetailApply", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: param
                });

                const result = await response.json();
                if (result.Message) {
                    alert(result.Message);
                }
                if(result.Code > 0) {
                    drawTableBody()
                }
            } catch (error) {
                console.error('저장 중 오류 발생:', error);
                alert('저장 중 오류가 발생했습니다.');
            } finally {
                progressBar(false);
            }
        });

        $(".thisMonth").on('click', function () {
            drawTableBody();
        });

        $("#preMonth").on('click', function () {
            let month = $("#month").text();
            let year = $("#year").text();
            month--;
            if (month < 1) {
                month = 12;
                year--;
            }
            const sdate = dateFormatToString(new Date(year, month-1, 1));
            const edate = dateFormatToString(new Date(year, month, 0));
            getDaysInRange(sdate, edate)
            drawTableBody();
        });

        $("#nextMonth").on('click', function () {
            let month = $("#month").text();
            let year = $("#year").text();
            month++;
            if (month > 12) {
                month = 1;
                year++;
            }
            const sdate = dateFormatToString(new Date(year, month-1, 1));
            const edate = dateFormatToString(new Date(year, month, 0));
            getDaysInRange(sdate, edate);
            drawTableBody();
        });

        // 직원 검색 input 이벤트
        $("#searchSabunName").on("keyup", function(event) {
            if( event.keyCode == 13) {
                drawTableBody();
            }
        });

    }
    function getDaysInRange(sdate, edate) {
        const startDate = new Date(makeDateFormat(sdate, '-'));
        const endDate = new Date(makeDateFormat(edate, '-'));

        // 년도와 월 표시
        $("#year").html(startDate.getFullYear());
        $("#month").html(startDate.getMonth() + 1);

        const daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
        const days = [];

        // 시작일부터 종료일까지 루프
        const currentDate = new Date(startDate);
        while (currentDate <= endDate) {
            days.push({
                date: currentDate.getDate(),
                day: daysOfWeek[currentDate.getDay()],
                fullDate: currentDate.toISOString().split('T')[0] // YYYY-MM-DD 형식
            });
            currentDate.setDate(currentDate.getDate() + 1);
        }

        return days;
    }

    function getCurrentWeekdays(year = new Date().getFullYear(), month = new Date().getMonth() + 1, day = new Date().getDate()) {
        const daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
        const currentDate = new Date(year, month - 1, day);
        const currentDay = currentDate.getDay();
        const currentMonday = new Date(currentDate);

        // Calculate the date of the current week's Monday
        if (currentDay === 0) {
            currentMonday.setDate(currentDate.getDate() - 6);
        } else {
            currentMonday.setDate(currentDate.getDate() - currentDay + 1);
        }

        const weekdays = [];
        for (let i = 0; i < 5; i++) { // Monday to Friday
            const date = new Date(currentMonday);
            date.setDate(currentMonday.getDate() + i);
            weekdays.push({ date: date.getDate(), day: daysOfWeek[date.getDay()] });
        }

        return weekdays;
    }


    function drawCalendar(days) {
        const calendarObjects = days.map(dayInfo => {
            return {
                date: dayInfo.date,
                day: dayInfo.day,
                class: (dayInfo.day === '토' || dayInfo.day === '일') ? 'day red' : 'day'
            };
        });

        // 캘린더 전체(근무조 개수만큼 캘린더 존재함)
        const $calendars = $('[id^="calendar"]');

        // 각 캘린더 요소에 대해 처리
        $calendars.each(function() {
            const $calendar = $(this);
            $calendar.empty();

            calendarObjects.forEach(obj => {
                const col = $('<div>').addClass('col');
                const dateP = $('<p>').addClass('date').text(obj.date);
                const dayP = $('<p>').addClass(obj.class).text(obj.day);

                col.append(dateP).append(dayP);
                $calendar.append(col);
            });
        });
    }

    async function drawTableBody() {
    	setTimeout(setFixTableWidth, 100);

        try {
            progressBar(true);

            let sdate = '', edate = '';
            if(calType === 'period') {
                sdate = $('#sdate').val().replace(/-/gi,"");
                edate = $('#edate').val().replace(/-/gi,"");
            } else {
                let year = $("#year").text().trim();
                let month = $("#month").text().trim();
                if (month.length === 1) {
                    month = '0' + month;
                }
                sdate = year + month + '01';
                edate = year + month + new Date(year, month, 0).getDate();

                $('#sdate').val(formatDate(sdate, '-'));
                $('#edate').val(formatDate(edate, '-'));
            }

            const param = "&workClassCd=" + '${selectedWorkClassCd}'
                + "&checkYN=Y"
                + "&sdate=" + sdate
                + "&edate=" + edate
                + "&searchSabunName=" + $('#searchSabunName').val();
            const response = await fetch("/WtmWorkTypeMgr.do?cmd=getWorkClassSchDetailList", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: param
            });

            const resData = await response.json()
            const empList = resData.DATA;
            const schHours = resData.HOURS;

            $("#empCnt").html(empList.length);

            const rowsData = [];
            empList.forEach(emp => {
                const empData = {
                    workGroupCd: emp.workGroupCd,
                    workGroupNm: emp.workGroupNm,
                    workGroupCnt: emp.cnt,
                    imgSrc: '/EmpPhotoOut.do?enterCd=' + emp.enterCd + '&searchKeyword=' + emp.sabun,
                    sabun: emp.sabun,
                    name: emp.name,
                    position: emp.jikweeNm,
                    team: emp.orgNm,
                    schedule: emp.schedule,
                    holiday: emp.holiday,
                    attend: emp.attend,
                    sdate: emp.sdate,
                    edate: emp.edate,
                }
                rowsData.push(empData);
            });

            const $fixTable = $('#fixTable');
            let workGroupCd = '';
            $fixTable.empty();
            rowsData.forEach(rowData => {
                if(workGroupCd !== rowData.workGroupCd) {
                    workGroupCd = rowData.workGroupCd
                    $fixTable.append(createHeader(rowData))
                    drawCalendar(getDaysInRange(sdate, edate))
                }
                $fixTable.append(createRow(rowData, schHours));
            });

            setFixTableWidth();
            addCloseIconEvent();
        } catch (error) {
            console.error('조회 중 오류 발생:', error);
            alert('조회 중 오류가 발생했습니다.');
        } finally {
            progressBar(false);
        }
    }
</script>
<body class="iframe_content white attendanceNew">
<h2 class="title-wrap">
    <div class="inner-wrap">
        <span class="icon-wrap"><i class="mdi-ico">checklist</i></span>
        <span class="page-title">근무스케줄 상세설정</span>
    </div>
</h2>
<div id="divDrag" class="drag-item-wrap wide">
    <div>
        <p class="desc"><span class="req"></span>항목을 드래그하여 근무를 상세 설정 해주세요.</p>
        <div class="chip-wrap" id="schChip">
            <div class="divider"></div>
        </div>
    </div>
    <div class="search-inner">
        <div class="search_input d-flex ml-auto">
            <input class="form-input" type="text" id="searchSabunName" name="searchSabunName" placeholder="사번/성명을 입력하세요"/>
            <a type="button" class="btn-search" href="javascript:drawTableBody();" >
                <i class="mdi-ico">search</i>
            </a>
        </div>
        <div class="btn-wrap">
            <button type="button" id="goSetBtn" class="btn outline">교대설정</button>
            <button type="button" id="saveBtn" class="btn outline_gray">임시저장</button>
            <button type="button" id="applyBtn" class="btn filled">스케줄 반영</button>
        </div>
    </div>
</div>
<div class="attendance-calendar schedule">
    <div class="calendar-head">
        <div class="toggle-tab-wrap">
            <ul class="toggle-tab">
                <li class="tab-slider active" rel="monthly">월간</li>
                <li class="tab-slider" rel="period">기간</li>
            </ul>
        </div>
        <div id="periodTabOptDiv" style="display: none;">
            <input id="sdate" name="sdate" type="text" size="10" class="date2 readonly" value="${curSysYyyyMMdd}" readonly/> ~
            <input id="edate" name="edate" type="text" size="10" class="date2 readonly" readonly/>
        </div>
        <div id="yearWrapDiv" class="year-wrap">
            <button><i class="mdi-ico" id="preMonth">chevron_left</i></button>
            <span class="year" id="year">${curSysYear}</span>
            <span class="unit">년</span>
            <span class="year ml-0" id="month">${curSysMon}</span>
            <span class="unit">월</span>
            <button><i class="mdi-ico" id="nextMonth">chevron_right</i></button>
            <a href="#" class="thisMonth">이번달</a>
        </div>
        <div class="chk-wrap">
            <input type="checkbox" class="form-checkbox type2" id="checkbox1"/>
            <label for="checkbox1">조원에게 같은 스케줄 적용</label>
        </div>
    </div>
    <form name="workClassSchDetailForm" id="workClassSchDetailForm">
    <div class="fixTable_outer_wrap">
	    <div class="fixTable_wrap" id="fixTable" style="height: calc(100vh - 200px)">
	        <!-- 헤더 영역 -->
	        <div class="fixTable_header">
	            <div class="th_row">
	                <!-- 헤더 / 좌 영역 -->
	                <div class="fixTable_th type_fix">
	                    <p class="team"></p>
	                    <p class="unit"><span class="cnt" id="empCnt"></span><span>명</span></p>
	                </div>
	                <!-- //헤더 / 좌 영역 -->
	
	                <!-- 헤더 / 우 영역 -->
	                <div class="fixTable_th type_move" id="calendar"></div>
	                <!-- //헤더 / 우 영역 -->
	            </div>
	
	        </div>
	        <!-- //헤더 영역 -->
	
	        <!-- 바디 영역 -->
	        <div class="fixTable_body" id="tableBody"></div>
	        <!-- //바디 영역 -->
	    </div>
	</div>
    </form>
</div>
<script>
    // 월간/기간 Button
    $(".toggle-tab-wrap .toggle-tab li").click(function () {
        if ($(this).attr("rel") == "period") {
            $('.toggle-tab-wrap').addClass('slide');
            $('#periodTabOptDiv').show();
            $('#yearWrapDiv').hide();
            calType = 'period';
        } else {
            $('.toggle-tab-wrap').removeClass('slide');
            $('#periodTabOptDiv').hide();
            $('#yearWrapDiv').show();
            calType = 'monthly';
        }
        $(".toggle-tab-wrap .toggle-tab li").removeClass("active");
        $(this).addClass("active");

        drawTableBody();
    });

    // 달력 헤더 생성
    function createHeader(rowData) {
        const workGroupCd = rowData.workGroupCd
        const workGroupNm = rowData.workGroupNm
        const workGroupCnt = rowData.workGroupCnt

        const $fixTable_header = $('<div class="fixTable_header">');
        const $th_row = $('<div class="th_row">');
        $fixTable_header.append($th_row);

        const $fixTable_th_group = $('<div class="fixTable_th type_fix">');
        $th_row.append($fixTable_th_group);

        const $team = $('<p class="team">'+workGroupNm+'</p>')
        const $unit = $('<p class="unit"><span class="cnt" id="empCnt"></span>'+workGroupCnt+'<span>명</span></p>')
        $fixTable_th_group.append($team);
        $fixTable_th_group.append($unit);

        const fixTable_th_cal = $('<div class="fixTable_th type_move" id="calendar'+workGroupCd+'"></div>')
        $th_row.append(fixTable_th_cal)
        return $fixTable_header;
    }

    function createRow(rowData, schHours) {

        const $fixTable_body = $('<div class="fixTable_body '+rowData.workGroupCd+'_body" id="tableBody"></div>');
        const $row = $('<div class="row"></div>');
        const $fixTableTd = $('<div class="fixTable_td type_fix" data-id="' + rowData.sabun + '"></div>');
        const $imgWrap = $('<div class="img-wrap"></div>');
        const $img = $('<img src="'+rowData.imgSrc+'" alt="">');
        $imgWrap.append($img)

        const $infoWrap = $('<div class="info-wrap"></div>');
        const $info = $('<div class="info"></div>');
        const $nameSpan = $('<span class="name">'+rowData.name+'</span>');
        const $positionSpan = $('<span class="position">'+rowData.position+'</span>');

        $info.append($nameSpan);
        $info.append($positionSpan);

        const $teamDiv = $('<div class="team">'+rowData.team+'</div>');
        $infoWrap.append($info);
        $infoWrap.append($teamDiv);

        $fixTableTd.append($imgWrap);
        $fixTableTd.append($infoWrap);

        const $moveTableTd = $('<div class="fixTable_td type_move"></div>');

        // 총 근무시간 계산
        let totWorkMin = 0;

        // 근무 스케줄
        const schedules = rowData.schedule;
        const sdate = makeDateFormat($("#sdate").val().replace(/-/gi,""));
        const edate = makeDateFormat($("#edate").val().replace(/-/gi,""));
        for (let date = sdate; date <= edate; date.setDate(date.getDate() + 1)) {
            const ymd = dateFormatToString(date);

            // ymd 와 일치하는 근무 스케줄이 있는지 검사.
            const filterSch = schedules.filter(schedule =>
                ymd === schedule.ymd
            );
            if (filterSch.length > 0) {
                const schedule = filterSch[0];
                const $col = $('<div class="col" ondrop="drop(event)" ondragover="allowDrop(event)" data-ymd="'+schedule.ymd+'" data-sabun="'+rowData.sabun+'" ></div>');
                const $attendChip = $('<div class="attend-chip sch '+schedule.color+'" id="chip'+Date.now()+'"></div>');
                const $textSpan = $('<span class="text">'+schedule.workSchSrtNm+'</span>');
                const $deleteIcon = $('<i class="mdi-ico">delete</i>');
                const $inputWorkClassCd = $('<input type="hidden" name="workClassCd" value="${selectedWorkClassCd}"/>');
                const $inputWorkSchCd = $('<input type="hidden" name="workSchCd" value="'+schedule.workSchCd+'"/>');
                const $inputSabun = $('<input type="hidden" name="sabun" value="'+rowData.sabun+'"/>');
                const $inputYmd = $('<input type="hidden" name="ymd" value="'+schedule.ymd+'"/>');
                const $inputWrkDtlId = $('<input type="hidden" name="wrkDtlId" value="'+schedule.wrkDtlId+'"/>');
                const $inputPostYn = $('<input type="hidden" name="postYn" value="'+schedule.postYn+'"/>');

                $attendChip.append($textSpan);
                $attendChip.append($deleteIcon);
                $attendChip.append($inputWorkClassCd);
                $attendChip.append($inputWorkSchCd);
                $attendChip.append($inputSabun);
                $attendChip.append($inputYmd);
                $attendChip.append($inputWrkDtlId);
                $attendChip.append($inputPostYn);

                $col.append($attendChip);
                $moveTableTd.append($col);

                // 스케줄 근무시간, 휴게시간 값으로 총 근무시간 계산
                // ymd 일자에 속하는 근무 유형이 있는지 검사.
                const schInfo = schHours.filter(schHour =>
                    schedule.workSchCd === schHour.workSchCd
                );

                if (schInfo.length > 0) {
                    // 총 근무시간 = 근무시간 - 휴게시간
                    totWorkMin += schInfo[0].workHours - schInfo[0].breakHours;
                }
            } else {
                const sdate = rowData.sdate;
                const edate = rowData.edate;
                let $col = '';
                if(ymd >= sdate && ymd <= edate) {
                    $col = $('<div class="col" ondrop="drop(event)" ondragover="allowDrop(event)" data-ymd="'+ymd+'" data-sabun="'+rowData.sabun+'" ></div>');
                } else {
                    $col = $('<div class="col noShift" style="background-color: #e3e3e3;" ondrop="drop(event)" data-ymd="'+ymd+'" data-sabun="'+rowData.sabun+'" ></div>');
                }
                $moveTableTd.append($col)
            }
        }
        let totTimeStr = (totWorkMin/60)+'시간';
        if(totWorkMin%60 > 0) totTimeStr += ' ' + (totWorkMin%60) + '분';

        const $timeChipSpan = $('<span class="time-chip ml-auto">' + totTimeStr + '</span>');
        $info.append($timeChipSpan);

        $row.append($fixTableTd);
        $row.append($moveTableTd);

        $fixTable_body.append($row)

        // 공휴일
        // const holidays = rowData.holiday;
        // holidays.forEach(function(holiday) {
        //     const $holidayChip = $('<div class="attend-chip day"></div>');
        //     const $textSpan = $('<span class="text">'+holiday.holidayNm+'</span>');
        //     $holidayChip.append($textSpan);
        //
        //     const $col = $row.find('[data-ymd="'+holiday.ymd+'"]')
        //     $col.append($holidayChip);
        //
        //     if(holiday.rpYmd !== '') {
        //         const $col = $row.find('[data-ymd="'+holiday.rpYmd+'"]')
        //         $col.append($holidayChip);
        //     }
        // })

        // 근태
        const attends = rowData.attend;
        attends.forEach(function(attend) {
            const attendChip = $('<div class="attend-chip day"></div>');
            const $textSpan = $('<span class="text">'+attend.gntShortNm+'</span>');
            attendChip.append($textSpan);

            const $col = $row.find('[data-ymd="'+attend.ymd+'"]')
            $col.append(attendChip);

        })

        return $fixTable_body;
    }

    /* function setFixTableWidth() {
        var th_boxWidth = $(".fixTable_header .type_fix").outerWidth();
        var td_boxWidth = $(".fixTable_body .type_move").outerWidth();
        $('.fixTable_body .row').width(th_boxWidth + td_boxWidth + 'px');
        $('.fixTable_header .th_row').width(th_boxWidth + td_boxWidth + 'px');
    }*/
    
    /* function setFixTableWidth() {
        var th_boxWidth = $(".fixTable_header .type_fix").outerWidth();
        var totalColWidth = 0;

        $(".fixTable_header .fixTable_th.type_move .col").each(function () {
            totalColWidth += $(this).outerWidth(false);
        });

        var totalWidth = th_boxWidth + totalColWidth;
        $('.fixTable_body .row').width(totalWidth + 'px');
        $('.fixTable_header .th_row').width(totalWidth + 'px');
    } */

    function setFixTableWidth() {
        var th_boxWidth = $(".fixTable_header .type_fix").outerWidth(); // 고정 영역 너비

        // 첫 번째 row의 col만 계산
        var colCount = $(".fixTable_body .row").first().find(".col").length;
        var singleColWidth = 98; // 셀 너비 (CSS 고정값)

        var totalColWidth = colCount * singleColWidth;
        var totalWidth = th_boxWidth + totalColWidth;

        // 계산된 width 적용
        $('.fixTable_body .row').width(totalWidth + 'px');
        $('.fixTable_header .th_row').width(totalWidth + 'px');
    }
    
    // fixed Table script
    // 틀고정 좌우 스크롤 너비값 계산 식
    $(document).ready(function () {
        setFixTableWidth();
    });

    // ie 대응 스크롤
    var agent = navigator.userAgent.toLowerCase();

    // ie 브라우저 타겟팅
    if (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1 || (agent.indexOf("msie") != -1)) {
        $('.fixTable_wrap').addClass('ie');
    }

    const container = document.querySelector('.fixTable_body'); //부모 박스
    const fixBox = document.querySelector('.type_fix'); // 고정 박스

    container.addEventListener('scroll', function () {
        var scrollnum = container.scrollLeft + 'px'; //스크롤 위치값 px값으로 가져오기

        if (container.scrollLeft != 0) {
            $('.fixTable_body .type_fix').css({"transform": 'translateX' + '(' + scrollnum + ')'}); // 스크롤이 위치값이 0이 아닐때 transform 값 변경
            $('.fixTable_th.type_move').css({"transform": 'translateX' + '(-' + scrollnum + ')'});
        } else {
            $('.fixTable_body .type_fix').css("transform", "translateX(0)");
            $('.fixTable_th.type_move').css("transform", "translateX(0)");
        }
    })

    // drag and drop
    function allowDrop(ev) {
        ev.preventDefault();
    }

    function drag(ev) {
        ev.dataTransfer.setData("text", ev.target.id);
    }

    function removeNode(node) {
        const scheduleId = node.getAttribute('data-id'); // Get the schedule ID
        const colIndex = Array.from(node.parentNode.parentNode.children).indexOf(node.parentNode); // Find the column index of the node
        const groupNode = $(node).closest('.fixTable_body')
        const groupClass = '.'+groupNode.attr('class').replace(/ /gi, ".")
        const allRows = $(groupClass);

        // '조원에게 같은 스케줄 적용'의 경우 같은 날짜 같은 스케줄 삭제
        if ($('#checkbox1').is(':checked')) {
            allRows.each(function() {
                const targetCol = $(this).find('.col').eq(colIndex);
                if (targetCol && targetCol.length > 0) {
                    targetCol.empty();
                }
            });
        } else {
            node.parentNode.removeChild(node);
        }
    }

    function drop(ev) {
        ev.preventDefault();
        // Ensure the drop target is a .col element
        if (!ev.target.classList.contains('col')) {
            return;
        }

        var data = ev.dataTransfer.getData("text");

        const $nodeCopy = $("#" + data).clone(true);
        $nodeCopy.attr("id", "chip" + new Date().getTime()) // 고유한 ID 생성
        $nodeCopy.find('input').remove();
        // var nodeCopy = document.getElementById(data).cloneNode(true);
        // nodeCopy.id = "chip" + new Date().getTime();

        // 스케줄 정보 설정
        const workSchCd = $('#'+data).data('id')
        const ymd = $(ev.target).data('ymd');
        const sabun = $(ev.target).data('sabun');
        const $inputWorkClassCd = $('<input type="hidden" name="workClassCd" value="${selectedWorkClassCd}"/>');
        const $inputWorkSchCd = $('<input type="hidden" name="workSchCd" value="'+workSchCd+'"/>');
        const $inputSabun = $('<input type="hidden" name="sabun" value="'+sabun+'"/>');
        const $inputYmd = $('<input type="hidden" name="ymd" value="'+ymd+'"/>');
        const $inputWrkDtlId = $('<input type="hidden" name="wrkDtlId" value=""/>');
        const $inputPostYn = $('<input type="hidden" name="postYn" value="N"/>');

        $nodeCopy.append($inputWorkClassCd)
        $nodeCopy.append($inputWorkSchCd)
        $nodeCopy.append($inputSabun)
        $nodeCopy.append($inputYmd)
        $nodeCopy.append($inputWrkDtlId);
        $nodeCopy.append($inputPostYn);

        // 기존 스케줄 삭제 후 새로 입력한 스케줄 삽입
        $(ev.target).empty();
        $(ev.target).append($nodeCopy);

        // 조원에게 같은 스케줄 적용 check 되어있을 때
        if ($('#checkbox1').is(':checked')) {
            const colIndex = $(ev.target).index();
            const groupNode = $(ev.target).closest('.fixTable_body')
            const groupClass = '.'+groupNode.attr('class').replace(/ /gi, ".")
            const allRows = $(groupClass);

            allRows.each(function() {
                const targetCol = $(this).find('.col').eq(colIndex);
                if (targetCol.length && !targetCol.has($nodeCopy).length) {
                    // 기존 스케줄 삭제 후 새로 입력한 스케줄 삽입
                    targetCol.empty();
                    const $additionalNodeCopy = $($nodeCopy).clone(true);
                    $additionalNodeCopy.attr('id', 'chip' + new Date().getTime());
                    $additionalNodeCopy.find('input[name="sabun"]').val(targetCol.data('sabun'))
                    targetCol.append($additionalNodeCopy);
                }
            });
        }

        // checkAndAddNewDropZone();
        addCloseIconEvent();
        ev.stopPropagation();
        return false;
    }

    function dragEnter(ev) {
        if (ev.target.classList.contains('col')) {
            ev.target.classList.add('drag-over');
        }
    }

    function dragLeave(ev) {
        if (ev.target.classList.contains('col')) {
            ev.target.classList.remove('drag-over');
        }
    }

    function addCloseIconEvent() {
        document.querySelectorAll('.mdi-ico').forEach(icon => {
            icon.removeEventListener('click', handleIconClick);
            icon.addEventListener('click', handleIconClick);
        });
    }

    function handleIconClick(ev) {
        ev.stopPropagation();
        const chip = ev.target.closest('.attend-chip');
        if (chip) {
            removeNode(chip);
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        addCloseIconEvent();

        document.querySelectorAll('.col:not(.noShift)').forEach(col => {
            col.addEventListener('dragenter', dragEnter);
            col.addEventListener('dragleave', dragLeave);
        });
    });
</script>
</body>
</html>