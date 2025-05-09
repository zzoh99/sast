<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112749' mdef='국민연금추가/환급액관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 국민연금추가/환급액관리
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:6, MergeSheet:msHeaderOnly};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",					Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='suname' mdef='성명|성명'/>",					Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2017082500567' mdef='호칭|호칭'/>",				Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='manageCdV1' mdef='사원구분|사원구분'/>",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='qOrgNmV4' mdef='소속|소속'/>",					Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='workTypeNmV4' mdef='직군|직군'/>",					Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jikchakNmV8' mdef='직책|직책'/>",					Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jikgubCdV1' mdef='직급|직급'/>",					Type:"Combo",		Hidden:Number("${jgHdn}"),					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jikweeCdV1' mdef='직위|직위'/>",					Type:"Combo",		Hidden:Number("${jwHdn}"),					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='idno' mdef='주민번호|주민번호'/>",				Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='statusCdV2' mdef='재직상태|재직상태'/>",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='empYmdV1' mdef='입사일|입사일'/>",					Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='gempYmdV1' mdef='그룹입사일|그룹입사일'/>",				Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='benefitBizCd_V2698' mdef='복리후생업무구분코드|복리후생업무구분코드'/>",	Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"benefitBizCd",KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='payActionCdV3' mdef='급여계산코드|급여계산코드'/>",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='mon7_V4' mdef='본인부담금|월보험료'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon7",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='addSelfMon_V2760' mdef='본인부담금|환급/추징'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"addSelfMon",	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon8_V4' mdef='본인부담금|퇴직전환금'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon8",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='addReasonCd' mdef='발생사유|발생사유'/>",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"addReasonCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직군코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

	// 직책코드(H20020)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	sheet1.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});


	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 사원구분코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

	// 추가/환급 사유코드(B10270)
	var addReasonCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B10270"), "");
	sheet1.SetColProperty("addReasonCd", {ComboText:"|"+addReasonCd[0], ComboCode:"|"+addReasonCd[1]});

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사원구분코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	$("#manageCd").html(manageCd[2]);
	$("#manageCd").select2({placeholder:("${ssnLocaleCd}" != "en_US" ? " 선택" : " Select")});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	$("#statusCd").html(statusCd[2]);
	$("#statusCd").select2({placeholder:("${ssnLocaleCd}" != "en_US" ? " 선택" : " Select")});

	$(window).smartresize(sheetResize);
	sheetInit();

	// 성명 입력시 자동완성 처리
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue){
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
					sheet1.SetCellValue(gPRow, "name",		rv["name"]);
					sheet1.SetCellValue(gPRow, "manageCd",	rv["manageCd"]);
					sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
					sheet1.SetCellValue(gPRow, "workType",	rv["workType"]);
					sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
					sheet1.SetCellValue(gPRow, "resNo",		rv["resNo"]);
					sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
					sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
					sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
				}
			}
		]
	});		
	
	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

// 필수값/유효성 체크
function chkInVal(sAction) {
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
			if (!chkInVal(sAction)) {
				break;
			}

			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));

			sheet1.DoSearch("${ctx}/StaPenAddBackMgr.do?cmd=getStaPenAddBackMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크(복리후생업무구분코드|사번|급여계산코드)
			if (!dupChk(sheet1, "benefitBizCd|sabun|payActionCd", false, true)) {break;}
			IBS_SaveName(document.sheet1SaveForm,sheet1);
			sheet1.DoSave("${ctx}/StaPenAddBackMgr.do?cmd=saveStaPenAddBackMgr", $("#sheet1SaveForm").serialize());
			break;

		case "Insert":
			// 필수값 체크
			if (!chkInVal(sAction)) {
				break;
			}

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "benefitBizCd", "10"); // 복리후생업무구분코드(B10230-10.국민연금)
			sheet1.SetCellValue(Row, "payActionCd", $("#payActionCd").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 2);
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "LoadExcel":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var d = new Date();
			var fName = "국민연금추가_환급액관리_" + d.getTime();
			var param  = {FileName:fName, DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;

		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"sabun|mon7|addSelfMon|mon8|addReasonCd"});
			break;
	}
}

function sheet1_OnLoadExcel() {
	$("#searchPayActionCd").val($("#payActionCd").val());
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 1) {
			if (colName == "name") {
				// 사원검색 팝업
				empSearchPopup(Row, Col);
			}
		}
	}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

// 사원검색 팝업
function empSearchPopup(Row, Col) {
	if(!isPopup()) {return;}

	var w		= 840;
	var h		= 520;
	var url		= "/Popup.do?cmd=employeePopup";
	var args	= new Array();

	gPRow = Row;
	pGubun = "employeePopup";

	openPopup(url+"&authPg=R", args, w, h);
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00001.급여)
	var paymentInfo = ajaxCall("${ctx}/StaPenAddBackMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,", false);

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

// 급여일자 검색 팝입
function payActionSearchPopup() {
	if(!isPopup()) {return;}

	var w		= 800;
	var h		= 520;
	var url		= "/PayDayPopup.do?cmd=viewPayDayLayer";
	let parameters = {
		runType : '00001,00003,R0001,00002,ETC,J0001,R0001,R0003'
	};

	gPRow = "";
	pGubun = "searchPayDayPopup";

	//openPopup(url+"&authPg=R", args, w, h);

    let layerModal = new window.top.document.LayerModal({
          id : 'payDayLayer'
        , url : url
        , parameters : parameters
        , width : w
        , height : h
        , title : '급여일자 조회'
        , trigger :[
            {
                  name : 'payDayTrigger'
                , callback : function(result){
                	getReturnValue(result);
                }
            }
        ]
    });
    layerModal.show();
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	//var rv = $.parseJSON('{' + returnValue+ '}');
	var rv =  returnValue;

    if(pGubun == "employeePopup"){
		sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
		sheet1.SetCellValue(gPRow, "name", rv["name"]);
		sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
		sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
		sheet1.SetCellValue(gPRow, "workType", rv["workType"]);
		sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
		sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
		sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
		sheet1.SetCellValue(gPRow, "manageCd", rv["manageCd"]);
		sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
		sheet1.SetCellValue(gPRow, "empYmd", rv["empYmd"]);
		sheet1.SetCellValue(gPRow, "gempYmd", rv["gempYmd"]);
		sheet1.SetCellValue(gPRow, "resNo", rv["resNo"]);
    } else if(pGubun == "searchPayDayPopup") {
		$("#payActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);
    }
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="multiManageCd" name="multiManageCd" value="" />
		<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td colth="6">  <input type="hidden" id="payActionCd" name="payActionCd" value="" />
															<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
						 <a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
					</tr>
					<tr>
						<th><tit:txt mid='103784' mdef='사원구분'/></th>
						<td>  <select id="manageCd" name="manageCd" multiple=""> </select> </td>
						<th><tit:txt mid='104472' mdef='재직상태'/></th>
						<td>  <select id="statusCd" name="statusCd" multiple=""> </select> </td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>  <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
						<td> <btn:a href="javascript:doAction1('Search')"	css="btn dark authR" mid='search' mdef="조회"/>  </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<form id="sheet1SaveForm" name="sheet1SaveForm">
		<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112749' mdef='국민연금추가/환급액관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('DownTemplate')"	css="btn outline-gray authA" mid='down2ExcelV1' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction1('LoadExcel')"		css="btn outline-gray authA" mid='upload' mdef="업로드"/>
								<btn:a href="javascript:doAction1('Copy')"			css="btn outline-gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')"		css="btn outline-gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')"			css="btn filled authA" mid='save' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
