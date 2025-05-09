<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },

			{Header:"<sht:txt mid='dataType' mdef='작업\n구분|작업\n구분'/>",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"dataType",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ymd' mdef='발생일자|발생일자'/>",		Type:"Text",	Hidden:0,	Width:65,	Align:"Center",	ColMerge:1,	SaveName:"ymd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='hms' mdef='발생시간|발생시간'/>",		Type:"Text",	Hidden:0,	Width:85,	Align:"Center",	ColMerge:1,	SaveName:"hms",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='grpNmV1' mdef='권한그룹명|권한그룹명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"grpNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applSabunV8' mdef='대상자|사번'/>",				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applNameV4' mdef='대상자|성명'/>",				Type:"Text",	Hidden:0,	Width:85,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대상자|호칭",				Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:85,	Align:"Center",	ColMerge:1,	SaveName:"alias",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNm' mdef='대상자|직급'/>",				Type:"Text",	Hidden:Number("${jgHdn}"),	Width:85,	Align:"Center",	ColMerge:1,	SaveName:"jikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNmV1' mdef='대상자|직위'/>",				Type:"Text",	Hidden:Number("${jwHdn}"),	Width:85,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='bSearchType' mdef='변경전|조회구분'/>",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"bSearchType",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='bDataRwType' mdef='변경전|쓰기구분'/>",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"bDataRwType",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='searchTypeV2' mdef='변경후|조회구분'/>",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"searchType",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='dataRwTypeV2' mdef='변경후|쓰기구분'/>",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"dataRwType",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='chkid' mdef='발생자|사번'/>",				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"chkid",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='name1' mdef='발생자|성명'/>",				Type:"Text",	Hidden:0,	Width:85,	Align:"Center",	ColMerge:1,	SaveName:"name1",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"발생자|호칭",				Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:85,	Align:"Center",	ColMerge:1,	SaveName:"alias1",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"발생자|직급",				Type:"Text",	Hidden:Number("${jgHdn}"),	Width:85,	Align:"Center",	ColMerge:1,	SaveName:"jikgubNm1",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"발생자|직위",				Type:"Text",	Hidden:Number("${jwHdn}"),	Width:85,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm1",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		$("#searchChkDate1").datepicker2({startdate:"searchChkDate2"});
		$("#searchChkDate2").datepicker2({enddate:"searchChkDate1"});

		$("#searchChkDate1, #searchChkDate2, #searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		doAction1("Search");
	});


	function chkInVal() {

		if ($("#searchChkDate1").val() == "" && $("#searchChkDate2").val() != "") {
			alert('발생일자 시작일을 입력하세요.');
			return false;
		}

		if ($("#searchChkDate1").val() != "" && $("#searchChkDate2").val() == "") {
			alert('발생일자 종료일을 입력하세요.');
			return false;
		}

		if ($("#searchChkDate1").val() != "" && $("#searchChkDate2").val() != "") {
			if (!checkFromToDate($("#searchChkDate1"),$("#searchChkDate2"),"발생일자","발생일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":		if(!chkInVal()){break;} sheet1.DoSearch( "${ctx}/AuthGrpUserMgrLog.do?cmd=getAuthGrpUserMgrLogList", $("#srchFrm").serialize() ); break;
		case "Down2Excel":	sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1}); break;
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
						<th><tit:txt mid='114737' mdef='발생일자'/></th>
						<td>
							<input id="searchChkDate1" name="searchChkDate1" type="text" size="10" class="date2" value="<%= DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> ~
							<input id="searchChkDate2" name="searchChkDate2" type="text" size="10" class="date2" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),1)%>"/>
						</td>
						<th><tit:txt mid='104450' mdef='성명 '/></th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="text" />
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='authGrpUserMgrLog' mdef='권한사용자변경로그'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
