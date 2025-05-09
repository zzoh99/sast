<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		    {Header:"<sht:txt mid='payCd' mdef='급여구분'/>",          Type:"Combo",     Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"payCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:10,  UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='openDd' mdef='공개일'/>",            Type:"Combo",     Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"openDd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"<sht:txt mid='openHm' mdef='공개시간\n(HH:MM)'/>", Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"openHm",  KeyField:1,   CalcLogic:"",   Format:"Hm",          PointCount:4,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 }  ];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		// 급여코드
        var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
        sheet1.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );

	    sheet1.SetColProperty("openDd", {ComboText:"-15|-14|-13|-12|-11|-10|-9|-8|-7|-6|-5|-4|-3|-2|-1|당일|+1|+2|+3|+4|+5|+6|+7|+8|+9|+10|+11|+12|+13|+14|+15",
	    	                             ComboCode:"-15|-14|-13|-12|-11|-10|-9|-8|-7|-6|-5|-4|-3|-2|-1|00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15"} );

		// 조회조건
		var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchPayCd").html(searchPayCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PayDayOpenMgr.do?cmd=getPayDayOpenMgrList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"payCd", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PayDayOpenMgr.do?cmd=savePayDayOpenMgr", $("#sheetForm").serialize()); break;
		case "Insert":		sheet1.DataInsert(0); break;
		case "Copy":
			var Row = sheet1.DataCopy();
            break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
					var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
					sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}



	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114519' mdef='급여구분 '/> </th>
						<td>  <select id="searchPayCd" name="searchPayCd" onchange="javascript:doAction1('Search')"> </select></td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='payDayOpenMgr' mdef='급여자료공개관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
