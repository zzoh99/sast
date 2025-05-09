<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>압류관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 압류관리
 * @author JM
-->
<script type="text/javascript">
$(function() {
	
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"세부\n내역",		Type:"Image",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"detail",			Cursor:"Pointer",				EditLen:1 },
		{Header:"접수일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"attatchSymd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"성명",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"계약유형",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"소속",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직구분",			Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직급",			Type:"Combo",		Hidden:Number("${jgHdn}"),	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직책",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직위",			Type:"Combo",		Hidden:Number("${jwHdn}"),	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"주민번호",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"resNo",			KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"재직상태",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"입사일",			Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"그룹입사일",		Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"퇴사일",			Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사건번호",		Type:"Text",		Hidden:0,					Width:90,			Align:"Left",	ColMerge:0,	SaveName:"attatchNo",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
		{Header:"공제항목코드",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"진행상태",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"attatchStatus",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"청구액",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"attachMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"공제\n누계",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"attTotMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"입금\n누계",		Type:"Int",			Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"receiptMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"청구잔액",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"remainAmt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"종료일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"invalidYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"결정일자(법원)",	Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"courtYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사건구분",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"attatchType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"채권자",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bonder",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
		{Header:"채권\n내용",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bondContent",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2000 },
		{Header:"채무\n내용",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"debtContent",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2000 },
		{Header:"관련사건",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"relationEvent",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"담당자(채권)",	Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bondCharger",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
		{Header:"전화번호(채권자)",Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bondHandNo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
		{Header:"이동번호(채권자)",Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bondTelNo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
		{Header:"은행",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"attBankNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
		{Header:"계좌번호",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"attAccountNo",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
		{Header:"예금주명",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"attDepositor",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
		{Header:"목록",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"list",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
		{Header:"비고",			Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
		{Header:"신구법적용여부",	Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"lawApplyType",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"급여항목코드",	Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"변제금액",		Type:"Int",			Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"dischargeMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true); sheet1.SetCountPosition(0); sheet1.SetVisible(true);
	
	doAction1("Search");

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직구분코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	sheet1.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 계약유형코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

	// 사건구분(C00200)
	var attatchType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00200"), "");
	sheet1.SetColProperty("attatchType", {ComboText:"|"+attatchType[0], ComboCode:"|"+attatchType[1]});

	// 압류진행상태(C00020)
	var attatchStatus = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00020"), "");
	sheet1.SetColProperty("attatchStatus", {ComboText:"|"+attatchStatus[0], ComboCode:"|"+attatchStatus[1]});

	sheet1.SetDataLinkMouse("detail", 1);
	sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 압류진행상태(C00020)
	var attatchStatus = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00020"), "");
	$("#attatchStatus").html(attatchStatus[2]);
	$("#attatchStatus").select2({placeholder:" 선택"});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	$("#statusCd").html(statusCd[2]);
	$("#statusCd").select2({placeholder:" 선택"});

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#orgNm, #sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});

	$("#fromAttatchSymd").datepicker2({startdate:"toAttatchSymd"});
	$("#toAttatchSymd").datepicker2({enddate:"fromAttatchSymd"});
	//$("#fromAttatchSymd").val("${curSysYyyyMMddHyphen}");
	//$("#toAttatchSymd").val("${curSysYyyyMMddHyphen}");

	$("#fromAttatchSymd, #toAttatchSymd").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});
});

function chkInVal(sAction) {
	if (sAction == "Search") {
		if ($("#fromAttatchSymd").val() != "" && $("#toAttatchSymd").val() != "") {
			if (!checkFromToDate($("#fromAttatchSymd"),$("#toAttatchSymd"),"접수일자","접수일자","YYYYMMDD")) {
				return false;
			}
		}
	} else if (sAction == "Save") {
		var rowCnt = sheet1.RowCount();
		var delCnt = 0;
		for (var i=1; i<=rowCnt; i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "D") {
				delCnt++;
			}
		}
		if (delCnt == 0) {
			alert("삭제할 대상을 선택하십시오.");
			return false;
		}
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));
			$("#multiAttatchStatus").val(getMultiSelect($("#attatchStatus").val()));

			sheet1.DoSearch("${ctx}/AttachMgr.do?cmd=getAttachMgrList", $("#sheet1Form").serialize());
			break;

		case "Delete":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/AttachMgr.do?cmd=saveAttachMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			attachMgrDtlPopup(0, sAction);
			break;

		case "Copy":
			var Row = sheet1.GetSelectRow();
			if (Row > 1) {
				attachMgrDtlPopup(Row, sAction);
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

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnClick(Row, Col, Value) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if (colName == "sDelete") {
				if (sheet1.GetCellValue(Row, "sStatus") == "D") {
					sheet1.SetCellEditable(Row,"detail",0);
				} else {
					sheet1.SetCellEditable(Row,"detail",1);
				}
			}
			if (colName == "detail") {
				// 압류세부내역 팝업
				if (sheet1.GetCellValue(Row, "sStatus") == "R" || sheet1.GetCellValue(Row, "sStatus") == "U") {
					attachMgrDtlPopup(Row, "Update");
				}
			}
		}
	} catch(ex) { }
}

// 압류세부내역 팝업
function attachMgrDtlPopup(Row, sAction) {
	var w		= 800;
	var h		= 730;
	var url		= "/AttachMgr.do?cmd=viewAttachMgrDtlPopup&authPg=${authPg}";
	let p = {};
	if (sAction == "Update" || sAction == "Copy") {
		p = {
			sabun			: sheet1.GetCellValue(Row, "sabun"),
			name			: sheet1.GetCellValue(Row, "name"),
			jikgubCd		: sheet1.GetCellValue(Row, "jikgubCd"),
			jikchakCd		: sheet1.GetCellValue(Row, "jikchakCd"),
			orgNm			: sheet1.GetCellValue(Row, "orgNm"),
			statusCd		: sheet1.GetCellValue(Row, "statusCd"),
			attatchSymd		: sheet1.GetCellValue(Row, "attatchSymd"),
			attatchNo		: sheet1.GetCellValue(Row, "attatchNo"),
			attatchType		: sheet1.GetCellValue(Row, "attatchType"),
			attatchStatus	: sheet1.GetCellValue(Row, "attatchStatus"),
			debtContent		: sheet1.GetCellValue(Row, "debtContent"),
			relationEvent	: sheet1.GetCellValue(Row, "relationEvent"),
			bonder			: sheet1.GetCellValue(Row, "bonder"),
			bondCharger		: sheet1.GetCellValue(Row, "bondCharger"),
			bondHandNo		: sheet1.GetCellValue(Row, "bondHandNo"),
			bondTelNo		: sheet1.GetCellValue(Row, "bondTelNo"),
			bondContent		: sheet1.GetCellValue(Row, "bondContent"),
			bondTelNo		: sheet1.GetCellValue(Row, "bondTelNo"),
			attBankNm		: sheet1.GetCellValue(Row, "attBankNm"),
			attAccountNo	: sheet1.GetCellValue(Row, "attAccountNo"),
			attDepositor	: sheet1.GetCellValue(Row, "attDepositor"),
			attachMon		: sheet1.GetCellValue(Row, "attachMon"),
			attTotMon		: sheet1.GetCellValue(Row, "attTotMon"),
			receiptMon		: sheet1.GetCellValue(Row, "receiptMon"),
			remainAmt		: sheet1.GetCellValue(Row, "remainAmt"),
			courtYmd		: sheet1.GetCellValue(Row, "courtYmd"),
			invalidYmd		: sheet1.GetCellValue(Row, "invalidYmd"),
			elementCd		: sheet1.GetCellValue(Row, "elementCd"),
			elementNm		: sheet1.GetCellValue(Row, "elementNm"),
			note			: sheet1.GetCellValue(Row, "note"),
			jikgubNm		: sheet1.GetCellText(Row, "jikgubCd"),
			jikchakNm		: sheet1.GetCellText(Row, "jikchakCd"),
			statusNm		: sheet1.GetCellText(Row, "statusCd"),
			attatchNoReadonly		: sheet1.GetCellValue(Row, "attatchNo"),
			sAction 		: sAction
		};
	} else {
		p = {
			sAction : sAction
		};
	}

	new window.top.document.LayerModal({
		id: 'attachMgrDtlLayer',
		url: url,
		parameters: p,
		width: w,
		height: h,
		title: '압류세부내역',
		trigger: [
			{
				name: 'attachMgrDtlTrigger',
				callback: function(rv) {
					if (rv.sAction === "Save") {
						doAction1("Search");
					}
				}
			}
		]
	}).show();
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />
		<input type="hidden" id="multiAttatchStatus" name="multiAttatchStatus" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>소속</th>
						<td> 
							<input type="text" id="orgNm" name="orgNm" class="text" value="" style="width:120px" />
						</td>
					 	<th>재직상태</th>
						<td>  <select id="statusCd" name="statusCd" multiple=""> </select> </td>
						<th>사번/성명</th>
						<td>  <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
					</tr>
					<tr>
						<th>접수일자</th>
						<td>  <input type="text" id="fromAttatchSymd" name="fromAttatchSymd" class="date2" /> ~ <input type="text" id="toAttatchSymd" name="toAttatchSymd" class="date2" /> </td>
						<th>진행상태</th>
						<td>  <select id="attatchStatus" name="attatchStatus" multiple=""> </select> </td>
						<td colspan="2"> <a href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">압류관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<!-- <a href="javascript:doAction1('Copy')"			class="basic authA">복사</a> -->
								<a href="javascript:doAction1('Delete')"		class="basic authA">삭제</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
