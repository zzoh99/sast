<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='' mdef='수습평가자매핑'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = ""; 
	var pGubun = "";


	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='No' mdef='No'/>"				,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>"		,Type:"${sDelTy}",	Hidden:1, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete",	Sort:0  },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"대상자회사"  ,Type:"Text",	    Hidden:1,  Width:70,	Align:"Center",	ColMerge:0,		SaveName:"wEnterCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번"		,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"sabun", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명"		,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"name", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속"		,Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   	SaveName:"orgNm", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위"		,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책"		,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"맵핑\n인원",Type:"Text",      	Hidden:0,  Width:30,  	Align:"Center",  ColMerge:0,   	SaveName:"inwonCnt", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			
			{Header:"평가소속"	,Type:"Text",  		Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"orgCd", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가ID코드",Type:"Text",  	 	Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"appraisalCd", KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"일정여부"	,Type:"Text",  	 	Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"schYn",		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"<sht:txt mid='No' mdef='No'/>"				,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",  	Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='check' mdef='선택'/>"		,Type:"${sDelTy}",	Hidden:0, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

			{Header:"소속"			,Type:"Text",   Hidden:0,  Width:95,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번"			,Type:"Text",   Hidden:0,  Width:65,  	Align:"Center",  ColMerge:0,   	SaveName:"appSabun", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명"			,Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appSabunNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위"			,Type:"Text",   Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   	SaveName:"appJikweeNm", KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책"			,Type:"Text",   Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   	SaveName:"appJikchakNm",KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			
			{Header:"평가자소속"	,Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"피평가자소속"	,Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"orgCd", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"피평가자사번"	,Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"sabun", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가ID코드"	,Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"appraisalCd", KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가자구분"	,Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"appTypeCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			
		]; IBS_InitSheet(sheet2, initdata2); sheet2.SetEditable("${editable}"); sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);
		
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata3.Cols = [
			{Header:"<sht:txt mid='No' mdef='No'/>"				,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",  	Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='check' mdef='선택'/>"		,Type:"${sDelTy}",	Hidden:0, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
			{Header:"평가코드"		,Type:"Text",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"compAppraisalCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가코드"		,Type:"Text",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"wEnterCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가코드"		,Type:"Text",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appEnterCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가소속"		,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가소속"		,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속"			,Type:"Text",  	Hidden:1,  Width:100,  	Align:"Center",  ColMerge:0,   	SaveName:"orgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속"			,Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"orgNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번"			,Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appSabun", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명"			,Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"name", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위"			,Type:"Text",  	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위"			,Type:"Text",  	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책"			,Type:"Text",  	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책"			,Type:"Text",  	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급"			,Type:"Text",  	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   	SaveName:"jikgubCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급"			,Type:"Text",  	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   	SaveName:"jikgubNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:""			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appSeqCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:""			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"aComment", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:""			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"cComment", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:""			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"ldsAppStatusCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:""			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"qOrgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:""			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"qOrgNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"피평가자사번"	,Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"sabun", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet3, initdata3); sheet3.SetEditable("${editable}"); sheet3.SetCountPosition(4); sheet3.SetUnicodeByte(3);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//평가명
		var appraisalCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListByIntern",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		
		$("#searchAppraisalCd").bind("change", function(event) {
			doAction2("Clear");
			doAction3("Clear");
			$("#inwonCnt").html("");
			doAction1("Search");
		});
		
		$("#searchSheet3Word").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction3("Search"); $(this).focus(); }
		});
		
		doAction1("Search");
	});
</script>
<script type="text/javascript">

/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
	switch(sAction){
		case "Search":		//조회
			sheet1.DoSearch( "${ctx}/InternAppEvaluatorMapMgr.do?cmd=getInternAppEvaluatorMapMgrList", $("#srchFrm").serialize() );
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}

		sheetResize();
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}

function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
	selectSheet = sheet1;
	if( OldRow != NewRow ) {
		$("#searchCurOrgCd").val(sheet1.GetCellValue(NewRow, "orgCd"));
		doAction2("Search");
	}
}


function doAction2(sAction) {
	switch(sAction) {
		case "Search":		//조회
			var Row = sheet1.GetSelectRow();
			sheet2.DoSearch("${ctx}/InternAppEvaluatorMapMgr.do?cmd=getInternAppEvaluatorMapMgrList2", $("#srchFrm").serialize() + "&searchSabun=" + sheet1.GetCellValue(Row, "sabun"));
			break;
		case "Save":        //오른쪽 버튼
			var chk = "N";
			

		
			var firstRow = sheet2.GetDataFirstRow();
			var lastRow	 = sheet2.GetDataLastRow();
			for(var i=firstRow; i <= lastRow; i++){
				if(sheet2.GetCellValue(i,"sStatus") == "D") {
					sheet2.SetCellValue(i,"sStatus", "U");
					chk = "Y";	
				}
			}
			
			if(chk == "N"){
				alert("선택된 대상자가 없습니다. 대상자를 선택해 주십시요!");
				return;
			}
			
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "schYn") == "Y") {
				alert("수습평가일정이 존재하는 평가자입니다\n삭제가 불가능 합니다.");
				return;
			}
			
			IBS_SaveName(document.srchFrm,sheet2);
			sheet2.DoSave("${ctx}/InternAppEvaluatorMapMgr.do?cmd=saveInternAppEvaluatorMapMgr",
					$("#srchFrm").serialize());
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
	}
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
		
		$("#inwonCnt").html(sheet2.RowCount());
		//sheet1.SetCellValue(sheet1.GetSelectRow(), "inwonCnt", sheet2.RowCount());
		//sheet1.SetCellValue(sheet1.GetSelectRow(), "sStatus", "R");
		
		doAction3('Search');
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != "")alert(Msg);
		doAction2('Search');

	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

function doAction3(sAction){
	switch(sAction){
		case "Search":		//조회
			if ($("#chkSheet3").attr("checked")){
				$("#searchCurOrgYn").val("Y");
			} else {
				$("#searchCurOrgYn").val("N");
			}
		
			var Row = sheet1.GetSelectRow();
			sheet3.DoSearch("${ctx}/InternAppEvaluatorMapMgr.do?cmd=getInternAppEvaluatorMapMgrList3", 
					$("#srchFrm").serialize() + "&searchSabun=" + sheet1.GetCellValue(Row, "sabun") + 
					"&searchAppOrgCd="+ sheet1.GetCellValue(Row, "appOrgCd"));
			break;
		case "Save":        //왼쪽버튼
			var chk = "N";
			var chkCnt = 0;
			
			var firstRow = sheet3.GetDataFirstRow();
			var lastRow	 = sheet3.GetDataLastRow();
			for(var i=firstRow; i <= lastRow; i++){
				if(sheet3.GetCellValue(i,"sStatus") == "D"){
					sheet3.SetCellValue(i,"sStatus", "U");
					chk = "Y";	
					chkCnt++;
				}
			}
			
			if(chk == "N"){
				alert("선택된 대상자가 없습니다. 대상자를 선택해 주십시요!");
				return;
			}
			
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "schYn") == "Y") {
				alert("수습평가일정이 존재하는 평가자입니다\n등록이 불가능 합니다.");
				return;
			}
			
			// 평가자가 2명이상인지 체크한다.
			var total = sheet2.RowCount() + chkCnt;
			if(total > 2) {
				alert("평가자는 2명을 초과 할 수 없습니다.");
				return;
			}
			
			IBS_SaveName(document.srchFrm,sheet3);
			var Row = sheet1.GetSelectRow();
			sheet3.DoSave("${ctx}/InternAppEvaluatorMapMgr.do?cmd=saveInternAppEvaluatorMapMgr2",
					$("#srchFrm").serialize() + "&searchSabun=" + sheet1.GetCellValue(Row, "sabun"));
			break;
		case "Clear":
			sheet3.RemoveAll();
			break;
	}
}

//조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != "")alert(Msg);
		doAction2('Search');
		
	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

//사원 팝업
function employeePopup(){
	try{
		if(!isPopup()) {return;}

		var args = new Array();

		gPRow = "";
		pGubun = "searchEmployeePopup";

		openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");
	}catch(ex){alert("Open Popup Event Error : " + ex);}
}

function setEmpPage() {
	$("#searchAppSabun").val($("#searchUserId").val());
	doAction1("Search");
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchAppSabun" name="searchAppSabun" />
		<table class="sheet_main">
		<colgroup>
			<col width="30%" />
			<col width="1%" />
			<col width="30%" />
			<col width="3%" />
			<col width="36%" />
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">평가대상자</li>
							<%--<li class="btn">
								<a href="javascript:doAction1('Init')"	class="button authA">평가자맵핑 초기화</a>
							</li>--%>
							<li class="btn">
								<span>* 평가명</span>
								<SELECT id="searchAppraisalCd" name="searchAppraisalCd" class="box"></SELECT>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "27%", "100%","kr"); </script>
			</td>
			
			<td>&nbsp;</td>
			
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"> [ <span id="inwonCnt" ></span> ]평가자 
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "27%", "100%","kr"); </script>
			</td>
			
			<td align=center>
				<a href="javascript:doAction3('Save');"><img src="/common/images/common/arrow_left1.gif"/></a><br/><br/>
				<a href="javascript:doAction2('Save');"><img src="/common/images/common/arrow_right1.gif"/></a>
			</td>
			
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">가능 대상</li>
							<li class="btn">
								<label style="height:19px;margin-right:5px;">
									<span>현재소속여부</span>
									<input type="checkbox" id="chkSheet3" name="chkSheet3" class="checkbox" checked/>
								</label>
								<input type="hidden" id="searchCurOrgYn" name="searchCurOrgYn"/>
								<input type="hidden" id="searchCurOrgCd" name="searchCurOrgCd"/>
								<span>소속/직위/직책/사번/성명</span>
								<input type="text" id="searchSheet3Word" name="searchSheet3Word" class="text" style="height:19px;margin-left:5px;"/>
								<btn:a href="javascript:doAction3('Search');" css="button" mid='search' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "36%", "100%","kr"); </script>
			</td>
		</tr>
		</table>
	</form>
</div>
</body>
</html>