<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연차촉진기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		init_sheet();

		doAction1("Search");
	});

	function init_sheet(){


		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22}; //, FrozenCol:8
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"구분|구분",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"planCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1},

			{Header:"1차촉진|알림시기",		Type:"Int",			Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"alarmBfDay1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"1차촉진|단위",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"alarmGubunCd1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"1차촉진|계획기간(일간)",	Type:"Int",			Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"planDay1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"1차촉진|메일발송",		Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sendMailYn1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N"},
			{Header:"1차촉진|메인알림",		Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mainNotiYn1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N"},
			{Header:"1차촉진|비고",		Type:"Text",		Hidden:0,	Width:165,	Align:"Left",	ColMerge:0,	SaveName:"note1",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

			{Header:"2차촉진|알림시기",		Type:"Int",			Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"alarmBfDay2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"2차촉진|단위",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"alarmGubunCd2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"2차촉진|계획기간(일간)",	Type:"Int",			Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"planDay2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"2차촉진|메일발송",		Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sendMailYn2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N"},
			{Header:"2차촉진|메인알림",		Type:"CheckBox",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mainNotiYn2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N"},
			{Header:"2차촉진|비고",		Type:"Text",		Hidden:0,	Width:165,	Align:"Left",	ColMerge:0,	SaveName:"note2",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		//계획구분
		var planCdList     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T56120"), "");
		sheet1.SetColProperty("planCd", 		{ComboText:"|"+planCdList[0], ComboCode:"|"+planCdList[1]} );

		//알림단위
		sheet1.SetColProperty("alarmGubunCd1", 		{ComboText:"|개월전|일전", ComboCode:"|M|D" } );
		sheet1.SetColProperty("alarmGubunCd2", 		{ComboText:"|개월전|일전", ComboCode:"|M|D" } );

		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/AnnualPlanAgrStd.do?cmd=getAnnualPlanAgrStdList", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);

			sheet1.SetCellValue(row, "mainNotiYn2", "N");

			break;
		case "Save":

			if(!dupChk(sheet1,"planCd", true, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AnnualPlanAgrStd.do?cmd=saveAnnualPlanAgrStd", $("#srchFrm").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "Copy":
			sheet1.DataCopy();
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
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">연차촉진기준관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Search');"	class="btn dark authA" >조회</a>
				<a href="javascript:doAction1('Insert');"	class="btn outline_gray authA" >입력</a>
				<a href="javascript:doAction1('Copy');"		class="btn outline_gray authA" >복사</a>
				<a href="javascript:doAction1('Save');"		class="btn filled authA" >저장</a>
				<a href="javascript:doAction1('Down2Excel');" class="btn outline_gray authR" >다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>