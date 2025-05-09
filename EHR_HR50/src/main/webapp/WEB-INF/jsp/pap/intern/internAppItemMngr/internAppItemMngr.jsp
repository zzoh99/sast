<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>수습평가항목관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No"	,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제"	,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태"	,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
			
			{Header:"평가요소"	,Type:"Text",	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appItemNm",		KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"평가기준"	,Type:"Text",	Hidden:0,  Width:250,  Align:"Left",    ColMerge:0,   SaveName:"appItemDetail",	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"척도"		,Type:"Combo",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"appCodeType",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			
			{Header:"수습평가항목"	,Type:"Int",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appItemSeq",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);
		
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P90060"), ""); // 척도구분코드(P90060)
		sheet1.SetColProperty("appCodeType", {ComboText: "|"+comboList1[0], ComboCode: "|"+comboList1[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});	

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/InternAppItemMngr.do?cmd=getInternAppItemMngrList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/InternAppItemMngr.do?cmd=saveInternAppItemMngr", $("#srchFrm").serialize()); break;
		case "Insert":		var Row = sheet1.DataInsert(0); break;
		case "Copy":		
							var Row = sheet1.DataCopy(); 
							sheet1.SetCellValue(Row, "appItemSeq", "");
							sheet1.SelectCell(Row, "appItemNm"); 
							break;
		case "Clear":		sheet1.RemoveAll(); break
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param); 
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
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">수습평가항목관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
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