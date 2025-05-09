<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>휴가 발생조건</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"근태명",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"월차감소",			Type:"CheckBox",	Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"mmDedYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35, TrueValue:"Y", FalseValue:"F" },
			{Header:"감소적용횟수",		Type:"Float",		Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"mmAppCnt",	KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"연차감소",			Type:"CheckBox",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"yyDedYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35, TrueValue:"Y", FalseValue:"F" },
			{Header:"감소적용횟수",		Type:"Float",		Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"yyAppCnt",	KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"휴가적용일수",		Type:"Float",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"appDay",		KeyField:0,	Format:"",	PointCount:3,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var gntCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCpnGntCdList"), "");

		sheet1.SetColProperty("gntCd", 			{ComboText:"|"+gntCd[0], ComboCode:"|"+gntCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/RealOccurStd.do?cmd=getRealOccurStdList",param );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/RealOccurStd.do?cmd=saveRealOccurStd", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
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

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">발생기준</li>
			<li class="btn">
				<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
				<a href="javascript:doAction1('Insert');" class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction1('Copy');" class="btn outline_gray authA">복사</a>
				<a href="javascript:doAction1('Save');" class="btn filled authA">저장</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>