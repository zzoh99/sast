<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#searchFromYmd").datepicker2({startdate:"searchToYmd"});
		$("#searchToYmd").datepicker2({enddate:"searchFromYmd"});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

            {Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",		Type:"Combo",    Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"enterCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",     Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"sabun",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",     Hidden:0,  Width:100, 	Align:"Center",  ColMerge:0,   SaveName:"name",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",     Hidden:Number("${aliasHdn}"),  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"alias",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",	Type:"Text",     Hidden:Number("${jgHdn}"),  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",     Hidden:Number("${jwHdn}"),  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='ymdV1' mdef='로그인일자'/>",	Type:"Text",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"ymd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='hmsV1' mdef='로그인시간'/>",	Type:"Text",     Hidden:0,  Width:100, 	Align:"Center",  ColMerge:0,   SaveName:"hms",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='ip' mdef='IP'/>",		Type:"Text",     Hidden:0,  Width:100, 	Align:"Center",  ColMerge:0,   SaveName:"ip",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

/* 		var enterCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getEnterCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("enterCd", 			{ComboText:enterCd[0], ComboCode:enterCd[1]} );

		$("#searchEnterCd").html(enterCd[2]);
		$("#searchEnterCd").change(function(){
			doAction1("Search");
		});
 */
		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});

	function chkInVal() {
		if ($("#searchFromYmd").val() != "" && $("#searchToYmd").val() != "") {
			if (!checkFromToDate($("#searchFromYmd"),$("#searchToYmd"),"로그인일자","로그인일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			sheet1.DoSearch( "${ctx}/LoginUserMgr.do?cmd=getLoginUserMgrList", $("#srchFrm").serialize() ); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param); break;	
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
<!-- 						<th><tit:txt mid='112488' mdef='회사 '/></th>
						<td>  <select id="searchEnterCd" name="searchEnterCd"> </select> </td>						 -->
						<th><tit:txt mid='112577' mdef='로그인일자'/></th>
						<td>
							<input id="searchFromYmd" name="searchFromYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),0)%>"/> ~
							<input id="searchToYmd" name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<th><tit:txt mid='104450' mdef='성명 '/></th>
						<td>  <input id="searchName" name ="searchName" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='113669' mdef='로그인유저로그'/></li>
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
