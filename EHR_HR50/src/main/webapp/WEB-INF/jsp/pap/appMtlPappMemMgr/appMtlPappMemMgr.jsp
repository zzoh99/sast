<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='' mdef='다면평가자맵핑'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = ""; 
	var pGubun = "";

	$(function() {
		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getComCodeNoteList&searchGrcodeCd=P00004&searchUseYn=Y",false).codeList, "전체");
		$("#searchAppSeqCd").html(appSeqCdList[2]);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='No' mdef='No'/>"				,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>"		,Type:"${sDelTy}",	Hidden:1, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete",	Sort:0  },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"대상자회사"  ,Type:"Text",	    Hidden:1,  Width:70,	Align:"Center",	ColMerge:0,		SaveName:"wEnterCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수"	,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appSeqNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번"		,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"sabun", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명"		,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"name", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속"		,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"orgNm", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위"		,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책"		,Type:"Text",      	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"맵핑\n인원"	,Type:"Text",      	Hidden:1,  Width:30,  	Align:"Center",  ColMerge:0,   	SaveName:"inwonCnt", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			
			{Header:"평가소속"	,Type:"Text",  		Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
			
		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"<sht:txt mid='No' mdef='No'/>"				,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",  	Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='check' mdef='선택'/>"		,Type:"${sDelTy}",	Hidden:0, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

			{Header:"소속"			,Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"orgNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번"			,Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appSabun", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명"			,Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appName", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위"			,Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책"			,Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			
			{Header:"평가소속"		,Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"orgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"피평가자사번"	,Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"sabun", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"대상자회사"  ,Type:"Text",	    Hidden:1,  Width:70,	Align:"Center",	ColMerge:0,		SaveName:"wEnterCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
			
		]; IBS_InitSheet(sheet2, initdata2); sheet2.SetEditable("${editable}"); sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);
		
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata3.Cols = [
			{Header:"<sht:txt mid='No' mdef='No'/>"				,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",  	Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='check' mdef='선택'/>"		,Type:"${sDelTy}",	Hidden:0, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
			{Header:"평가코드"	,Type:"Text",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"compAppraisalCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가코드"	,Type:"Text",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"wEnterCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가코드"	,Type:"Text",      	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appEnterCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가소속"			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가소속"			,Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속"			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"orgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속"			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"orgNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번"			,Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appSabun", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명"			,Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"name", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위"			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위"			,Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책"			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책"			,Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급"			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikgubCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급"			,Type:"Text",  	Hidden:1,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikgubNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
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
		var comboList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getCompAppraisalCdList",false).codeList, "");
		$("#searchCompAppraisalCd").html(comboList1[2]);
		
		// 차수
		var comboList2 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00004&searchUseYn=Y",false).codeList, "");
		$("#searchAppSeqCd").html(comboList2[2]);
		
		$("#searchCompAppraisalCd, #searchAppSeqCd").bind("change", function(event) {
			doAction1("Search");
		});
		
		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
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
			sheet1.DoSearch( "${ctx}/CompAppPeopleMng.do?cmd=getCompAppPeopleMngList1", $("#mySheetForm").serialize() );
			break;
		case "Init"://초기화
			var appSeqNm = $("#searchAppSeqCd option:selected").text();
			var msg = "[" + appSeqNm + "] 다면평가자맵핑을 초기화 하시겠습니까?";
			if(confirm(msg)) {
				var data = ajaxCall("${ctx}/AppMtlPappMemMgr.do?cmd=initializeAppMtlPappMem", $("#mySheetForm").serialize() + "&appSeqNm=" + appSeqNm, false);
				if(data.Result["Code"] > 0) {
					alert(data.Result["Message"]);
					doAction1("Search");
				} else {
					alert(data.Result["Message"]);
				}
			}
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
		doAction2("Search");
	}
}


function doAction2(sAction){
	switch(sAction){
		case "Search":		//조회
			var Row = sheet1.GetSelectRow();
			sheet2.DoSearch("${ctx}/CompAppPeopleMng.do?cmd=getCompAppPeopleMngList2", $("#mySheetForm").serialize() + "&searchSabun=" + sheet1.GetCellValue(Row, "sabun") + "&searchWEnterCd=" + sheet1.GetCellValue(Row, "wEnterCd"));
			break;
		case "Save":        //오른쪽 버튼
			var chk = "N";
			for(var i=1; i <= sheet2.LastRow(); i++){
				if(sheet2.GetCellValue(i,"sStatus") == "D"){
					//sheet2.SetCellValue(i,"sStatus", "U");
					chk = "Y";	
				}
			}
			
			if(chk == "N"){
				alert("선택된 대상자가 없습니다. 대상자를 선택해 주십시요!");
				return;
			}
			
			IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave("${ctx}/CompAppPeopleMng.do?cmd=saveCompAppPeopleMng1",
					$("#mySheetForm").serialize());
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
		sheet1.SetCellValue(sheet1.GetSelectRow(), "inwonCnt", sheet2.RowCount());
		sheet1.SetCellValue(sheet1.GetSelectRow(), "sStatus", "R");
		
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
				$("#searchStatusYn").val("Y");
			} else {
				$("#searchStatusYn").val("N");
			}
		
			var Row = sheet1.GetSelectRow();
			sheet3.DoSearch("${ctx}/AppMtlPappMemMgr.do?cmd=getAppMtlPappMemMgrList3", 
					$("#mySheetForm").serialize() + "&searchSabun=" + sheet1.GetCellValue(Row, "sabun") + 
					"&searchAppOrgCd="+ sheet1.GetCellValue(Row, "appOrgCd") + "&searchWEnterCd=" + sheet1.GetCellValue(Row, "wEnterCd") +
					"&searchAppSeqCd=" + sheet1.GetCellValue(Row, "appSeqCd")  + "&ldsAppStatusCd=Y"
			);
			break;
		case "Save":        //왼쪽버튼
			var chk = "N";
			for(var i=1; i <= sheet3.LastRow(); i++){
				if(sheet3.GetCellValue(i,"sStatus") == "D"){
					sheet3.SetCellValue(i,"sStatus", "U");
					//sheet3.SetCellValue(i, "sabun", "TEMP");
					chk = "Y";	
				}
			}
			
			if(chk == "N"){
				alert("선택된 대상자가 없습니다. 대상자를 선택해 주십시요!");
				return;
			}
			
			IBS_SaveName(document.mySheetForm,sheet3);
			var Row = sheet1.GetSelectRow();
			sheet3.DoSave("${ctx}/CompAppPeopleMng.do?cmd=saveCompAppPeopleMng2",
					$("#mySheetForm").serialize() + "&searchSabun=" + sheet1.GetCellValue(Row, "sabun"));

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
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchCompAppraisalCd" id="searchCompAppraisalCd"></select>
						</td>
						<td>
							<span>차수</span>
							<select name="searchAppSeqCd" id="searchAppSeqCd"></select>
						</td>
						<td>
						    <span>대상자(피평가자)</span>
							<input type="radio" id="searchConditionType1" name="searchConditionType" value="NAME" class="radio" checked/> <label for="searchConditionType1">성명</label>
							<input type="radio" id="searchConditionType2" name="searchConditionType" value="SABUN" class="radio" /> <label for="searchConditionType2">사번</label>
							<input type="text" id="searchCondition" name="searchCondition" class="text" />
						</td>
						<td>
<%--							<span>평가자 소속</span>--%>
							<input type="hidden" id="searchOrgNm" name="searchOrgNm" class="text"/>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<table class="sheet_main">
		<colgroup>
			<col width="32%" />
			<col width="1%" />
			<col width="32%" />
			<col width="3%" />
			<col width="32%" />
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">대상자(피평가자)</li>
							<%--<li class="btn">
								<a href="javascript:doAction1('Init')"	class="button authA">평가자맵핑 초기화</a>
							</li>--%>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "30%", "100%","kr"); </script>
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
				<script type="text/javascript">createIBSheet("sheet2", "30%", "100%","kr"); </script>
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
								<input type="checkbox" id="chkSheet3" name="chkSheet3" class="checkbox" checked/>
								<label class="bg-none" for="chkSheet3">재직자여부</label>
								<input type="hidden" id="searchStatusYn" name="searchStatusYn"/>
								<span>소속/직위/직책/사번/성명</span>
								<input type="text" id="searchSheet3Word" name="searchSheet3Word" class="text" style="height:19px;margin-left:5px;"/>
								<btn:a href="javascript:doAction3('Search');" css="button" mid='search' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "30%", "100%","kr"); </script>
			</td>
		</tr>
		</table>
	</form>
</div>
</body>
</html>