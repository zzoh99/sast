<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});
		
		$("#searchFrom, #searchTo, #searchResortNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		init_sheet();

		doAction1("Search");
	});
	
	function init_sheet(){ 
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo'           mdef='No' />",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo", RowSpan:3 },
			
			{Header:"<sht:txt mid='L19080500063'  mdef='리조트명' />",	Type:"Text",   Hidden:0, Width:130,	Align:"Left",	ColMerge:0,	 SaveName:"resortNm",		Edit:0},
			{Header:"<sht:txt mid='L19080600003'  mdef='객실유형' />",	Type:"Text",   Hidden:0, Width:200,	Align:"Left",	ColMerge:0,	 SaveName:"roomType",		Edit:0},
			{Header:"<sht:txt mid='L19080600001'  mdef='체크인' />",		Type:"Text",   Hidden:0, Width:80,	Align:"Center",	ColMerge:0,	 SaveName:"sdate",			Format:"Ymd", Edit:0},
			{Header:"<sht:txt mid='L19080600002'  mdef='체크아웃' />",	Type:"Text",   Hidden:0, Width:80,	Align:"Center",	ColMerge:0,	 SaveName:"edate",			Format:"Ymd", Edit:0},
			{Header:"<sht:txt mid='workDay'       mdef='일수' />",		Type:"Text",   Hidden:1, Width:60,	Align:"Center",	ColMerge:0,	 SaveName:"days",			Edit:0},
			
			{Header:"<sht:txt mid='sabun' 		  mdef='사번' />",		Type:"Text",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0, RowSpan:3},
   			{Header:"<sht:txt mid='name' 		  mdef='성명' />",		Type:"Text",   Hidden:0, Width:80,	Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0, RowSpan:3},
   			{Header:"<sht:txt mid='orgNmV8' 	  mdef='부서' />",		Type:"Text",   Hidden:0, Width:120, Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0, RowSpan:3},
   			{Header:"<sht:txt mid='jikgubNm' 	  mdef='직급' />",		Type:"Text",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0, RowSpan:3},
   			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/ResortApr.do?cmd=getResortLstList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">	
<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기간</th>
			<td colspan="2">
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.getCurrentTime("yyyy-MM-dd")%>">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),90)%>">
			</td>
			<th><tit:txt mid="L19080500065" mdef="리조트명" /></th>
			<td>
				<input id="searchResortNm" name="searchResortNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="button"/>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">리조트 예약현황</li> 
				<li class="btn"> 
					<btn:a href="javascript:doAction1('Down2Excel');" 	css="basic authR" mid='down2excel' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
