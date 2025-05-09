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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.11/jquery.lazy.min.js"></script>

    <script type="text/javascript">
        var calType = 'monthly';
        $(document).ready(function () {
            // drawChips();
            // drawTableBody();

            initEvent();
            setSearchWorkClassCd()
            setSearchWorkGroupCd()
            search()

            //스크롤시 이미지 lazy 적용
            $('#fixTable_outer_wrap').on('scroll', function() {
                imgLazy();
            });
        });

        function search() {
            drawChips()
            drawTableBody()
            imgLazy();
        }

        function imgLazy(){
            $('.fixTable_outer_wrap .lazy:not(.lazy-loaded)').lazy({
                scrollContainer: '.fixTable_outer_wrap',
                effect: "fadeIn",
            });
        }
        /*async function drawChips() {
            const data = await callFetch("/WtmShiftSchMgr.do?cmd=getWorkScheduleList", "workClassCd=" + $("#searchWorkClassCd").val());
            if (data == null || data.isError) {
                if (data && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return;
            }
            const scheduleList = data.DATA;

            const $schChip = $("#schChip");
            $schChip.empty();
            for (let i = 0; i < scheduleList.length; i++) {
                const schedule = scheduleList[i];
                const chipHtml = `<div class="attend-chip sch ${'${schedule.color}'}" draggable="true" id="divDrag${'${(i + 2)}'}" data-id="${'${schedule.workSchCd}'}">
                                  <span class="text ellipsis">${'${schedule.workSchSrtNm}'}</span>
                                  <i class="mdi-ico">delete</i>
                              </div>`;
                $schChip.append(chipHtml);
                const $last = $schChip.children().last();
                $last.on("dragstart", function(e) {
                    drag(e);
                })
            }
            const dividerHtml = `<div class="divider"></div>`;
            $schChip.append(dividerHtml);
        }*/

        async function drawChips() {

            const getChipHtml = () => {
                return `<div class="attend-chip sch" draggable="true" data-id="">
                            <span class="text ellipsis"></span>
                            <i class="mdi-ico">delete</i>
                        </div>`;
            }

            const data = await callFetch(
                "/WtmShiftSchMgr.do?cmd=getWorkScheduleList",
                "workClassCd=" + $("#searchWorkClassCd").val()
            );
            if (!data || data.isError) {
                alert(data?.errMsg || "알 수 없는 오류가 발생하였습니다.");
                return;
            }
            const scheduleList = data.DATA;
            const $schChip      = $("#schChip").empty();
            const dividerHtml   = '<div class="divider"></div>';
            const maxVisible    = 10;

            // chip 추가 함수
            function appendChip(schedule, index) {
                const chipHtml = getChipHtml();
                $schChip.append(chipHtml);
                const $last = $schChip.children().last();
                $last.addClass(schedule.color);
                $last.attr("id", "divDrag" + (index+2));
                $last.data("id", schedule.workSchCd);
                $last.find(".text").text(schedule.workSchSrtNm);
                $last.on("dragstart", function(e) {
                    drag(e);
                })
            }

            // 1) 전체가 maxVisible 이하라면: 전부 그리고 divider
            if (scheduleList.length <= maxVisible) {
                scheduleList.forEach(appendChip);
                $schChip.append(dividerHtml);
                return;
            }

            // 2) 5개만 그리고
            scheduleList.slice(0, maxVisible).forEach(appendChip);

            // 3) divider 추가
            $schChip.append(dividerHtml);

            // 4) 더보기 버튼 추가
            const remaining = scheduleList.length - maxVisible;
            const moreBtnHtml = `<button class="attend-chip more">+${'${remaining}'} 더보기<i class="mdi-ico">expand_more</i></button>`;
            $schChip.append(moreBtnHtml);

            function scheduleMorePopup(e) {
                e.preventDefault();

                const totalChips    = $('.att-type-list li').length;
                const visibleCount  = 10;
                const remaining     = Math.max(0, totalChips - visibleCount);

                const addChips = function(result) {
                    const $schChip = $("#schChip");
                    const $chipMore = $schChip.find('.attend-chip.more');
                    if (!$chipMore.prev().hasClass("divider")) {
                        $chipMore.prev().remove();
                    }
                    $chipMore.before(getChipHtml());
                    const $prev = $chipMore.prev();
                    $prev.addClass(result.color);
                    $prev.attr("id", "divDrag" + (totalChips+1));
                    $prev.data("id", result.workSchCd);
                    $prev.find(".text").text(result.workSchSrtNm);
                    $prev.on("dragstart", function(e) {
                        drag(e);
                    })
                }

                const popupUrl = '/WtmShiftSchMgr.do?cmd=viewWtmShiftSchMgrChipLayer';
                let layerModal = new window.top.document.LayerModal({
                    id         : 'wtmShiftSchMgrChipLayer',
                    url        : popupUrl,
                    parameters : {
                        chips: Array.from($("#schChip .attend-chip.sch")).map(chip => {
                            const workSchCd = $(chip).data("id");
                            const workSchNm = $(chip).find(".text").text();
                            return { "workSchCd": workSchCd, "workSchNm": workSchNm };
                        }),
                        workClassCd: $("#searchWorkClassCd").val()
                    },
                    width      : 600,
                    height     : 586,
                    title      : '개인근무유형상세'
                    , trigger :[
                        {
                            name : 'wtmShiftSchMgrChipLayerTrigger'
                            , callback : addChips
                        }
                    ]
                });
                layerModal.show();
            }
            // 5) 더보기 클릭 시 모달 띄우기
            $schChip.find('.attend-chip.more').on('click', scheduleMorePopup);
        }

        function initEvent() {
            // 월간/기간 Radio 버튼
            $(".form-radio").change(function () {
                // 선택된 radio 버튼의 value 값에 따라 동작
                if ($(this).val() == "period") {
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

                // 선택된 radio 버튼에 따라 tab active 변경
                $(".form-radio").each(function () {
                    $(this).siblings('label').removeClass("active"); // 기존 active 제거
                });
                $(this).siblings('label').addClass("active"); // 선택된 라벨에 active 클래스 추가

                drawTableBody();
            });

            // 교대조, 근무조 설정
            $("#searchWorkClassCd").on('change', setSearchWorkGroupCd)

            // 기간 입력 input box
            $("#sdate").datepicker2({
                startdate:"edate",
                onReturn: setSearchWorkClassCd
            });

            $("#edate").datepicker2({
                enddate:"sdate",
                onReturn: setSearchWorkClassCd
            });

            const today = new Date();
            const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
            $("#edate").val(dateFormatToString(lastDay, '-'))

            // 임시저장 버튼 클릭 이벤트
            $("#saveBtn").on('click', async function () {
                try {
                    progressBar(true, '저장중입니다.');
                    const schedules = getTemporarySavedSchedules();
                    if (schedules.length === 0) {
                        alert("임시저장할 변경된 스케줄이 없습니다.");
                        return;
                    }

                    const sdate = $('#sdate').val().replace(/-/gi,"");
                    const edate = $('#edate').val().replace(/-/gi,"");


                    // 저장 처리
                    const param = {"schedules": schedules, "sdate": sdate, "edate": edate, "workClassCd": $("#searchWorkClassCd").val()};
                    const result = await callFetch("/WtmShiftSchMgr.do?cmd=saveWorkClassSchDetail", param);
                    if (result && result.isError) {
                        alert(result.errMsg);
                    } else if (!result) {
                        alert("알 수 없는 오류가 발생하였습니다.");
                    }

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

                    const schedules = getNotPostedSchedules();
                    if (schedules.length === 0) {
                        alert("스케줄 반영 가능한 임시저장된 스케줄이 없습니다.");
                        return;
                    }

                    const sdate = $('#sdate').val().replace(/-/gi,"");
                    const edate = $('#edate').val().replace(/-/gi,"");

                    const param = "&workClassCd=" + $("#searchWorkClassCd").val()
                        + "&sdate=" + sdate
                        + "&edate=" + edate
                        + "&searchSabunName=" + $('#searchSabunName').val();

                    // 저장 처리
                    const result = await callFetch("/WtmShiftSchMgr.do?cmd=saveWorkClassSchDetailApply", param);
                    if (result == null || result.isError) {
                        if (result && result.errMsg) alert(result.errMsg);
                        else alert("알 수 없는 오류가 발생하였습니다.");
                        return;
                    }

                    if (result.Message)
                        alert(result.Message);

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


                const param = "&workClassCd=" + $("#searchWorkClassCd").val()
                    + "&checkYN=Y"
                    + "&sdate=" + sdate
                    + "&edate=" + edate
                    + "&searchSabunName=" + $('#searchSabunName').val();
                const resData = await callFetch("/WtmShiftSchMgr.do?cmd=getWorkClassSchDetailList", param);
                if (!resData || resData.isError) {
                    if (!resData) alert("알 수 없는 오류가 발생하였습니다.");
                    else alert(resData.errMsg);
                    return;
                }

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

        function setSearchWorkClassCd() {
            const param = "&searchSdate="+$("#sdate").val()
                +"&searchEdate="+$("#edate").val()
                +"&searchWorkTypeCd=D"
                +"&searchUseYn=Y"
            const workClassCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWtmWorkClassCdComboList"+param,false).codeList, "");
            $("#searchWorkClassCd").html(workClassCdList[2]);
        }

        function setSearchWorkGroupCd() {
            const param = "&searchWorkClassCd="+$("#searchWorkClassCd").val()
            const workGroupCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWtmWorkGroupCdComboList"+param,false).codeList, "전체");
            $("#searchWorkGroupCd").html(workGroupCdList[2]);
        }

        function getTemporarySavedSchedules() {
            return $('#workClassSchDetailForm [id^="chip"]').map(function () {
                if ($(this).find('input[name="wrkDtlId"]').val() === '') { // 임시저장 중인 데이터
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
        }

        function getNotPostedSchedules() {
            return $('#workClassSchDetailForm [id^="chip"]').map(function() {
                if($(this).find('input[name="postYn"]').val() === 'N'){ // 반영 전인 데이터
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
        }
    </script>
<body class="iframe_content white attendanceNew pa-0">
<form name="workClassSchDetailForm" id="workClassSchDetailForm">
    <div class="typeDetail-content">
        <div class="setting-wrap pa-0">
            <h2 class="title-wrap">
                <div class="inner-wrap">
                    <span class="icon-wrap"><i class="mdi-ico">checklist</i></span>
                    <span class="page-title">근무스케줄 상세설정</span>
                </div>
            </h2>

            <div class="table-wrap mt-2 table-responsive">
                <table class="basic type5 line-grey">
                    <colgroup>
                        <col width="10%">
                        <col width="*%">
                        <col width="10%">
                        <col width="20%">
                        <col width="10%">
                        <col width="25%">
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>기간구분</th>
                        <td>
                            <div class="input-wrap">
                                <span class="radio-wrap">
                                    <input type="radio" id="monthly" name="periodType" value="monthly" class="form-radio" checked>
                                    <label for="monthly">월간</label>
                                </span>
                                <span class="radio-wrap">
                                    <input type="radio" id="period" name="periodType" value="period" class="form-radio">
                                    <label for="period">기간</label>
                                </span>
                            </div>
                            <div id="periodTabOptDiv" style="display: none;">
                                <input id="sdate" name="sdate" type="text" size="10" class="date2 readonly" value="${curSysYyyyMMdd}" readonly/> ~
                                <input id="edate" name="edate" type="text" size="10" class="date2 readonly" readonly/>
                            </div>
                        </td>
                        <th>근무유형</th>
                        <td>
                            <select id="searchWorkClassCd" name="searchWorkClassCd" class="custom_select" ></select>
                        </td>
                        <%--                        <th>근무조</th>--%>
                        <%--                        <td>--%>
                        <%--                            <div class="d-flex wid-100">--%>
                        <%--                                <select id="searchWorkGroupCd" name="searchWorkGroupCd" class="custom_select"></select>--%>
                        <%--                            </div>--%>
                        <%--                        </td>--%>
                        <th>사번/성명</th>
                        <td>
                            <div class="input-wrap w-100">
                                <div class="input-wrap">
                                    <input id="searchSabunName" name="searchSabunName" class="form-input" type="text" placeholder="사번 또는 성명 입력">
                                </div>
                                <button type="button" onClick="javascript:search()" class="btn dark ml-auto">조회</button>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div id="divDrag" class="drag-item-wrap wide">
                <div>
                    <p class="desc"><span class="req"></span>항목을 드래그하여 세부 설정 해주세요.</p>
                    <div class="chip-wrap" id="schChip">
                        <div class="divider"></div>
                    </div>
                </div>
                <div class="search-inner">
                    <div class="ml-auto btn-wrap">
                        <button type="button" id="saveBtn" class="btn outline_gray">임시저장</button>
                        <button type="button" id="applyBtn" class="btn filled">스케줄 반영</button>
                    </div>
                </div>
            </div>
            <div class="attendance-calendar schedule">
                <div class="calendar-head">
                    <div id="yearWrapDiv" class="year-wrap">
                        <button type="button"><i class="mdi-ico" id="preMonth">chevron_left</i></button>
                        <span class="year" id="year">${curSysYear}</span>
                        <span class="unit">년</span>
                        <span class="year ml-0" id="month">${curSysMon}</span>
                        <span class="unit">월</span>
                        <button type="button"><i class="mdi-ico" id="nextMonth">chevron_right</i></button>
                        <a class="thisMonth">이번달</a>
                    </div>
                    <div class="chk-wrap">
                        <input type="checkbox" class="form-checkbox type2" id="checkbox1"/>
                        <label for="checkbox1">조원에게 같은 스케줄 적용</label>
                    </div>
                </div>

                <div class="fixTable_outer_wrap" style="overflow-y: auto">
                    <div class="fixTable_wrap" id="fixTable" style="height: calc(100vh - 244px)">
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
            </div>
        </div>
    </div>
</form>
<script>
    // 월간/기간 Button
    // $(".toggle-tab-wrap .toggle-tab li").click(function () {
    //     if ($(this).attr("rel") == "period") {
    //         $('.toggle-tab-wrap').addClass('slide');
    //         $('#periodTabOptDiv').show();
    //         $('#yearWrapDiv').hide();
    //         calType = 'period';
    //     } else {
    //         $('.toggle-tab-wrap').removeClass('slide');
    //         $('#periodTabOptDiv').hide();
    //         $('#yearWrapDiv').show();
    //         calType = 'monthly';
    //     }
    //     $(".toggle-tab-wrap .toggle-tab li").removeClass("active");
    //     $(this).addClass("active");
    //
    //     drawTableBody();
    // });

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

        const $infoRow2 = `<div class="info">
                                 <div class="team">${'${rowData.team}'}</div>
                             </div>`;
        $infoWrap.append($info);
        $infoWrap.append($infoRow2);

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
                const $col = $(`<div class="col" data-ymd="${'${ymd}'}" ></div>`);

                for (const schedule of filterSch) {
                    const html = `<div class="attend-chip sch ${'${schedule.color}'}" id="chip${'${Date.now()}'}">
                                      <span class="text">${'${schedule.workSchSrtNm}'}</span>
                                      <i class="mdi-ico">delete</i>
                                      <input type="hidden" name="workClassCd" value="${'${$("#searchWorkClassCd").val()}'}"/>
                                      <input type="hidden" name="workSchCd" value="${'${schedule.workSchCd}'}"/>
                                      <input type="hidden" name="sabun" value="${'${rowData.sabun}'}"/>
                                      <input type="hidden" name="ymd" value="${'${schedule.ymd}'}"/>
                                      <input type="hidden" name="wrkDtlId" value="${'${schedule.wrkDtlId}'}"/>
                                      <input type="hidden" name="postYn" value="${'${schedule.postYn}'}"/>
                                  </div>`;

                    $col.append(html);
                }
                $col.data('schedules', filterSch);

                $col.on("drop", function(e) {
                    drop(e);
                });
                $col.on("dragover", function(e) {
                    allowDrop(e);
                });
                $moveTableTd.append($col);

                // 스케줄 근무시간, 휴게시간 값으로 총 근무시간 계산
                // ymd 일자에 속하는 근무 유형이 있는지 검사.
                const schInfo = schHours.filter(schHour =>
                    filterSch[0].workSchCd === schHour.workSchCd
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
                    $col = $('<div class="col" ondragover="allowDrop(event)" data-ymd="'+ymd+'" data-sabun="'+rowData.sabun+'" ></div>');
                } else {
                    $col = $('<div class="col noShift" style="background-color: #e3e3e3;" data-ymd="'+ymd+'" data-sabun="'+rowData.sabun+'" ></div>');
                }
                $moveTableTd.append($col);
                $moveTableTd.children().last()
                    .on("drop", function(e) { drop(e); });
            }
        }
        let totTimeStr = Math.floor(totWorkMin/60)+'시간';
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
        ev.originalEvent.dataTransfer.setData("text", ev.target.id);
        ev.originalEvent.dataTransfer.setData("workSchCd", ev.target.dataset.id);
    }

    function removeNode(node) {
        const $parent = $(node).parent();

        const scheduleId = node.getAttribute('data-id'); // Get the schedule ID
        const colIndex = Array.from(node.parentNode.parentNode.children).indexOf(node.parentNode); // Find the column index of the node
        const groupNode = $(node).closest('.fixTable_body')
        const groupClass = '.'+groupNode.attr('class').replace(/ /gi, ".")
        const allRows = $(groupClass);

        // '조원에게 같은 스케줄 적용'의 경우 같은 날짜 같은 스케줄 삭제
        if ($('#checkbox1').is(':checked')) {
            allRows.each(function() {
                const targetCol = $(this).find('.col:not(.noShift)').eq(colIndex);
                if (targetCol && targetCol.length > 0) {
                    targetCol.empty();
                }

                const isExistsNotSavedData = targetCol.find(".attend-chip").filter(function(idx, obj) { return $(obj).find("input[name=postYn]").val() === "N" }).length !== 0;
                if (isExistsNotSavedData) {
                    targetCol.css("background-color", "#e4eaf8");
                } else {
                    targetCol.css("background-color", "unset");
                }
            });
        } else {
            node.parentNode.removeChild(node);

            const isExistsNotSavedData = $parent.find(".attend-chip").filter(function(idx, obj) { return $(obj).find("input[name=postYn]").val() === "N" }).length !== 0;
            if (isExistsNotSavedData) {
                $parent.css("background-color", "#e4eaf8");
            } else {
                $parent.css("background-color", "unset");
            }
        }
    }

    function drop(ev) {
        ev.preventDefault();

        const tmpWorkSchCd = ev.originalEvent.dataTransfer.getData("workSchCd");
        const isExistsSameSchedule = $(ev.currentTarget).find(".attend-chip").filter(function(idx, obj) { return $(obj).find("input[name=workSchCd]").val() === tmpWorkSchCd && $(obj).find("input[name=postYn]").val() === "Y" }).length !== 0;
        if (isExistsSameSchedule) {
            alert("이미 동일한 근무스케줄이 등록되어 있습니다.");
            return;
        }

        const data = ev.originalEvent.dataTransfer.getData("text");
        const $nodeCopy = $("#" + data).clone(true);
        $nodeCopy.attr("id", "chip" + new Date().getTime()) // 고유한 ID 생성
        $nodeCopy.find('input').remove();
        $nodeCopy.removeAttr("ondragstart").removeAttr("draggable").removeAttr("data-id");
        // var nodeCopy = document.getElementById(data).cloneNode(true);
        // nodeCopy.id = "chip" + new Date().getTime();

        // 스케줄 정보 설정
        const workSchCd = $('#'+data).data('id');
        const ymd = $(ev.currentTarget).data('ymd');
        const sabun = $(ev.currentTarget).closest(".row").find(".type_fix").data("id");
        const $inputWorkClassCd = $('<input type="hidden" name="workClassCd" value="' + $("#searchWorkClassCd").val() + '"/>');
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
        $(ev.currentTarget).children().filter(function(idx, obj) { return $(obj).find("input[name=postYn]").val() === "N"; }).remove();
        $(ev.currentTarget).append($nodeCopy);
        $(ev.currentTarget).css("background-color", "#e4eaf8");

        // 조원에게 같은 스케줄 적용 check 되어있을 때
        if ($('#checkbox1').is(':checked')) {
            const colIndex = $(ev.currentTarget).index();
            const groupNode = $(ev.currentTarget).closest('.fixTable_body')
            const groupClass = '.'+groupNode.attr('class').replace(/ /gi, ".")
            const allRows = $(groupClass);

            allRows.each(function() {
                const targetCol = $(this).find('.col').eq(colIndex);
                console.log(targetCol, $nodeCopy, targetCol.data('sabun'));
                if (targetCol.length && !targetCol.has($nodeCopy).length && !targetCol.is(".noShift")) {
                    // 기존 스케줄 삭제 후 새로 입력한 스케줄 삽입
                    targetCol.empty();
                    const $additionalNodeCopy = $($nodeCopy).clone(true);
                    $additionalNodeCopy.attr('id', 'chip' + new Date().getTime());
                    $additionalNodeCopy.find('input[name="sabun"]').val(targetCol.closest(".row").find(".type_fix").data("id"));
                    targetCol.append($additionalNodeCopy);
                    targetCol.css("background-color", "#e4eaf8");
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
        $('.attend-chip:not(.more) .mdi-ico')
            .filter(function(idx, obj) {
                return $(obj).text() === "delete";
            })
            .off("click")
            .on("click", function(e) {
                handleIconClick(e);
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