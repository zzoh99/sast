<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp" %>
<!-- Meta -->

<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript">

    var mboTargetYn = "";
    var compTargetYn = "";
    var appraisalYn = "";

    $(function () {

        const modal = window.top.document.LayerModalUtility.getModal('selfAprLayer');
        var args = modal.parameters;
        $("#searchEvaSabun").val(args.searchEvaSabun);
        $("#searchAppSabun").val(args.searchAppSabun);
        $("#searchAppraisalCd").val(args.searchAppraisalCd);
        $("#searchAppOrgCd").val(args.searchAppOrgCd);
        $("#searchAppSeqCd").val(args.searchAppSeqCd);
        $("#searchAppStepCd").val(args.searchAppStepCd);

        init();
    });

    function init() {
        setAppSabunList(); // 평가자 정보 세팅
        setHideItems(); // 권한 없는 항목들 hide 처리
    }

    // 평가대상자 정보 세팅
    function setAppSabunList() {
        const data = ajaxCall('/EvaMain.do?cmd=getAppSabunList', $("#selfAprLayerForm").serialize(), false).DATA;
        if(data != null && data !== 'undefined') {
            let html = '';
            data.forEach(function(item){
                mboTargetYn = item.mboTargetYn;
                compTargetYn = item.compTargetYn;
                appraisalYn = $("#searchAppSeqCd").val() === item.appSeqCd ? item.appraisalYn : appraisalYn;

                $("#aprTitle").text(item.title);
                $("#aprAppPeriod").text(item.appPeriod);
                $("#lastAppSeqCd").val(item.lastAppSeqCd);

                let isActive = $("#searchAppSeqCd").val() === item.appSeqCd ? 'active' : '';
                let statusNm = item.appraisalYn === 'Y' ? 'evaluation done' : 'evaluation';
                html += `
                        <li class="box box-border flex-column ${'${isActive}'}">
                            <div class="cate">
                                <p class="badge gray">${'${item.appSeqNm}'}</p>
                            </div>
                            <div class="d-inline-block">
                                <span class="name">${'${item.appSabunName}'}</span>
                                <span class="caption-sm text-boulder">${'${item.appSabunJikweeNm}'}</span>
                            </div>
                            <p class="caption-sm text-boulder pt-1">${'${item.appSabunOrgNm}'}</p>
                            <p class="${'${statusNm}'}"><i class="mdi-ico mr-1"></i></p>
                        </li>
                        `;
            });
            $("#aprAppSabunListWrap").html(html);
            $("#searchAppYn").val(appraisalYn);

            // 업적, 역량 모두 평가 대상이 아닌경우
            if(compTargetYn === 'N' && mboTargetYn === 'N') {
                alert('평가 할 내용이 없습니다.');
                closeCommonLayer('selfAprLayer')
            }
        }
    }

    function showTargetTabs1() {
        // 평가대상인 탭만 보이도록설정
        if(mboTargetYn === 'Y') {
            $("#mboTab").show();
            $("#target1-1").show();
            $("#mboTab").addClass("active");
            $("#target1-1").addClass("show active");
            showIframe1('1');
        } else {
            $("#mboTab").hide();
            $("#target1-1").hide();
            $("#mboTab").removeClass("active");
            $("#target1-1").removeClass("show active");
        }

        if(compTargetYn === 'Y') {
            showIframe1('2');
            $("#compTab").show();
            $("#target1-2").show();

            if( mboTargetYn === 'N') {
                $("#compTab").addClass("active");
                $("#target1-2").addClass("show active");
            } else {
                $("#compTab").removeClass("active");
                $("#target1-2").removeClass("show active");
            }
        } else {
            $("#compTab").hide();
            $("#target1-2").hide();
            $("#compTab").removeClass("active");
            $("#target1-2").removeClass("show active");
        }

        // 활성화 되어있는 탭만 보여주기
        $("[id^='target1-'].show.active").show();
        $("[id^='target1-']:not(.show):not(.active)").hide();
    }

    function showTargetTabs2() {

        $("#goalMboTab").removeClass('active')
        $("#target2-1").removeClass("show active");
        $("#goalCompTab").removeClass('active')
        $("#target2-2").removeClass("show active");
        $("#aprHstTab").removeClass('active')
        $("#target2-3").removeClass("show active");

        // 평가대상인 탭만 보이도록설정
        if(mboTargetYn === 'Y') {
            $("#goalMboTab").show();
            $("#target2-1").show();
            $("#goalMboTab").addClass("active");
            $("#target2-1").addClass("show active");
            showIframe2('1');
        } else {
            $("#goalMboTab").hide();
            $("#target2-1").hide();
            $("#goalMboTab").removeClass("active");
            $("#target2-1").removeClass("show active");
        }

        if(compTargetYn === 'Y') {
            showIframe2('2');
            $("#goalCompTab").show();
            $("#target2-2").show();

            if( mboTargetYn === 'N') {
                $("#goalCompTab").addClass("active");
                $("#target2-2").addClass("show active");
            } else {
                $("#goalCompTab").removeClass("active");
                $("#target2-2").removeClass("show active");
            }
        } else {
            $("#goalCompTab").hide();
            $("#target2-2").hide();
            $("#goalCompTab").removeClass("active");
            $("#target2-2").removeClass("show active");
        }

        // 활성화 되어있는 탭만 보여주기
        $("[id^='target2-'].show.active").show();
        $("[id^='target2-']:not(.show):not(.active)").hide();
    }

    // 권한 없는 항목들 hide 처리
    function setHideItems() {
        showTargetTabs1();
        showTargetTabs2();

        // 평가완료 버튼
        if(appraisalYn === 'Y') {
            $("#btnApp").hide();
        } else {
            $("#btnApp").show();
        }

    }

    function showIframe1(iframeIdx1) {
        $("#target1-"+iframeIdx1).show();
        $("[id^='target1-']:not(#target1-" + iframeIdx1 + ")").hide();
        switch (iframeIdx1) {
            case "1":
                var param = $("#selfAprLayerForm").serialize();
                $("#tab1-1").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboApr&"+param);
                setTabHeight($("#tab1-1").get(0))
                break;

            case "2":
                var param = $("#selfAprLayerForm").serialize();
                $("#tab1-2").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboCompApr&"+param);
                setTabHeight($("#tab1-2").get(0))
                break;
        }
    }

    function showIframe2(iframeIdx2) {
        $("#target2-"+iframeIdx2).show();
        $("[id^='target2-']:not(#target2-" + iframeIdx2 + ")").hide();
        switch (iframeIdx2) {
            case "1":
                var param = $("#selfAprLayerForm").serialize();
                param += '&editableYn=N'
                $("#tab2-1").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboReg&"+param);
                setTabHeight($("#tab2-1").get(0))
                break;
            case "2":
                var param = $("#selfAprLayerForm").serialize();
                param += '&editableYn=N'
                $("#tab2-2").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboCompReg&"+param);
                setTabHeight($("#tab2-2").get(0))
                break;
            case "3":
                var param = $("#selfAprLayerForm").serialize();
                $("#tab2-3").attr("src", "${ctx}/EvaMain.do?cmd=viewReferGoalSta&"+param);
                break;
        }
    }

    function setTabHeight(tabIframe) {
        tabIframe.addEventListener('load', function() {
            setTimeout(function () {
                let height = tabIframe.contentWindow.document.body.scrollHeight + 'px';
                tabIframe.style.height = height;
            }, 1000);
        });
    }

    function doAction(sAction) {
        switch (sAction) {
            case "ChkApp": //평가완료
                if (!isPopup()) {return;}

                //공통 체크
                if( !commCheck() ) return;
                //sheet1 체크 - MBO
                if (mboTargetYn == "Y") {
                    if( !checkTab1() ) {
                        return;
                    }
                }
                //sheet2 체크 - 역량
                if (compTargetYn == "Y") {
                    if( !checkTab2() ) {
                        return;
                    }
                }

                var args = new Array();

                args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
                args["searchEvaSabun"] = $("#searchEvaSabun").val();
                args["searchAppOrgCd"] = $("#searchAppOrgCd").val();
                args["searchAppStepCd"] = $("#searchAppStepCd").val();
                args["searchAppSeqCd"] = $("#searchAppSeqCd").val();
                args["searchAppSabun"] = $("#searchAppSabun").val();
                args["searchAppYn"] = "Y";
                args["lastAppSeqCd"] = $("#lastAppSeqCd").val();

                var layer = new window.top.document.LayerModal({
                    id : 'appSelfReturnCommentLayer'
                    , url : "${ctx}/EvaMain.do?cmd=viewAppSelfReturnComment"
                    , parameters: args
                    , width : 500
                    , height : 320
                    , top: '50vh'
                    , left: '50vw'
                    , title : "의견등록"
                    , trigger :[
                        {
                            name : 'appSelfReturnCommentLayerTrigger'
                            , callback : function(rv){
                                if ( rv["Code"] != "-1" )	{
                                    $("#searchAppYn").val("Y");
                                    setTimeout(function(){
                                        var data = ajaxCall("${ctx}/EvaMain.do?cmd=prcAppSelf2",$("#selfAprLayerForm").serialize(),false);

                                        if(data.Result.Code == null) {
                                            alert( "평가확정 처리되었습니다.");
                                            init();
                                        } else {
                                            alert(data.Result.Message);
                                        }

                                    }, 300);
                                }
                            }
                        }
                    ]
                });
                layer.show();


                break;
        }
    }

    //공통 체크
    function commCheck(){
        if($("#searchAppraisalCd", "#selfAprLayerForm").val() == "") {
            alert("평가명이 존재하지 않습니다.");
            return false;
        }

        if($("#searchAppOrgCd", "#selfAprLayerForm").val() == ""){
            alert("평가소속이 존재하지 않습니다.");
            return false;
        }

        if($("#searchAppSabun", "#selfAprLayerForm").val() == "") {
            alert("평가자가 존재하지 않습니다.");
            return false;
        }

        if($("#searchEvaSabun", "#selfAprLayerForm").val() == "") {
            alert("평가 대상자가 존재하지 않습니다.");
            return false;
        }
        
        if($("#searchAppYn", "#selfAprLayerForm").val() == "") {
            alert("이미 평가완료된 상태입니다.");
            return false;
        }

        return true;
    }

    //Tab1 Check
    function checkTab1(){
        let item = $('#tab1-1').get(0).contentWindow.checkRequiredCol();

        if(item !== null) {
            alert("[ 업적 ] 탭 평가 항목의 "+item+"을 모두 입력하여 주세요.");
            return false;
        }

        return true;
    }

    //Tab2 Check
    function checkTab2(){
        let item = $('#tab1-2').get(0).contentWindow.checkRequiredCol();

        if(item !== null) {
            alert("[ 역량 ] 탭 평가 항목의 "+item+"을 모두 입력하여 주세요.");
            return false;
        }

        return true;
    }

    // 출력
    function showRd(){
        if ( $("#searchAppOrgCd").val() == ""  ) {
            alert("평가정보가 없습니다.");
            return;
        }

        var rdMrd   = "pap/progress/AppSelfReport.mrd";
        var rdTitle = "본인평가표출력";
        var rdParam = "";

        var searchAppraisalCdSAbunAppOrgCd_s = "('" + $("#searchAppraisalCd").val() + "', '"+ $("#searchEvaSabun").val() +"', '"+ $("#searchAppOrgCd").val() +"'),";
        searchAppraisalCdSAbunAppOrgCd_s = searchAppraisalCdSAbunAppOrgCd_s.substr(0, searchAppraisalCdSAbunAppOrgCd_s.length-1);

        rdParam  = rdParam +"[${ssnEnterCd}] "; //회사코드
        rdParam  = rdParam +"[5] "; //단계
        rdParam  = rdParam +"[0] "; // 차수
        rdParam  = rdParam +"["+ searchAppraisalCdSAbunAppOrgCd_s +"] "; //피평가자 사번, 평가소속
        rdParam  = rdParam +"[N] "; //최종결과출력

        const data = {
            parameters : rdParam,
            rdMrd : rdMrd
        };

        window.top.showRdLayer('/EvaMain.do?cmd=getEncryptRd', data, null, rdTitle, null, null, '50vh', '50vw');
    }
</script>
<form name="selfAprLayerForm" id="selfAprLayerForm" method="post">
    <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
    <input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value=""/>
    <input type="hidden" id="searchEvaSabun" name="searchEvaSabun" value=""/>
    <input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value=""/>
    <input type="hidden" id="searchAppStatusCd" name="searchAppStatusCd" value=""/>
    <input type="hidden" id="searchAppSeqCd" name="searchAppSeqCd" value=""/>
    <input type="hidden" id="searchAppSabun" name="searchAppSabun" value=""/>
    <input type="hidden" id="lastAppSeqCd" name="lastAppSeqCd" value=""/>
    <input type="hidden" id="searchAppYn" name="searchAppYn" value=""/>
</form>
<div class="hr-container target-modal p-0 full">
    <div class="modal-content border-0">
        <div class="modal-body p-0">
            <div class="row line">
                <div class="col scroll">
                    <div class="sub-title-wrap">
                        <div class="d-flex align-items-center">
                            <h3 id="aprTitle" class="h2 mr-2"></h3>
                            <span id="aprAppPeriod" class="date"></span>
                            <div class="btns ml-auto">
                                <a href="javascript:showRd()" id="btnPrint" class="btn outline-gray">출력</a>
                            </div>
                            <div class="btns ml-2">
                                <a href="javascript:doAction('ChkApp')"	class="btn filled" id="btnApp">평가완료</a>
                            </div>
                        </div>
                    </div>
                    <ul id="aprAppSabunListWrap" class="process-wrap row box p-0 flex-nowrap"></ul>
                    <ul class="nav nav-tabs type1" id="targetTabs1">
                        <li class="nav-item">
                            <a id="mboTab" class="nav-link active" data-toggle="tab" href="#target1-1"
                               onclick="javascript:showIframe1('1');">업적</a>
                        </li>
                        <li class="nav-item">
                            <a id="compTab" class="nav-link" data-toggle="tab" href="#target1-2"
                               onclick="javascript:showIframe1('2');">역량</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="target1-1">
                            <iframe id="tab1-1" name="tab1-1" src='${ctx}/EvaMain.do?cmd=viewEvaMboApr' frameborder='0'
                                    scrolling="no" style="width:100%" onload="setTabHeight(this)"></iframe>
                        </div>
                        <div class="tab-pane fade" id="target1-2">
                            <iframe id="tab1-2" name="tab1-2" src='${ctx}/EvaMain.do?cmd=viewEvaMboCompApr' frameborder='0'
                                    scrolling="no" style="width:100%" onload="setTabHeight(this)"></iframe>
                        </div>
                    </div>
                </div>
                <div class="col scroll">
                    <ul class="nav nav-tabs modal-tabs mt-0 w-auto">
                        <li class="nav-item">
                            <a id="goalMboTab" class="nav-link active" data-toggle="tab" href="#target2-1"
                               onclick="javascript:showIframe2('1');">목표 업적</a>
                        </li>
                        <li class="nav-item">
                            <a id="goalCompTab" class="nav-link" data-toggle="tab" href="#target2-2"
                               onclick="javascript:showIframe2('2');">목표 역량</a>
                        </li>
                        <li class="nav-item">
                            <a id="aprHstTab" class="nav-link" data-toggle="tab" href="#target2-3"
                               onclick="javascript:showIframe2('3');">평가진행이력</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="target2-1">
                            <iframe id="tab2-1" name="tab2-1" src='${ctx}/EvaMain.do?cmd=viewEvaMboReg'
                                    frameborder='0' scrolling="no" style="width:100%"
                                    onload="setTabHeight(this)"></iframe>
                        </div>
                        <div class="tab-pane fade" id="target2-2">
                            <iframe id="tab2-2" name="tab2-2" src='${ctx}/EvaMain.do?cmd=viewEvaMboCompReg'
                                    frameborder='0' scrolling="no" style="width:100%"
                                    onload="setTabHeight(this)"></iframe>
                        </div>
                        <div class="tab-pane fade" id="target2-3">
                            <iframe id="tab2-3" name="tab2-3" src='${ctx}/EvaMain.do?cmd=viewReferGoalSta'
                                    frameborder='0' scrolling="no" style="width:100%"
                                    onload="setTabHeight(this)"></iframe>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>


