<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- bootstrap -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<!-- lazy load plugin -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.11/jquery.lazy.min.js"></script>
<title>개인근무유형관리</title>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>

<!-- 개별 화면 script -->
<script type="text/javascript">
    $(document).ready(function () {
        initEvent();
        init();

        //스크롤시 이미지 lazy 적용
        $('#bodyContainer').on('scroll', function() {
            imgLazy();
        });
    });

    $(document).on('click', '.workType-card', function () {
        $('.workType-card').removeClass('active');
        $(this).addClass('active');
        if($(this).find('#workClassNmStr').val() != null && $(this).find('#workClassNmStr').val() != ''){
            $('#pageTitle').text($(this).find('#workClassNmStr').val());
        }else{
            $('#pageTitle').text('전체 근무제');
        }
    });

    $(document).on('keyup', '#searchSabunName', function (event) {
        if( event.keyCode == 13){
            init();
        }
    });

    function init() {
        let workClassCd = $('#searchWorkClassCd').val();
        drawWorkClassCard();
        doSearch();
    }

    function initEvent() {
        $('#setEmpBtn').hide();

        $('#searchDate').datepicker2({
            searchDate: 'searchDate'
        });

        $("#setEmpBtn").on('click', async function () {
            try {
                // if (!$("#searchWorkClassCd").val()) {
                //     confirm("근무유형을 선택해주세요.");
                //     return;
                // }
                const workClassCd = $('#searchWorkClassCd').val();
                const params = {
                    workClassCd : workClassCd
                }
                let layerModal = new window.top.document.LayerModal({
                    id : 'wtmPsnlWorkTypeTargetLayer' //식별자ID
                    , url : '/WtmPsnlWorkTypeMgr.do?cmd=viewWtmPsnlWorkTypeTargetLayer' //팝업에 띄울 화면 jsp
                    , parameters: params
                    , width : 1000
                    , height : 720
                    , title : '대상자 설정'
                    , trigger :[ //콜백
                        {
                            name : 'wtmPsnlWorkTypeTargetLayerTrigger'
                            , callback : function(result){
                                doSearch(workClassCd)
                            }
                        }
                    ]
                });
                layerModal.show();
            } catch (error) {
            } finally {
            }
        });
    }
    async function drawWorkClassCard() {
        try {
            progressBar(true);

            const response = await fetch("/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkTypeMgrWorkClassList", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: $('#wtmPsnlWorkTypeMgrFrm').serialize()
            });
            const data = (await response.json()).DATA;

            if (data) {
                if(data.totInfo) {
                    $("#totWorkClassCnt").text(data.totInfo.totWorkClassCnt);
                    $("#workClassCnt").text(data.totInfo.totWorkClassCnt + '개');
                    $("#totEmpCnt").text(data.totInfo.totEmpCnt);
                }

                if(data.workClassList && data.workClassList.length > 0) {
                    let cardHtml = '';
                    data.workClassList.forEach((info) => {

                        let cardEmpHtml = '';
                        info.empList.forEach(emp => {
                            cardEmpHtml += `

                            `;
                        })

                        const workDay = getWorkDay(info.workDay);
                        cardHtml += ''
                        cardHtml += '<li class="workType-card personal" onClick="doSearch(\'' + info.workClassCd + '\', \'' + info.workGroupCd + '\')">';
                        cardHtml += '    <input type="hidden" id="workClassNmStr" value="' + info.workClassNm + '" />';
                        cardHtml += '    <div class="card-title mt-0">' + info.workClassNm + '<span class="day-wrap"><span class="day">' + info.workTypeNm + '</span></span></div>';
                        cardHtml += '    <div class="period-wrap">';
                        cardHtml += '        <div class="inner-wrap">';
                        if(info.typeLabel){
                            cardHtml += '            <span class="label">' + info.typeLabel + '</span>';
                        }
                        if(info.typeValue){
                            cardHtml += '            <span class="date">' + info.typeValue + '</span>';
                        }
                        cardHtml += '        </div>';
                        if(workDay != ''){
                            cardHtml += '        <div class="inner-wrap">';
                            cardHtml += '            <span class="label">근무요일</span>';
                            cardHtml += '            <span class="day-wrap">';
                            workDay.forEach(function(item){
                                cardHtml += '<span class="day">' + item + '</span>'
                            })
                            cardHtml += '            </span>';
                            cardHtml += '        </div>';
                        }
                        cardHtml += '    </div>';
                        cardHtml += '    <div class="shift-wrap">';
                        cardHtml += '        <span class="label">인원</span><span class="cnt">' + info.empCnt + '명</span>';
                        cardHtml += '        <div class="avatar-wrap">';
                        cardHtml += '            <ul class="avatar-list">';
                        // <li><img src="https://i.pravatar.cc/200"></li><li><img src="https://i.pravatar.cc/180"></li><li><img src="https://i.pravatar.cc/300"></li><li><img src="https://i.pravatar.cc/240"></li><li><img src="https://i.pravatar.cc/520"></li><li><img src="https://i.pravatar.cc/120"></li>
                        info.empList.forEach(function(item){
                            cardHtml += '<li><img src="${ctx}/EmpPhotoOut.do?enterCd=' + item.enterCd + '&sabun='+item.sabun+'"></li>';
                        })
                        cardHtml += '            </ul>';
                        cardHtml += '            <span class="re-cnt"></span>';
                        cardHtml += '        </div>';
                        cardHtml += '    </div>';
                        cardHtml += '</li>';
                    })
                    $("#workTypeCardList").html(cardHtml);
                }
            }
        } catch (error) {
            console.error('조회 중 오류 발생:', error);
            alert('조회 중 오류가 발생했습니다.');
        } finally {
            progressBar(false);
        }
    }

    async function doSearch(workClassCd, workGroupCd){

        progressBar(true);

        if(workClassCd != null){
            $('#searchWorkClassCd').val(workClassCd);
        }
        const response = await fetch("/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkTypeMgrList", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: $('#wtmPsnlWorkTypeMgrFrm').serialize()
        });
        const data = (await response.json()).DATA;
        // const list = response.data.DATA;
        let html = '';
        data.forEach(function(item){
            html += '<div class="col-xl-4 col-lg-4 col-md-6 col-sm-12 card-gutter">';
            html += '    <div class="workType-card personal">';
            html += '        <div class="profile">';
            html += '            <div class="img-wrap">';
            html += '                <img class="lazy" data-src="${ctx}/EmpPhotoOut.do?enterCd=' + item.enterCd + '&sabun='+item.sabun+'">';
            html += '            </div>';
            html += '            <div class="info-wrap">';
            html += '                <div class="info">';
            html += '                    <span class="name">' + item.name + '</span>';
            html += '                    <span class="position co-num">' + item.sabun + '</span>';
            html += '                    <span class="btn-wrap ml-auto">';
            html += '                       <a href="javascript:showEditLayer(\'' + item.baseWorkClassCd + '\', \'' + item.workClassCd + '\', \'' + item.workGroupCd + '\', \'' + item.sabun + '\')"><i class="mdi-ico">edit</i></a>';
            if(item.workClassCd != item.baseWorkClassCd){
                html += '      <a href="javascript:deleteWork(\'' + item.workClassCd + '\', \'' + item.sabun + '\', \'' + item.sdate + '\')"><i class="mdi-ico filled">cancel</i></a>';
            }
            html += '                    </span>';
            html += '                </div>';
            html += '                <div class="info">';
            html += '                   <span class="position">' + item.jikweeNm + '</span>';
            html += '                   <span class="divider"></span>';
            html += '                   <span class="team">' + item.orgNm + '</span>';
            html += '               </div>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="row workTime-box">';
            html += '            <div class="d-flex align-center">';
            html += '                <div class="label">근무유형</div>';
            html += '                <div class="desc ml-auto">' + item.workClassNm;
            if(item.workGroupNm) html += '('+item.workGroupNm+')';
            html += '</div>';
            html += '            </div>';
            html += '            <div class="d-flex align-center mt-4">';
            html += '                <div class="label">기간</div>';
            html += '                <div class="desc ml-auto">' + item.sdate + ' - ' + item.edate + '</div>';
            html += '            </div>';
            html += '        </div>';
            html += '    </div>';
            html += '</div>';
        })
        $('#workTypeMgrList').html(html);
        $('#workTypeMgrCnt').html(data.length);
        $('#setEmpBtn').show();

        imgLazy();

        progressBar(false);
    }

    function imgLazy(){
        $('#bodyContainer .lazy:not(.lazy-loaded)').lazy({
            scrollContainer: '#bodyContainer',
            effect: "fadeIn",
        });
    }

    /* CSS 용 함수 모음 */
    $(document).ready(function () {
        // CSS 용 함수 호출
        cardWrapperHeight();
        typeCardListHeight();
        adjustAvatarList();
    });

    // resize 이벤트에 디바운스 적용
    $(window).on('resize', debounce(function() {
        cardWrapperHeight();
        typeCardListHeight();
        adjustAvatarList();
    }, 100));

    // 카드 모음 Height 설정
    function cardWrapperHeight() {
        const $workTypeBody = $('.workType-body.scroll'); // 높이를 설정할 대상
        const $titleh2 = $('.setting-wrap h2.title-wrap'); // 높이를 뺄 대상 DOM
        const $titleh3 = $('.setting-wrap h3.title-wrap'); // 높이를 뺄 대상 DOM
        const $tableWrap = $('.setting-wrap .table-wrap'); // 높이를 뺄 대상 DOM

        const windowHeight = $(window).height(); // 전체 창 높이
        const titleHeighth2 = $titleh2.outerHeight(true) || 0; // 뺄 DOM의 높이 (요소가 없으면 0)
        const titleHeighth3 = $titleh3.outerHeight(true) || 0; // 뺄 DOM의 높이 (요소가 없으면 0)
        const targetHeight2 = $tableWrap.outerHeight(true) || 0; // 뺄 DOM의 높이 (요소가 없으면 0)

        $workTypeBody.css('height', (windowHeight - titleHeighth2 - titleHeighth3 - targetHeight2 - 44) + 'px');
    }

    function typeCardListHeight(){
        const $workTypeCardList = $('.workTypeCardList');
        const $workTypeStatus = $('.workType-status');

        const windowHeight = $(window).height(); // 전체 창 높이
        const workTypeCardListHeight = $workTypeCardList.outerHeight(true) || 0; // 뺄 DOM의 높이 (요소가 없으면 0)
        const workTypeStatusHeight = $workTypeStatus.outerHeight(true) || 0; // 뺄 DOM의 높이 (요소가 없으면 0)

        $workTypeCardList.css('height', (windowHeight - workTypeStatusHeight - 48) + 'px');
    }

    function adjustAvatarList() {
        const $shiftWrap = $('.shift-wrap');
        const $avatarWrap = $shiftWrap.find('.avatar-wrap');
        const $avatarList = $avatarWrap.find('.avatar-list');
        const $reCnt = $avatarWrap.find('.re-cnt');
        const $items = $avatarList.find('li');

        const totalCount = parseInt($shiftWrap.find('.cnt').text().replace(/[^0-9]/g, ''), 10); // 전체 인원
        const wrapWidth = $avatarWrap.width(); // avatar-wrap의 전체 너비
        const itemWidth = $items.first().outerWidth(true); // li 항목 하나의 너비 (margin 포함)

        const maxVisibleItems = 7; // 최대 보이는 항목 수를 고정
        let visibleCount;

        // 화면 크기에 따라 보이는 항목 수 조정
        if (wrapWidth < 280) {
            visibleCount = 5; // 너비가 280px 미만일 때 최대 5개만 표시
        } else {
            visibleCount = Math.floor(wrapWidth / itemWidth); // 표시할 수 있는 최대 li 수
            visibleCount = Math.min(visibleCount, maxVisibleItems); // 최대 7개까지만 보이도록 제한
        }

        // li 항목 보이기/숨기기
        $items.each(function (index) {
            if (index < visibleCount) {
                $(this).show(); // 보이기
            } else {
                $(this).hide(); // 숨기기
            }
        });

        // 숨겨진 항목 수 계산 및 re-cnt에 표시
        const hiddenCount = totalCount - visibleCount;
        if(hiddenCount > 0){
            $reCnt.text(`+${hiddenCount}`);
        }else{
            $reCnt.text('');
        }
    }

    // 멀티로 함수 실행에 따른 delay 함수
    function debounce(func, delay) {
        let timer;
        return function(...args) {
            clearTimeout(timer);
            timer = setTimeout(() => {
                func.apply(this, args);
            }, delay);
        };
    }
    /* CSS 용 함수 모음 끝 */

    function getWorkTime(workTimeF, workTimeT){
        let result = '';
        if(workTimeF){
            result += workTimeF.substring(0, 2) + ':' + workTimeF.substring(2, 4);
        }
        if(workTimeF && workTimeT){
            result += '-';
        }
        if(workTimeT){
            result += workTimeT.substring(0, 2) + ':' + workTimeT.substring(2, 4);
        }
        return result;
    }

    function getWorkDay(workDay){
        let result = '';
        if(workDay){
            result = workDay.replace('MON', '월')
                .replace('TUE', '화')
                .replace('WED', '수')
                .replace('THU', '목')
                .replace('FRI', '금');
        }
        return result.split(',');
    }

    // 조직검색 팝업
    function orgSearchLayer(targetId) {
        new window.top.document.LayerModal({
            id : 'orgLayer'
            , url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R'
            , parameters : {}
            , width : 840
            , height : 800
            , title : '조직 리스트 조회'
            , trigger :[
                {
                    name : 'orgTrigger'
                    , callback : function(result){
                        $("#"+targetId+"Nm").val(result[0].orgNm);
                        $("#"+targetId).val(result[0].orgCd);
                    }
                }
            ]
        }).show();
    }

    // 조직검색 팝업
    function showEditLayer(baseWorkClassCd, workClassCd, workGroupCd, sabun) {
        const p = {
            baseWorkClassCd: baseWorkClassCd,
            searchWorkClassCd: workClassCd,
            searchWorkGroupCd: workGroupCd,
            searchSabun: sabun,
            searchDate: $('#searchDate').val()
        }
        new window.top.document.LayerModal({
            id : 'wtmPsnlWorkTypeEditLayer'
            , url : '/WtmPsnlWorkTypeMgr.do?cmd=viewWtmPsnlWorkTypeEditLayer'
            , parameters : p
            , width : 600
            , height : 600
            , title : '개인근무유형 상세'
            , trigger :[
                {
                    name : 'wtmPsnlWorkTypeEditLayerTrigger'
                    , callback : function(result){
                        doSearch();
                    }
                }
            ]
        }).show();
    }

    // 조직검색 팝업
    function deleteWork(workClassCd, sabun, sdate) {
        const p = {
            searchWorkClassCd: workClassCd,
            searchSabun: sabun,
            sdate: sdate,
        }

        var data = ajaxCall("${ctx}/WtmPsnlWorkTypeMgr.do?cmd=deleteWtmPsnlWorkMgr", p,false);
        alert(data.Result.Message)
        if(data.Result.Code > 0){
            init();
        }
    }

</script>
<body class="iframe_content white attendanceNew pa-0">
<form id="wtmPsnlWorkTypeMgrFrm" name="wtmPsnlWorkTypeMgrFrm">
    <input type="hidden" id="searchWorkClassCd" name="searchWorkClassCd" value="" />
    <div class="row flex-grow-1 m-0">
        <div class="col-3 workType-content bg-skyblue pa-0">
            <div class="py-20 px-24 workType-status">
                <h2 class="title-wrap">
                    <div class="inner-wrap">
                        <span class="page-title">근무유형<span id="workClassCnt" class="cnt">6개</span></span>
                    </div>
                </h2>
                <li class="workType-card type-status" onClick="doSearch('')">
                    <div class="card-title mt-0"><i class="mdi-ico filled">folder</i>등록된 근무유형</div>
                    <span class="status">전체</span>
                    <div class="desc-wrap">
                        <div class="inner-wrap">
                            <span class="label">근무유형</span>
                            <span id="totWorkClassCnt" class="cnt point-blue"></span>
                            <span class="unit">개</span>
                        </div>
                        <div class="inner-wrap">
                            <span class="label">총 인원</span>
                            <span id="totEmpCnt" class="cnt point-blue"></span>
                            <span class="unit">명</span>
                        </div>
                    </div>
                </li>
            </div>
            <div class="py-20 px-24 border-top workType-desc">
                <ul id="workTypeCardList" class="workTypeCardList">
<%--                    <li class="workType-card personal">--%>
<%--                        <div class="card-title mt-0">기본근무유형<span class="day-wrap"><span class="day">기본근무</span></span></div>--%>
<%--                        <div class="period-wrap">--%>
<%--                            <div class="inner-wrap">--%>
<%--                                <span class="label">근무시간</span>--%>
<%--                                <span class="date">09:00 -18:00</span>--%>
<%--                            </div>--%>
<%--                            <div class="inner-wrap">--%>
<%--                                <span class="label">근무요일</span>--%>
<%--                                <span class="day-wrap"><span class="day">월</span><span class="day">화</span></span>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="shift-wrap">--%>
<%--                            <span class="label">인원</span><span class="cnt">50명</span>--%>
<%--                            <div class="avatar-wrap">--%>
<%--                                <ul class="avatar-list">--%>
<%--                                    <li><img src="https://i.pravatar.cc/180"></li><li><img src="https://i.pravatar.cc/200"></li><li><img src="https://i.pravatar.cc/180"></li><li><img src="https://i.pravatar.cc/300"></li><li><img src="https://i.pravatar.cc/240"></li><li><img src="https://i.pravatar.cc/520"></li><li><img src="https://i.pravatar.cc/120"></li>--%>
<%--                                </ul>--%>
<%--                                <span class="re-cnt">+1</span>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </li>--%>
<%--                    <li class="workType-card personal">--%>
<%--                        <div class="card-title mt-0">기본근무유형<span class="day-wrap"><span class="day">기본근무</span></span></div>--%>
<%--                        <div class="period-wrap">--%>
<%--                            <div class="inner-wrap">--%>
<%--                                <span class="label">근무시간</span>--%>
<%--                                <span class="date">09:00 -18:00</span>--%>
<%--                            </div>--%>
<%--                            <div class="inner-wrap">--%>
<%--                                <span class="label">근무요일</span>--%>
<%--                                <span class="day-wrap"><span class="day">월</span><span class="day">화</span></span>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="shift-wrap">--%>
<%--                            <span class="label">인원</span><span class="cnt">50명</span>--%>
<%--                            <div class="avatar-wrap">--%>
<%--                                <ul class="avatar-list">--%>
<%--                                    <li><img src="https://i.pravatar.cc/180"></li><li><img src="https://i.pravatar.cc/200"></li><li><img src="https://i.pravatar.cc/180"></li><li><img src="https://i.pravatar.cc/300"></li><li><img src="https://i.pravatar.cc/240"></li><li><img src="https://i.pravatar.cc/520"></li><li><img src="https://i.pravatar.cc/120"></li>--%>
<%--                                </ul>--%>
<%--                                <span class="re-cnt">+1</span>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </li>--%>
                </ul>
            </div>
        </div>
        <div class="col-9 typeDetail-content">
            <div class="setting-wrap">
                <h2 class="title-wrap">
                    <div class="inner-wrap">
                        <i class="mdi-ico filled">today</i>
                        <span class="page-title" id="pageTitle">전체 근무제</span>
                    </div>
                    <!-- 버튼 리스트 -->
                    <div class="btn-wrap">
<%--                        <button class="btn outline_gray">전체삭제</button>--%>
<%--                        <button class="btn dark">저장</button>--%>
                    </div>
                </h2>
                <div class="table-wrap mt-2 table-responsive">
                    <table class="basic type5 line-grey">
                        <colgroup>
                            <col width="10%">
                            <col width="20%">
                            <col width="10%">
                            <col width="20%">
                            <col width="10%">
                            <col width="*%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>기준일자</th>
                            <td>
                                <div class="input-wrap wid-100">
                                    <input id="searchDate" name="searchDate" class="form-input" type="text" value="${curSysYyyyMMddHyphen}">
                                </div>
                            </td>
                            <th>소속</th>
<%--                            <td>--%>
<%--                                <div class="input-wrap wid-100">--%>
<%--                                    <input id="searchOrgCd" name="searchOrgCd" class="form-input" type="text">--%>
<%--                                </div>--%>
<%--                            </td>--%>
                            <td>
                                <div class="d-flex wid-100">
                                    <input id="searchOrgCd" name="searchOrgCd" type="hidden">
                                    <input id="searchOrgNm" name ="searchOrgNm" type="text" class="form-input" readOnly />
                                    <a onclick="javascript:orgSearchLayer('searchOrg');return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
                                    <a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
                                </div>
                            </td>
                            <th>사번/성명</th>
                            <td>
                                <div class="input-wrap w-100">
                                    <div class="input-wrap">
                                        <input id="searchSabunName" name="searchSabunName" class="form-input" type="text" placeholder="사번 또는 성명 입력">
                                    </div>
                                    <button type="button" onClick="javascript:init()" class="btn dark ml-auto">조회</button>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <h3 class="title-wrap" style="margin-top: 12px;">
                    <div class="inner-wrap">
                        <span class="page-title">전체 <span class="cnt point-blue" id="workTypeMgrCnt">0</span>명</span>
                    </div>
                    <!-- 버튼 리스트 -->
                    <div class="btn-wrap">
                        <button type="button" class="btn outline" id="setEmpBtn">대상자 추가</button>
                    </div>
                </h3>
                <div id="bodyContainer" class="workType-body scroll">
                    <!-- 데이터 없을 때 -->
                    <!-- <div class="data-none mt-60">
                      <i class="mdi-ico filled">person</i>
                      <p class="desc">해당되는 대상자가 없습니다.<br>대상자 설정 버튼을 눌러 대상자를 설정해주세요.</p>
                    </div> -->
                    <!-- 데이터가 있을 때 -->
                    <div class="row card-wrapper" id="workTypeMgrList" >
<%--                        <div class="col-xl-4 col-lg-4 col-md-6 col-sm-12 card-gutter">--%>
<%--                            <div class="workType-card personal">--%>
<%--                                <div class="profile">--%>
<%--                                    <div class="img-wrap">--%>
<%--                                        <img src="https://i.pravatar.cc/40">--%>
<%--                                    </div>--%>
<%--                                    <div class="info-wrap">--%>
<%--                                        <div class="info">--%>
<%--                                            <span class="name">홍길동</span>--%>
<%--                                            <span class="position">연구원</span>--%>
<%--                                            <span class="divider"></span>--%>
<%--                                            <span class="position co-num">021314</span>--%>
<%--                                            <span class="btn-wrap ml-auto">--%>
<%--                              <a href="#"><i class="mdi-ico">edit</i></a>--%>
<%--                              <a href="#"><i class="mdi-ico filled">cancel</i></a>--%>
<%--                            </span>--%>
<%--                                        </div>--%>
<%--                                        <div class="team">솔루션개발팀</div>--%>
<%--                                    </div>--%>
<%--                                </div>--%>
<%--                                <div class="row workTime-box">--%>
<%--                                    <div class="d-flex align-center">--%>
<%--                                        <div class="label">근무유형</div>--%>
<%--                                        <div class="desc ml-auto">기본근무</div>--%>
<%--                                    </div>--%>
<%--                                    <div class="d-flex align-center mt-4">--%>
<%--                                        <div class="label">기간</div>--%>
<%--                                        <div class="desc ml-auto">2024.01.01 - 9999.12.31</div>--%>
<%--                                    </div>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="col-xl-4 col-lg-4 col-md-6 col-sm-12 card-gutter">--%>
<%--                            <div class="workType-card personal">--%>
<%--                                <div class="profile">--%>
<%--                                    <div class="img-wrap">--%>
<%--                                        <img src="https://i.pravatar.cc/40">--%>
<%--                                    </div>--%>
<%--                                    <div class="info-wrap">--%>
<%--                                        <div class="info">--%>
<%--                                            <span class="name">홍길동</span>--%>
<%--                                            <span class="position">연구원</span>--%>
<%--                                            <span class="divider"></span>--%>
<%--                                            <span class="position co-num">021314</span>--%>
<%--                                            <span class="btn-wrap ml-auto">--%>
<%--                              <a href="#"><i class="mdi-ico">edit</i></a>--%>
<%--                              <a href="#"><i class="mdi-ico filled">cancel</i></a>--%>
<%--                            </span>--%>
<%--                                        </div>--%>
<%--                                        <div class="team">솔루션개발팀</div>--%>
<%--                                    </div>--%>
<%--                                </div>--%>
<%--                                <div class="row workTime-box">--%>
<%--                                    <div class="d-flex align-center">--%>
<%--                                        <div class="label">근무유형</div>--%>
<%--                                        <div class="desc ml-auto">기본근무</div>--%>
<%--                                    </div>--%>
<%--                                    <div class="d-flex align-center mt-4">--%>
<%--                                        <div class="label">기간</div>--%>
<%--                                        <div class="desc ml-auto">2024.01.01 - 9999.12.31</div>--%>
<%--                                    </div>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
                    </div>
                    <!-- 리스트 끝 -->
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>