<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
    var sSabun = "";
    $(function () {
        const modal = window.top.document.LayerModalUtility.getModal('goalAprLayer');
        var args = modal.parameters;
        $("#searchAppSabun").val(args.searchAppSabun);
        $("#searchAppraisalCd").val(args.searchAppraisalCd);
        $("#searchAppSeqCd").val(args.searchAppSeqCd);
        $("#searchAppStepCd").val(args.searchAppStepCd);
        $("#searchTitle").val(args.searchTitle);

        if($("#searchAppStepCd", "#goalAprLayerForm").val() == '3') {
            $("#histTabTitle").text('중간점검진행이력');
        }

        createIBSheet3(document.getElementById('goalAprLayerSht1-wrap'), "goalAprLayerSht1", "0px", "0px", "${ssnLocaleCd}");

        var appClassCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y&visualYn=Y","P00001"), ""); // 평가등급(P00001)
        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
            {Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"상태",		Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"출력선택",				Type:"DummyCheck",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chk",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            {Header:"성명",					Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"사번",					Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"호칭",					Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"소속",					Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"직급",					Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"직위",					Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"입사일",					Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

            {Header:"목표승인",				Type:"Image",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"진행상태",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

            {Header:"중간평가등급",			Type:"Combo",		Hidden:1,		Width:100,	Align:"Center",	ColMerge:0,	SaveName:"middleAppClassCd",KeyField:0,	UpdateEdit:1,	InsertEdit:1,	ComboText: appClassCdList[0], ComboCode: appClassCdList[1]},
            {Header:"의견",					Type:"Text",		Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"middleAppMemo",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:1500},

            {Header:"중간점검의견\n등록여부",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"middleMemoYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

            {Header:"평가ID",				Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"평가소속코드",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"진행상태코드",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"마지막평가차수",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"lastAppSeqCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"수정가능여부",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"editable",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

            // Hidden
            {Header:"직무",           Type:"Text",    Hidden:1,  SaveName:"jobNm"},
            {Header:"업적평가여부",   Type:"Text",    Hidden:1,	SaveName:"mboTargetYn"},
            {Header:"역량평가여부",   Type:"Text",    Hidden:1,	SaveName:"compTargetYn"}
        ]; IBS_InitSheet(goalAprLayerSht1, initdata);goalAprLayerSht1.SetEditable("${editable}");goalAprLayerSht1.SetVisible(true);goalAprLayerSht1.SetCountPosition(4);goalAprLayerSht1.SetUnicodeByte(3);

        goalAprLayerSht1.SetEditEnterBehavior("newline");
        goalAprLayerSht1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
        goalAprLayerSht1.SetDataLinkMouse("detail",1);
        $("#goalAprLayerSht1-wrap").hide();

        $("#target1-1").hide();
        $("#target1-2").hide();
        $("#target2-1").hide();
        $("#target2-2").hide();
        doAction1('Search');
    });

    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                goalAprLayerSht1.DoSearch( "${ctx}/EvaMain.do?cmd=getMboTargetAprList", $("#goalAprLayerForm").serialize() );
                break;

            case "ChkApp": //승인
                if( !commCheck() ) return;
                if(!isPopup()) {return;}
                chkAppPopup("ChkApp");
                break;
                
            case "ChkReturn": //반려
                if( !commCheck() ) return;
                if(!isPopup()) {return;}
                chkAppPopup("ChkReturn");
                break;
        }
    }

    //공통 체크
    function commCheck(){
        if($("#searchAppraisalCd", "#goalAprLayerForm").val() == "") {
            alert("평가명이 존재하지 않습니다.");
            return false;
        }

        if($("#searchAppOrgCd", "#goalAprLayerForm").val() == ""){
            alert("평가소속이 존재하지 않습니다.");
            return false;
        }

        if($("#searchAppSabun", "#goalAprLayerForm").val() == "") {
            alert("평가자가 존재하지 않습니다.");
            return false;
        }

        if($("#searchEvaSabun", "#goalAprLayerForm").val() == "") {
            alert("평가 대상자가 존재하지 않습니다.");
            return false;
        }

        return true;
    }

    // 조회 후 에러 메시지
    function goalAprLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try{
            if (Msg != "") alert(Msg);

            var sSabunRow = '';
            var searchAppSeqCd = $("#searchAppSeqCd").val();
            var maxCnt = 0, curCnt = 0;
            var orgCd = '', html = '';
            for(var i = goalAprLayerSht1.HeaderRows(); i < goalAprLayerSht1.RowCount()+goalAprLayerSht1.HeaderRows() ; i++) {

                let appOrgCd = goalAprLayerSht1.GetCellValue(i, "appOrgCd");
                if(i === goalAprLayerSht1.RowCount()+goalAprLayerSht1.HeaderRows()-1) {
                    html += '</div>';
                    html = curCnt > 0 ? html.replace(`<span id="${'${orgCd}'}CurCnt" className="current">0</span>`, `<span id="${'${orgCd}'}CurCnt" className="current">${'${curCnt}'}</span>`) : html;
                    html = maxCnt > 0 ? html.replace(`<span id="${'${orgCd}'}MaxCnt" class="total">/0</span>`, `<span id="${'${orgCd}'}MaxCnt" className="total">/${'${maxCnt}'}</span>`) : html;
                }

                if(orgCd !== appOrgCd) {
                    if(i !== goalAprLayerSht1.HeaderRows()) {
                        html += '</div>';
                        html = curCnt > 0 ? html.replace(`<span id="${'${orgCd}'}CurCnt" class="current">0</span>`, `<span id="${'${orgCd}'}CurCnt" class="current">${'${curCnt}'}</span>`) : html;
                        html = maxCnt > 0 ? html.replace(`<span id="${'${orgCd}'}MaxCnt" class="total">/0</span>`, `<span id="${'${orgCd}'}MaxCnt" class="total">/${'${maxCnt}'}</span>`) : html;
                    }

                    let appOrgNm = goalAprLayerSht1.GetCellValue(i, "appOrgNm");
                    html += `<h4 class="h4 mr-1 d-inline-block">${'${appOrgNm}'}</h4>
                            <div class="caption-sm d-inline-block">
                                <span id="${'${appOrgCd}'}CurCnt" class="current">0</span><span id="${'${appOrgCd}'}MaxCnt" class="total">/0</span>
                            </div>
                            <div class="box p-0 flex-column mt-2">`;

                    // 초기화
                    orgCd = appOrgCd;
                    maxCnt = 0;
                    curCnt = 0;
                }

                var statusCd = goalAprLayerSht1.GetCellValue(i, "statusCd");
                let sabun = goalAprLayerSht1.GetCellValue(i, "sabun");
                // 선택한 사번으로 자동 조회하기 위한 sSabunRow 값 구하기
                sSabunRow = sSabun === sabun ? i : sSabunRow;

                let datetime = new Date().getTime();
                let imageUrl = '/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + goalAprLayerSht1.GetCellValue(i, "sabun") + '&t=' + datetime;
                let name = goalAprLayerSht1.GetCellValue(i, "name");
                let jikweeNm = goalAprLayerSht1.GetCellValue(i, "jikweeNm");
                let jobNm = goalAprLayerSht1.GetCellValue(i, "jobNm");
                let statusNm = goalAprLayerSht1.GetCellValue(i, "statusNm");
                let statusClass = 'green';
                if(statusCd === '11') {
                    statusClass = 'gray';
                } else if (Number(searchAppSeqCd)+1+'1' === statusCd) {
                    statusClass = 'blue';
                }
                html += `<div id="aprCard${'${sabun}'}" name="aprCard" class="box box-border pointer" onclick="searchMbo(${'${i}'}); activeCard(this); ">
                            <p class="thumb mr-0"><img src="${'${imageUrl}'}"></p>
                            <div class="d-flex flex-column">
                                <div class="d-inline-block">
                                    <span class="name">${'${name}'}</span>
                                    <span class="caption-sm text-boulder">${'${jikweeNm}'}</span>
                                </div>
                                <p class="caption-sm text-boulder pt-2">${'${jobNm}'}</p>
                            </div>
                            <p class="badge sm ${'${statusClass}'} ml-auto">${'${statusNm}'}</p>
                        </div>`

                /*
                P10018(평가진행상태)
                11	미제출
                21	승인요청
                23	1차반려
                25	1차승인
                31	2차승인요청
                33	2차반려
                35	2차승인
                41	3차승인요청
                43	3차반려
                99	최종승인
                */
                maxCnt++;
                curCnt++;
                switch (searchAppSeqCd) {
                    // 1차평가
                    case "1":
                        // 11(미제출), 21(1차승인요청)
                        if (statusCd === "11" || statusCd === '21') curCnt--;
                        break;
                    // 2차평가
                    case "2":
                        // 11(미제출), 21(1차승인요청), 23(1차반려), 25(1차승인), 31(2차승인요청)
                        if (statusCd === "11" ||
                            statusCd === '21' || statusCd === '23' || statusCd === '25' ||
                            statusCd === '31') curCnt--;
                        break;
                    // 3차평가
                    case "6":
                        // 11(미제출), 21(1차승인요청), 23(1차반려), 25(1차승인), 31(2차승인요청), 33(2차반려), 35(2차승인), 41(3차승인요청)
                        if (statusCd === "11" ||
                            statusCd === '21' || statusCd === '23' || statusCd === '25' ||
                            statusCd === '31' || statusCd === '33' || statusCd === '35' ||
                            statusCd === '41' ) curCnt--;
                        break;
                    default:
                        break;
                }
            }
            $("#goalAprOrgSabunWrap").html(html);

            if(sSabunRow !== '') {
                searchMbo(sSabunRow)
                activeCard($("#aprCard"+sSabun).get(0))
            } else if(goalAprLayerSht1.RowCount() > 0) {
                searchMbo(goalAprLayerSht1.HeaderRows());
                activeCard($("#aprCard"+goalAprLayerSht1.GetCellValue(goalAprLayerSht1.HeaderRows(), 'sabun')).get(0))
            }

            sheetResize();
        }catch(ex){
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 선택한 카드의 CSS 변경
    function activeCard(obj) {
        $('div[name="aprCard"]').removeClass('active');
        $(obj).addClass('active');
    }

    // 선택한 피평가자의 업적 조회
    function searchMbo(Row){
        sSabun = goalAprLayerSht1.GetCellValue(Row, "sabun");

        // 반려, 승인 버튼
        $("#aprBtnWrap").addClass("hide");
        /*
        P10018(평가진행상태)
        11	미제출
        21	승인요청
        23	1차반려
        25	1차승인
        31	2차승인요청
        33	2차반려
        35	2차승인
        41	3차승인요청
        43	3차반려
        99	최종승인
        */
        var searchAppSeqCd = $("#searchAppSeqCd").val();
        var statusCd = goalAprLayerSht1.GetCellValue(Row, "statusCd");
        switch (searchAppSeqCd) {
            // 1차평가
            case "1":
                // 21(승인요청)
                if (statusCd == "21")
                    $("#aprBtnWrap").removeClass("hide");
                break;
            // 2차평가
            case "2":
                // 25(1차승인), 31(2차승인요청)
                if (statusCd == "25" || statusCd == "31")
                    $("#aprBtnWrap").removeClass("hide");
                break;
            // 3차평가
            case "6":
                // 35(2차승인), 41(3차승인요청)
                if (statusCd == "35" || statusCd == "41")
                    $("#aprBtnWrap").removeClass("hide");
                break;
            default:
                break;
        }

        $("#searchEvaSabun", "#goalAprLayerForm").val(goalAprLayerSht1.GetCellValue(Row, "sabun"))
        $("#searchAppOrgCd", "#goalAprLayerForm").val(goalAprLayerSht1.GetCellValue(Row, "appOrgCd"))
        $("#lastAppSeqCd", "#goalAprLayerForm").val(goalAprLayerSht1.GetCellValue(Row, "lastAppSeqCd"))

        setAppSabunInfo();
        if(goalAprLayerSht1.GetCellValue(Row, "statusCd") === '11') {
            $("#searchEvaSabun", "#goalAprLayerForm").val('')
            $("#mboTab").hide();
            $("#compTab").hide();
            $("#target1-1").hide();
            $("#target1-2").hide();
            $("#target2-1").hide();
            $("#target2-2").hide();
            alert("현재 미제출 또는 작성중 상태입니다.");
            $("#btnPrint").hide();

            showTargetTabs('N', 'N');
        } else {
            var mboTargetYn  = goalAprLayerSht1.GetCellValue(Row, "mboTargetYn");		// 업적평가여부
            var compTargetYn = goalAprLayerSht1.GetCellValue(Row, "compTargetYn");		// 역량평가여부
            showTargetTabs(mboTargetYn, compTargetYn);
            $("#btnPrint").show();
        }
    }

    function showTargetTabs(mboTargetYn, compTargetYn) {
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

        $(".tab2.active").click();
    }

    // 평가대상자 정보 세팅
    function setAppSabunInfo() {
        const data = ajaxCall('/EvaMain.do?cmd=getAppSabunMap', $("#goalAprLayerForm").serialize(), false).DATA;
        if(data != null && data !== 'undefined') {
            $("#aprTitle").text(data.title);
            $("#aprPeriod").text(data.period);
            let datetime = new Date().getTime();
            let imageUrl = '/EmpPhotoOut.do?enterCd=' + data.enterCd + '&searchKeyword=' + data.sabun + '&t=' + datetime;
            $('#aprSabunImg').attr('src', imageUrl);
            $("#aprName").text(data.name);
            $("#aprJikweeNm").text(data.jikweeNm);
            $("#aprAppOrgNm").text(data.appOrgNm);

            let statusClass = 'blue';
            if (data.statusCd === '11') statusClass = 'gray'
            else if (data.statusCd === '99') statusClass = 'green'
            $("#aprAppStatusNm").text(data.statusNm);
            $("#aprAppStatusNm").removeClass();
            $("#aprAppStatusNm").addClass("badge " + statusClass);

            $("#searchAppStatusCd", "#goalAprLayerForm").val(data.statusCd);
            $("#searchAppSabun", "#goalAprLayerForm").val(data.appSabun);

        }
    }

    function showIframe1(iframeIdx1) {
        $("#target1-"+iframeIdx1).show();
        $("[id^='target1-']:not(#target1-" + iframeIdx1 + ")").hide();
        switch(iframeIdx1){
            case "1":
                $("#target1-1").show();
                var param = $("#goalAprLayerForm").serialize();
                param += '&editableYn=N'
                $("#tab1-1").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboReg&"+param);
                setTabHeight($("#tab1-1").get(0))
                break;
            case "2":
                $("#target1-2").show();
                var param = $("#goalAprLayerForm").serialize();
                param += '&editableYn=N'
                $("#tab1-2").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboCompReg&"+param);
                setTabHeight($("#tab1-2").get(0))
                break;
        }
    }

    function showIframe2(iframeIdx2) {
        $("#target2-"+iframeIdx2).show();
        $("[id^='target2-']:not(#target2-" + iframeIdx2 + ")").hide();

        switch(iframeIdx2){
			case "1":
                var param = $("#goalAprLayerForm").serialize();
				$("#tab2-1").attr("src", "${ctx}/EvaMain.do?cmd=viewReferIntvHst&"+param);
                setTabHeight($("#tab2-1").get(0))
				break;
            case "2":
                var param = $("#goalAprLayerForm").serialize();
                $("#tab2-2").attr("src", "${ctx}/EvaMain.do?cmd=viewReferGoalSta&"+param);
                setTabHeight($("#tab2-2").get(0))
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

    function chkAppPopup(bg) {

        var args = {};

        var appYn = "";
        if(bg=="ChkApp"){
            appYn = "Y";
            args["lastAppSeqCd"] = $("#lastAppSeqCd", "#goalAprLayerForm").val();
        }else if(bg=="ChkReturn"){
            appYn = "N";
        }

        pGubun = "evaGoalCommentReg";

        args["searchAppraisalCd"] = $("#searchAppraisalCd", "#goalAprLayerForm").val();
        args["searchEvaSabun"] = $("#searchEvaSabun", "#goalAprLayerForm").val();
        args["searchAppOrgCd"] = $("#searchAppOrgCd", "#goalAprLayerForm").val();
        args["searchAppStepCd"] = $("#searchAppStepCd", "#goalAprLayerForm").val();
        args["searchAppStatusCd"] = $("#searchAppStatusCd", "#goalAprLayerForm").val();
        args["searchAppSeqCd"] = $("#searchAppSeqCd", "#goalAprLayerForm").val();
        args["searchAppSabun"] = $("#searchAppSabun", "#goalAprLayerForm").val();
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
                        if(rv["popGubun"]=="ChkApp") {
                            if ( rv["Code"] != "-1" )	{
                                $("#searchAppYn", "#goalAprLayerForm").val("Y");

                                setTimeout(function(){
                                    var data = ajaxCall("${ctx}/EvaMain.do?cmd=prcMboTargetReg2",$("#goalAprLayerForm").serialize(),false);

                                    if(data.Result.Code == null) {
                                        alert( "승인 처리되었습니다.");
                                        $("#searchEvaSabun", "#goalAprLayerForm").val('')
                                        $("#searchAppOrgCd", "#goalAprLayerForm").val('')
                                        doAction1('Search');
                                    } else {
                                        alert(data.Result.Message);
                                    }

                                }, 300);
                            }
                        } else if(rv["popGubun"]=="ChkReturn") {
                            if ( rv["Code"] != "-1" )	{
                                $("#searchAppYn", "#goalAprLayerForm").val("N");
                                setTimeout(function(){
                                    var data = ajaxCall("${ctx}/EvaMain.do?cmd=prcMboTargetReg2",$("#goalAprLayerForm").serialize(),false);

                                    if(data.Result.Code == null) {
                                        alert( "반려 처리되었습니다.");
                                        $("#searchEvaSabun", "#goalAprLayerForm").val('')
                                        $("#searchAppOrgCd", "#goalAprLayerForm").val('')
                                        doAction1('Search');
                                    } else {
                                        alert(data.Result.Message);
                                    }
                                }, 300);
                            }
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
<form name="goalAprLayerForm" id="goalAprLayerForm" method="post">
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
            <div class="d-flex gap-20">
                <div class="line position-relative">
                    <div class="scroll">
                        <div id="goalAprOrgSabunWrap" class="current-situation-list"></div>
                    </div>
                </div>
                <div id="goalAprLayerSht1-wrap" class="hide"></div>
                <div class="row line flex-grow-1">
                    <div class="col scroll">
                        <div class="sub-title-wrap">
                            <div class="d-flex align-items-center">
                                <h3 id="aprTitle" class="h2 mr-2"></h3>
                                <span id="aprPeriod" class="date"></span>
                                <div class="btns ml-auto">
                                    <a href="javascript:showRd()" id="btnPrint" class="btn outline-gray">출력</a>
                                </div>
                                <div id="aprBtnWrap" class="btns big-btns ml-2 hide">
                                    <a href="javascript:doAction1('ChkReturn')"		class="btn red-btn" id="btnReturn">반려</a>
                                    <a href="javascript:doAction1('ChkApp')"			class="btn filled" id="btnApp">승인</a>
                                </div>
                            </div>
                        </div>
                        <dl class="d-flex">
                            <dt class="profile">
                                <p class="thumb"><img id="aprSabunImg"></p>
                            </dt>
                            <dd>
                                <p id="aprName" class="name"><span id="aprJikweeNm" class="ml-2"></span></p>
                                <p>부서명</p>
                            </dd>
                            <dd>
                                <span>평가조직</span>
                                <p id="aprAppOrgNm"></p>
                            </dd>
                            <dd>
                                <span>평가상태</span>
                                <div class="cate">
                                    <span id="aprAppStatusNm" class="badge"></span>
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
                                <a class="nav-link active tab2" data-toggle="tab" href="#target2-1" onclick="javascript:showIframe2('1');">면담내역</a>
                            </li>
                            <li class="nav-item">
                                <a id="histTabTitle" class="nav-link tab2" data-toggle="tab" href="#target2-2" onclick="javascript:showIframe2('2');">목표진행이력</a>
                            </li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane fade show active" id="target2-1">
                                <iframe id="tab2-1" name="tab2-1" src='${ctx}/EvaMain.do?cmd=viewReferIntvHst' frameborder='0' scrolling="no" style="width:100%"></iframe>
                            </div>
                            <div class="tab-pane fade" id="target2-2">
                                <iframe id="tab2-2" name="tab2-2" src='${ctx}/EvaMain.do?cmd=viewReferGoalSta' frameborder='0' scrolling="no" style="width:100%"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


