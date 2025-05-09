<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='' mdef='평가자맵핑'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

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
			
			{Header:"평가차수",	Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appSeqNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",		Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"sabun", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",		Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"name", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속",		Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"orgNm", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위",		Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",		Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"맵핑인원",	Type:"Int",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"inwonCnt", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
			
			//{Header:"평가대상그룹"	,Type:"Text",  	Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
			
		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"<sht:txt mid='No' mdef='No'/>"				,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",  	Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='check' mdef='선택'/>"		,Type:"${sDelTy}",	Hidden:0, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
			
			{Header:"소속",			Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",			Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"name", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위",			Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",			Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가자",			Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appName", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가자 직책",		Type:"Text",   Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appJikchakNm",KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			
			{Header:"소속코드",		Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",			Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"sabun", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가자 사번",		Type:"Text",   Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"appSabun", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
			
		]; IBS_InitSheet(sheet2, initdata2); sheet2.SetEditable("${editable}"); sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);
		
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata3.Cols = [
			{Header:"<sht:txt mid='No' mdef='No'/>"				,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",  	Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='check' mdef='선택'/>"		,Type:"${sDelTy}",	Hidden:0, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

			{Header:"소속",			Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",			Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"name", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위",			Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikweeNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",			Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"jikchakNm", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가자",			Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appName", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가자 직책"	,	Type:"Text",  	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   	SaveName:"appJikchakNm",KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

			{Header:"소속코드",		Type:"Text",  	Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"appOrgCd", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",			Type:"Text",  	Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"sabun", 		KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가자 사번",		Type:"Text",  	Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   	SaveName:"appSabun", 	KeyField:0, CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
			
		]; IBS_InitSheet(sheet3, initdata3); sheet3.SetEditable("${editable}"); sheet3.SetCountPosition(4); sheet3.SetUnicodeByte(3);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		
		$("#searchAppraisalCd").bind("change",function(event){
			var appStepCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppStepCdList&searchAppraisalCd=" + $(this).val(),false).codeList, "");
			$("#searchAppStepCd").html(appStepCdList[2]);
			$("#searchAppStepCd").val("5");
			
			sheet1.RemoveAll();
			sheet2.RemoveAll();
			sheet3.RemoveAll();
			$("#inwonCnt").html("");
		});

		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y&searchNote1=Y",false).codeList, "");
		$("#searchAppSeqCd").html(appSeqCdList[2]);
		
		$("#searchAppSeqCd, #searchAppStepCd").bind("change", function(event) {
			doAction1("Search");
		});
		
		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$("#searchSheet3Word").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction3("Search"); $(this).focus(); }
		});
		
		$("#searchAppraisalCd").change();
	});
</script>
<script type="text/javascript">

/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
	if ($("#searchAppraisalCd").val() == "") {
		alert("평가명을 선택해 주시기 바랍니다.");
		$("#searchAppraisalCd").focus();
		return;
	}
	if ($("#searchAppStepCd").val() == "") {
		alert("평가단계를 선택해 주시기 바랍니다.");
		$("#searchAppStepCd").focus();
		return;
	}
	if ($("#searchAppSeqCd").val() == "") {
		alert("평가차수를 선택해 주시기 바랍니다.");
		$("#searchAppSeqCd").focus();
		return;
	}
	switch(sAction){
		case "Search"://조회
			sheet1.DoSearch("${ctx}/AppPappMemMgr.do?cmd=getAppPappMemMgrList1", $("#mySheetForm").serialize());
			break;
		case "Init"://초기화
			var appSeqNm = $("#searchAppSeqCd option:selected").text();
			var msg = "[" + appSeqNm + "] 평가자맵핑을 초기화 하시겠습니까?";
			if(confirm(msg)) {
				var data = ajaxCall("${ctx}/AppPappMemMgr.do?cmd=deleteInitializeAppPappMem", $("#mySheetForm").serialize() + "&appSeqNm=" + appSeqNm, false);
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
	if ($("#searchAppraisalCd").val() == "") {
		alert("평가명을 선택해 주시기 바랍니다.");
		$("#searchAppraisalCd").focus();
		return;
	}
	if ($("#searchAppStepCd").val() == "") {
		alert("평가단계를 선택해 주시기 바랍니다.");
		$("#searchAppStepCd").focus();
		return;
	}
	if ($("#searchAppSeqCd").val() == "") {
		alert("평가차수를 선택해 주시기 바랍니다.");
		$("#searchAppSeqCd").focus();
		return;
	}
	switch(sAction){
		case "Search":		//조회
			var Row = sheet1.GetSelectRow();
			sheet2.DoSearch("${ctx}/AppPappMemMgr.do?cmd=getAppPappMemMgrList2", 
					$("#mySheetForm").serialize() + "&searchAppSabun=" + sheet1.GetCellValue(Row, "sabun"));
			break;
		case "Save":        //오른쪽 버튼
			var chk = "N";
			for(var i=1; i <= sheet2.LastRow(); i++){
				if(sheet2.GetCellValue(i,"sStatus") == "D"){
					sheet2.SetCellValue(i,"sStatus", "U");
					chk = "Y";	
				}
			}
			
			if(chk == "N"){
				alert("선택된 대상자가 없습니다. 대상자를 선택해 주십시요!");
				return;
			}
			
			IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave("${ctx}/AppPappMemMgr.do?cmd=saveAppPappMemMgr", 
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
	if ($("#searchAppraisalCd").val() == "") {
		alert("평가명을 선택해 주시기 바랍니다.");
		$("#searchAppraisalCd").focus();
		return;
	}
	if ($("#searchAppStepCd").val() == "") {
		alert("평가단계를 선택해 주시기 바랍니다.");
		$("#searchAppStepCd").focus();
		return;
	}
	if ($("#searchAppSeqCd").val() == "") {
		alert("평가차수를 선택해 주시기 바랍니다.");
		$("#searchAppSeqCd").focus();
		return;
	}
	switch(sAction){
		case "Search":		//조회
			sheet3.DoSearch("${ctx}/AppPappMemMgr.do?cmd=getAppPappMemMgrList3", $("#mySheetForm").serialize());
			break;
		case "Save":        //왼쪽버튼
			var sheet1Row = sheet1.GetSelectRow();
		
			if(sheet1Row < 1) {
				alert("선택된 평가자가 없습니다. 평가자를 선택해 주십시요!");
				return;
			}
			
			// 평가자 사번
			var appSabun = sheet1.GetCellValue(sheet1Row, "sabun");
			
			var chk = "N";
			for(var i=1; i <= sheet3.LastRow(); i++){
				if(sheet3.GetCellValue(i,"sStatus") == "D"){
					sheet3.SetCellValue(i,"sStatus", "U");
					//sheet3.SetCellValue(i, "appSabun", "TEMP");
					sheet3.SetCellValue(i, "appSabun", appSabun);
					chk = "Y";	
				}
			}
			
			if(chk == "N"){
				alert("선택된 대상자가 없습니다. 대상자를 선택해 주십시요!");
				return;
			}
			
			IBS_SaveName(document.mySheetForm,sheet3);
			var Row = sheet1.GetSelectRow();
			sheet3.DoSave("${ctx}/AppPappMemMgr.do?cmd=saveAppPappMemMgr", 
					$("#mySheetForm").serialize() + "&searchAppSabun=" + sheet1.GetCellValue(Row, "sabun"));
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
							<select name="searchAppraisalCd" id="searchAppraisalCd"></select>
						</td>
						<td>
							<span>평가단계</span>
							<select name="searchAppStepCd" id="searchAppStepCd"></select>
						</td>
						<td>
							<span>차수</span>
							<select name="searchAppSeqCd" id="searchAppSeqCd"></select>
						</td>
						<td>
							<span>평가자 사번/성명</span>
							<input type="text" id="searchSabunName" name="searchSabunName" class="text"/>
						</td>
						<td>
							<span>평가자 소속</span>
							<input type="text" id="searchOrgNm" name="searchOrgNm" class="text"/>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
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
							<li id="txt" class="txt">평가자</li>
							<li class="btn">
								<a href="javascript:doAction1('Init')"	class="btn filled authA">평가자맵핑 초기화</a>
							</li>
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
							<li id="txt" class="txt"> [ <span id="inwonCnt" ></span> ]피평가자 
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
							<li id="txt" class="txt">평가자 미적용자</li>
							<li class="btn">
								<span>소속/성명/평가그룹</span>
								<input type="text" id="searchSheet3Word" name="searchSheet3Word" class="text" style="height:19px;margin-left:5px;"/>
								<btn:a href="javascript:doAction3('Search');" css="btn dark" mid='search' mdef="조회"/>
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