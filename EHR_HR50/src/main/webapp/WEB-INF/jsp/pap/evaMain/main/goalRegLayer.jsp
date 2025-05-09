<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
    var mboTargetYn = "";
    var compTargetYn = "";
    $(function () {
        const modal = window.top.document.LayerModalUtility.getModal('goalRegLayer');
        var args = modal.parameters;
        $("#searchEvaSabun", "#goalRegLayerForm").val(args.searchEvaSabun);
        $("#searchAppSabun", "#goalRegLayerForm").val(args.searchAppSabun);
        $("#searchAppraisalCd", "#goalRegLayerForm").val(args.searchAppraisalCd);
        $("#searchAppSeqCd", "#goalRegLayerForm").val(args.searchAppSeqCd);
        $("#searchAppOrgCd", "#goalRegLayerForm").val(args.searchAppOrgCd);
        $("#searchAppStepCd", "#goalRegLayerForm").val(args.searchAppStepCd);
        $("#searchTitle", "#goalRegLayerForm").val(args.searchTitle);

        if($("#searchAppStepCd", "#goalRegLayerForm").val() == '3') {
            $("#histTabTitle").text('중간점검진행이력');
        }
        setAppSabunInfo();
        showTargetTabs();
        showIframe2('1');
    });

    function showTargetTabs() {
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

    // 평가대상자 정보 세팅
    function setAppSabunInfo() {
        const data = ajaxCall('/EvaMain.do?cmd=getAppSabunMap', $("#goalRegLayerForm").serialize(), false).DATA;
        if(data != null && data !== 'undefined') {
            $("#goalRegTitle").text(data.title);
            $("#goalRegPeriod").text(data.period);
            let datetime = new Date().getTime();
            let imageUrl = '/EmpPhotoOut.do?enterCd=' + data.enterCd + '&searchKeyword=' + data.sabun + '&t=' + datetime;
            $('#goalRegSabunImg').attr('src', imageUrl);
            $("#goalRegName").text(data.name);
            $("#goalRegJikweeNm").text(data.jikweeNm);
            $("#goalRegOrgNm").text(data.orgNm);
            $("#goalRegAppOrgNm").text(data.appOrgNm);

            let statusClass = 'blue';
            if (data.statusCd === '11') statusClass = 'gray'
            else if (data.statusCd === '99') statusClass = 'green'
            $("#goalRegStatusNm").text(data.statusNm);
            $("#goalRegStatusNm").addClass(statusClass);

            $("#searchAppStatusCd", "#goalRegLayerForm").val(data.statusCd);
            $("#searchAppSabun", "#goalRegLayerForm").val(data.appSabun);
            mboTargetYn = data.mboTargetYn;
            compTargetYn = data.compTargetYn;

            if( data.statusCd == "21" || data.statusCd == "25" || data.statusCd == "31" || data.statusCd == "35" || data.statusCd == "41" || data.statusCd == "99") {
                $("#btnRequest").hide(); //승인요청
            } else {
                $("#btnRequest").show(); //승인요청
            }
        }
    }

    function showIframe1(iframeIdx1) {
        $("#target1-"+iframeIdx1).show();
        $("[id^='target1-']:not(#target1-" + iframeIdx1 + ")").hide();
        switch(iframeIdx1){
            case "1":
                $("#target1-1").show();
                var param = $("#goalRegLayerForm").serialize();
                $("#tab1-1").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboReg&"+param);
                setTabHeight($("#tab1-1").get(0))
                break;
            case "2":
                $("#target1-2").show();
                var param = $("#goalRegLayerForm").serialize();
                $("#tab1-2").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboCompReg&"+param);
                setTabHeight($("#tab1-2").get(0))
                break;
        }
    }

    function showIframe2(iframeIdx2) {
		switch(iframeIdx2){
            case "1":
                var param = $("#goalRegLayerForm").serialize();
				$("#tab2-1").attr("src", "${ctx}/EvaMain.do?cmd=viewReferGoalSta&"+param);
                setTabHeight($("#tab2-1").get(0));
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

    function requestGoal() {
        if( !commCheck() ) return;
        if( mboTargetYn === "Y" && !checkTab1() ) return;
        if( compTargetYn === "Y" && !checkTab2() ) return;

        if(!isPopup()) {return;}

        chkAppPopup("Request");
    }

    //공통 체크
    function commCheck(){
        if($("#searchAppraisalCd", "#goalRegLayerForm").val() == "") {
            alert("평가명이 존재하지 않습니다.");
            return false;
        }

        if($("#searchAppOrgCd", "#goalRegLayerForm").val() == ""){
            alert("평가소속이 존재하지 않습니다.");
            return false;
        }

        if($("#searchAppSabun", "#goalRegLayerForm").val() == "") {
            alert("평가자가 존재하지 않습니다.");
            return false;
        }

        if($("#searchEvaSabun", "#goalRegLayerForm").val() == "") {
            alert("평가 대상자가 존재하지 않습니다.");
            return false;
        }

        return true;
    }

    //Tab1 Check
    function checkTab1(){

        if( $('#tab1-1').contents().find('#weightSum').text() !== '100%' ) {
            alert("업적의 가중치 합계가 100% 가 아니면 제출할 수 없습니다.");
            return false;
        }
        return true;

    }

    //Tab2 Check
    function checkTab2(){
        if( $('#tab1-2').contents().find('#weightSum').text() === '' ) {
            alert("역량탭 내용 을 확인하세요.");
            return false;
        }

        if( $('#tab1-2').contents().find('#weightSum').text() !== '100%' ) {
            alert("역량의 가중치 합계가 100% 가 아니면 제출할 수 없습니다.");
            return false;
        }
        return true;
    }

    function chkAppPopup(bg) {

        var args = {};

        var appYn = "";
        if(bg=="ChkApp"){
            appYn = "Y";
            args["lastAppSeqCd"] = $("#lastAppSeqCd", "#goalRegLayerForm").val();
        }else if(bg=="ChkReturn"){
            appYn = "N";
        }

        gPRow = "";
        pGubun = "mboTargetRegPopCommentRegLayer";

        args["searchAppraisalCd"] = $("#searchAppraisalCd", "#goalRegLayerForm").val();
        args["searchEvaSabun"] = $("#searchEvaSabun", "#goalRegLayerForm").val();
        args["searchAppOrgCd"] = $("#searchAppOrgCd", "#goalRegLayerForm").val();
        args["searchAppStepCd"] = $("#searchAppStepCd", "#goalRegLayerForm").val();
        args["searchAppStatusCd"] = $("#searchAppStatusCd", "#goalRegLayerForm").val();
        args["searchAppSeqCd"] = $("#searchAppSeqCd", "#goalRegLayerForm").val();
        args["searchAppSabun"] = $("#searchAppSabun", "#goalRegLayerForm").val();
        args["popGubun"] = bg;

        args["searchAppYn"] = appYn;

        var layer = new window.top.document.LayerModal({
            id : 'mboTargetRegPopCommentRegLayer'
            , url : "${ctx}/EvaMain.do?cmd=viewMboTargetRegPopCommentReg"
            , parameters: args
            , width : 500
            , height : 320
            , top: '50vh'
            , left: '50vw'
            , title : "의견등록"
            , trigger :[
                {
                    name : 'evaGoalCommentRegTrigger'
                    , callback : function(rv){
                        if(rv["popGubun"] === "Request" &&  rv["Code"] != "-1" ) {
                            $("#searchAppYn", "#goalRegLayerForm").val("");
                            $("#searchAppStatusCd", "#goalRegLayerForm").val(rv["searchAppStatusCd"]);
                            setTimeout(function(){
                                var data = ajaxCall("${ctx}/EvaMain.do?cmd=prcMboTargetReg1",$("#goalRegLayerForm").serialize(),false);

                                if(data.Result.Code == null) {
                                    alert("처리되었습니다.");
                                    setAppSabunInfo();
                                    showTargetTabs();
                                    showIframe2('1');
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
    }

    // 출력
    function showRd(){
        if ( $("#searchAppOrgCd").val() == ""  ) {
            alert("평가정보가 없습니다.");
            return;
        }

        var rdMrd	= "";
        var rdTitle = "";
        var rdParam = "";

        if($("#searchAppStepCd").val() == "1") {
            //목표승인
            rdMrd = "pap/progress/MboTargetStep1.mrd";
            rdTitle = "목표등록출력물";
        } else {
            //중간점검승인
            rdMrd = "pap/progress/MboTargetStep2.mrd";
            rdTitle = "중간점검출력물";
        }

        rdParam  = rdParam +"[${ssnEnterCd}] "; //회사코드
        rdParam  = rdParam +"["+ $("#searchAppraisalCd").val() +"] "; //평가ID
        rdParam  = rdParam +"[('"+ $("#searchEvaSabun").val() +"', '"+ $("#searchAppOrgCd").val() +"')] "; //피평가자 사번, 평가소속

        const data = {
            parameters : rdParam,
            rdMrd : rdMrd
        };

        window.top.showRdLayer('/EvaMain.do?cmd=getEncryptRd', data, null, rdTitle, null, null, '50vh', '50vw');
    }
</script>
<form name="goalRegLayerForm" id="goalRegLayerForm" method="post">
    <input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value=""/>
    <input type="hidden" id="searchEvaSabun" name="searchEvaSabun" value=""/>
    <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
    <input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value=""/>
    <input type="hidden" id="searchAppStatusCd" name="searchAppStatusCd" value=""/>
    <input type="hidden" id="searchAppSeqCd" name="searchAppSeqCd" value=""/>
    <input type="hidden" id="searchAppSabun" name="searchAppSabun" value=""/>
    <input type="hidden" id="searchTitle" name="searchTitle" value=""/>
</form>
<div class="hr-container target-modal p-0 full">
    <div class="modal-content border-0">
        <div class="modal-body p-0">
            <div class="row line">
                <div class="col scroll">
                    <div class="sub-title-wrap">
                        <div class="d-flex align-items-center">
                            <h3 id="goalRegTitle" class="h2 mr-2"></h3>
                            <span id="goalRegPeriod" class="date"></span>
                            <div class="btns ml-auto">
                                <a href="javascript:showRd()" class="btn outline-gray">출력</a>
                                <a href="javascript:requestGoal()" id="btnRequest" class="btn filled">등록완료</a>
                            </div>
                        </div>
                    </div>
                    <dl class="d-flex">
                        <dt class="profile">
                            <p class="thumb"><img id="goalRegSabunImg"></p>
                        </dt>
                        <dd>
                            <p id="goalRegName" class="name"><span id="goalRegJikweeNm" class="ml-2"></span></p>
                            <p id="goalRegOrgNm"></p>
                        </dd>
                        <dd>
                            <span>평가조직</span>
                            <p id="goalRegAppOrgNm" class="font-weight-bold"></p>
                        </dd>
                        <dd>
                            <span>평가상태</span>
                            <!-- finished:등록완료 non:미등록 ing:승인요청 -->
                            <div class="cate">
                                <span id="goalRegStatusNm" class="badge"></span>
                            </div>
                        </dd>
                    </dl>
                    <ul class="nav nav-tabs type1" id="targetTabs1">
                        <li class="nav-item">
                            <a id="mboTab" class="nav-link active" data-toggle="tab" href="#target1-1" onclick="javascript:showIframe1('1');">업적</a>
                        </li>
                        <li class="nav-item">
                            <a id="compTab" class="nav-link" data-toggle="tab" href="#target1-2" onclick="javascript:showIframe1('2');">역량</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="target1-1">
                            <iframe id="tab1-1" name="tab1-1" frameborder='0' scrolling="no" style="width:100%"></iframe>
                        </div>
                        <div class="tab-pane fade" id="target1-2">
                            <iframe id="tab1-2" name="tab1-2" frameborder='0' scrolling="no" style="width:100%"></iframe>
                        </div>
                    </div>
                </div>
                <div class="col scroll">
                    <ul class="nav nav-tabs modal-tabs mt-0 w-auto">
                        <li class="nav-item">
                            <a id="histTabTitle" class="nav-link active" data-toggle="tab" href="#target2-1" onclick="javascript:showIframe2('1');">목표진행이력</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="target2-1">
                            <iframe id="tab2-1" name="tab2-1" src='${ctx}/EvaMain.do?cmd=viewReferGoalSta' frameborder='0' scrolling="no" style="width:100%" onload="setTabHeight(this)"></iframe>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

