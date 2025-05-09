<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>항목값 정의</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	
	$(function() {
		
		var arg = p.window.dialogArguments;
	    if( arg != undefined ) {
	    	$("#searchAppraisalCd").val(arg["appraisalCd"]);
	    	$("#searchItemCd").val(arg["itemCd"]);
	    	$("#sItemNm").text(arg["itemNm"]);
	    }

	    
		//배열 선언				
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};                                                                                                                                                                                              
		//HeaderMode                                                                                                                                                                                                                                 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};                                                                                                                                                                          
		//InitColumns + Header Title                                                                                                                                                                                                                 
		initdata.Cols = [                                                                                                                                                                                                                            
				{Header:"No",         	Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"삭제",       	Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
				{Header:"상태",       	Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
				{Header:"평가명",    		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"appraisalCd", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"항목코드",    	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"itemCd", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"항목값코드",    	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"valueCd",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"항목값명",    	Type:"Text",      Hidden:0,  Width:200,    Align:"Center",  ColMerge:0,   SaveName:"valueNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:33, MultiLineText:1  },
				{Header:"순서",     		Type:"Text",      Hidden:0,  Width:40,    Align:"Center",  ColMerge:0,   SaveName:"sunbun", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		 ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4); sheet1.SetEditEnterBehavior("newline");
		
		
	    $(window).smartresize(sheetResize); sheetInit();
	    $("#searchBaseDate").datepicker2();
	    
	    doAction1("Search");
	    
	    $(".close").click(function() {
	    	p.self.close();
	    });     
        
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppSelfReportItemMgr.do?cmd=getAppSelfReportItemMgrValuePopList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppSelfReportItemMgr.do?cmd=saveAppSelfReportItemMgrValuePop", $("#srchFrm").serialize()); break;
		case "Insert":		
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
			sheet1.SetCellValue(Row, "itemCd", $("#searchItemCd").val());
			sheet1.SelectCell(Row, "valueNm"); 
		break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param); 
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 	조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
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
</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>자기신고서 항목값 관리</li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
			<form id="srchFrm" name="srchFrm" tabindex="1">
	            <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
	            <input type="hidden" id="searchItemCd" name="searchItemCd" />
			</form>
			
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><span id="sItemNm"></span> 항목값 </li>
							<li class="btn">
							<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
							<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
							<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
					</td>
				</tr>
			</table>
	
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:p.self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>



