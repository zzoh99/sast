<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114215' mdef='소급대상소득선정'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 소급대상소득선정
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0},
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0},
		{Header:"<sht:txt mid='payActionCdV5' mdef='급여일자코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='rtrPayActionCd' mdef='소급대상급여계산코드'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"rtrPayActionCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payActionCd' mdef='급여일자'/>",			Type:"Popup",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payActionNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='payYmV2' mdef='급여년월'/>",			Type:"Date",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payYm",			KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 },
		{Header:"<sht:txt mid='payCdV5' mdef='급여구분코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='incomeAnnualPaymentYmd' mdef='지급일자'/>",			Type:"Date",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata2.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0},
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0},
		{Header:"<sht:txt mid='payActionCdV5' mdef='급여일자코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='rtrPayActionCd' mdef='소급대상급여계산코드'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"rtrPayActionCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",			Type:"Popup",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

// 필수값/유효성 체크
function chkInVal() {
	if ($("#payActionCd").val() == "") {
		alert("<msg:txt mid='109681' mdef='급여일자를 선택하십시오.'/>");
		$("#payActionNm").focus();
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			doAction1("Clear");
			doAction2("Clear");

			sheet1.DoSearch("${ctx}/RetroEleSetMgr.do?cmd=getRetroEleSetMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 중복체크
			if (!dupChk(sheet1, "payActionCd|rtrPayActionCd", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/RetroEleSetMgr.do?cmd=saveRetroEleSetMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			sheet1.SelectCell(sheet1.DataInsert(0), 2);
			doAction2("Clear");
			break;

		case "Copy":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			sheet1.SelectCell(sheet1.DataCopy(), 2);
			doAction2("Clear");
			break;

		case "PrcP_CPN_RETRO_ELE_INS":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			var payActionCd = $("#payActionCd").val();

			const convertYmdToYm = (ymd) => {
				const y = ymd.substring(0, 4);
				const m = ymd.substring(4, 6);
				return y + "." + m;
			}

			const payInfo = ajaxCall("${ctx}/RetroEleSetMgr.do?cmd=getCpnPayActionMap", "searchPayActionCd="+payActionCd, false).DATA;
			const msg = `\${convertYmdToYm(payInfo.ordSymd)} ~ \${convertYmdToYm(payInfo.ordEymd)} 기간 내 귀속된 급/상여 일자 데이터가 소급대상급여일자로 생성됩니다. 생성하시겠습니까?`;

			if (confirm(msg)) {

				progressBar(true, "소급대상 급여일자 및 항목 생성중입니다.");

				// 소급대상일자 및 항목자료 생성
				ajaxCall2("${ctx}/RetroEleSetMgr.do?cmd=prcP_CPN_RETRO_ELE_INS"
						, "payActionCd="+payActionCd
						, true
						, null
						, function(data) {
							progressBar(false);
							if (data && data.Result && data.Result.Code) {
								if (data.Result.Code === "0") {
									alert("<msg:txt mid='109677' mdef='자료생성 되었습니다.'/>");
									// 프로시저 호출 후 재조회
									doAction1("Search");
								} else if (data.Result.Message) {
									alert(data.Result.Message);
								}
							} else {
								alert("<msg:txt mid='109363' mdef='소급대상일자 및 항목자료 생성 오류입니다.'/>");
							}
						}, function() {
							progressBar(false);
						})
			}
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
}

function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			$("#rtrPayActionCd").val("");

			var Row = sheet1.GetSelectRow();
			if (Row > 0) {
				if (sheet1.GetCellValue(Row,"payActionCd") != null && sheet1.GetCellValue(Row,"payActionCd") != "" &&
					sheet1.GetCellValue(Row,"rtrPayActionCd") != null && sheet1.GetCellValue(Row,"rtrPayActionCd") != "") {
					$("#payActionCd").val(sheet1.GetCellValue(Row,"payActionCd"));
					$("#rtrPayActionCd").val(sheet1.GetCellValue(Row,"rtrPayActionCd"));
				}
			}

			sheet2.DoSearch("${ctx}/RetroEleSetMgr.do?cmd=getRetroEleSetMgrDtlList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 중복체크
			if (!dupChk(sheet2, "payActionCd|rtrPayActionCd|elementCd", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave("${ctx}/RetroEleSetMgr.do?cmd=saveRetroEleSetMgrDtl", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			var Row = sheet1.GetSelectRow();
			if (Row < 1) {
				alert("<msg:txt mid='alertRetroEleSetMgr1' mdef='선택된 Master 정보가 없습니다.'/>");
				break;
			} else if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") != "R") {
				alert("<msg:txt mid='alertRetroEleSetMgr2' mdef='새로 추가되거나 수정 중인 Master 정보에 대해서는 추가 작업을 할 수 없습니다.'/>");
				break;
			}

			var Row = sheet2.DataInsert(0);
			sheet2.SetCellValue(Row, "payActionCd", sheet1.GetCellValue(sheet1.GetSelectRow(), "payActionCd"));
			sheet2.SetCellValue(Row, "rtrPayActionCd", sheet1.GetCellValue(sheet1.GetSelectRow(), "rtrPayActionCd"));
			sheet2.SelectCell(Row, 2);
			break;

		case "Copy":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			sheet2.SelectCell(sheet2.DataCopy(), 2);
			break;

		case "Clear":
			sheet2.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
	}
}

//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		sheetResize();

		var Row = sheet1.GetSelectRow();
		if (Row > 0) {
			if (sheet1.GetCellValue(Row,"rtrPayActionCd") != null && sheet1.GetCellValue(Row,"rtrPayActionCd") != "") {
				$("#rtrPayActionCd").val(sheet1.GetCellValue(Row,"rtrPayActionCd"));
				// 항목조회
				doAction2("Search");
			}
		}
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "")
			alert(Msg);

		doAction1("Search");
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

//저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		if (Row > 0 && sheet1.GetCellValue(Row, "sStatus") != "I") {
			if (sheet1.GetCellValue(Row,"rtrPayActionCd") != null && sheet1.GetCellValue(Row,"rtrPayActionCd") != "") {
				$("#rtrPayActionCd").val(sheet1.GetCellValue(Row,"rtrPayActionCd"));
				// 항목조회
				doAction2("Search");
			}
		}
	} catch (ex) {
		alert("OnClick Event Error " + ex);
	}
}

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0 && colName == "payActionNm") {
			// 급여일자검색 팝업
			sheet1PayActionSearchPopup(Row, Col);
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

function sheet2_OnPopupClick(Row, Col) {
	try{
		var colName = sheet2.ColSaveName(Col);
		if (Row > 0 && colName == "elementNm") {
			// 항목검색 팝업
			elementSearchPopup(Row, Col);
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-RETRO.소급)
	var paymentInfo = ajaxCall("${ctx}/RetroEleSetMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=RETRO,", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("Search");
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

// sheet1 급여일자검색 팝업
function sheet1PayActionSearchPopup(Row, Col) {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : '00001,00002,00003'
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					sheet1.SetCellValue(Row, "payActionCd", $("#payActionCd").val());
					sheet1.SetCellValue(Row, "rtrPayActionCd", result.payActionCd);
					sheet1.SetCellValue(Row, "payActionNm", result.payActionNm);
					sheet1.SetCellValue(Row, "payCd", result.payCd);
					sheet1.SetCellValue(Row, "payYm", result.payYm);
					sheet1.SetCellValue(Row, "paymentYmd", result.paymentYmd);
				}
			}
		]
	});
	layerModal.show();
}

// 항목검색 팝업
function elementSearchPopup(Row, Col) {
	let layerModal = new window.top.document.LayerModal({
		id : 'payElementLayer'
		, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R'
		, parameters : {
			searchElementLinkType1 : 'retro'
			, elementType : 'A'
		}
		, width : 860
		, height : 520
		, title : '수당,공제 항목'
		, trigger :[
			{
				name : 'payTrigger'
				, callback : function(result){
					sheet2.SetCellValue(Row, "payActionCd", sheet2.GetCellValue(Row, "payActionCd"));
					sheet2.SetCellValue(Row, "rtrPayActionCd", sheet2.GetCellValue(Row, "rtrPayActionCd"));
					sheet2.SetCellValue(Row, "elementCd", result.resultElementCd);
					sheet2.SetCellValue(Row, "elementNm", result.resultElementNm);
				}
			}
		]
	});
	layerModal.show();
}

// 급여일자 검색 팝입
function payActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : 'RETRO'
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);

					if (result.payActionCd) {
						doAction1("Search");
					} else {
						doAction1("Clear");
						doAction2("Clear");
					}
				}
			}
		]
	});
	layerModal.show();
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>
							<input type="hidden" id="payActionCd" name="payActionCd" value="" />
							<input type="hidden" id="rtrPayActionCd" name="rtrPayActionCd" value="" />
							<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
							<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<td> <btn:a href="javascript:doAction1('PrcP_CPN_RETRO_ELE_INS')"	css="basic authA" mid='110741' mdef="작업"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="49%" />
			<col width="1%" />
			<col width="49%" />
		</colgroup>
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='104477' mdef='소급대상급여일자'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Search')"	css="button authR" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction1('Insert')"	css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')"		css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')"		css="basic authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td>
			</td>
			<td class="top">
				<div>
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='payElementPop4' mdef='수당,공제 항목'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction2('Search')"	css="button authR" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction2('Insert')"	css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Copy')"		css="basic authA" mid='110696' mdef="복사"/>
								<a href="javascript:doAction2('Save')"		class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
