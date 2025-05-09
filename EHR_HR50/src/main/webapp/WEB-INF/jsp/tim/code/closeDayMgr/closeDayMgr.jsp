<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근태마감기준일설정</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {

		$("#searchYm").datepicker2({ymonly:true});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
  			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"급여유형|급여유형",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payType",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"대상월|대상월",			Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ym",			KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:7 },
			{Header:"근태기준일|구분",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"gntDayType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"근태기준일|시작일",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"stdSDd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2, MinimumValue:1, MaximumValue:31 },
			{Header:"근태기준일|종료일",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"stdEDd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2, MinimumValue:1, MaximumValue:31 },
			{Header:"근무기준일|구분",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workDayType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"근무기준일|시작일",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"stdwSDd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2, MinimumValue:1, MaximumValue:31 },
			{Header:"근무기준일|종료일",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"stdwEDd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2, MinimumValue:1, MaximumValue:31 },
			{Header:"발령기준일|구분",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordDayType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"발령기준일|시작일",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordSDd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2, MinimumValue:1, MaximumValue:31 },
			{Header:"발령기준일|종료일",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordEDd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2, MinimumValue:1, MaximumValue:31 },
			{Header:"집계여부|근태",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"gntSumYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"집계여부|근무",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workSumYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var payType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110"), "전체");

		sheet1.SetColProperty("payType", 		{ComboText:"|"+payType[0], ComboCode:"|"+payType[1]} );
		sheet1.SetColProperty("gntDayType", 	{ComboText:"|전월|당월", ComboCode:"|1|3"} );
		sheet1.SetColProperty("workDayType", 	{ComboText:"|전월|당월", ComboCode:"|1|3"} );
		sheet1.SetColProperty("ordDayType", 	{ComboText:"|전월|당월", ComboCode:"|1|3"} );
		sheet1.SetColProperty("gntSumYn", 		{ComboText:"|Yes|No", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("workSumYn", 		{ComboText:"|Yes|No", ComboCode:"|Y|N"} );

		$("#payType").html(payType[2]);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			var param = "payType="+$("#payType").val();
				param += "&searchYm="+$("#searchYm").val();
			sheet1.DoSearch( "${ctx}/CloseDayMgr.do?cmd=getCloseDayMgrList",param );
			break;
		case "Save":

			if(!dupChk(sheet1,"payType|ym", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/CloseDayMgr.do?cmd=saveCloseDayMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var row = sheet1.DataCopy();

			sheet1.SetCellValue(row, "holidayCd","");
			sheet1.SelectCell(row, "holidayNm");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>급여유형</th>
			<td>
				<select id="payType" name="payType" onchange="doAction1('Search');">
				</select>
			</td>
			<th style="display:none">대상월</th>
			<td style="display:none">
				<input id="searchYm" name="searchYm" type="text" size="6" class="date2" />
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">근태마감기준일설정</li>
			<li class="btn">
				<a href="javascript:doAction1('Insert');" class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction1('Copy');" class="btn outline_gray authA">복사</a>
				<a href="javascript:doAction1('Save');" class="btn filled authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" class="btn outline_gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>