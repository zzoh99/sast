<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103836' mdef='인사기본(경력)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var sabun = "${param.sabun}";
	var enterCd = "${param.enterCd}";
	var dbLink = "${param.dbLink}";

	$(function() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='totAgreeYyCnt' mdef='경력인정년'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"careerYyCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='totAgreeMmCnt' mdef='경력인정월'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"careerMmCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='workYyCnt' mdef='재진년'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workYyCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='workMmCnt' mdef='재직월'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workMmCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='allCareerYyCnt' mdef='총경력년'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"allCareerYyCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='allCareerMmCnt' mdef='총경력월'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"allCareerMmCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",			Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"<sht:txt mid='cmpCd' mdef='직장코드'/>",		Type:"Popup",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"cmpCd",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='cmpNm' mdef='직장명'/>",			Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"cmpNm",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"sdate",		KeyField:1,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",			Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"edate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='jobCdV2' mdef='담당직무코드'/>",	Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jobCd",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='jobNm_V1931' mdef='담당직무'/>",		Type:"Popup",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jobNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='jobNmBef' mdef='담당직무\n(과거)'/>",Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jobNmBef",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"<sht:txt mid='businessNm' mdef='직무상세'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"businessNm",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",      	Hidden:0,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='workYmCntV1' mdef='근속기간'/>",		Type:"Text",      	Hidden:0,  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"workYmCnt",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetFocusAfterProcess(false);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "enterCd="+enterCd
						+"&sabun="+sabun
						+"&dbLink="+dbLink;

			sheet1.DoSearch( "${ctx}/PsnalCareerPop.do?cmd=getPsnalCareerUserList", param );
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "enterCd="+enterCd
						+"&sabun="+sabun
						+"&dbLink="+dbLink;

			sheet2.DoSearch( "${ctx}/PsnalCareerPop.do?cmd=getPsnalCareerList", param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
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
			getSheetData();
			doAction2('Search');
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			sheetResize();
			
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 시트에서 폼으로 세팅.
	function getSheetData() {

		var row = sheet1.LastRow();

		if(row == 0) {
			return;
		}

		$('#careerYyCnt').val(sheet1.GetCellValue(row,"careerYyCnt"));
		$('#careerMmCnt').val(sheet1.GetCellValue(row,"careerMmCnt"));
		$('#careerYyCntTxt').text(sheet1.GetCellValue(row,"careerYyCnt")+"년");
		$('#careerMmCntTxt').text(sheet1.GetCellText(row,"careerMmCnt")+"개월");		
		$('#workYyCntTxt').text(sheet1.GetCellValue(row,"workYyCnt")+"년");
		$('#workMmCntTxt').text(sheet1.GetCellValue(row,"workMmCnt")+"개월");
		$('#allCareerYyCntTxt').text(sheet1.GetCellValue(row,"allCareerYyCnt")+"년");
		$('#allCareerMmCntTxt').text(sheet1.GetCellValue(row,"allCareerMmCnt")+"개월");
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='career' mdef='경력'/></li>
		</ul>
		</div>
	</div>

	<form id="infoFrom" name="infoFrom">
		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="13%" />
			<col width="21%" />
			<col width="13%" />
			<col width="21%" />
			<col width="13%" />
			<col width="*" />
		</colgroup>
		<tr>
			<th><tit:txt mid='104331' mdef='입사전 경력년수'/></th>
			<td>
				<span id="careerYyCntTxt"></span>&nbsp;<span id="careerMmCntTxt" style="display:none;"></span>
			</td>
			<th><tit:txt mid='104536' mdef='현 재직년수'/></th>
			<td>
				<span id="workYyCntTxt"></span>&nbsp;<span id="workMmCntTxt"></span>
			</td>
			<th><tit:txt mid='104537' mdef='총 경력년수'/></th>
			<td>
				<span id="allCareerYyCntTxt"></span>&nbsp;<span id="allCareerMmCntTxt"></span>
			</td>
		</tr>
		</table>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='104538' mdef='전근무지 이력'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction2('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
