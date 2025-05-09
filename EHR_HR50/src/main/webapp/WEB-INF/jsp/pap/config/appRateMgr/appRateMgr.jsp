<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가ID관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
			  		{Header:"No|No"		,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:1,   SaveName:"sNo" },
					{Header:"삭제|삭제"	,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:1,   SaveName:"sDelete" },
					{Header:"상태|상태"	,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:1,   SaveName:"sStatus" },
					{Header:"직급명|직급명"		,Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"jikchakCd",   	   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"업적|1차반영비율(%)"	,Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"mboRate1",   	   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"업적|2차반영비율(%)"	,Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"mboRate2",   	   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"역량|1차반영비율(%)"	,Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"competencyRate1",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"역량|2차반영비율(%)"	,Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"competencyRate2",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"종합|업적반영비율(%)"	,Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"mboRate",    	   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"종합|역량반영비율(%)"	,Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"competencyRate",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
					{Header:"평가코드|평가코드"	,Type:"Text",      Hidden:1,  Width:180,  Align:"Center",  ColMerge:1,   SaveName:"appraisalCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			]; 
			IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);
			
			var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchAppTypeCd=C,",false).codeList, ""); // 평가명
			var famList1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), ""); // 직급
			
			$("#searchAppraisalCd").html(famList[2]); //평가명
			$("#searchjikchakCd").html("<option value=''>전체</option>"+famList1[2]); //직급
			
			sheet1.SetColProperty("jikchakCd", 			{ComboText:famList1[0], ComboCode:famList1[1]} );
			
			$(window).smartresize(sheetResize); sheetInit();
		    doAction1("Search");
	});	


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppRateMgr.do?cmd=getAppRateMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							if (!dupChk(sheet1, "appraisalCd|jikchakCd", false, true)) {break;}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppRateMgr.do?cmd=saveAppRateMgr", $("#srchFrm").serialize()); break;
		case "Insert":		var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
							sheet1.SelectCell(Row, "jikchakCd"); 
							break;
		case "Copy":		
							var row = sheet1.DataCopy(); 
							sheet1.SetCellValue(row, "jikchakCd", "");
							sheet1.SelectCell(Row, "jikchakCd"); 
							break;
		case "Clear":		sheet1.RemoveAll(); break;
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
			if(Msg != ""){ 
				alert(Msg); 
			} 
			doAction1("Search");
		}catch(ex){ 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	function openCopyPopup(){
		var args    = new Array();
	    var rv = openPopup("/AppRateMgr.do?cmd=viewAppRateMgrCopy", args, "600","520"); 
	    
	    if(rv != null){
	    	$("#searchAppraisalCd").val(rv["appraisalCd"]);
	    	 doAction1("Search");
	    }
	}
	
	
</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td>
							<span>직급</span>
							<select name="searchjikchakCd" id="searchjikchakCd" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
							<a href="javascript:openCopyPopup();" id="btnSearch" class="button">종합평가반영비율복사</a>
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
							<li id="txt" class="txt">종합평가반영비율</li>
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