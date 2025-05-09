<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>근무상세내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">
	$(function() {
		createIBSheet3(document.getElementById('sheet1_wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");
		var searchSabun = "";
		var searchSYm   = "";
		var searchEYm   = "";
		var sdate = "";
		var edate = "";
		var payType = "";
		
		const modal = window.top.document.LayerModalUtility.getModal('psnlWorkStaLayer');
		searchSabun = modal.parameters.searchSabun;
		searchSYm	= modal.parameters.searchSYm;
		searchEYm	= modal.parameters.searchEYm;
		sdate		= modal.parameters.sdate;
		edate		= modal.parameters.edate;
		payType 	= modal.parameters.payType;

		$("#searchSabun").val(searchSabun);
		$("#searchSYm").val(searchSYm);
		$("#searchEYm").val(searchEYm);
		$("#searchSYmd").val(sdate);
		$("#searchEYmd").val(edate);
		$("#payType").val(payType);

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 }
		]; IBS_InitSheet(sheet1, initdata1);
		sheet1.SetEditable("${editable}");

		sheet1.SetVisible(true);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	$(function() {
		$("#searchSYm").mask("1111-11");
		$("#searchEYm").mask("1111-11");
		$("#searchSYm").datepicker2({ymonly:true});
		$("#searchEYm").datepicker2({ymonly:true});
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchSYm").val() == "" || $("#searchEYm").val() == "") {
				alert("<msg:txt mid='109965' mdef='대상년월은 필수값 입니다.'/>") ;
				$("#searchSYm").focus() ;
				return ;
			}
			searchTitleList();
			sheet1.DoSearch( "${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlWorkStaPopList", $("#sheet1Form").serialize());
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

	/*SETTING HEADER LIST*/
	function searchTitleList() {

		var titleList = ajaxCall("${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlWorkStaPopHeaderList", $("#sheet1Form").serialize(), false);
		if (titleList != null && titleList.DATA != null) {
			sheet1.Reset();
			var fixedCnt = 0 ;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

			initdata1.Cols = [];
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",       	Type:"${sDelTy}",   Hidden:1,  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0};
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",       	Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0};
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='ymdV7' mdef='근무일|근무일'/>",		Type:"Date",		Hidden:0,  Width:75,   Align:"Center",  ColMerge:1,   SaveName:"ymd",	   		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='dayNm' mdef='요일|요일'/>",			Type:"Text",		Hidden:0,  Width:30,   Align:"Center",  ColMerge:1,   SaveName:"dayNm",	   		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='gubunV7' mdef='구분|구분'/>",			Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"dayType",	   	KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='timNm' mdef='근무시간명|근무시간명'/>",Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"timNm",	   		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='inYmd' mdef='출근|일'/>",			Type:"Date",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"inYmd",	   		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='inHm' mdef='출근|시간'/>",			Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"inHm",	   		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='outYmd' mdef='퇴근|일'/>",			Type:"Date",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"outYmd",	   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='outHm' mdef='퇴근|시간'/>",			Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"outHm",	   		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };

			//값 매핑시 앞쪽 고정컬럼 이후부터 매핑하기위해 사용
			FIXED_HEAD_CNT = fixedCnt ;

			var i = 0 ;
			for(; i<titleList.DATA.length; i++) {
				//alert("i : " + i);
				initdata1.Cols[i+fixedCnt] = {Header:titleList.DATA[i].mReportNm + "|" + titleList.DATA[i].reportNm,	Type:"AutoSum",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:1,	SaveName:"hour"+(i+1),	KeyField:0,	Format:"",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			}
			IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

			$(window).smartresize(sheetResize); sheetInit();
		}
	}


</script>
</head>

<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheet1Form" name="sheet1Form" >
			<input type="hidden" id="searchSabun" name="searchSabun"  />
			<input type="hidden" id="sdate" name="sdate" />
			<input type="hidden" id="edate" name="edate" />
			<input type="hidden" id="payType" name="payType" />
			<input type="hidden" id="searchSYmd" name="searchSYmd" />
			<input type="hidden" id="searchEYmd" name="searchEYmd" />
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='114444' mdef='대상년월'/> </th>
							<td>
								<input id="searchSYm" name ="searchSYm" type="text" class="date2 required"  value="${curSysYyyyMMHyphen}" maxlength="7" size="7" /> ~
								<input id="searchEYm" name ="searchEYm" type="text" class="date2 required"  value="${curSysYyyyMMHyphen}" maxlength="7" size="7" />
							 </td>
							<td> <btn:a href="javascript:doAction1('Search');" id="btnSearch" css="btn dark" mid="search" mdef="조회"/> </td>
						</tr>
					</table>
				</div>
			</div>
			<div class="sheet_title outer">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='psnlWorkStaPop' mdef='근무상세내역'/></li>
			</ul>
			</div>
			<div id="sheet1_wrap"></div>
		</form>
	</div>
	<div class="modal_footer">
		<ul>
			<li>
				<btn:a href="javascript:closeCommonLayer('psnlWorkStaLayer');" css="btn outline_gray large" mid="close" mdef="닫기"/>
			</li>
		</ul>
	</div>
</div>
</body>
</html>