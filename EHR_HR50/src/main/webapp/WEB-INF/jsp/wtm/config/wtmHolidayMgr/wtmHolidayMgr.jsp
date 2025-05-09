<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- bootstrap -->
<link rel="stylesheet" type="text/css" href="/common/plugin/bootstrap/css/bootstrap.min.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!--common-->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>
<script src="/common/plugin/bootstrap/js/bootstrap.min.js"></script>
<script>
    <!-- 개별 화면 script -->
    $(document).ready(async function() {
        progressBar(true);
        await init();
        initHeaderEvent();
        initEvent();
        await renderViews();
        progressBar(false);
    })

    async function init() {

        const currentYear = "${curSysYear}";
        $('#currentYear').text(currentYear);
        $("#searchYear").val(currentYear);
        $('#searchBizPlaceCd').val("all");

        //getYeaBizPlaceCdList
        const bizPlaceCdList = await fetchBizPlaceCd();
        const $tabBottom = $('.tab_bottom');

        bizPlaceCdList.forEach(function (place) {
            const tabItem = $('<li>', {
                class: 'tab_menu',
                text: place.codeNm,
                'data-code': place.code
            });
            $tabBottom.append(tabItem);
        });
    }

    /**
     * 급여사업장 정보 조회
     * @returns {*}
     */
    async function fetchBizPlaceCd() {
        const url = "${ctx}/CommonCode.do?cmd=getCommonNSCodeList";
        const response = await fetch(url, {
            method: "POST",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: "queryId=getYeaBizPlaceCdList"
        });
        return (await response.json()).codeList;
    }

    function initHeaderEvent() {
        $('.tab_menu').off('click');
        $('.tab_menu').on('click', async function() {
            progressBar(true);
            const code = $(this).data('code');
            $('#searchBizPlaceCd').val(code);
            $('.tab_menu').removeClass('active');
            $(this).addClass('active');

            // 상태 목록에서 point-blue 클래스를 업데이트합니다.
            $('.status-holiday li .cnt').removeClass('point-blue');

            $('.status-holiday li[data-code=' + code + '] .cnt').addClass('point-blue');
            const data = await fetchHolidayList();
            drawCard(data);
            progressBar(false);
        });
    }

    function initEvent() {
        let currentYear = $("#currentYear").text();

        function updateYearDisplay() {
            $('#currentYear').text(currentYear);
            $('#searchYear').val(currentYear);
        }

        // 연도 조정 버튼 클릭 이벤트
        $('#chevron_left').on('click', async function() {
            progressBar(true);
            currentYear--;
            updateYearDisplay();
            await renderViews();
            progressBar(false);
        });

        $('#chevron_right').on('click', async function() {
            progressBar(true);
            currentYear++;
            updateYearDisplay();
            await renderViews();
            progressBar(false);
        });
    }

    /**
     * 공통휴일, 사업장별 휴일 수를 설정
     * @returns {Promise<void>}
     */
    async function setHolidayCnt() {
        const data = (await fetchHolidayCnt());

        var $holidayList = $('.status-holiday');
        $holidayList.empty();

        data.forEach(function(holidayCount) {
            var $li = $('<li>').attr('data-code', holidayCount.businessPlaceCd);
            var $label = $('<span>').addClass('label').text(holidayCount.businessPlaceNm);
            var $count = $('<span>').addClass('cnt').text(holidayCount.count);

            $li.append($label).append($count);
            $holidayList.append($li);
        });

        $('.status-holiday li[data-code=' + $("#searchBizPlaceCd").val() + '] .cnt').addClass('point-blue');
    }

    /**
     * 공통휴일, 사업장별 휴일 수를 조회
     * @returns {Promise<any>}
     */
    async function fetchHolidayCnt() {
        const url = "${ctx}/WtmHolidayMgr.do?cmd=getWtmHolidayMgrCnt";
        const response = await fetch(url, {
            method: "POST",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: $("#searchForm").serialize()
        });
        return (await response.json()).DATA;
    }

    /**
     * 공휴일 리스트 조회
     * @returns {*}
     */
    async function fetchHolidayList() {
        const url = "${ctx}/WtmHolidayMgr.do?cmd=getWtmHolidayMgrList";
        const response = await fetch(url, {
            method: "POST",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: $("#searchForm").serialize()
        });
        const json = await response.json();
        if (json.Message) alert(json.Message);
        return json.DATA;
    }

    function drawCard(data) {
        const $container = $('.row.card-wrapper');
        $container.empty();

        for (let i = 1; i <= 12; i++) {
            const month = (i < 10 ? '0' : '') + i; // 2자리 숫자로 변환
            let holidayList = '';
            if (data[month]) {
                data[month].forEach(holiday => {

                    if (holiday.rpYy != null && holiday.rpYy != "") {
                        const dateStr = holiday.rpDd + '일 (' + new Date(holiday.rpYy, holiday.rpMm - 1, holiday.rpDd).toLocaleDateString('ko-KR', { weekday: 'short' }) + ')';

                        holidayList +=
                            `<li data-id="${'${holiday.holidayCd}'}" data-inputGroupId="${'${holiday.inputGroupId}'}">
                                 <div>
                                     <span class="date">${'${dateStr}'}</span>
                                     <span class="title">${'${holiday.holidayNm}'}(대체휴일) </span></div>
                             </li>`;
                    } else {
                        const dateStr = new Date(holiday.yy, holiday.mm - 1, holiday.dd).toLocaleDateString('ko-KR', { weekday: 'short' });
                        holidayList +=
                            `<li data-id="${'${holiday.holidayCd}'}" data-inputGroupId="${'${holiday.inputGroupId}'}">
                                 <div class="com-name ellipsis">${'${holiday.businessPlaceNm}'}</div>
                                 <div class="day-info">
                                     <span class="date">${'${holiday.dd}'}일 (${'${dateStr}'})</span>
                                     <span class="title ellipsis">${'${holiday.holidayNm}'}</span>
                                     <div class="btn-wrap">
                                         <button><i class="mdi-ico update-btn">edit</i></button>
                                         <button><i class="mdi-ico delete-btn">close</i></button>
                                     </div>
                                 </div>
                             </li>`;
                    }
                });
            }

            const monthCard =
                `<div class="col-xl-3 col-lg-4 col-md-6 col-sm-12 card-gutter">
                     <div class="calendar-card">
                         <div class="card-header">${'${i}'} 월<button class="btn outline_gray btn-add">추가</button></div>
                         <div class="card-body">
                             <ol class="schedule-list">
                                 ${'${holidayList}'}
                             </ol>
                         </div>
                     </div>
                 </div>`;
            $container.append(monthCard);
        }

        initCardEvent();
    }

    function initCardEvent() {
        $('.delete-btn').off('click');
        $('.btn-add').off('click');
        $('.update-btn').off('click');

        $('.delete-btn').on('click', function () {
            const $li = $(this).closest('li');
            const holidayId = $li.data('id');
            const inputGroupId = $li.data('inputgroupid');
            openDeleteLayer(holidayId, inputGroupId);
        });

        $('.btn-add').on('click', function () {
            openCreateLayer();
        });

        $('.update-btn').on('click', function () {
            const $li = $(this).closest('li');
            const holidayId = $li.data('id');
            openCreateLayer(holidayId);
        });

        $(".btn-cre").off("click")
            .on("click", function() {
                makeAllHoliday();
            });
    }

    async function renderViews(data) {
        setHolidayCnt();
        if (data)
            drawCard(data);
        else {
            const data = await fetchHolidayList();
            drawCard(data);
        }
    }

    async function openDeleteLayer(holidayId, inputGroupId) {
        const params = {
            searchYear: $("#searchYear").val(),
            searchHolidayCd: holidayId,
            searchBusinessPlaceCd: $("#searchBizPlaceCd").val(),
        };
        const data = await fetchDeleteType(params);
        if (data.soloYn === "Y") {
            const dayNm = $("li[data-id=" + holidayId + "] .day-info span.title").text();
            if (!confirm(dayNm + "을(를) 삭제하시겠습니까?")) return;

            deleteHoliday(holidayId, inputGroupId, 'current');
            return;
        }

        const deleteLayer = new window.top.document.LayerModal({
            id : 'wtmHolidayDeleteLayer',
            url : '/WtmHolidayMgr.do?cmd=viewWtmHolidayDeleteLayer',
            parameters: data,
            width : 300,
            height : 200,
            title : "반복 공휴일 삭제",
            trigger :[
                {
                    name : 'wtmHolidayDeleteLayerTrigger'
                    , callback : function(result){
                        deleteHoliday(holidayId, inputGroupId, result.type);
                    }
                }
            ]
        });
        deleteLayer.show();
    }

    async function fetchDeleteType(params) {
        const body = "searchYear=" + params.searchYear +
            "&searchHolidayCd=" + params.searchHolidayCd +
            "&searchBusinessPlaceCd=" + params.searchBusinessPlaceCd;

        const response = await fetch("${ctx}/WtmHolidayMgr.do?cmd=getWtmHolidayDeleteLayerDeleteType", {
            method: "POST",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: body
        });

        const json = await response.json();
        if (json.Message) {
            alert(json.Message);
            return null;
        }
        return json.DATA;
    }

    function openCreateLayer(holidayId) {
        const params = {
            dataCode : $('.tab_menu.active').attr('data-code'),
            holidayId : holidayId,
            searchYear : $("#searchYear").val()
        };

        const deleteLayer = new window.top.document.LayerModal({
            id : 'wtmHolidayCreateLayer',
            url : '/WtmHolidayMgr.do?cmd=viewWtmHolidayCreateLayer',
            parameters: params,
            width : 700,
            height : 530,
            title : "공휴일 생성",
            trigger :[
                {
                    name : 'wtmHolidayCreateLayerTrigger'
                    , callback : async function() {
                        progressBar(true);
                        await renderViews();
                        progressBar(false);
                    }
                }
            ]
        });
        deleteLayer.show();
    }

    async function deleteHoliday(holidayId, inputGroupId, deleteType) {
        const params = $("#searchForm").serialize() +
                    "&holidayCd=" + holidayId +
                    "&deleteType=" + deleteType +
                    "&inputGroupId=" + inputGroupId;

        const result = ajaxCall("${ctx}/WtmHolidayMgr.do?cmd=deleteWtmHolidayMgr", params, false);
        if (result.Result.Code > 0) {
            alert("삭제되었습니다.");

            progressBar(true);
            await renderViews();
            progressBar(false);
        } else {
            alert(result.Result.Message);
        }
    }

    async function makeAllHoliday() {

        const bizPlaceNm = $(".tab_menu[data-code=" + $("#searchBizPlaceCd").val() + "]").text();
        if (!confirm($("#searchYear").val() + "년도의 " + bizPlaceNm + " 공휴일을 생성하시겠습니까? 기존 데이터는 삭제 후 생성됩니다.")) return;

        progressBar(true);
        try {
            const response = await fetch("${ctx}/WtmHolidayMgr.do?cmd=excWtmHolidayMgrKoreanHolidays", {
                method: "POST",
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: $("#searchForm").serialize()
            });
            const data = (await response.json());
            if (data && data.code <= 0) {
                alert(data.message);
            } else {
                alert("생성되었습니다.");

                progressBar(true);
                await renderViews(data.DATA);
                progressBar(false);
            }
        } catch(error) {
            console.error(error);
        } finally {
            progressBar(false);
        }
    }

</script>
</head>
<body class="iframe_content white attendanceNew">
<form id="searchForm" name="searchForm">
    <input type="hidden" id="searchYear" name="searchYear"/>
    <input type="hidden" id="searchBizPlaceCd" name="searchBizPlaceCd">
</form>
<h2 class="title-wrap"><span class="icon-wrap"><img src="../assets/images/icon_holiday.png" alt="icon"></span><span class="page-title">공휴일 관리</span></h2>
<!-- tab -->
<ul class="tab_bottom">
    <li class="tab_menu active" data-code="all">전체</li>
</ul>
<!-- 달력 -->
<div class="attendance-calendar">
    <!-- 달력 head -->
    <div class="calendar-head">
    	<div class="welcome-msg"><i class="mdi-ico">emoji_emotions</i>회사 공휴일을 등록하세요</div>
        <div class="year-wrap">
            <button><i class="mdi-ico" id="chevron_left">chevron_left</i></button>
            <span class="year" id="currentYear"></span>
            <span class="unit">년</span>
            <button><i class="mdi-ico" id="chevron_right">chevron_right</i></button>
        </div>
        <button class="btn filled icon_text btn-add"><i class="mdi-ico">add</i>추가하기</button>
        <button class="btn filled icon_text btn-cre"><i class="mdi-ico">add</i>일괄생성</button>
    </div>
    <div class="calendar-scroll">
    	<!-- 회사 별 휴일 리스트 상태 -->
    	<ul class="status-holiday"></ul>
	    <!-- 달력 body -->
	    <div class="calendar-body">
	        <div class="row card-wrapper"></div>
	    </div>
    </div>
</div>
</body>
</html>