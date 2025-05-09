<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>공통사무 리스트 조회</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0,ChildPage:5};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },

				{Header:"공통사무코드",		Type:"Text",      Hidden:0,  Width:60,    Align:"Center",    ColMerge:0,   SaveName:"taskCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"공통사무명",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    	ColMerge:0,   SaveName:"taskNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	            {Header:"공통사무명(영문)", 	Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    	ColMerge:0,   SaveName:"taskEngNm",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",		Type:"Date",      Hidden:0,  Width:80,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:80,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"핵심공통사무",  	Type:"CheckBox",  Hidden:0,  Width:40,    Align:"Center",    ColMerge:0,   SaveName:"keyTaskYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='armyMemo' mdef='비고'/>",  		Type:"Text",      Hidden:0,  Width:150,    Align:"Left",    	ColMerge:0,   SaveName:"memo",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
		];
		IBS_InitSheet(mySheet, initdata);mySheet.SetVisible(true);mySheet.SetCountPosition(4);mySheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$("#searchTaskCd,#searchTaskNm,#searchStdDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		
	    $(window).smartresize(sheetResize); sheetInit();

	    doAction("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });

	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet.DoSearch( "${ctx}/Popup.do?cmd=getTaskPopupList", $("#mySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function mySheet_OnDblClick(Row, Col){
		var rv = new Array(7);
		rv["taskCd"] 	= mySheet.GetCellValue(Row, "taskCd");
		rv["taskNm"]	= mySheet.GetCellValue(Row, "taskNm");
		rv["sdate"]		= mySheet.GetCellValue(Row, "sdate");
		rv["edate"]		= mySheet.GetCellValue(Row, "edate");
		rv["memo"]		= mySheet.GetCellValue(Row, "memo");

		p.popReturnValue(rv);
		p.window.close();
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>공통사무 리스트 조회</li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>공통사무코드 </th>
							<td>  <input id="searchTaskCd" name ="searchTaskCd" type="text" class="text" /> </td>
							<th>공통사무명 </th>
							<td>  <input id="searchTaskNm" name ="searchTaskNm" type="text" class="text" /> </td>
							<th><tit:txt mid='103906' mdef='기준일자 '/></th>
							<td>  <input id="searchStdDate" name="searchStdDate" type="text" size="10" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> </td>
	
							<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
						<li id="txt" class="txt">공통사무 리스트 조회</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>



