<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가차수반영비율</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:6, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No"	,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제"	,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태"	,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

			{Header:"평가종류"		,Type:"Combo",	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appTypeCd",		KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13},
			{Header:"본인(%)"		,Type:"Int",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appSelfRate",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"1차평가(%)"		,Type:"Int",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"app1stRate",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"2차평가(%)"		,Type:"Int",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"app2ndRate",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"3차평가(%)"		,Type:"Int",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"app3rdRate",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"합계"			,Type:"Int",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sumRate",		KeyField:0,   CalcLogic:"|appSelfRate|+|app1stRate|+|app2ndRate|+|app3rdRate|",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"평가ID"			,Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"비고"			,Type:"Text",		Hidden:0,  Width:180,  Align:"Center",  ColMerge:0,   SaveName:"note",			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		// 평가종류
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","P10003"));
		sheet1.SetColProperty("appTypeCd", 			{ComboText:comboList1[0], ComboCode:comboList1[1]} );


		$("#searchAppraisalCd").val($("#searchAppraisalCd", parent.document).val());

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppRate.do?cmd=getAppRateTab1", $("#srchFrm").serialize() ); break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
				if(!dupChk(sheet1,"appraisalCd|appTypeCd", true, true)){break;}
			}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppRate.do?cmd=saveAppRateTab1", $("#srchFrm").serialize()); break;
		case "Insert":		var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
							break;
		case "Copy":
			var row = sheet1.DataCopy();

			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != -1 ) doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
	</form>
		<table class="sheet_main">
		<colgroup>
			<col width="100%" />
		</colgroup>
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">평가차수반영비율</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
								<a href="javascript:doAction1('Copy')" 	class="btn outline-gray authA">복사</a>
								<a href="javascript:doAction1('Insert')" class="btn outline-gray authA">입력</a>
								<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
		</table>

</div>
</body>
</html>