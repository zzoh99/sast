<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>급/상여대장검색(일자별)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급/상여대장검색(일자별)
 * @author JM
-->
<script type="text/javascript">
var columnInfo = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:0};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' 				mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' 			mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' 			mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='payYmV2' 			mdef='급여년월'/>",	Type:"Date",		Hidden:1,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payYm",		KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 },
		{Header:"<sht:txt mid='payActionCd' 		mdef='급여일자'/>",	Type:"Text",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"payActionNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='appOrgNmV5' 			mdef='소속'/>",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='agreeSabun' 			mdef='사번'/>",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' 			mdef='성명'/>",		Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='hochingNm' 			mdef='호칭'/>",		Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJikgubNmV1' 		mdef='직책'/>",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikweeNm' 		mdef='직위'/>",		Type:"Combo",		Hidden:Number("${jwHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jikgubCd' 			mdef='직급'/>",		Type:"Combo",		Hidden:Number("${jgHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='manageCd' 			mdef='사원구분'/>",	Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJobJikgunNmV1'	mdef='직군'/>",		Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='statusCdV5' 			mdef='재직상태'/>",	Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='empYmd' 				mdef='입사일'/>",		Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='gempYmd' 			mdef='그룹입사일'/>",	Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='edateV1' 			mdef='퇴사일'/>",		Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='locationCd' 			mdef='근무지'/>",		Type:"Combo",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"locationCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//

	//공통코드 한번에 조회
	var grpCds = "H10050,H20010,H20020,H20030,H10030,H10010,C00300";
	var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
	sheet1.SetColProperty("workType", {ComboText:"|"+codeLists["H10050"][0], ComboCode:"|"+codeLists["H10050"][1]}); // 직군코드(H10050)
	// sheet1.SetColProperty("jikgubCd", {ComboText:"|"+codeLists["H20010"][0], ComboCode:"|"+codeLists["H20010"][1]}); // 직급코드(H20010)
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+codeLists["H20020"][0], ComboCode:"|"+codeLists["H20020"][1]}); // 직책코드(H20020)
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+codeLists["H20030"][0], ComboCode:"|"+codeLists["H20030"][1]}); // 직위코드(H20030)
	sheet1.SetColProperty("manageCd", {ComboText:"|"+codeLists["H10030"][0], ComboCode:"|"+codeLists["H10030"][1]}); // 사원구분코드(H10030)
	sheet1.SetColProperty("statusCd", {ComboText:"|"+codeLists["H10010"][0], ComboCode:"|"+codeLists["H10010"][1]}); // 재직상태코드(H10010)

	// 근무지(TSYS015)
	var tsys015Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getLocationCdList", false).codeList, "");
	sheet1.SetColProperty("locationCd", {ComboText:"|"+tsys015Cd[0], ComboCode:"|"+tsys015Cd[1]});

	// 코스트센터(TORG109)
	var torg109Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=300", "queryId=getTorg109List", false).codeList, "");
	sheet1.SetColProperty("ccCd", {ComboText:"|"+torg109Cd[0], ComboCode:"|"+torg109Cd[1]});

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사업장
	<c:choose>
		<c:when test="${ssnSearchType == 'A'}">
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		</c:when>
		<c:otherwise>
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
		</c:otherwise>
	</c:choose>
	$("#businessPlaceCd").html(tcpn121Cd[2]);

	// 급여구분(TCPN051)
	var payCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getPayActionStaCpnPayCdList", false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
	$("#payCd").html(payCd[2]);
	//$("#payCd").select2({placeholder:""});
	//$("#payCd").select2("val", ["01","02"]);
	// 재직상태코드(H10010)
	$("#statusCd").html(codeLists["H10010"][2]);
	$("#statusCd").select2({placeholder:" 선택"});

	// 직군(H10050)
	$("#workType").html(codeLists["H10050"][2]);
	$("#workType").select2({placeholder:" 선택"});

	// 사원구분코드(H10030)
	$("#manageCd").html(codeLists["H10030"][2]);
	$("#manageCd").select2({placeholder:" 선택"});

	// 급여출력구분(C00300)
	$("#reportYn").html(codeLists["C00300"][2]);

// 	$(window).smartresize(sheetResize);
	sheetInit();
	getCpnLatestPaymentInfo();
	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});

	//근무내역 체크 처리
	$("#chkWorkHour").change(function() {
		$("#chkWorkHourYn").val(this.checked ? "Y" : "N");
	});
});

// 필수값/유효성 체크
function chkInVal(sAction) {

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if($("#searchPayActionCd").val() == "") {
				alert("급여일자를 선택해 주시기 바랍니다.");
				return;
			}

			$("#multiPayCd").val(getMultiSelect($("#payCd").val()));

			// 급여구분별 항목리스트 조회
			searchTitleList();

			// 일자별 합계할지 여부
			if ($("#sumYnCheckbox").is(":checked")) {
				$("#sumYn").val("Y");
				sheet1.SetColHidden("payYm",1);
				//sheet1.SetColHidden("payActionNm",1);
			}else{
				$("#sumYn").val("N");
				sheet1.SetColHidden("payYm",0);
				//sheet1.SetColHidden("payActionNm",0);
			}

			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));
			$("#multiWorkType").val(getMultiSelect($("#workType").val()));
			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));

			var info = [{StdCol:5, SumCols:columnInfo, CaptionCol:5}];
			if ($("#subSumYnCheckbox").is(":checked")) {
				sheet1.ShowSubSum(info);
			} else {
				sheet1.HideSubSum(info);
			}
			sheet1.DoSearch("${ctx}/PayActionSta.do?cmd=getPayActionStaList", $("#sheet1Form").serialize());
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

function searchTitleList() {
	// 급여구분별 항목리스트 조회
	var titleList = ajaxCall("${ctx}/PayActionSta.do?cmd=getPayActionStaTitleList", $("#sheet1Form").serialize(), false);

	if (titleList != null && titleList.DATA != null) {

		// IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
		sheet1.Reset();

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:12, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

		initdata1.Cols 	   = [];
		initdata1.Cols[0]  = {Header:"<sht:txt mid='sNo' 				mdef='No|No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[1]  = {Header:"<sht:txt mid='sDelete V5' 		mdef='삭제|삭제'/>",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 };
		initdata1.Cols[2]  = {Header:"<sht:txt mid='sStatus' 			mdef='상태|상태'/>",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 };
		initdata1.Cols[3]  = {Header:"<sht:txt mid='payYmV2' 			mdef='급여년월|급여년월'/>",		Type:"Date",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"payYm",		KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 };
		initdata1.Cols[4]  = {Header:"<sht:txt mid='payActionCd' 		mdef='급여일자|급여일자'/>",		Type:"Text",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"payActionNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[5]  = {Header:"<sht:txt mid='appOrgNmV5' 		mdef='소속|소속'/>",			Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[6]  = {Header:"<sht:txt mid='agreeSabun' 		mdef='사번|사번'/>",			Type:"Text",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 };
		initdata1.Cols[7]  = {Header:"<sht:txt mid='appNameV1' 			mdef='성명|성명'/>",			Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[8]  = {Header:"<sht:txt mid='hochingNm' 			mdef='호칭|호칭'/>",			Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"empAlias",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[9]  = {Header:"<sht:txt mid='applJikgubNmV1' 	mdef='직책|직책'/>",			Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[10] = {Header:"<sht:txt mid='applJikweeNm' 		mdef='직위|직위'/>",			Type:"Combo",		Hidden:Number("${jgHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[11] = {Header:"<sht:txt mid='jikgubCd' 			mdef='직급|직급'/>",			Type:"Combo",		Hidden:Number("${jwHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[12] = {Header:"<sht:txt mid='manageCd' 			mdef='사원구분|사원구분'/>",		Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[13] = {Header:"<sht:txt mid='applJobJikgunNmV1' 	mdef='직군|직군'/>",			Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[14] = {Header:"<sht:txt mid='statusCdV5' 		mdef='재직상태|재직상태'/>",		Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[15] = {Header:"<sht:txt mid='empYmd' 			mdef='입사일|입사일'/>",		Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[16] = {Header:"<sht:txt mid='gempYmd' 			mdef='그룹입사일|그룹입사일'/>",	Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[17] = {Header:"<sht:txt mid='edateV1' 			mdef='퇴사일|퇴사일'/>",		Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[18] = {Header:"<sht:txt mid='locationCd' 		mdef='근무지|근무지'/>",		Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"locationCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };

		var elementCd = "";
		columnInfo = "";
		for(var i=0; i<titleList.DATA.length; i++) {
			elementCd = convCamel(titleList.DATA[i].elementCd);
			initdata1.Cols[i+19] = {Header:titleList.DATA[i].elementNm,Type:"AutoSum", Hidden:0, Width:75,	Align:"Right", ColMerge:0, SaveName:elementCd, KeyField:0, Format:"Integer", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 };
			if(i > 0) columnInfo = columnInfo + "|";
			columnInfo = columnInfo+(i+19);
		}

		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
		//$(window).smartresize(sheetResize);
		//sheetInit();

		//------------------------------------- 그리드 콤보 -------------------------------------//
		//공통코드 한번에 조회
		var grpCds = "H10050,H20010,H20020,H20030,H10030,H10010,C00300";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
		sheet1.SetColProperty("workType", {ComboText:"|"+codeLists["H10050"][0], ComboCode:"|"+codeLists["H10050"][1]}); // 직군코드(H10050)
		sheet1.SetColProperty("jikgubCd", {ComboText:"|"+codeLists["H20010"][0], ComboCode:"|"+codeLists["H20010"][1]}); // 직급코드(H20010)
		sheet1.SetColProperty("jikchakCd", {ComboText:"|"+codeLists["H20020"][0], ComboCode:"|"+codeLists["H20020"][1]}); // 직책코드(H20020)
		sheet1.SetColProperty("jikweeCd", {ComboText:"|"+codeLists["H20030"][0], ComboCode:"|"+codeLists["H20030"][1]}); // 직위코드(H20030)
		sheet1.SetColProperty("manageCd", {ComboText:"|"+codeLists["H10030"][0], ComboCode:"|"+codeLists["H10030"][1]}); // 사원구분코드(H10030)
		sheet1.SetColProperty("statusCd", {ComboText:"|"+codeLists["H10010"][0], ComboCode:"|"+codeLists["H10010"][1]}); // 재직상태코드(H10010)

		// 근무지(TSYS015)
		var tsys015Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getLocationCdList", false).codeList, "");
		sheet1.SetColProperty("locationCd", {ComboText:"|"+tsys015Cd[0], ComboCode:"|"+tsys015Cd[1]});

		// 코스트센터(TORG109)
		var torg109Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=300", "queryId=getTorg109List", false).codeList, "");
		sheet1.SetColProperty("ccCd", {ComboText:"|"+torg109Cd[0], ComboCode:"|"+torg109Cd[1]});
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		//sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

	 // 급여일자 검색 팝입
    function payActionSearchPopup() {
    	try{
			if(!isPopup()) {return;}
			gPRow = "";
			pGubun = "payDayPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'payDayLayer'
				, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
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
							$("#searchPayActionCd").val(result.payActionCd);
							$("#searchPayActionNm").val(result.payActionNm);
							$("#payCd").val(result.payCd);
							$("#payYm").val(result.payYm);

							if ($("#searchPayActionCd").val() != null && $("#searchPayActionNm").val() != "") {
								doAction1("Search");
							}
						}
					}
				]
			});
			layerModal.show();
    	}catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    function getReturnValue(returnValue) {
    	var rv = returnValue;
    }

	// 최근급여일자 조회
	function getCpnLatestPaymentInfo() {
		var procNm = "최근급여일자";
		// 급여구분(C00001-00001.급여)
		var paymentInfo = ajaxCall("${ctx}/PayActionSta.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,", false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
			$("#searchPayActionCd").val(paymentInfo.DATA[0].payActionCd);
			$("#searchPayActionNm").val(paymentInfo.DATA[0].payActionNm);
			$("#payCd").val(paymentInfo.DATA[0].payCd);

			if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
				//	doAction("Search");
			}
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			alert(paymentInfo.Message);
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="multiPayCd" 	name="multiPayCd" 	 value="" />
		<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />
		<input type="hidden" id="multiWorkType" name="multiWorkType" value="" />
		<input type="hidden" id="multiManageCd" name="multiManageCd" value="" />

		<input type="hidden" id="payYm" 		name="payYm" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>
							<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" /><input type="hidden" id="sabun" name="sabun" class="text" value="" />
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text" value="" validator="required" readonly="readonly" style="width:150px" />
							<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th><tit:txt mid='114399' mdef='사업장'/></th>
						<td>  <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
						<th><tit:txt mid='112032' mdef='급여구분'/></th>
						<td>  <select id="payCd" name="payCd" disabled="disabled" class="readonly"> </select> </td>
						<th><tit:txt mid='104481' mdef='합계'/></th>
						<td>  <input type="checkbox" id="sumYnCheckbox" name="sumYnCheckbox" /><input type="hidden" id="sumYn" name="sumYn" value="" /> </td>
						<th><tit:txt mid='112806' mdef='출력구분'/></th>
						<td>  <select id="reportYn" name="reportYn"> </select> </td>
					</tr>
					<tr>
						<th><tit:txt mid='104089' mdef='직군'/></th>
						<td>  <select id="workType" name="workType" multiple=""> </select> </td>
						<th><tit:txt mid='103784' mdef='사원구분'/></th>
						<td>  <select id="manageCd" name="manageCd" multiple=""> </select> </td>
						<th><tit:txt mid='104472' mdef='재직상태'/></th>
						<td>  <select id="statusCd" name="statusCd" multiple=""> </select> </td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>  <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
						<th><tit:txt mid='114213' mdef='소계'/></th>
						<td>  <input type="checkbox" id="subSumYnCheckbox" name="subSumYnCheckbox" /><input type="hidden" id="subSumYn" name="subSumYn" value="" /> </td>
						<th><tit:txt mid='114213' mdef='근무내역 보기'/></th>
						<td>  <input type="checkbox" id="chkWorkHour" name="chkWorkHour" checked /><input type="hidden" id="chkWorkHourYn" name="chkWorkHourYn" value="Y" /></td>
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
							<li id="txt" class="txt">급/상여대장검색(일자별)</li>
							<li class="btn">
								<a href="javascript:doAction1('Search')"	class="button authR"><tit:txt mid='104081' mdef='조회'/></a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
