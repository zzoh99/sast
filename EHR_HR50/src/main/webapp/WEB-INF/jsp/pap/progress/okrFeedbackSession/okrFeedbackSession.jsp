<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<title>Feedback Session</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	
	//권한에 따른 화면 컨트롤방식 처리
	var sGrpCd = "${sessionScope.ssnGrpCd}";
	var sPapGrp = "O"; //P:임직원,O:권한(디폴트)
	
	if(sGrpCd == "99") { //임직원인경우
		sPapGrp = "P";
	}

	$(function() {
		
		if(sPapGrp == "O"){
			//성명,사번
			$("#searchAppSabun").val("${sessionScope.ssnSabun}");
			$("#searchAppName").val("${sessionScope.ssnName}");
			$("#searchKeyword").val("${sessionScope.ssnName}");
			$("#span_searchName").html("${sessionScope.ssnName}");
		} else {
			//성명,사번
			$("#searchSabun").val("${sessionScope.ssnSabun}");
			$("#searchName").val("${sessionScope.ssnName}");
			$("#searchKeyword").val("${sessionScope.ssnName}");
			$("#span_searchName").html("${sessionScope.ssnName}");
			setAppEmployee();
		}

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='detail_V3353' mdef='세부\n내역'/>",		Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0, UpdateEdit:0,	InsertEdit:0,	Cursor:"Pointer"},
			{Header:"<sht:txt mid='stateCdNm' mdef='진행상태'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='2023082500935' mdef='업무내용'/>",	Type:"Text",		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"workTitle",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000},
			{Header:"<sht:txt mid='2023082500932' mdef='정량/정성'/>",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"quaCd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"<sht:txt mid='2023082500936' mdef='기한'/>",			Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"termPeriod",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000},
			{Header:"<sht:txt mid='2023082501084' mdef='리뷰결과'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reviewCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='2023082501102' mdef='코멘트'/>",			Type:"Text",		Hidden:0,	Width:300,	Align:"Center",	ColMerge:0,	SaveName:"reviewComment",KeyField:0,UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000 },
			
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속",			Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가ID",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가소속코드",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"진행상태코드",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"팀목표순번",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq"},
			{Header:"업무순번",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"},
			{Header:"업무진행상태코드",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workStatusCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);
		
		// 업무진행상태
		var statusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30018"), ""); // 상시평가진행상태(업무)(P30018)
		sheet1.SetColProperty("statusCd", 	{ComboText:statusCdList[0], ComboCode:statusCdList[1]} );
		
		// 상시평가방법
		var quaCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30004"), ""); // 상시평가방법(P30004)
		sheet1.SetColProperty("quaCd", 	{ComboText:quaCdList[0], ComboCode:quaCdList[1]} );
		
		// 리뷰결과
		var reviewCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30003"), ""); // 상시평가리뷰결과(P30003)
		sheet1.SetColProperty("reviewCd", 	{ComboText:reviewCdList[0], ComboCode:reviewCdList[1]} );
		
		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListOkr&searchAppStepCd="+$('#searchAppStepCd').val(),false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		
		//관리자 또는 평가자권한인 경우에만 처리
		if(sPapGrp == "O"){
			setAppPeople();
			setWorkStatusNm();

			$("#searchAppPeople").bind("change",function(event){
				doAction1("Search");
				setWorkStatusNm();
			});
		} else {
			setAppOrgCdCombo();
			setAppEmployee();
			setWorkStatusNm();
		}
		
		// 이벤트 setting
		$("#searchAppraisalCd").bind("change",function(event){
			if(sPapGrp == "O"){
				setAppPeople(); //피평가자 리스트
				setWorkStatusNm();
			}
			doAction1("Search");
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//대상자
	function setAppPeople() {
		var appPeopleList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOkrAppPeopleList&"+$("#empForm").serialize(),false).codeList, "");
		$("#searchAppPeople").html("");
		$("#searchAppPeople").html(appPeopleList[2]);
	}
	
	//업무진행상태
	function setWorkStatusNm() {
		var result = ajaxCall( "${ctx}/OkrFeedbackSession.do?cmd=getOkrFeedbackSessionInfo", $("#empForm").serialize(),false);
		var workStatusCd = "";
		var workStatusNm = "";
		if ( result != null && result.DATA != null ){ 
			workStatusCd = result.DATA.workStatusCd;
			workStatusNm = result.DATA.workStatusNm;
		}
		$("#workStatusCd").val(workStatusCd);
		$("#workStatusNm").html(workStatusNm);
	}

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchAppName").val($("#searchKeyword").val());
		$("#searchAppSabun").val($("#searchUserId").val());
		setAppPeople(); //피평가자 리스트
		setWorkStatusNm(); //업무진행상태
		doAction1("Search");
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OkrFeedbackSession.do?cmd=getOkrFeedbackSessionList", $("#empForm").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "Feedback":
			if($("#searchAppPeople").val() == "") {
				alert("<msg:txt mid='2023082501105' mdef='피드백은 대상자 선택 후 등록해주세요.'/>");
				return;
			}
			showWorkDetailPopup();
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			
			if(sheet1.RowCount() > 0){ //리스트가 존재할 경우 피드백 버튼 활성화
				$("#btnFeedback").show();
			}
			
			//일정에 따라 버튼 활성화 및 분기에 대한 활성화처리
			var result = ajaxCall( "${ctx}/MboTargetPer.do?cmd=getMboTargetPerInfo", $("#empForm").serialize(),false);
			var appCheckSeq = "";
			if ( result != null && result.DATA != null ){ 
				appCheckSeq = result.DATA.appCheckSeq;
			}
			
			$("#searchAppCheckSeq").val(appCheckSeq);
			
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if (Row < sheet1.HeaderRows()) return;
			if ( sheet1.ColSaveName(Col) == "detail" ) {
				showDetailPopup('R',Row);
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	var showDetailPopup = function (authPg,Row) {
		if(!isPopup()) {return;}
		
		var args = new Array();
		var url = url = "${ctx}/OkrWorkReg.do?cmd=viewOkrWorkRegReviewPop";
		args["authPg"] = authPg;
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		args["searchAppStepCd"] = $("#searchAppStepCd").val();
		args["searchAppSabun"] = $("#searchAppSabun").val();
		args["searchAppName"] = $("#searchAppName").val();
		args["searchAppOrgCd"] = sheet1.GetCellValue(Row, "appOrgCd");
		args["searchSabun"] = sheet1.GetCellValue(Row, "sabun");
		args["searchPriorSeq"] = sheet1.GetCellValue(Row, "priorSeq");
		args["searchSeq"] = sheet1.GetCellValue(Row, "seq");
		args["searchStatusCd"] = sheet1.GetCellValue(Row, "statusCd");
		
		gPRow = Row;
		pGubun = "okrWorkRegPop";
		
		openPopup(url,args,800,980);
	};

	//피드백팝업
	var showWorkDetailPopup = function () {
		if(!isPopup()) {return;}
		
		var args = new Array();
		var url = url = "${ctx}/OkrFeedbackSession.do?cmd=viewOkrFeedbackSessionPop";
		args["authPg"] = "A";
		if(sPapGrp == "O"){
		args["adminCheck"] = "A";
		}else{
		args["adminCheck"] = "U";	
		}
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		args["searchAppStepCd"] = $("#searchAppStepCd").val();
		args["searchAppSabun"] = $("#searchAppSabun").val();
		if(sPapGrp == "O"){ //관리자 및 평가자
			args["searchSabun"] = $("#searchAppPeople").val();
		}else{ //피평가자
			args["searchSabun"] = $("#searchSabun").val();
		}
		args["searchAppCheckSeq"] = $("#searchAppCheckSeq").val();
		args["searchWorkStatusCd"] = $("#workStatusCd").val();

		pGubun = "okrFeedbackSessionPop";
		
		openPopup(url,args,800,400);
	};
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		
		if(pGubun == "okrFeedbackSessionPop") {
			setWorkStatusNm(); //업무진행상태
		}
		doAction1("Search");
	}
	
	//평가소속 setting(평가명 change, 성명 팝업 선택 후)
	function setAppOrgCdCombo() {
		$("#searchAppOrgCd").html("");

		var appOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&"
			,"queryId=getAppOrgCdListMboTarget"
			+"&searchAppraisalCd="+$("#searchAppraisalCd").val()
			+"&searchSabun="+$("#searchSabun").val()
			+"&searchAppStepCd="+$("#searchAppStepCd").val()
			+"&searchAppYn=Y"
			,false).codeList, ""); // 평가소속
		
		$("#searchAppOrgCd").val(appOrgCdList[1]);
		$("#searchAppOrgCd").change();
	}
	
	//피평가자정보조회(평가소속 change)
	function setAppEmployee() {
		$("#searchAppSabun").val("");
		
		$("#searchAppName").val("");
		$("#span_searchAppName").html("");

		var data = ajaxCall("${ctx}/OkrWorkReg.do?cmd=getOkrWorkRegMapAppEmployee",$("#empForm").serialize(),false);
		
		if(data != null && data.map != null) {
			$("#searchAppSabun").val(data.map.appSabun);
			$("#searchAppName").val(data.map.appName);
			$("#span_searchAppName").html(data.map.appName);
		}
		doAction1("Search");
	}
	
</script>
</head>

<body class="bodywrap">
<div class="wrapper">
	<form id="empForm" name="empForm" >
	<input type="hidden" name="searchAppStepCd"		id="searchAppStepCd"	value="${map.searchAppStepCd}">
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->
	<input type="hidden" id="searchEmpType"			name="searchEmpType" value="I"/>
	<input type="hidden" id="searchUserId"			name="searchUserId" value="" />
	<input type="hidden" id="searchUserEnterCd"		name="searchUserEnterCd" value="" />
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->
	<input type="hidden" id="searchAppCheckSeq"		name="searchAppCheckSeq" value="" />
	<input type="hidden" id="searchAppOrgCd"		name="searchAppOrgCd" value="" />

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span><tit:txt mid='111888' mdef='평가명'/></span>
				<select id="searchAppraisalCd" name="searchAppraisalCd" class="required" required> </select>
			</td>
<c:set var="sGrpCd" value="${sessionScope.ssnGrpCd}" />
<c:set var="sPapGrp" value="O" /> <!-- P:임직원,O:권한(디폴트) -->
<c:if test="${sGrpCd == '99'}">
	<c:set var="sPapGrp" value="P" />
</c:if>
	<c:choose>
		<c:when test="${sPapGrp == 'O'}">
			<td><span><tit:txt mid='113683' mdef='평가자'/></span>
				<input id="searchAppSabun" name ="searchAppSabun" type="hidden" class="text"	/>
				<input id="searchAppName" name ="searchAppName" type="hidden" class="text"	/>
				<!-- <input type="text" id="searchKeyword" name="searchKeyword" class="text w100" style="ime-mode:active"/> -->
				<c:choose>
					<c:when test="${ sessionScope.ssnPapAdminYn == 'Y' }">
							<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
					</c:when>
					<c:otherwise>
							<input type="hidden" id="searchKeyword" name="searchKeyword" />
							<span id="span_searchName" class="txt pap_span f_normal"></span>
					</c:otherwise>
				</c:choose>
			</td>
			<td>
				<span><tit:txt mid='103863' mdef='대상자'/></span>
				<select id="searchAppPeople" name="searchAppPeople" class="required" required> </select>
			</td>
		</c:when>
		<c:otherwise>
			<td>
				<span class="w40"><tit:txt mid='113683' mdef='평가자'/> </span>
				<input id="searchAppName" name ="searchAppName" type="hidden" class="text readonly" readonly />
				<span id="span_searchAppName" class="txt pap_span f_normal"></span>
			</td>
			<td>
				<span class="w40"><tit:txt mid='113302' mdef='성명'/></span>
				<input id="searchSabun" name ="searchSabun" type="hidden" />
				<input id="searchName" name ="searchName" type="hidden" />
				<input type="hidden" id="searchKeyword" name="searchKeyword" />
				<span id="span_searchName" class="txt pap_span f_normal"></span>
			</td>
		</c:otherwise>
	</c:choose>
			<td>
				<span><tit:txt mid='2023082501104' mdef='업무진행상태'/></span>
				<input id="workStatusCd" name ="workStatusCd" type="hidden" />
				<span id="workStatusNm" class="txt pap_span f_normal"></span>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt" id="pageTitle">Feedback Session</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Feedback');"   css='basic pink authR' mid='2023082501103' mdef="피드백" id="btnFeedback" style="display:none;"/>
						<btn:a href="javascript:doAction1('Down2Excel');" css='basic authR' mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>