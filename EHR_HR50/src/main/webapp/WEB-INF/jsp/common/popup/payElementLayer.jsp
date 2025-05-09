<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><span id="titleText"><tit:txt mid='payElementPop4' mdef='수당,공제 항목'/></span></title>

<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;
	$(function() {
		var callPage 	= "";
		// var arg = p.window.dialogArguments;

		var searchElementLinkType1 = "";
		var searchElementLinkType2 = "";
		var elementType = "";
	    var isSep = ""; // 퇴직항목

		createIBSheet3(document.getElementById('mySheet-wrap'), "mySheet", "100%", "100%","${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('payElementLayer');
		searchElementLinkType1 = modal.parameters.searchElementLinkType || '';
		searchElementLinkType2 = modal.parameters.searchElementLinkType2 || '';
		elementType = modal.parameters.elementType || '';
		isSep = modal.parameters.isSep || '';
		callPage = modal.parameters.callPage || ''

		$('#searchElemNm').val(modal.parameters.elementNm);

		if (elementType == "A") {
        	$("#titleText").html("수당 항목");
        	$("#subTitle1Text").html("수당 항목");
        	$("#subTitle2Text").html("수당 항목");
		} else if (elementType == "D") {
        	$("#titleText").html("공제 항목");
        	$("#subTitle1Text").html("공제 항목");
        	$("#subTitle2Text").html("공제 항목");
		}

        $("#callPage").val(callPage);

        $("#searchElementLinkType2").val(searchElementLinkType2);
        $("#elementType").val(elementType);
        $("#isSep").val(isSep);

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",   Hidden:1,Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",   Hidden:1,Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
			{Header:"<sht:txt mid='elementType' mdef='항목유형'/>",       Type:"Combo",     Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"elementType",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",       Type:"Text",      Hidden:0,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",         Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"elementNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='reportNmV1' mdef='Report명'/>",       Type:"Text",      Hidden:0,  Width:120,   Align:"Left",    ColMerge:0,   SaveName:"reportNm",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='priority' mdef='계산\n순위'/>",     Type:"Text",      Hidden:1,  Width:40,   Align:"Right",   ColMerge:0,   SaveName:"priority",          KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='updownType' mdef='절상/사\n구분'/>",  Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"updownType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='danwi' mdef='단위'/>",           Type:"Combo",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"updownUnit",        KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='currency' mdef='통화'/>",           Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"currencyCd",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"항목Link유형", Type:"Combo",     Hidden:0,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"elementLinkType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",       Type:"Text",      Hidden:0,  Width:75,   Align:"Center",  ColMerge:0,   SaveName:"sdate",             KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",       Type:"Text",      Hidden:0,  Width:75,   Align:"Center",  ColMerge:0,   SaveName:"edate",             KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",           Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sdelete" }
		];
		IBS_InitSheet(mySheet, initdata); mySheet.SetEditable("${editable}");

		// 절상/사\n구분 updownType
        updownTypeList   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00005"), "");
        mySheet.SetColProperty("updownType",         {ComboText:updownTypeList[0],    ComboCode:updownTypeList[1]} );

		// 단위 updownUnit
		updownUnitList   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00006"), "");
        mySheet.SetColProperty("updownUnit",         {ComboText:updownUnitList[0],    ComboCode:updownUnitList[1]} );

		// 통화 currency
		currencyList   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030"), "");
        mySheet.SetColProperty("currencyCd",         {ComboText:currencyList[0],    ComboCode:currencyList[1]} );

        //퇴직항목의 경우
        if (isSep != null && (isSep == "Y" || isSep == "EY")) {

        	$("#titleText").html("퇴직 항목");
        	$("#subTitle1Text").html("퇴직 항목");
        	$("#subTitle2Text").html("퇴직 항목");

        	// 통화 숨김
			mySheet.SetColHidden("currencyCd",1);

    		// 항목유형 elementType
    		elementTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00755"), "");
    		mySheet.SetColProperty("elementType", {ComboText:elementTypeList[0], ComboCode:elementTypeList[1]} );

    		// 항목Link\n유형 elementLinkType
    		const elementLinkTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00770"), "<tit:txt mid='103895' mdef='전체'/>");
            mySheet.SetColProperty("elementLinkType", {ComboText:elementLinkTypeList[0], ComboCode:elementLinkTypeList[1]} );
			$("#searchElementLinkType1").html(elementLinkTypeList[2]);
			if (searchElementLinkType1)
				$("#searchElementLinkType1").val(searchElementLinkType1);

        } else {

        	// 항목유형 elementType
    		mySheet.SetColProperty("elementType", {ComboText:"수당|공제", ComboCode:"A|D"} );

    		// 항목Link\n유형 elementLinkType
			const elementLinkTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00003"), "<tit:txt mid='103895' mdef='전체'/>");
            mySheet.SetColProperty("elementLinkType", {ComboText:elementLinkTypeList[0], ComboCode:elementLinkTypeList[1]} );
			$("#searchElementLinkType1").html(elementLinkTypeList[2]);
			if (searchElementLinkType1)
				$("#searchElementLinkType1").val(searchElementLinkType1);
        }

		mySheet.SetCountPosition(4);

		$("#searchElemNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();

	    doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet.DoSearch( "${ctx}/PayElementPopup.do?cmd=getPayElementList", $("#mySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
			
			$("#searchElemNm").focus();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		const modal = window.top.document.LayerModalUtility.getModal('payElementLayer');
		let triggerType = '';
		if(modal.parameters.searchType === 'sheet'){
			triggerType = 'payTrigger2';
		}else{
			triggerType = 'payTrigger';
		}
		modal.fire(triggerType, {
			  resultElementCd : mySheet.GetCellValue(Row, "elementCd")
			, resultElementNm : mySheet.GetCellValue(Row, "elementNm")
			, sdate : mySheet.GetCellValue(Row, "sdate")
		}).hide();
	}

	/**
	 * 수당, 공제 항목 초기화 이벤트
	 */
	function setClear() {
		const modal = window.top.document.LayerModalUtility.getModal('payElementLayer');
		let triggerType = '';
		if(modal.parameters.searchType === 'sheet'){
			triggerType = 'payTrigger2';
		}else{
			triggerType = 'payTrigger';
		}
		modal.fire(triggerType, {
			resultElementCd : ""
			, resultElementNm : ""
			, sdate : ""
		}).hide();
	}
</script>


</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
        <div class="modal_body">
			<form id="mySheetForm" name="mySheetForm">
				<input type="hidden" id="callPage" name="callPage" value="" />
				<input type="hidden" id="searchElementLinkType2" name="searchElementLinkType2" value="" />
				<input type="hidden" id="elementType" name="elementType" value="" />
				<input type="hidden" id="isSep" name="isSep" value="" />
				<div class="sheet_search outer">
					<div>
						<table>
							<tr>
								<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
								<td>
									<input id="searchElemNm" name="searchElemNm" type="text" class="text"/>
								</td>
								<th><tit:txt mid='elementLinkTypeV1' mdef='항목Link유형'/></th>
								<td>
									<select id="searchElementLinkType1" name="searchElementLinkType1"></select>
								</td>
								<th><tit:txt mid='111965' mdef='사용여부'/></th>
								<td>
									 <select name="searchYn">
										<option value="" >전체</option>
										<option value="Y" selected >사용</option>
										<option value="N" >미사용</option>
									 </select>
								</td>
								<td>
									<btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
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
								<li id="txt" class="txt"><span id="subTitle2Text"><tit:txt mid='payElementPop4' mdef='수당,공제 항목'/></span></li>
							</ul>
							</div>
						</div>
						<div id="mySheet-wrap"></div>
					</td>
				</tr>
			</table>
       	</div>
       	<div class="modal_footer">
			<btn:a href="javascript:setClear();" css="btn filled" mid='110754' mdef="초기화"/>
       		<btn:a href="javascript:closeCommonLayer('payElementLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>
