<!-- 부트스트랩 사용시 우선순위 순서 필요 -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    $(function() {
        /* 조회 조건 설정 */
        // 평가명 설정
        var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchCloseYn=N",false).codeList, "");
        $("#searchAppraisalCd").html(appraisalCdList[2]);

        /* 조회 조건 이벤트 등록 */
        // 평가명 이벤트
        $("#searchAppraisalCd").bind("change",function(event){
            searchAll();
        });

        searchAll();
    });

    //인사헤더에서 이름 변경 시 호출 됨
    function setEmpPage() {
        searchAll();
    }

    // 공통 체크
    function commCheck(){
        if($("#searchAppraisalCd").val() == "") {
            alert("평가명이 존재하지 않습니다.");
            return false;
        }
        return true;
    }

    // 전체 조회
    function searchAll() {
        $("#searchSabun").val($("#searchUserId").val());
        $("#goalCardWrap").removeClass('d-none').addClass('d-flex');
        $("#midCardWrap").removeClass('d-none').addClass('d-flex');
        $("#coachingCardWrap").removeClass('d-none').addClass('d-flex');
        $("#aprCardWrap").removeClass('d-none').addClass('d-flex');

        searchGoal('목표등록', '1', 'goalRegCard');
        searchGoalApr('목표승인', '1', 'goalAprCard');
        searchGoal('중간점검', '3', 'midRegCard');
        searchGoalApr('중간점검승인', '3', 'midAprCard');

        // 조회 된 카드 갯수에 따라 스타일 변경
        if($("#goalRegCard").hasClass('d-none') && $("#goalAprCard").hasClass('d-none')) {
            $("#goalCardWrap").removeClass('d-flex').addClass('d-none');
        } else if ($("#goalAprCard").hasClass('d-none') ) {
            $("#goalRegCard").removeClass('row')
        }

        if($("#midRegCard").hasClass('d-none') && $("#midAprCard").hasClass('d-none')) {
            $("#midCardWrap").removeClass('d-flex').addClass('d-none');
        } else if ($("#midAprCard").hasClass('d-none') ) {
            $("#midRegCard").removeClass('row')
        }

        searchCoaching();
        searchApr();
    }

    /* 목표, 중간점검 등록 카드 */
    // 목표, 중간점검 카드 조회
    function searchGoal(searchTitle, searchAppStepCd, objId) {
        const data = ajaxCall('/EvaMain.do?cmd=getGoalCardList&searchAppStepCd='+searchAppStepCd, $("#evaMainForm").serialize(), false).DATA;
        if(data != null && data !== 'undefined' && data.length > 0) {
            let html = '';
            data.forEach(function(goal){
                let statusClass = 'blue';
                if (goal.statusCd === '11') statusClass = 'gray'
                else if (goal.statusCd === '99') statusClass = 'green'
                html += `<li class="bx">
                            <a class="w-100" href="javascript:openGoalRegLayer('${'${goal.appOrgCd}'}','${'${searchTitle}'}','${'${searchAppStepCd}'}');">
                                <strong class="badge ${'${statusClass}'} mb-2">${'${goal.statusNm}'}</strong>
                                <span class="cate" style="float:right">${'${goal.appOrgNm}'}</span>
                                <p class="subject">${'${goal.title}'}</p>
                                <div class="date d-flex justify-content-between w-100">
                                    <span class="cate">${'${goal.subTitle}'}</span>
                                    <span>${'${goal.appPeriod}'}</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between w-100">
                                    <div class="progress">
                                        <div class="progress-bar" role="progressbar" style="width: calc(100% / ${'${goal.maxCnt}'} * ${'${goal.curCnt}'})" aria-valuenow="${'${goal.curCnt}'}" aria-valuemin="0" aria-valuemax="${'${goal.maxCnt}'}"></div>
                                    </div>
                                    <span class="current">${'${goal.curCnt}'}<span class="total">/${'${goal.maxCnt}'}</span></span>
                                </div>
                            </a>
                        </li>`
            });
            $("#"+objId).html(html);
            $("#"+objId).removeClass('d-none').addClass('d-flex');
        } else {
            $("#"+objId).removeClass('d-flex').addClass('d-none');
        }
    }

    function openGoalRegLayer(appOrgCd, searchTitle, searchAppStepCd){
        var url = '/EvaMain.do?cmd=viewGoalRegLayer';
        var layer = new window.top.document.LayerModal({
            id : 'goalRegLayer'
            , url : url
            , parameters : {
                searchEvaSabun: $("#searchSabun").val(),
                searchAppSabun: $("#searchSabun").val(),
                searchAppraisalCd: $("#searchAppraisalCd").val(),
                searchAppOrgCd: appOrgCd,
                searchAppSeqCd: '0', // 본인평가
                searchAppStepCd: searchAppStepCd, // 목표
                searchTitle: searchTitle,
              }
            , title : searchTitle
            , width : 'auto'
            , height : 'auto'
            , trigger :[
                {
                    name : 'goalRegLayerTrigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layer.show();
    }

    /* 목표, 중간점검 승인 카드 */
    // 목표, 중간점검 승인 카드 조회
    function searchGoalApr(searchTitle, searchAppStepCd, objId) {
        const data = ajaxCall('/EvaMain.do?cmd=getGoalAprCardList&searchAppStepCd='+searchAppStepCd, $("#evaMainForm").serialize(), false).DATA;
        if(data != null && data !== 'undefined' && data.length > 0) {
            let html = '';
            data.forEach(function(apr){
                html += `<li class="bx">
                            <a class="w-100" href="javascript:openGoalAprLayer('${'${apr.appSeqCd}'}','${'${searchTitle}'}','${'${searchAppStepCd}'}');">
                                <p class="cate" style="padding-bottom:0.7rem">${'${apr.appSeqNm}'}</p>
                                <p class="subject">${'${apr.title}'}</p>
                                <div class="date d-flex justify-content-between w-100">
                                    <span class="cate">${'${apr.subTitle}'}</span>
                                    <span>${'${apr.appPeriod}'}</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between w-100">
                                    <div class="progress">
                                        <div class="progress-bar" role="progressbar" style="width: calc(100% / ${'${apr.maxCnt}'} * ${'${apr.curCnt}'})" aria-valuenow="${'${apr.curCnt}'}" aria-valuemin="0" aria-valuemax="${'${apr.maxCnt}'}"></div>
                                    </div>
                                    <span class="current">${'${apr.curCnt}'}<span class="total">/${'${apr.maxCnt}'}</span></span>
                                </div>
                            </a>
                        </li>`
            });
            $("#"+objId).html(html);
            $("#"+objId).removeClass('d-none').addClass('d-flex');
        } else {
            $("#"+objId).removeClass('d-flex').addClass('d-none');
        }
    }

    function openGoalAprLayer(appSeqCd, searchTitle, searchAppStepCd){
        var url = '/EvaMain.do?cmd=viewGoalAprLayer';
        var layer = new window.top.document.LayerModal({
            id : 'goalAprLayer'
            , url : url
            , parameters : {
                searchAppSabun: $("#searchSabun").val(),
                searchAppraisalCd: $("#searchAppraisalCd").val(),
                searchAppSeqCd: appSeqCd,
                searchAppStepCd: searchAppStepCd,
                searchTitle: searchTitle,
            }
            , title : searchTitle
            , width : 'auto'
            , height : 'auto'
            , trigger :[
                {
                    name : 'goalAprLayerTrigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layer.show();
    }

    /* Coaching 카드 */
    // Coaching 카드 조회
    function searchCoaching() {
        const data = ajaxCall('/EvaMain.do?cmd=getCoachCardList', $("#evaMainForm").serialize(), false).DATA;
        if(data != null && data !== 'undefined' && data.length > 0) {
            let html = '';
            data.forEach(function(coach){
                html += `<li class="bx">
                            <a class="w-100" href="javascript:openCoachingLayer(${'${coach.appSeqCd}'});">
                                <p class="cate" style="padding-bottom:0.7rem">${'${coach.subTitle}'}</p>
                                <p class="subject">${'${coach.title}'}</p>
                            </a>
                        </li>`
            });
            $("#coachingCardWrap").removeClass('d-none').addClass('d-flex');
            $("#coachingCard").html(html);
        } else {
            $("#coachingCardWrap").removeClass('d-flex').addClass('d-none');
        }
    }

    function openCoachingLayer(searchAppSeqCd){
        var url = '/EvaMain.do?cmd=viewCoachingLayer&authPg=${authPg}';
        var layer = new window.top.document.LayerModal({
            id : 'coachingLayer'
            , url : url
            , parameters : {
                searchAppSabun: $("#searchSabun").val(),
                searchAppraisalCd: $("#searchAppraisalCd").val(),
                searchAppSeqCd: searchAppSeqCd,
                searchTitle: 'Coaching',
            }
            , title : 'Coaching'
            , width : 1200
            , height : 1000
            , trigger :[
                {
                    name : 'coachingLayerTrigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layer.show();
    }

    /* 최종평가 카드 */
    // 최종평가 카드 조회
    function searchApr() {
        const data = ajaxCall('/EvaMain.do?cmd=getAprCardList', $("#evaMainForm").serialize(), false).DATA;
        if(data != null && data !== 'undefined' && data.length > 0) {
            let html = '';
            data.forEach(function(apr){
                let statusClass = 'blue';
                if (apr.statusCd === '11') statusClass = 'gray'
                else if (apr.statusCd === '99') statusClass = 'green'
                let selfAprOrgNm = apr.appSeqCd == '0' ? apr.appOrgNm : '전체';
                let selfStatus = apr.appSeqCd == '0' ?
                    `<strong class="badge ${'${statusClass}'} mb-2">${'${apr.statusNm}'}</strong><span class="cate" style="float:right">${'${selfAprOrgNm}'}</span>` : `<p class="cate" style="padding-bottom:0.7rem">${'${selfAprOrgNm}'}</p>`;

                html += `<li class="bx">
                            <a class="w-100" href="javascript:openAprLayer('${'${apr.appSeqCd}'}', '${'${apr.appOrgCd}'}');">
                                ${'${selfStatus}'}
                                <p class="subject">${'${apr.appraisalNm}'} ${'${apr.appSeqNm}'}</p>
                                <div class="date d-flex justify-content-between w-100">
                                    <span class="cate">${'${apr.appSeqNm}'}</span>
                                    <span>${'${apr.appPeriod}'}</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between w-100">
                                    <div class="progress">
                                        <div class="progress-bar" role="progressbar" style="width: calc(100% / ${'${apr.maxCnt}'} * ${'${apr.curCnt}'})" aria-valuenow="${'${apr.curCnt}'}" aria-valuemin="0" aria-valuemax="${'${apr.maxCnt}'}"></div>
                                    </div>
                                    <span class="current">${'${apr.curCnt}'}<span class="total">/${'${apr.maxCnt}'}</span></span>
                                </div>
                            </a>
                        </li>`
            });
            $("#aprCard").html(html);
            $("#aprCardWrap").removeClass('d-none').addClass('d-flex');
        } else {
            $("#aprCardWrap").removeClass('d-flex').addClass('d-none');
        }
    }

    function openAprLayer(appSeqCd, appOrgCd){
        var url = '', id = '';
        if(appSeqCd === '0') {
            // 본인평가
            url = '/EvaMain.do?cmd=viewSelfAprLayer';
            id = 'selfAprLayer'
        } else {
            // 1~3차 평가
            url = '/EvaMain.do?cmd=viewEvaAprLayer';
            id = 'evaAprLayer'
        }
        var layer = new window.top.document.LayerModal({
              id : id
            , url : url
            , parameters : {
                searchEvaSabun: $("#searchSabun").val(),
                searchAppSabun: $("#searchSabun").val(),
                searchAppraisalCd: $("#searchAppraisalCd").val(),
                searchAppOrgCd: appOrgCd,
                searchAppSeqCd: appSeqCd,
                searchAppStepCd: '5', // 최종평가
            }
            , title : '평가'
            , width : 'auto'
            , height : 'auto'
            , trigger :[
                {
                    name : id+'Trigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layer.show();
    }
</script>
</head>
<body>
<div class="wrapper overflow-auto">
    <%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
    <div class="hr-container p-3">
        <form name="evaMainForm" id="evaMainForm" method="post">
            <input type="hidden" id="searchSabun" name="searchSabun" value=""/>
            <table class="table table-wrap table-fixed border-bottom-0 mb-0">
                <colgroup>
                    <col width="17%">
                </colgroup>
                <tbody>
                <tr>
                    <th><sup>*</sup>평가명</th>
                    <td>
                        <div class="d-flex justify-content-between">
                            <select class="col-2" name="searchAppraisalCd" id="searchAppraisalCd" required></select>
                            <div class="btns navy-btns">
                                <btn:a href="javascript:searchAll()" mid="search" mdef="조회" css="btn dark"/>
                            </div>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
        <section class="sect-sub">
            <div id="goalCardWrap" class="d-flex">
                <div class="bx bg-gray"><i class="mdi-ico icon-green">track_changes</i><h3 class="h3">목표</h3></div>
                <div class="row">
                    <ul id="goalRegCard" class="row"></ul>
                    <ul id="goalAprCard" class="row border-0"></ul>
                </div>
            </div>
            <div id="midCardWrap" class="d-flex">
                <div class="bx bg-gray"><i class="mdi-ico icon-green">rate_review</i><h3 class="h3">중간점검</h3></div>
                <div class="row">
                    <ul id="midRegCard" class="row"></ul>
                    <ul id="midAprCard" class="row border-0"></ul>
                </div>
            </div>
            <div id="coachingCardWrap" class="d-flex">
                <div class="bx bg-gray"><i class="mdi-ico filled icon-green">speaker_notes</i><h3 class="h3">Coaching</h3></div>
                <ul id="coachingCard" class="row"></ul>
            </div>
            <div id="aprCardWrap" class="d-flex">
                <div class="bx bg-gray"><i class="mdi-ico filled icon-green">assignment</i><h3 class="h3">평가</h3></div>
                <ul id="aprCard" class="row"></ul>
            </div>
        </section>
    </div>
</div>
<%--<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>--%>
</body>
</html>