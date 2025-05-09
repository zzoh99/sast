<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
 		var bizCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "");
 		
 		$("#searchYmd1").datepicker2({startdate:"searchYmd2"});
 		$("#searchYmd2").datepicker2({enddate:"searchYmd1"});
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",	Type:"Combo",    Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"bizCd",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='successYn' mdef='성공여부'/>",	Type:"Combo",    Hidden:0,  Width:50, 	Align:"Center",  ColMerge:0,   SaveName:"successYn",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",     Hidden:0,  Width:300,	Align:"Left",    ColMerge:0,   SaveName:"errLog",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000, MultiLineText:1 },
            {Header:"<sht:txt mid='ymdV4' mdef='작업일자'/>",	Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"ymd",     		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='hmsV4' mdef='작업시간'/>",	Type:"Text",     Hidden:0,  Width:80, 	Align:"Center",  ColMerge:0,   SaveName:"hms",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetEditEnterBehavior("down");

		sheet1.SetColProperty("bizCd", {ComboText:bizCdList[0], ComboCode:bizCdList[1]} );
		sheet1.SetColProperty("successYn", {ComboText:"성공|실패", ComboCode:"Y|N"} );
		
		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchBizCd").html("<option value=''>전체</option>"+bizCdList[2]);
		$("#searchBizCd").change(function(){
			doAction1("Search");
		});
		
		doAction1("Search");
	});

	function chkInVal() {
		if ($("#searchYmd1").val() != "" && $("#searchYmd2").val() != "") {
			if (!checkFromToDate($("#searchYmd1"),$("#searchYmd2"),"작업일자","작업일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/IfLogSht.do?cmd=getIfLogShtList", $("#srchFrm").serialize() ); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
						<th><tit:txt mid='113970' mdef='업무구분 '/></th>
 						<td>  <select id="searchBizCd" name="searchBizCd"></select> </td>
 						<th><tit:txt mid='113299' mdef='작업일자'/></th>
						<td>
							<input id="searchYmd1" name="searchYmd1" type="text" size="10" class="date2" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-1)%>"/> ~
							<input id="searchYmd2" name="searchYmd2" type="text" size="10" class="date2" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),0)%>"/>
						</td>	
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='ifLogSht' mdef='I/F로그'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
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
