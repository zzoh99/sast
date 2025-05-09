<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>근태상세내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">
	$(function() {
		createIBSheet3(document.getElementById('sheet1_wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");
		var searchSabun = "";
		var searchSYm   = "";
		var searchEYm   = "";
		var sdate = "";
		var edate = "";

		const modal = window.top.document.LayerModalUtility.getModal('psnlTimeStaLayer');
		searchSabun = modal.parameters.searchSabun;
		searchSYm	= modal.parameters.searchSYm;
		searchEYm	= modal.parameters.searchEYm;
		sdate		= modal.parameters.sdate;
		edate		= modal.parameters.edate;

		$("#searchSabun").val(searchSabun);
		$("#searchSYm").val(searchSYm);
		$("#searchEYm").val(searchEYm);
		$("#sdate").val(sdate);
		$("#edate").val(edate);

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='gntNmV3' mdef='근태종류'/>",	Type:"Text",      	Hidden:0,  	Width:100,  Align:"Center",	ColMerge:0,   	SaveName:"gntNm",			KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			//{Header:"<sht:txt mid='applYmdV10' mdef='신청일|신청일'/>",			Type:"Date",      	Hidden:0,  	Width:90,   Align:"Center",	ColMerge:1,   	SaveName:"applYmd",			KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='ymdV9' mdef='일자'/>",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,		SaveName:"ymd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			//{Header:"신청기간|종료일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,		SaveName:"eYmd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='holDayV3' mdef='적용\n일수'/>",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,		SaveName:"holDay",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='applStatusNm' mdef='신청상태'/>",	Type:"Text",      	Hidden:0,  	Width:100,	Align:"Center",	ColMerge:0,   	SaveName:"applStatusNm",	KeyField:0, Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

		// 헤더 머지
		sheet1.SetMergeSheet( msAll);
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlTimeStaPopList", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row,"sabun",sabun);
			sheet1.SetCellValue(row,"reqYmd",reqYmd);
			sheet1.SetCellValue(row,"reqGb",reqGb);
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/SaveData.do?cmd=savePsnalInfoUpdLicPop", $("#sheet1Form").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun"  />
		<input type="hidden" id="searchSYm" name="searchSYm" />
		<input type="hidden" id="searchEYm" name="searchEYm" />
		<input type="hidden" id="sdate" name="sdate" />
		<input type="hidden" id="edate" name="edate" />
	</form>
	<div class="modal_body">
		<div class="sheet_title outer">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='psnlTimeStaPop' mdef='근태상세내역'/></li>
			</ul>
		</div>
		<div id="sheet1_wrap" ></div>
	</div>
	<div class="modal_footer">
		<ul>
			<li>
				<btn:a href="javascript:closeCommonLayer('psnlTimeStaLayer');" css="btn outline_gray large" mid="close" mdef="닫기"/>
			</li>
		</ul>
	</div>
</div>
</body>
</html>