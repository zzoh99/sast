<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사기본(직무)변경</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>
<!--
 * 인사기본(직무)변경
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
	initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata1.Cols = [
      	{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
    	{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
    	{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   		{Header:"시작일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   		{Header:"종료일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   		{Header:"소속코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   		{Header:"소속",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   		{Header:"직군",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   		{Header:"직책",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   		{Header:"직위",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
    	{Header:"직무코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
    	{Header:"직무",			Type:"Popup",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
    	{Header:"비고(변경내역메모)",	Type:"Text",	Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
	]; IBS_InitSheet(sheet1, initdata1);sheet1.SetCountPosition(4);

	$("#hdnSabun").val($("#searchUserId",parent.document).val());

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val();
			sheet1.DoSearch("${ctx}/PsnalJob.do?cmd=getPsnalJobEditList", param);
			break;

		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/PsnalJob.do?cmd=savePsnalJobEdit", $("#sheet1Form").serialize());
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize();	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		if (Code > 0) {
			doAction1("Search");
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if (colName == "jobNm") {
				// 직무검색 팝업
				jobPopup(Row);
			}
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		if (Row > 0) {
			if (sheet1.GetCellEditable(Row, Col) == true) {
				var colName = sheet1.ColSaveName(Col);
				if (colName == "jobNm" && KeyCode == 46) {
					// 직무코드 초기화
					sheet1.SetCellValue(Row,"jobCd","");
				}
			}
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

// 직무검색 팝업
function jobPopup(Row){
	var args = new Array();
	args["searchJobType"] = "10050"; // 직무

	var rv = openPopup("/Popup.do?cmd=jobPopup&authPg=R", args, "740","720");

	if (rv != null) {
		sheet1.SetCellValue(Row, "jobCd", rv["jobCd"]);    
		sheet1.SetCellValue(Row, "jobNm", rv["jobNm"]);    
	}
}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">직무 변경</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Save')"			css="basic" mid='save' mdef="저장"/>
				<a href="javascript:doAction1('Down2Excel');"	class="basic">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
