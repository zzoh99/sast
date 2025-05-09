<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>복리후생마감관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 복리후생이력생성결과
-->
<script type="text/javascript">

$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"선택",		Type:"DummyCheck",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"check",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
		{Header:"복리후생업무구분코드",	Type:"Text",Hidden:1,	Width:100,	Align:"Center", ColMerge:0, SaveName:"benGubun",		KeyField:0, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"복리후생업무구분",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center", ColMerge:0, SaveName:"benGubunNm",		KeyField:0, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"사번",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMarge:0,	SaveName:"sabun",			KeyField:0, Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"성명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMarge:0,	SaveName:"name",			KeyField:0, Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"조직",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMarge:0,	SaveName:"orgNm",			KeyField:0, Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"직위",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMarge:0,	SaveName:"jikweeNm",		KeyField:0, Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"직급",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMarge:0,	SaveName:"jikgubNm",		KeyField:0, Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"직책",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMarge:0,	SaveName:"jikchakNm",		KeyField:0, Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"급여항목코드",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"elementCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"급여항목명",	Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"elementNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"금액",		Type:"AutoSum",			Hidden:0,	Width:80,	Align:"Center", ColMerge:0,  SaveName:"mon",			KeyField:0, Format:"Integer", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
		{Header:"사업장코드",	Type:"Text",		Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사업장명",	Type:"Text",		Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
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
	/* var businessPlaceCd = "";
	if(allFlag) {
		businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장	
	} else {
		businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
	}
	sheet1.SetColProperty("businessPlaceCd", {ComboText:businessPlaceCd[0], ComboCode:businessPlaceCd[1]}); */
	
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
	//sheet1.SetColProperty("benefitBizCd", {ComboText:"|"+benefitBizCdList[0], ComboCode:"|"+benefitBizCdList[1]} );
	
    $("#schBenefitBizCd").html(benefitBizCdList[2]);


	$(window).smartresize(sheetResize);
	sheetInit();

	$("#schElementCd").html("<option value=''>전체</option>");
    
	$("#schBenefitBizCd").on("change",function(){
		
		var elementCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBenElementCdList&searchBenefitBizCd="+$(this).val(),false).codeList, "전체");
		$("#schElementCd").html(elementCdList[2]);
		
		doAction1('Search');
	});

	$("#schElementCd").on("change",function(){
		doAction1('Search');
	});

	$("#searchName").on("keyup", function(e) {
		if (e.keyCode === 13)
			doAction1('Search');
	})
	
	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/WelfareHisResultMgr.do?cmd=getWelfareHisResultMgrList", $("#sheet1Form").serialize());
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


//최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-RETRO.소급)
	var paymentInfo = ajaxCall("${ctx}/WelfareHisResultMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,00002,", false);

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
						<th><label for="payActionNm">급여일자</label></th>
						<td>
							<input type="hidden" id="payActionCd" name="payActionCd" value="" />
							<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
							<a onclick="javascript:payActionSearchPopup();"  class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
							<input type="hidden" id="payPeopleStatus" name="payPeopleStatus" value="" />
							<input type="hidden" id="payCd" name="payCd" value="" />
						</td>
						<th><label for="searchName">성명/사번</label></th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="text" style="ime-mode:active;" />
						</td>
						<th><label for="schBenefitBizCd">복리후생업무구분</label></th>
						<td>
							<select id="schBenefitBizCd" name="schBenefitBizCd"></select>
						</td>
						<th><label for="schElementCd">급여항목</label></th>
						<td>
							<select id="schElementCd" name="schElementCd"></select>
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
							<li class="txt">복리후생이력생성결과</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" class="btn authR">다운로드</a>
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