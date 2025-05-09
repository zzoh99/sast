<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var adminCheck = "";

 $(function() {
	//성명,사번
	$("#searchSabun").val("${sessionScope.ssnSabun}");
	$("#searchName").val("${sessionScope.ssnName}");
	$("#searchKeyword").val("${sessionScope.ssnName}");
	$("#span_searchName").html("${sessionScope.ssnName}");

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msAll,Page:22};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
	{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
	{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
	{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
	{Header:"<sht:txt mid='detail_V3353' mdef='세부\n내역'/>",		Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0, UpdateEdit:0,	InsertEdit:0,	Cursor:"Pointer"},
	{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",				KeyField:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
	{Header:"<sht:txt mid='stateCdNm' mdef='진행상태'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
	{Header:"<sht:txt mid='sResult_V667' mdef='결과'/>",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reviewCd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
	{Header:"<sht:txt mid='2023082500935' mdef='업무내용'/>",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"workTitle",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000},
	{Header:"<sht:txt mid='2023082500932' mdef='정량/정성'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"quaCd",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
	{Header:"<sht:txt mid='2023082500936' mdef='기한'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"deadlineDate",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
	{Header:"Co-worker",	Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"coworkerList",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000},
	{Header:"<sht:txt mid='actMemo' mdef='실적'/>",			Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail1",			KeyField:0, UpdateEdit:0,   InsertEdit:0,   Cursor:"Pointer"},
	{Header:"<sht:txt mid='2023082500937' mdef='평가자점검'/>",		Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail2",			KeyField:0, UpdateEdit:0,   InsertEdit:0,   Cursor:"Pointer"},

	{Header:"평가ID",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
	{Header:"평가소속",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
	{Header:"사원번호",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
	{Header:"팀목표순번",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq"},
	{Header:"업무순번",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"},
	{Header:"업무진행상태코드",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workStatusCd"}
	]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

	sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
	sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_popup.png");

	sheet1.SetDataLinkMouse("detail",1);
	sheet1.SetDataLinkMouse("detail1",1);
	sheet1.SetDataLinkMouse("detail2",1);

	// 업무진행상태
	var statusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30018"), ""); // 상시평가진행상태(업무)(P30018)
	sheet1.SetColProperty("statusCd", 	{ComboText:statusCdList[0], ComboCode:statusCdList[1]} );

	// 리뷰결과
	var reviewCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30003"), ""); // 상시평가리뷰결과(P30003)
	sheet1.SetColProperty("reviewCd", 	{ComboText:reviewCdList[0], ComboCode:reviewCdList[1]} );

	// 상시평가방법
	var quaCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30004"), ""); // 상시평가방법(P30004)
	sheet1.SetColProperty("quaCd", 	{ComboText:quaCdList[0], ComboCode:quaCdList[1]} );

	$(window).smartresize(sheetResize); sheetInit();

	//평가명
	var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListOkr&searchAppStepCd="+$('#searchAppStepCd').val(),false).codeList, ""); // 평가명
	$("#searchAppraisalCd").html(appraisalCdList[2]);
	
	$("#searchAppraisalCd").change();
	setAppOrgCdCombo();
	setAppEmployee();
	
	// 조회조건 이벤트 등록
	$("#searchAppraisalCd").bind("change",function(event){
		setAppOrgCdCombo();
	});

	$("#searchAppOrgCd").bind("change",function(event){
		setAppEmployee();
	});
	
	doAction1("Search");
});

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
	
	$("#searchAppOrgCd").html(appOrgCdList[2]);
	$("#searchAppOrgCd").change();
}

// 임직원조회 자동완성 결과 세팅 처리
function setEmpPage(){
	$("#searchName").val($("#searchKeyword").val());
	$("#searchSabun").val($("#searchUserId").val());
	setAppOrgCdCombo();
}

//피평가자, 평가자정보조회(평가소속 change)
function setAppEmployee() {
	$("#searchAppSabun").val("");
	//$("#searchAppStatusCd").val("");
	
	$("#searchAppName").val("");
	$("#span_searchAppName").html("");
	$("#searchJikweeNm").val("");
	$("#span_searchJikweeNm").html("");
	$("#searchStatus").val("");

	var data = ajaxCall("${ctx}/OkrWorkReg.do?cmd=getOkrWorkRegMapAppEmployee",$("#empForm").serialize(),false);
	
	if(data != null && data.map != null) {
		$("#searchAppSabun").val(data.map.appSabun);
		//$("#searchAppStatusCd").val(data.map.workStatusCd);
		
		$("#searchAppName").val(data.map.appName);
		$("#span_searchAppName").html(data.map.appName);
		$("#searchJikweeNm").val(data.map.jikweeNm);
		$("#span_searchJikweeNm").html(data.map.jikweeNm);
		
		//$("#searchWorkStatus").val(data.map.workStatusNm);
		//$("#span_searchWorkStatus").html(data.map.workStatusNm);
		$("#searchAppraisalYn").val(data.map.appraisalYn); //평가완료여부
		
		if($("#searchAppName").val() != ""){
			$("#btnInsert").removeClass("hide");
			$("#btnRequest").removeClass("hide");
			$("#btnSave").removeClass("hide");
		} else {
			$("#btnInsert").addClass("hide");
			$("#btnRequest").addClass("hide");
			$("#btnSave").addClass("hide");
		}
	} else {
		$("#btnInsert").addClass("hide");
		$("#btnRequest").addClass("hide");
	}
	
	doAction1("Search");
}
	
//공통 체크
function commCheck(){
	if($("#searchAppraisalCd").val() == "") {
		alert("<msg:txt mid='110470' mdef='평가명이 존재하지 않습니다.'/>");
		return false;
	}

	if($("#searchAppOrgCd").val() == ""){
		alert("<msg:txt mid='109905' mdef='평가소속이 존재하지 않습니다.'/>");
		return false;
	}

	if($("#searchAppName").val() == "") {
		alert("<msg:txt mid='109904' mdef='평가자가 존재하지 않습니다.'/>");
		return false;
	}

	if($("#searchSabun").val() == "") {
		alert("<msg:txt mid='2023082400773' mdef='평가 대상자가 존재하지 않습니다.'/>");
		return false;
	}
	
	return true;
}
	
function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OkrWorkReg.do?cmd=getOkrWorkRegList", $("#empForm").serialize() );
			break;
		case "Save":
			//if(!dupChk(sheet1,"orderSeq", true, true)){break;}
			IBS_SaveName(document.empForm,sheet1);
			sheet1.DoSave( "${ctx}/OkrWorkReg.do?cmd=saveOkrWorkReg1", $("#empForm").serialize());
			break;
		case "Insert":
			showDetailPopup('A', 0, 'detail');
			break;
		case "Request": //승인요청
			if( !commCheck() ) return;
			
			var requestCnt = 0;
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				if((sheet1.GetCellValue(i, "statusCd") == "" || sheet1.GetCellValue(i, "statusCd") == "11" || sheet1.GetCellValue(i, "statusCd") == "23") && sheet1.GetCellValue(i, "chk") == "1"){
					sheet1.SetCellValue(i, "sStatus", "U");
					requestCnt++;
				}
			}
			
			if(requestCnt < 1){
				alert("<msg:txt mid='2023082501079' mdef='승인요청 대상이 존재하지 않습니다.'/>");
				return;
			}
			
			if(confirm("<msg:txt mid='2023082501078' mdef='선택한 업무를 승인요청 하시겠습니까?'/>")) {
				
				$("#searchStatusCd").val("21"); //승인요청
				
				IBS_SaveName(document.empForm,sheet1);
				sheet1.DoSave( "${ctx}/OkrWorkReg.do?cmd=updateOkrWorkRegStatusCd", $("#empForm").serialize(), -1, 0);
			}
			
			break;
		case "Down2Excel":
			var downcol = makeHiddenImgSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
	return true;
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") { alert(Msg); }
		
		for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
			var statusCd = sheet1.GetCellValue(i, "statusCd");
			
			// 작성중이 아닌경우 삭제와 선택체크박스 선택 불가
			if (statusCd != "11" && statusCd != "23"){
				sheet1.SetCellEditable(i, "sDelete", 0);
				sheet1.SetCellEditable(i, "chk", 0);
			}
		}
		
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != "") alert(Msg);
		
		$("#searchStatusCd").val(""); //초기화
		
		doAction1("Search");
	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try{
		// 세부내역, 실적, 평가자점검 이미지 선택 시
		if(sheet1.ColSaveName(Col) == "detail" || sheet1.ColSaveName(Col) == "detail1" || sheet1.ColSaveName(Col) == "detail2"){
			showDetailPopup('R',Row, sheet1.ColSaveName(Col));
		}
	}catch(ex){
		alert("OnClick Event Error : " + ex);
	}
}

var showDetailPopup = function (authPg,Row, btn) {
	if(!isPopup()) {return;}
	
	var args = new Array();
	var url = "";
	var popW = 800;
	var popH = 800;
	
	if(btn == "detail"){ //상세
		adminCheck = "USER";
		url = "${ctx}/OkrWorkReg.do?cmd=viewOkrWorkRegPopDetail";
	} else if(btn == "detail1"){ //실적
		url = "${ctx}/OkrWorkReg.do?cmd=viewOkrWorkRegPerPop";
	} else if(btn == "detail2"){ //평가자점검
		url = "${ctx}/OkrWorkReg.do?cmd=viewOkrWorkRegReviewPop";
		popW = 800;
		popH = 980;
	}
	
	args["authPg"] = authPg;
	args["adminCheck"] = adminCheck;
	args["pageGubun"] = "workReg";
	args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
	args["searchAppStepCd"] = $("#searchAppStepCd").val();
	args["searchAppSabun"] = $("#searchAppSabun").val();
	args["searchAppName"] = $("#searchAppName").val();
	args["searchAppOrgCd"] = $("#searchAppOrgCd").val();
	args["searchSabun"] = $("#searchSabun").val();
	
	/* 업무진행상태
		11	작성중
		21	승인요청
		23	반려
		25	승인
		31	실적제출
		35	협의요청
		99	확정
	*/
	if((btn == "detail" && sheet1.GetCellValue(Row, "statusCd") == "11") ||  //작성중
		(btn == "detail" && sheet1.GetCellValue(Row, "statusCd") == "23") || //반려
		(btn == "detail1" && sheet1.GetCellValue(Row, "statusCd") == "25") || //승인
		(btn == "detail2" && sheet1.GetCellValue(Row, "statusCd") == "99") || authPg == "R"){
		
		if((btn == "detail" && sheet1.GetCellValue(Row, "statusCd") == "11") || //작성중
			(btn == "detail" && sheet1.GetCellValue(Row, "statusCd") == "23") || //반려
			(btn == "detail1" && sheet1.GetCellValue(Row, "statusCd") == "25") || //승인
			(btn == "detail2" && sheet1.GetCellValue(Row, "statusCd") == "99")){
			args["authPg"] = "A";
		}
		
		args["searchStatusCd"] = sheet1.GetCellValue(Row, "statusCd");
		args["searchPriorSeq"] = sheet1.GetCellValue(Row, "priorSeq");
		args["searchSeq"] = sheet1.GetCellValue(Row, "seq");
	} else {
		args["searchStatusCd"] = "11";
		args["searchPriorSeq"] = "";
		args["searchSeq"] = "";
	}
	
	gPRow = Row;
	pGubun = "okrWorkRegPop";
	
	openPopup(url,args,popW,popH);
};

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');
	
	doAction1("Search");
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" name="searchAppStepCd"		id="searchAppStepCd"	value="${map.searchAppStepCd}">
		<input type="hidden" name="searchAppSabun"		id="searchAppSabun" />
		<input type="hidden" name="searchAppStatusCd"	id="searchAppStatusCd" />
		<input type="hidden" name="searchOrgCd"			id="searchOrgCd" />
		<input type="hidden" name="searchOrgNm"			id="searchOrgNm" />
		<input type="hidden" name="searchAppYn"			id="searchAppYn" />
		<input type="hidden" name="searchAppraisalYn"	id="searchAppraisalYn" />
		<input type="hidden" name="searchStatusCd"		id="searchStatusCd" />
		
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->
		<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/>
		<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
		<input type="hidden" id="searchUserEnterCd"  name="searchUserEnterCd" value="" />
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->
	
	<div class="sheet_search outer">
		<table>
			<tr>
				<td>
					<span class="w40"><tit:txt mid='111888' mdef='평가명'/> </span>
					<select id="searchAppraisalCd" name="searchAppraisalCd" class="required" required></select>
				</td>
				<td>
					<span class="w80"><tit:txt mid='112259' mdef='평가소속'/> </span>
					<select id="searchAppOrgCd" name="searchAppOrgCd" class="required" required></select>
				</td>
				<td>
					<span class="w40"><tit:txt mid='113683' mdef='평가자'/> </span>
					<input id="searchAppName" name ="searchAppName" type="hidden" class="text readonly" readonly />
					<span id="span_searchAppName" class="txt pap_span f_normal"></span>
				</td>
				<td></td>
			</tr>
			<tr>
				<td>
					<span class="w40"><tit:txt mid='113302' mdef='성명'/> </span>
					<input id="searchSabun" name ="searchSabun" type="hidden" />
					<input id="searchName" name ="searchName" type="hidden" />
			<c:choose>
				<c:when test="${ sessionScope.ssnPapAdminYn == 'Y' && (map.searchAppraisalCd_sub == null || map.searchAppraisalCd_sub == '') }">
					<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
				</c:when>
				<c:otherwise>
					<input type="hidden" id="searchKeyword" name="searchKeyword" />
					<span id="span_searchName" class="txt pap_span f_normal"></span>
				</c:otherwise>
			</c:choose>
				</td>
				<td>
					<span class="w60"><tit:txt mid='113312' mdef='직위'/> </span>
					<input id="searchJikweeNm" name ="searchJikweeNm" type="hidden" />
					<span id="span_searchJikweeNm" class="txt pap_span f_normal"></span>
				</td>
				<td></td>
				<td>
					<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
				</td>
			</tr>
		</table>
	</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt" id="pageTitle"><tit:txt mid='2023082501071' mdef='개인업무(TASK)관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Request')"		css="basic authA f_point hide"	id="btnRequest" mid='2023082400765' mdef="승인요청"/>
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA hide" 			id="btnInsert" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA hide" 			id="btnSave" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
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
