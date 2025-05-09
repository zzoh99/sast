<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<title>급여일자 조회</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('payDayMultiLayer');
		let runType = modal.parameters.runType;
		let payCd = modal.parameters.payCd;
		let searchType = modal.parameters.searchType;
		let searchSabun = modal.parameters.searchSabun;

		if(runType != undefined){
			$("#searchRunType").val(runType);
			$("#multiRunType").val(getMultiSelect($("#searchRunType").val()));
	    }
		$("#searchType").val(searchType);
		$("#searchSabun").val(searchSabun);

		$("#searchMonthFrom").datepicker2({ymonly:true});
		$("#searchMonthTo").datepicker2({ymonly:true});

		createIBSheet3(document.getElementById('payDayMultiLayerSht-wrap'), "payDayMultiLayerSht", "100%", "100%","${ssnLocaleCd}");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"세부\n내역",		Type:"Image",     Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"selectImg",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"급여계산코드",   	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"payActionCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"선택",           	Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"chk",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"급여계산명",     	Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:1,   SaveName:"payActionNm",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"대상년월",       	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"payYm",          KeyField:1,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:7 },
            {Header:"급여구분",       	Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"payCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"RUN_TYPE",       	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"runType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"지급일자",       	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"paymentYmd",     KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"마감\n여부",     	Type:"CheckBox",Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"closeYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"급여구분코드명",      Type:"Text",	Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"payNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"지급일자",       	Type:"Text",    Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"paymentYmdHyphen", KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"발령기준시작일",  	Type:"Text",    Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"ordSymd", KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"발령기준종료일",  	Type:"Text",    Hidden:1,  Width:90,   Align:"Center",  ColMerge:1,   SaveName:"ordEymd", KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"비고",				Type:"Text",	Hidden:0,  Width:100,   Align:"Right",   ColMerge:0,   SaveName:"bigo",         KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
            {Header:"지급일",        	Type:"Text",	Hidden:1,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"day",         KeyField:0,   CalcLogic:"",   Format:"",   PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 } ];
		IBS_InitSheet(payDayMultiLayerSht, initdata);payDayMultiLayerSht.SetEditable(true);payDayMultiLayerSht.SetVisible(true);payDayMultiLayerSht.SetCountPosition(4);

		// 급여코드
        var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "전체");
        payDayMultiLayerSht.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );

        // 조회조건
		var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "전체");
		$("#searchPayCd").html(searchPayCdList[2]);
		if(payCd != undefined){
			$("#searchPayCd").val(payCd);
	    }

		$("#col1,#col2,#col3,#col4").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		var sheetHeight = $(".modal_body").height() - $("#mySheetForm").height() - $(".sheet_title").height() - 2;
		payDayMultiLayerSht.SetSheetHeight(sheetHeight);

		doAction1("Search");

        $("#searchMonthFrom, #searchMonthTo").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); }
		});
	});

	//payDayMultiLayerSht Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if ($("#searchType").val() == "A") {
					// 개인별급여세부내역(관리자)용 쿼리호출
					payDayMultiLayerSht.DoSearch( "${ctx}/PayDayPopup.do?cmd=getPayDayAdminPopupList", $("#mySheetForm").serialize() );
				} else if ($("#searchType").val() == "B") {
					// 개인별급여세부내역용 쿼리호출
					payDayMultiLayerSht.DoSearch( "${ctx}/PayDayPopup.do?cmd=getPayDayUserPopupList", $("#mySheetForm").serialize() );
				} else {
					payDayMultiLayerSht.DoSearch( "${ctx}/PayDayPopup.do?cmd=getPayDayPopupList", $("#mySheetForm").serialize() );
				}
				break;
		}
	}

	// 조회 후 에러 메시지
	function payDayMultiLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);	} sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function payDayMultiLayerSht_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function payDayMultiLayerSht_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && payDayMultiLayerSht.GetCellValue(Row, "sStatus") == "I") {
				payDayMultiLayerSht.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function confirm() {
		var sRow = payDayMultiLayerSht.FindCheckedRow("chk");
		var arrRow = sRow.split("|");
		if (arrRow[0] == "") {
			alert("급여일자를 선택해 주세요.");
			return;
		}
		
		var payActionCdArr = new Array();
		var payActionNmArr = new Array();
		for(var i = 0 ; i < arrRow.length ; i++){
			payActionCdArr.push(payDayMultiLayerSht.GetCellValue(arrRow[i], "payActionCd")+",");
			payActionNmArr.push(payDayMultiLayerSht.GetCellValue(arrRow[i], "payActionNm"));
		}

		const modal = window.top.document.LayerModalUtility.getModal('payDayMultiLayer');
		modal.fire('payDayMultiTrigger', {
			payActionCd : payActionCdArr,
			payActionNm	: payActionNmArr
		}).hide();
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
        <div class="modal_body">
			<form id="mySheetForm" name="mySheetForm">
			<input type="hidden" id="callPage" name="callPage" value="" />
			<input type="hidden" id="searchSabun" name="searchSabun" value="" />
			<input type="hidden" id="searchType" name="searchType" value="" />
			<input id="searchRunType" name="searchRunType" type="hidden" >
			<input type="hidden" id="multiRunType" name="multiRunType" value="" />
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<th>급여구분 </th>
					<td>  <select id="searchPayCd" name="searchPayCd"> </select></td>
					<th>대상년월 </th>
					<td>
						<input id="searchMonthFrom" name ="searchMonthFrom" type="text" class="date2" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-11)%>"/>
						~
						<input id="searchMonthTo" name ="searchMonthTo" type="text" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
					</td>
					<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
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
									<li id="txt" class="txt">급여일자조회</li>
								</ul>
							</div>
						</div>
						<div id="payDayMultiLayerSht-wrap"></div>
					</td>
				</tr>
			</table>
       </div>

		<div class="modal_footer">
			<a href="javascript:confirm();" class="btn filled">확인</a>
			<a href="javascript:closeCommonLayer('payDayMultiLayer');" class="btn outline_gray">닫기</a>
		</div>
	</div>
</body>
</html>
