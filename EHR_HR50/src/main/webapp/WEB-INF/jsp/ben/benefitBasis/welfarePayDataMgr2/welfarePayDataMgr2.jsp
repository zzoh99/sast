<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>복리후생마감관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 복리후생마감관리
 * @author JM
-->
<script type="text/javascript">
var procCallResultMsg = "" ;

$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msAll};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"선택",		Type:"DummyCheck",	Hidden:0,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"check",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
		{Header:"사업장코드",	Type:"Combo",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"복리후생업무구분", Type:"Combo",     Hidden:0,  Width:100,       Align:"Center",  ColMerge:0,   SaveName:"benefitBizCd",   KeyField:1, Format:"", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"마감상태",		Type:"Combo",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"closeSt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"최종작업시간",	Type:"Text",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"chkdate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"최종작업자",	Type:"Text",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"chkid",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"비고",		Type:"Text",		Hidden:0,	Width:300,			Align:"Left",	ColMerge:0,	SaveName:"bigo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
		{Header:"B_B_C",	Type:"Text",		Hidden:1,	Width:300,			Align:"Left",	ColMerge:0,	SaveName:"benefitBizCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 사업장(TCPN121)
	//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
	var url     = "queryId=getBusinessPlaceCdList";
	var allFlag = true;
	if ("${ssnSearchType}" != "A"){
		url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
		allFlag = false;
	}		
	var businessPlaceCd = "";
	if(allFlag) {
		businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장	
	} else {
		businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
	}
	sheet1.SetColProperty("businessPlaceCd", {ComboText:businessPlaceCd[0], ComboCode:businessPlaceCd[1]});
	
	//복리후생업무구분(B10230)
	url     = "queryId=getBenManagerList";
	allFlag = true;
	if ("${ssnSearchType}" != "A"){
		allFlag = false;
	}		
	var benefitBizCdList = "";
	if(allFlag) {
		benefitBizCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장	
	} else {
		benefitBizCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
	}
	sheet1.SetColProperty("benefitBizCd", {ComboText:"|"+benefitBizCdList[0], ComboCode:"|"+benefitBizCdList[1]} );

	// 마감상태코드(S90003)
	var closeSt = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S90003"), "");
	sheet1.SetColProperty("closeSt", {ComboText:"|"+closeSt[0], ComboCode:"|"+closeSt[1]});

    $("#schBusinessPlaceCd").html(businessPlaceCd[2]);
    $("#schBenefitBizCd").html(benefitBizCdList[2]);


	$(window).smartresize(sheetResize);
	sheetInit();

	$("#ym").datepicker2({ymonly:true});
	$("#ym").val("${curSysYyyyMMHyphen}");

	$("#schBusinessPlaceCd,#schBenefitBizCd").on("change",function(){
		doAction1('Search');
	});

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

function chkInVal() {
	if ($("#ym").val() == "") {
		alert("대상년월을 입력하십시오.");
		$("#ym").focus();
		return false;
	}

	return true;
}

function chkClose() {
	var rowCnt = sheet1.RowCount();
	for (var i=1; i<=rowCnt; i++) {
		if (sheet1.GetCellValue(i, "sStatus") == "D" && sheet1.GetCellValue(i, "closeSt") == "10005") {
			alert("마감상태 입니다.");
			sheet1.SelectCell(i, "closeCd");
			return false;
		}
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

			sheet1.DoSearch("${ctx}/WelfarePayDataMgr.do?cmd=getWelfarePayDataMgr2List", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			// 중복체크
			if (!dupChk(sheet1, "ym|closeCd", false, true)) {break;}

			IBS_SaveName(document.sheet1Form,sheet1)
			sheet1.DoSave("${ctx}/WelfarePayDataMgr.do?cmd=saveWelfarePayDataMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			var Row = sheet1.DataInsert();
			sheet1.SetCellValue(Row, "ym", $("#ym").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 2);
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

		case "InsertMonthData":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			var prcYm = $("#ym").val();
			// 자료생성
			if (confirm("전월자료를 복사 하시겠습니까?")) {
				var result = ajaxCall("${ctx}/WelfarePayDataMgr.do?cmd=insertWelfarePayDataMgrMonthData", "ym="+prcYm, false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (parseInt(result["Result"]["Code"]) > 0) {
						alert("전월자료 복사 하였습니다.");
						doAction1("Search");
					} else if (result["Result"]["Message"] != null) {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("전월자료 복사 중 오류입니다.");
				}
			}
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

function callProc(Row, procName) {
	if( sheet1.RowCount("I") > 1 ) {
		alert("입력중인 행이 존재합니다. 저장후 처리하시기 바랍니다.") ;
		return ;
	}

	var params = "&searchPayActionCd="+ $("#payActionCd").val() +
				 "&searchBusinessPlaceCd="+sheet1.GetCellValue(Row, "businessPlaceCd") +
				 "&searchBenefitBizCd="+sheet1.GetCellValue(Row, "benefitBizCd") ;

	var ajaxCallCmd = "call"+procName ;
 
	var data = ajaxCall("/WelfarePayDataMgr.do?cmd="+ajaxCallCmd,params,false);


	if(data == null || data.Result == null) {
		msg = procName+"를 사용할 수 없습니다." ;
		return msg ;
	} 
	
	if(data.Result.Code == null || data.Result.Code == "OK") {
		msg = "TRUE" ;
		procCallResultMsg = data.Result.Message ; 
	} else {
    	msg = Row+"행 데이터 처리도중 : "+data.Result.Message;
	} 

	return msg ;
}

function callProcPerRow(procName) {
	if( $("#searchPayActionCd").val() == "" ) {
		alert("급여일자를 선택하여 주십시오.") ; return ;
	}

	var cpnClose = ajaxCall("${ctx}/WelfarePayDataMgr.do?cmd=getCpnQueryList", "queryId=getCpnCloseYnMap&payActionCd="+$("#payActionCd").val(), false);
	var cpnCloseYn = "N";

	if (cpnClose.DATA != null && cpnClose.DATA != "" && typeof cpnClose.DATA[0] != "undefined") {
		cpnCloseYn = cpnClose.DATA[0].closeYn;
	} else if (cpnClose.Message != null && cpnClose.Message != "") {
		alert(cpnClose.Message);
		return;
	}

	if(cpnCloseYn == "Y") {
		alert("해당 급여작업이 마감되었습니다.");
		return;
	}

	var chkRows = sheet1.FindCheckedRow("check");
	if(chkRows == "") {
		alert("<msg:txt mid='110132' mdef='선택된 행이 없습니다.'/>") ;
		return;
	}

	var arrRows = chkRows.split("|");

	for( var i = 1; i < arrRows.length; i++ ) {
		const row = arrRows[i];
		if(sheet1.GetCellValue(row, "check") == "Y") {
			if(sheet1.GetCellValue(row, "closeSt") == "10001" && procName != "P_BEN_PAY_DATA_CREATE" ) {
				alert("작업전상태인 데이터는 작업만 가능합니다.") ;
				sheet1.SelectCell(row, "closeSt") ;
				return ;
			}
			if(sheet1.GetCellValue(row, "closeSt") == "10003" && (procName == "P_BEN_PAY_DATA_CREATE" || procName == "P_BEN_PAY_DATA_CLOSE_CANCEL")  ) {
				alert("작업상태인 데이터는 작업취소 또는 마감만 가능합니다.") ;
				sheet1.SelectCell(row, "closeSt") ;
				return ;
			}
			if(sheet1.GetCellValue(row, "closeSt") == "10005" && procName != "P_BEN_PAY_DATA_CLOSE_CANCEL") {
				alert("마감상태인 데이터는 마감취소만 가능합니다.") ;
				sheet1.SelectCell(row, "closeSt") ;
				return ;
			}
		}
	}

	const procNm = (procName) => {
		return (procName === "P_BEN_PAY_DATA_CREATE") ? "작업"
				: (procName === "P_BEN_PAY_DATA_CREATE_DEL") ? "작업취소"
						: (procName === "P_BEN_PAY_DATA_CLOSE") ? "마감"
								: (procName === "P_BEN_PAY_DATA_CLOSE_CANCEL") ? "마감취소" : "";
	}

	progressBar(true, procNm(procName) + " 중입니다.");
	setTimeout(
		function(){

			for( var i = 0; i < arrRows.length ; i++ ) {

				var checker = callProc(arrRows[i], procName) ;
				if( checker != "TRUE" ) {
					progressBar(false) ;
					alert( checker ) ;
					return ;
				}
			}

			progressBar(false) ;
			alert(procCallResultMsg) ;
			doAction1("Search") ;
		}
		, 100);
}


//최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-RETRO.소급)
	var paymentInfo = ajaxCall("${ctx}/WelfarePayDataMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,00002,", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);
		$("#payCd").val(paymentInfo.DATA[0].payCd);
		doAction1("Search");
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

//급여일자 검색 팝업
function payActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
		, parameters : {
			runType : '00001,0002'
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
					$("#payCd").val(result.payCd);

					if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
						doAction1("Search");
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
						<th>급여일자</th>
						<td>
							<input type="hidden" id="payActionCd" name="payActionCd" value="" />
							 <input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
							 <a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
							 <input type="hidden" id="payPeopleStatus" name="payPeopleStatus" value="" /><input type="hidden" id="payCd" name="payCd" value="" />
						</td>
						<th>사업장</th>
						<td>
							<select id="schBusinessPlaceCd" name="schBusinessPlaceCd">
						</td>
						<th>복리후생업무구분</th>
						<td>
							<select id="schBenefitBizCd" name="schBenefitBizCd">
						</td>
						<td>
							<a href="javascript:doAction1('Search')" class="button authR">조회</a>
						</td>
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
							<li id="txt" class="txt">복리후생마감관리</li>
							<li class="btn">
<!-- 								<a href="javascript:doAction1('InsertMonthData')"	class="basic authA">전월자료복사</a>  -->
								<a href="javascript:callProcPerRow('P_BEN_PAY_DATA_CREATE')"		class="btn filled authA">작업</a>
								<a href="javascript:callProcPerRow('P_BEN_PAY_DATA_CREATE_DEL')"	class="btn filled authA">작업취소</a>
								<a href="javascript:callProcPerRow('P_BEN_PAY_DATA_CLOSE')"			class="btn outline authA">마감</a>
								<a href="javascript:callProcPerRow('P_BEN_PAY_DATA_CLOSE_CANCEL')"		class="btn outline authA">마감취소</a>
<!-- 								<a href="javascript:doAction1('Insert')"			class="basic authA">입력</a> -->
<!-- 								<a href="javascript:doAction1('Copy')"				class="basic authA">복사</a> -->
<!-- 								<a href="javascript:doAction1('Save')"				class="basic authA">저장</a> -->
								<a href="javascript:doAction1('Down2Excel')"		class="btn authR">다운로드</a>
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