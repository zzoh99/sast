<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		// 트리레벨 정의
		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});
		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});		
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"시작일",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },                                                  
			{Header:"상위조직코드",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"조직코드",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"조직명",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,	Cursor:"Pointer",    TreeCol:1,  LevelSaveName:"sLevel" }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			   
			{Header:"조직코드|조직코드",	Type:"Text",     Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },                   
			/*
			{Header:"직급|직급",			Type:"Combo",    Hidden:0,  Width:95,   Align:"Center",  ColMerge:0,   SaveName:"jikgubCd",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			*/
			{Header:"시작일|시작일",		Type:"Date",     Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sdate",        KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },                   
			{Header:"종료일|종료일",		Type:"Date",  	 Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
			{Header:"정원|정원",			Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"orgJikCnt",    KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"현재인원|현재인원",	Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"nowCnt",       KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },                   
			{Header:"차이|차이",			Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"newCnt",       KeyField:0,   CalcLogic:"|nowCnt|-|orgJikCnt|",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:3 },
			{Header:"변경사유|변경사유",	Type:"Text",     Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"changeReason", KeyField:0,   CalcLogic:"",   Format:"",            		   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"충원계획|1월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon1", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|2월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon2", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|3월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon3", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },			
			{Header:"충원계획|4월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon4", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|5월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon5", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|6월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon6", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|7월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon7", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|8월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon8", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|9월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon9", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|10월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon10", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|11월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon11", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|12월",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"mon12", 		KeyField:0,   CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"충원계획|합",		Type:"Text",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"allCnt", 		KeyField:0,   CalcLogic:"|mon1|+|mon2|+|mon3|+|mon4|+|mon5|+|mon6|+|mon7|+|mon8|+|mon9|+|mon10|+|mon11|+|mon12|",   Format:"NullInteger",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 }			
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		// 헤더 머지
		sheet2.SetMergeSheet( msHeaderOnly);
		
		//var jikgubCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");	//직급구분
		//sheet2.SetColProperty("jikgubCd", 			{ComboText:jikgubCd[0], ComboCode:jikgubCd[1]} );	//직급구분

		// 2014 년 부터 다음해까지의 년도 옵션 생성.
		var searchYear = $('#year');
		searchYear.empty();
		for (var i = 2014; i <= Number("${curSysYear}")+1; i++) {
			searchYear.append($('<option></option>').val(i).text(i));
		}

		$("#year").val( "${curSysYear}" ) ;

		$(window).smartresize(sheetResize); sheetInit();
		sheet2.SetFocusAfterProcess(0);

		doAction1("Search");
	});
	
	$(function() {
		$("#year").change(function(){
			doAction2("Search");
		});	        
	});	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/OrgJikgubCapaMgr.do?cmd=getOrgJikgubCapaMgrSheet1List", $("#srchFrm").serialize() ); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/OrgJikgubCapaMgr.do?cmd=getOrgJikgubCapaMgrSheet2List", $("#srchFrm").serialize(),1 ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet2);
							sheet2.DoSave( "${ctx}/OrgJikgubCapaMgr.do?cmd=saveOrgJikgubCapaMgr", $("#srchFrm").serialize() ); break;
		case "Insert":		var Row = sheet2.DataInsert(0);
							sheet2.SelectCell(Row, "name"); 
					        sheet2.SetCellValue(Row, "orgCd", $("#searchOrgCd").val());
					        sheet2.SetCellValue(Row, "sdate", $("#year").val()+"-01-01");	
					        
							var objCnt = ajaxCall('${ctx}/OrgJikgubCapaMgr.do?cmd=getNowCnt',  $("#srchFrm").serialize(), false);
							if (objCnt.DATA != null) {
								sheet2.SetCellValue(Row, "nowCnt", objCnt.DATA.cnt);
							}
							
							break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var d = new Date();
			var fName = $('#year').val() + "년도 인력운영계획_" + d.getTime();
			var param  = {FileName: fName, DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {		
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
	    	$("#searchOrgCd").val(sheet1.GetCellValue(NewRow, "orgCd"));
	    	doAction2("Search");        
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction2("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction2("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	//조직별 직급별 현인원 조회
	function sheet2_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		/*
		if(sheet2.ColSaveName(Col) == "orgJikCnt"){
			var objCnt = ajaxCall('${ctx}/OrgJikgubCapaMgr.do?cmd=getNowCnt',  $("#srchFrm").serialize(), false);
			if (objCnt.DATA != null) {
				sheet2.SetCellValue(Row, "nowCnt", objCnt.DATA.cnt);
			}
		}
		*/
	}	
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="30%" />
		<col width="70%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">조직도
						<div class="util">
						<ul>
							<li	id="btnPlus"></li>
							<li	id="btnStep1"></li>
							<li	id="btnStep2"></li>
							<li	id="btnStep3"></li>
						</ul>
						</div>								
					</li>	
					<li class="btn">
						<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%"); </script>
		</td>	
		<td class="sheet_right">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchOrgCd" name="searchOrgCd">		
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">
						<select id="year" name="year" class="required"></select>
						년도 인력운영계획
					</li>
					<li class="btn">
						<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
						<!--  <a href="javascript:doAction2('Copy')" 	class="basic authA">복사</a>-->
						<a href="javascript:doAction2('Insert')" class="btn outline-gray authA">입력</a>
						<a href="javascript:doAction2('Save')" 	class="btn filled authA">저장</a>
					</li>
				</ul>
				</div>
			</div>
	</form>	
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>