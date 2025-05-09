<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head> <title>역량항목팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<script type="text/javascript">

	$(function() {
		createIBSheet3(document.getElementById('mysheet-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제"			,Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },
				{Header:"상태"			,Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
				{Header:"구분명"		,Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"mainAppTypeNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
				{Header:"역량명"		,Type:"Text",	Hidden:0,	Width:70,	Align:"Left",	ColMerge:1,	SaveName:"competencyNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
				{Header:"내용"		,Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:1,	SaveName:"memo",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500, MultiLineText:1 },
				{Header:"역량코드"		,Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"competencyCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
				{Header:"척도"		,Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"gmeasureMemo" }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();
		
		var sheetHeight = $(".modal_body").height() - $("#sheet1Form").height() - 2;
		sheet1.SetSheetHeight(sheetHeight);
		
		doAction1("Search");
	});
	
	function setValue(){
		if(sheet1.GetSelectRow() < 1 ){
			alert("항목을 선택하세요.");
			return;
		}
		const p = {
			competencyNm : sheet1.GetCellValue(sheet1.GetSelectRow(), "competencyNm"),
			competencyCd : sheet1.GetCellValue(sheet1.GetSelectRow(), "competencyCd"),
			mainAppTypeNm : sheet1.GetCellValue(sheet1.GetSelectRow(), "mainAppTypeNm"),
			gmeasureMemo : sheet1.GetCellValue(sheet1.GetSelectRow(), "gmeasureMemo"),
			memo : sheet1.GetCellValue(sheet1.GetSelectRow(), "memo")
		};
		var modal = window.top.document.LayerModalUtility.getModal('mboTargetRegPopCompetencyLayer');
		modal.fire('mboTargetRegPopCompetencyTrigger', p).hide();

	}
</script>

<script type="text/javascript">

	function doAction1(sAction){
		switch(sAction){
		case "Search":		//조회
			sheet1.DoSearch("${ctx}/EvaMain.do?cmd=getMboTargetRegPopCompetencyList", $("#sheet1Form").serialize());
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet1_OnDblClick(Row, Col){
		setValue();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheet1Form" name="sheet1Form" >
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div id="mysheet-wrap"></div>
					</td>
				</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('mboTargetRegPopCompetencyLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>