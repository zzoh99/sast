<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>퇴직월급여실지급일자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직월급여실지급일자관리
-->
<script type="text/javascript">
var gPayCd = "35,C5,CG, S4, S6,S1,S2";

$(function() {
	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata2.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		/*
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:0,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		*/
		{Header:"상태",			Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

		{Header:"사번",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"성명",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"실지급일\n(회계처리용)", Type:"Date",		Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,		SaveName:"realPaymentYmd",			KeyField:0,   CalcLogic:"", Format:"Ymd",     PointCount:0, UpdateEdit:1, InsertEdit:0, EditLen:50 },
		{Header:"소속",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

		{Header:"직급",			Type:"Combo",		Hidden:Number("${jgHdn}"),	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"호봉",			Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"salClass",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

		{Header:"입사일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"퇴사일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"급여계산코드",	Type:"Text",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"payActionCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(4);sheet2.SetEditable(true);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	sheet2.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사업장
	<c:choose>
		<c:when test="${ssnSearchType == 'A'}">
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "전체");
		</c:when>
		<c:otherwise>
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
		</c:otherwise>
	</c:choose>
	$("#businessPlaceCd").html(tcpn121Cd[2]);

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#businessPlaceCd").on("change", function() {
		doAction1("SearchPeople");
		doAction1("Search");
	})

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();

	$("#sabunName").on("keyup", function(event) {
		if (event.keyCode === 13) {
			//doAction2("Search");
			sabunName();
		}
	});
});

// 필수값/유효성 체크
function chkInVal() {
	if ($("#payActionCd").val() == "") {
		alert("급여일자를 선택하십시오.");
		$("#payActionNm").focus();
		return false;
	}

	return true;
}

// 마감여부 확인
function chkClose() {
	if ($("#payCalcCloseYn").is(":checked") == true) {
		alert("이미 마감되었습니다.");
		return false;
	}

	return true;
}


// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00001.급여)
	var paymentInfo = ajaxCall("${ctx}/SepMonPayMgr.do?cmd=getCpnQueryList&payCd="+gPayCd, "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,R0001", false);

	if (paymentInfo.DATA && paymentInfo.DATA[0]) {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);
		$("#payCd").val(paymentInfo.DATA[0].payCd);
		$("#closeYn").val(paymentInfo.DATA[0].closeYn);
		$("#closeStatusNm").html(getCloseStatusNm());
		$("#payYm").html(formatDate(paymentInfo.DATA[0].payYm, "-"));
	} else if (paymentInfo.Message) {
		alert(paymentInfo.Message);
	}
}

function sabunName(){

	if($("#sabunName").val() == "") return;

	var Row = 0;

	if( sheet2.GetSelectRow() < sheet2.LastRow()){
		Row = sheet2.FindText("name", $("#sabunName").val(), sheet2.GetSelectRow()+1, 2);
	}else{
		Row = -1;
	}

	if(Row > 0){
		sheet2.SelectCell(Row,"name");
		$("#sabunName").focus();
	}else if(Row == -1){
		if(sheet2.GetSelectRow() > 1){
			Row = sheet2.FindText("name", $("#sabunName").val(), 1, 2);
			if(Row > 0){
				sheet2.SelectCell(Row,"name");
				$("#sabunName").focus();
			}
		}
	}
	$("#sabunName").focus();
}

// 마감여부 확인
function chkClose2() {
	if ($("#closeYn").val() === "Y") {
		alert("급여가 이미 마감되었습니다.");
		return false;
	}

	return true;
}

function doAction2(sAction) {
	// pre task
	if (!chkInVal()) {
		return;
	}

	switch (sAction) {
		case "Search":
			sheet2.ClearHeaderCheck();

			sheet2.DoSearch("/SepMonPayMgr.do?cmd=getSepMonPayMgrList", $("#sheet1Form").serialize());

			$("#sabunName").focus();
			break;

		case "Save":
			// 마감여부 확인
			if (!chkClose2()) {
				break;
			}
			if(sheet2.RowCount() > 0) {
				for ( var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows(); i++){
					if(sheet2.GetCellValue(i, "payActionCd") == "" ) {
						sheet2.SetCellValue(i, "payActionCd", $("#payActionCd").val());
					}
				}
			}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave("${ctx}/SepMonPayMgr.do?cmd=saveSepMonPayMgr", $("#sheet1Form").serialize());
			break;
		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
	}
}

function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
    try {
		if (Msg)
			alert(Msg);

        sheetResize();
	} catch (ex) {
        alert("OnSearchEnd Event Error : " + ex);
    }
}

//저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg)
			alert(Msg);
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

//급여일자 조회 팝업
function openPayDayPopup() {

	const getCloseYn = (closeYn) => {
		return (closeYn === "0" || closeYn === "Y") ? "Y" : "N";
	}

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
		, parameters : {
			runType : '00001,R0001'
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					console.log(result);
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
					$("#payCd").val(result.payCd);
					$("#closeYn").val(getCloseYn(result.closeYn));
					$("#closeStatusNm").html(getCloseStatusNm());
					$("#payYm").html(formatDate(result.payYm, "-"));
					doAction2("Search");
				}
			}
		]
	});
	layerModal.show();
}

function getCloseStatusNm() {
	return ($("#closeYn") === "Y") ? "마감" : "미마감";
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<div class="inner">
		<form id="sheet1Form" name="sheet1Form" >
			<table border="0" cellpadding="0" cellspacing="0" class="default inner">
				<colgroup>
					<col width="7%" />
					<col width="18%" />
					<col width="7%" />
					<col width="18%" />
					<col width="7%" />
					<col width="18%" />
					<col width="7%" />
					<col width="18%" />
				</colgroup>
				<tr>
					<th>급여일자</th>
					<td>
						<input type="hidden" id="payActionCd" name="payActionCd" value="" />
						<input type="text" id="payActionNm" name="payActionNm" class="text required readonly w150" value="" readonly />
						<a href="javascript:openPayDayPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<input type="hidden" id="payPeopleStatus" name="payPeopleStatus" value="" />
						<input type="hidden" id="payCd" name="payCd" value="" />
						<input type="hidden" id="closeYn" name="closeYn" value="" />
					</td>
					<th>사업장</th>
					<td>
						<select id="businessPlaceCd" name="businessPlaceCd"> </select>
					</td>
					<th>대상년월</th>
					<td id="payYm"> </td>
					<th>급여마감여부</th>
					<td id="closeStatusNm">
					</td>
				</tr>
			</table>

			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">
							<span>퇴직월급여실지급일자관리</span>
						</li>
						<li class="btn">
							사번/성명&nbsp;<input type="text" id="sabunName" name="sabunName" class="text" value="" onKeyUp="check_Enter();"/>
							<a href="javascript:doAction2('Search')"		class="button authR">조회</a>
							<a href="javascript:doAction2('Save')"			class="basic authA">저장</a>
							<a href="javascript:doAction2('Down2Excel')"	class="basic authR">다운로드</a>
						</li>
					</ul>
				</div>
			</div>
		</form>
		<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","${ssnLocaleCd}"); </script>
	</div>
</div>
</body>
</html>