<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='gLInterfaceCallMgr' mdef='급상여전표처리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급상여전표처리
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var inputFlag = "Y" ;

$(function() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='payActionCdV1' mdef='급여계산코드'/>",	Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='payActionNm' mdef='급여계산명'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payActionNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		//{Header:"<sht:txt mid='incomeAnnualPaymentYmd' mdef='지급일자'/>",		Type:"Date",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:1,	Format:"Ymd",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		//{Header:"<sht:txt mid='exSendYn' mdef='전송여부'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"exSendYn",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		//{Header:"EX_BUKRS",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"exBukrs",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		//{Header:"EX_GJAHR",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"exGjahr",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		//{Header:"EX_BELNR",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"exBelnr",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		//{Header:"EX_MSG",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"exMsg",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		//{Header:"<sht:txt mid='payCd' mdef='급여구분'/>",		Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"payCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",			Type:"Int",			Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='businessPlaceCdV2' mdef='사업장'/>",			Type:"Combo",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='locationCdV4' mdef='Location'/>",		Type:"Combo",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"locationCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='ccCd' mdef='코스트센터'/>",		Type:"Combo",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"ccCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='cdKey' mdef='차대구분'/>",		Type:"Combo",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"cdKey",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='acctCdV1' mdef='계정과목\n코드'/>",	Type:"Combo",		Hidden:0,					Width:150,			Align:"Center",	ColMerge:0,	SaveName:"acctCd",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='basicMon' mdef='금액'/>",			Type:"Int",			Hidden:0,					Width:70,			Align:"Right",	ColMerge:0,	SaveName:"resultMon",		KeyField:0,	Format:"Integer",PointCount:0,UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='headText' mdef='헤더텍스트'/>",		Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"headText",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='referText' mdef='참조텍스트'/>",		Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"referText",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);
	  
      
      
      
	//------------------------------------- 그리드 콤보 -------------------------------------//	
	// 급여구분
	//var payCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnPayCdList", false).codeList, "");
	//sheet1.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]});
	
	// 차대구분
	var bschlList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C14020"), "<tit:txt mid='103895' mdef='전체'/>");
	sheet1.SetColProperty("cdKey", {ComboText:"|"+bschlList[0], ComboCode:"|"+bschlList[1]});

	// 계정과목
	var hkontList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C14000"), "");
	sheet1.SetColProperty("acctCd", {ComboText:"|"+hkontList[0], ComboCode:"|"+hkontList[1]});

	// 통화구분
	//var currencyCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S10030"), "");
	//sheet1.SetColProperty("currencyCd", {ComboText:"|"+currencyCdList[0], ComboCode:"|"+currencyCdList[1]});
	
	// 사업장
	var mapCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "구분없음");
	sheet1.SetColProperty("businessPlaceCd", {ComboText:"|"+mapCdList[0], ComboCode:"|"+mapCdList[1]});
	
	// 코스트센터
	var kostlList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=300", "queryId=getTorg109List", false).codeList, "구분없음");
	sheet1.SetColProperty("ccCd", {ComboText:"|"+kostlList[0], ComboCode:"|"+kostlList[1]});
	
	// Location
	var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "구분없음");	//LOCATION
	sheet1.SetColProperty("locationCd", {ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]});
	//------------------------------------- 그리드 콤보 -------------------------------------//
	
	//------------------------------------- 조회조건 콤보 -------------------------------------//
	//$("#searchBschl").html(bschlList[2]); 
	$("#searchMapCd").html(mapCdList[2]); 
	$("#searchKostl").html(kostlList[2]); 
	$("#searchLocationCd").html(locationCd[2]);
	
	$(window).smartresize(sheetResize);
	sheetInit();

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

			sheet1.DoSearch("${ctx}/GLInterfaceCalMgr.do?cmd=getGLInterfaceCalMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/GLInterfaceCalMgr.do?cmd=saveGLInterfaceCalMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			
			if(inputFlag == "N") {
				alert($("#payActionNm").val()+" 에 해당되는 전표는\n이미전송되었으므로 입력하실 수 없습니다.") ;
				return ;
			}
			
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", $("#payActionCd").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "seq", "");
			sheet1.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet1.RemoveAll();
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
		if (Msg != "") { 
			alert(Msg);
		} sheetResize(); 
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex); 
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { 
			
			alert(Msg); 
			
		} doAction1("Search") ; 
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex); 
	}
}

// 값 변경시 이벤트 처리
function sheet1_OnChange(Row, Col, Value) {
	try{
		if(sheet1.ColSaveName(Col)== "acctCd" && sheet1.GetCellValue(Row,"acctCd") != "") {
			//계정과목 코드가 사번일때는 계정과목값을 빈칸 처리
			if(sheet1.GetCellValue(Row,"acctCd") == "10000000") {
				sheet1.SetCellValue(Row,"acctNm","",0);
			} else {
				sheet1.SetCellValue(Row,"acctNm",sheet1.GetCellValue(Row,"acctCd"),0);	
			}
		}
	}catch(ex){
		alert("OnChange Event Error : " + ex);
	}
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00001.급여)
	var paymentInfo = ajaxCall("${ctx}/GLInterfaceCalMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,R0001,", false);

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

// 급여일자 검색 팝업
function payActionSearchPopup() {
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "payDayPopup";

	let payDayLayer = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType: "00001,R0001"
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
					doAction1("Search");
				}
			}
		]
	});
	payDayLayer.show();
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "payDayPopup"){
		var payActionCd	= rv["payActionCd"];
		var payActionNm	= rv["payActionNm"];

		$("#payActionCd").val(payActionCd);
		$("#payActionNm").val(payActionNm);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("Search");
		}
    }
}

function callProc(procName) {

	if( $("#payActionCd").val() == "" ) {
		alert("<msg:txt mid='alertWelfarePayDataMgr7' mdef='급여일자를 선택하여 주십시오.'/>") ;
		return ;
	}
	
	var bCd = "";
	var lCd = "";
	var cCd = "";
	
	if($("#searchMapCd").val() == ""){
		bCd = "ALL";
	}else{
		bCd = $("#searchMapCd").val();
	}
	
	if($("#searchLocationCd").val() == ""){
		lCd = "ALL";
	}else{
		lCd = $("#searchLocationCd").val();
	}
	
	if($("#searchKostl").val() == ""){
		cCd = "ALL";
	}else{
		cCd = $("#searchKostl").val();
	}
	if( !confirm("전표생성작업을 실행하시겠습니까?") ) return ;
	
	var params = "payActionCd="+$("#payActionCd").val()+"&searchMapCd="+bCd+"&searchLocationCd="+lCd+"&searchKostl="+cCd;
	
	var ajaxCallCmd = "call"+procName ;

	ajaxCall2("/GLInterfaceCalMgr.do?cmd="+ajaxCallCmd
			, params
			, true
			, function() {
				progressBar(true, "전표 생성중입니다.");
			}
			, function(data) {
				progressBar(false);
				if (data && data.Result) {
					if(data.Result.Code == null || data.Result.Code === "OK") {
						alert("전표생성을 완료했습니다.");
						doAction1("Search");
					} else {
						alert("전표 생성 도중 오류가 발생하였습니다. => " + data.Result.Message);
					}
				} else {
					alert(procName+"를 사용할 수 없습니다.");
				}
			}, function() {
				progressBar(false);
				alert(procName+"를 사용할 수 없습니다.");
			})
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
							<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
							<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
						<%-- 
						<th><tit:txt mid='114140' mdef='차대구분'/></th>
						<td>  <select id="searchBschl" name="searchBschl" onchange="doAction1('Search')"> </select> </td>
						--%>
						<th><tit:txt mid='114399' mdef='사업장'/></th>
						<td>  <select id="searchMapCd" name="searchMapCd" onchange="doAction1('Search')"> </select> </td>
						<th>Location</th>
						<td>  <select id="searchLocationCd" name="searchLocationCd" onchange="doAction1('Search')"> </select> </td>
						<th><tit:txt mid='112702' mdef='코스트센터'/></th>
						<td>  <select id="searchKostl" name="searchKostl" onchange="doAction1('Search')"> </select> </td>
						
						<td> <a href="javascript:doAction1('Search')"	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
							<li id="txt" class="txt"><tit:txt mid='gLInterfaceCallMgr' mdef='급상여전표처리'/></li>
							<li class="btn">
								<a href="javascript:callProc('P_CPN_GL_INS')"		class="btn filled authA"><tit:txt mid='112033' mdef='전표생성'/></a>
								<a href="javascript:doAction1('Insert')"			class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Save')"				class="btn outline_gray authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel')"		class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
