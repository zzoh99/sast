<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		$("#searchStdDate").datepicker2();

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='2017082800628' mdef='공통사무코드'/>",		Type:"Text",      Hidden:0,  Width:60,    Align:"Center",    ColMerge:0,   SaveName:"taskCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='2017082800630' mdef='공통사무명'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    	ColMerge:0,   SaveName:"taskNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='2017082800631' mdef='공통사무명(영문)'/>", 	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    	ColMerge:0,   SaveName:"taskEngNm",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",		Type:"Date",      Hidden:0,  Width:80,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='edate' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:80,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='2017082800626' mdef='핵심공통사무'/>",  	Type:"CheckBox",  Hidden:0,  Width:40,    Align:"Center",    ColMerge:0,   SaveName:"keyTaskYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='note' mdef='비고'/>",  		Type:"Text",      Hidden:0,  Width:150,    Align:"Left",    	ColMerge:0,   SaveName:"memo",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$("#searchTaskCd,#searchTaskNm,#searchStdDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getTaskMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveTaskMgr", $("#srchFrm").serialize() ); break;
		case "Insert":		var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
							//sheet1.SetCellValue(Row, "edate", "99991231");
							sheet1.SelectCell(Row, "taskCd");
							break;
		case "Copy":		sheet1.SetCellValue(sheet1.DataCopy(), 'sdate', ''); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 	if (Msg != "") { alert(Msg); }
		        sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='2017082800633' mdef='공통사무코드'/> </th>
						<td>  <input id="searchTaskCd" name ="searchTaskCd" type="text" class="text" /> </td>
						<th><tit:txt mid='2017082800635' mdef='공통사무명'/> </th>
						<td>  <input id="searchTaskNm" name ="searchTaskNm" type="text" class="text" /> </td>
						<th><tit:txt mid='103906' mdef='기준일자 '/> </th>
						<td>  <input id="searchStdDate" name="searchStdDate" type="text" size="10" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> </td>

						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/>  </td>
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
							<li id="txt" class="txt"><tit:txt mid='2017082800636' mdef='공통사무관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='down2excel' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>