<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114214' mdef='소급계산_급여대상자관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 소급계산
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var p = eval("${popUpStatus}");
$(function() {
	var payActionCd		= "";
	var payActionNm		= "";
	var businessPlaceCd	= "";
	var businessPlaceNm	= "";
	var closeYn			= "";

	var arg = p.window.dialogArguments;
	if( arg != undefined ) {
		payActionCd 	= arg["payActionCd"];
		payActionNm 	= arg["payActionNm"];
		businessPlaceCd = arg["businessPlaceCd"];
		businessPlaceNm = arg["businessPlaceNm"];
		closeYn 		= arg["closeYn"];
	}else{
	    if(p.popDialogArgument("payActionCd")!=null)		payActionCd  	= p.popDialogArgument("payActionCd");
	    if(p.popDialogArgument("payActionNm")!=null)		payActionNm  	= p.popDialogArgument("payActionNm");
	    if(p.popDialogArgument("businessPlaceCd")!=null)	businessPlaceCd  = p.popDialogArgument("businessPlaceCd");
	    if(p.popDialogArgument("businessPlaceNm")!=null)	businessPlaceNm  	= p.popDialogArgument("businessPlaceNm");
	    if(p.popDialogArgument("closeYn")!=null)			closeYn  	= p.popDialogArgument("closeYn");
    }
	$("#payActionCd").val(payActionCd);
	$("#payActionNm").val(payActionNm);
	$("#businessPlaceCd").val(businessPlaceCd);
	$("#businessPlaceNm").val(businessPlaceNm);
	$("#closeYn").val(closeYn);


	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:0,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"<sht:txt mid='payActionCdV7' mdef='소급계산코드'/>",	Type:"Text",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"payActionCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payPeopleStatus' mdef='작업\n대상'/>",	Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='payPeopleStatusText' mdef='작업'/>",		Type:"Text",		Hidden:0,					Width:50,			Align:"Left",	ColMerge:0,	SaveName:"payPeopleStatusText",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='businessPlaceCdV3' mdef='급여사업장'/>",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='ccCd' mdef='코스트센터'/>",	Type:"Combo",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"ccCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Popup",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",				KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",	Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",		Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='oldPayPeopleStatus' mdef='변경전급여대상자상태'/>",	Type:"Text",	Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"oldPayPeopleStatus",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직군코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 사원구분코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

	// 사업장(TCPN121)
	var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
	sheet1.SetColProperty("businessPlaceCd", {ComboText:"|"+tcpn121Cd[0], ComboCode:"|"+tcpn121Cd[1]});

	// 코스트센터(TORG109)
	var torg109Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=300", "queryId=getTorg109List", false).codeList, "");
	sheet1.SetColProperty("ccCd", {ComboText:"|"+torg109Cd[0], ComboCode:"|"+torg109Cd[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	$(".close").click(function() {
		p.self.close();
	});

	$("#sabunName").bind("keyup",function(event){
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});

	doAction1("SearchBasic");
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#payActionCd").val() == "") {
		alert("<msg:txt mid='alertPeopleSetPop1' mdef='급여일자를 확인하십시오.'/>");
		return false;
	}

	return true;
}
// 마감여부 확인
function chkClose() {
	if ($("#closeYn").val() == "Y") {
		alert("<msg:txt mid='alertPayCalcCre1' mdef='이미 마감되었습니다.'/>");
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "SearchBasic":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 기본사항조회
			var basicInfo = ajaxCall("${ctx}/RetroCalcCre.do?cmd=getRetroCalcCreBasicMap", $("#sheet1Form").serialize(), false);

			$("#payYm"		).html("");
			$("#payNm"		).html("");
			$("#ordYmd"		).html("");
			$("#paymentYmd"	).html("");
			$("#timeYm"		).html("");
//			$("#empStatus"	).html("");
			$("#empStatus"	).val("");
			$("#closeYn"	).val("");

			if (basicInfo.Map != null) {
				basicInfo = basicInfo.Map;
				$("#payYm"		).html(basicInfo.payYm		);
				$("#payNm"		).html(basicInfo.payNm		);
				$("#ordYmd"		).html(basicInfo.ordYmd		);
				$("#paymentYmd"	).html(basicInfo.paymentYmd	);
				$("#timeYm"		).html(basicInfo.timeYm		);
//				$("#empStatus"	).html(basicInfo.empStatus	);
				$("#empStatus"	).val(basicInfo.empStatus	);
				$("#closeYn"	).val(basicInfo.closeYn		);

				doAction1("Search");
			}
			break;			

		case "Search":
			sheet1.ClearHeaderCheck();

			sheet1.DoSearch("/RetroCalcCre.do?cmd=getRetroCalcCrePeopleSetList", $("#sheet1Form").serialize());
			peopleCnt();

			break;

		case "Save":
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/RetroCalcCre.do?cmd=saveRetroCalcCrePeopleSet", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", $("#payActionCd").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "PrcP_CPN_CAL_EMP_INS":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			if ($("#empStatus").html() != "10005") {
				var rowCnt = sheet1.RowCount();
				if (rowCnt > 0) {
					if (!confirm("<msg:txt mid='114756' mdef='이미 대상자가 존재합니다. 덮어쓰시겠습니까?'/>"))
						return;
				}

				if (confirm("<msg:txt mid='114775' mdef='[작업]을 실행하시겠습니까?'/>")) {

					var payActionCd = $("#payActionCd").val();
					var businessPlaceCd = $("#businessPlaceCd").val();
					// 급여대상자 생성
					var result = ajaxCall("${ctx}/RetroCalcCre.do?cmd=prcP_CPN_CAL_EMP_INS", "sabun=&payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd, false);

					if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
						if (result["Result"]["Code"] == "0") {
							alert("<msg:txt mid='alertPeopleSetPop4' mdef='급여대상자 생성 되었습니다.'/>");
							doAction1("Search");
							peopleCnt();
						} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
							alert(result["Result"]["Message"]);
						}
					} else {
						alert("<msg:txt mid='alertPeopleSetPop5' mdef='급여대상자 생성 오류입니다.'/>");
					}

				}
			} else {
				alert("<msg:txt mid='alertPeopleSetPop6' mdef='이미 마감되었습니다.n마감취소 후 작업이 가능합니다.'/>");
			}
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { alert(Msg); } 
		sheetResize();
	} catch (ex) { 
		alert("OnSearchEnd Event Error : " + ex); 
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { alert(Msg); } 
		doAction1("Search");
		peopleCnt();
	} catch (ex) { 
		alert("OnSaveEnd Event Error " + ex); 
	}
}

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if (colName == "name") {
				// 사원검색 팝업
				empSearchPopup(Row, Col);
			}
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

// 사원검색 팝업
function empSearchPopup(Row, Col) {

	if(!isPopup()) {return;}
	gPRow = Row;
	pGubun = "employeePopup";

	var w		= 840;
	var h		= 520;
	var url		= "/Popup.do?cmd=employeePopup";
	var args	= new Array();

	var result = openPopup(url+"&authPg=R", args, w, h);

}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "employeePopup"){

		var sabun			= rv["sabun"];
		var name			= rv["name"];
		var orgNm			= rv["orgNm"];
		var workType		= rv["workType"];
		var jikchakCd		= rv["jikchakCd"];
		var jikweeCd		= rv["jikweeCd"];
		var manageCd		= rv["manageCd"];
		var statusCd		= rv["statusCd"];
		var empYmd			= rv["empYmd"];
		var gempYmd			= rv["gempYmd"];
		var resNo			= rv["resNo"];
		var businessPlaceCd	= rv["businessPlaceCd"];
		var ccCd			= rv["ccCd"];

		sheet1.SetCellValue(gPRow, "sabun", sabun);
		sheet1.SetCellValue(gPRow, "name", name);
		sheet1.SetCellValue(gPRow, "orgNm", orgNm);
		sheet1.SetCellValue(gPRow, "workType", workType);
		sheet1.SetCellValue(gPRow, "jikchakCd", jikchakCd);
		sheet1.SetCellValue(gPRow, "jikweeCd", jikweeCd);
		sheet1.SetCellValue(gPRow, "manageCd", manageCd);
		sheet1.SetCellValue(gPRow, "statusCd", statusCd);
		sheet1.SetCellValue(gPRow, "empYmd", empYmd);
		sheet1.SetCellValue(gPRow, "gempYmd", gempYmd);
		sheet1.SetCellValue(gPRow, "resNo", resNo);
		sheet1.SetCellValue(gPRow, "businessPlaceCd", businessPlaceCd);
		sheet1.SetCellValue(gPRow, "ccCd", ccCd);
    }
}
/*
// 검색한 이름을 sheet에서 선택
function checkEnter() {
    if (event.keyCode==13) findName();
}

// 검색한 이름을 sheet에서 선택
function findName() {
	if ($("#name").val() == "") return;

	var Row = 0;
	if (sheet1.GetSelectRow() < sheet1.LastRow()) {
		Row = sheet1.FindText("name", $("#name").val(), sheet1.GetSelectRow()+1, 2);
	}else{
		Row = -1;
	}

	if (Row > 0) {
		sheet1.SetCellEditable(Row,"name",true);
		sheet1.SelectCell(Row,"name");
		sheet1.SetCellEditable(Row,"name",false);
	}else if (Row == -1) {
		if (sheet1.SelectRow > 1) {
			Row = sheet1.FindText("name", $("#name").val(), 1, 2);
			if (Row > 0) {
				sheet1.SetCellEditable(Row,"name",true);
				sheet1.SelectCell(Row,"name");
				sheet1.SetCellEditable(Row,"name",false);
			}
		}
	}
	$("#name").focus();
}*/

function peopleCnt(){
	var payActionCd = $("#payActionCd").val();
	var businessPlaceCd = $("#businessPlaceCd").val();
	var peopleInfo = ajaxCall("${ctx}/RetroCalcCre.do?cmd=getRetroCalcCrePeopleMap", "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd, false);
	if (peopleInfo.Map != null) {
		peopleInfo = peopleInfo.Map;
		var rv = new Array();		
		rv["peopleTotCnt"] = peopleInfo.peopleTotCnt;
		rv["peopleSubCnt"] = peopleInfo.peopleSubCnt;
		rv["peoplePCnt"]   = peopleInfo.peoplePCnt;
		rv["peopleJCnt"]   = peopleInfo.peopleJCnt;
		if(p.popReturnValue) p.popReturnValue(rv);
	}
}
</script>
</head>
<body class="hidden bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='peopleSetPop' mdef='급여대상자관리'/></li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<form id="sheet1Form" name="sheet1Form">
			<table border="0" cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='104477' mdef='급여일자'/></th>
					<td colspan="5"><input type="text" id="payActionNm" name="payActionNm" class="text readonly" value="" readonly style="width:300px" />
									<input type="hidden" id="payActionCd" name="payActionCd" value="" /><input type="hidden" id="closeYn" name="closeYn" value="" /></td>
				</tr>
				<tr>
					<th><tit:txt mid='114444' mdef='대상년월'/></th>
					<td id="payYm"> </td>
					<th><tit:txt mid='112032' mdef='급여구분'/></th>
					<td id="payNm"> </td>
					<th><tit:txt mid='112700' mdef='지급일자'/></th>
					<td id="paymentYmd"> </td>
				</tr>
				<tr>
					<th><tit:txt mid='112111' mdef='소급계산기준일'/></th>
					<td id="ordYmd"> </td>
					<th><tit:txt mid='112374' mdef='근태기준년월'/></th>
					<td id="timeYm" colspan="3"> </td>
					<!-- th><tit:txt mid='114507' mdef='대상자선정상태'/></th>
					<td id="empStatus"></td -->
				</tr>
				<tr>
					<th><tit:txt mid='114399' mdef='사업장'/></th>
					<td colspan="3"><input type="text" id="businessPlaceNm" name="businessPlaceNm" class="text readonly" value="" readonly style="width:300px" />
									<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" value="" /> </td>
					<th><tit:txt mid='114138' mdef='대상자선정'/></th>
					<td><btn:a href="javascript:doAction1('PrcP_CPN_CAL_EMP_INS')"	css="basic authA" mid='110741' mdef="작업"/></td>
				</tr>
			</table>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='peopleSetPop' mdef='급여대상자관리'/></li>
							<li class="btn">
								<!-- <span><tit:txt mid='104395' mdef='대상자명'/></span> <input type="text" id="name" name="name" class="text" value="" size="20" style="ime-mode:active" onKeyUp="checkEnter();" />
								<a onclick="javascript:findName();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> -->
								<span><tit:txt mid='104330' mdef='사번/성명'/></span> <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" />
								<btn:a href="javascript:doAction1('Search')"		css="button authR" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			</form>
			<div class="popup_button outer">
				<ul>
					<li>
						<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
