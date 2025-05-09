<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>급여일자 조회</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var p = eval("${popUpStatus}");
var searchType = "";
var searchSabun = "";

	$(function() {
		var runType = "";
		var payCd   = "";
		var arg = p.popDialogArgumentAll();
		if( arg != undefined ) {
			searchType = arg["searchType"];
			runType = arg["runType"];
			payCd = arg["payCd"];
			searchSabun = arg["searchSabun"];
		}

		//searchType = window.dialogArguments["searchType"];
		//var runType = window.dialogArguments["runType"];
		//var payCd = window.dialogArguments["payCd"];
		//searchSabun = window.dialogArguments["searchSabun"];

		if(runType != undefined){
			$("#searchRunType").val(runType);
			$("#multiRunType").val(getMultiSelect($("#searchRunType").val()));
	    }
		$("#searchMonthFrom").datepicker2({ymonly:true});
		$("#searchMonthTo").datepicker2({ymonly:true});
		//$("#searchMonthFrom").val("${curSysYear}"+"-01");
		//$("#searchMonthTo").val("${curSysYyyyMMHyphen}");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"세부\n내역",     Type:"Image",     Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"selectImg",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"급여계산코드",   Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"payActionCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"선택",           Type:"CheckBox",  Hidden:0,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"chk",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"급여계산명",     Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:1,   SaveName:"payActionNm",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"대상년월",       Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"payYm",          KeyField:1,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:7 },
            {Header:"급여구분",       Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"payCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"RUN_TYPE",       Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"runType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"지급일자",       Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"paymentYmd",     KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"마감\n여부",     Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"closeYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"급여구분코드명",       Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"payNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"지급일자",       Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"paymentYmdHyphen", KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"발령기준시작일",  Type:"Text",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"ordSymd", KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"발령기준종료일",  Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"ordEymd", KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"비고",		Type:"Text",     Hidden:0,  Width:100,   Align:"Right",   ColMerge:0,   SaveName:"bigo",         KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
            {Header:"지급일",         Type:"Text",     Hidden:1,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"day",         KeyField:0,   CalcLogic:"",   Format:"",   PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 } ];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 급여코드
        var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "전체");
        sheet1.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );

        // 조회조건
		var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "전체");
		$("#searchPayCd").html(searchPayCdList[2]);
		if(payCd != undefined){
			$("#searchPayCd").val(payCd);
	    }

		$("#col1,#col2,#col3,#col4").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
	    $(".close").click(function() {
	    	p.self.close();
	    });
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

        $("#searchMonthFrom, #searchMonthTo").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); }
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if(searchSabun != null && typeof searchSabun != "undefined") {
					$("#searchSabun").val(searchSabun);
				}

				if (searchType == "A") {
					// 개인별급여세부내역(관리자)용 쿼리호출
					sheet1.DoSearch( "${ctx}/PayDayPopup.do?cmd=getPayDayAdminPopupList", $("#mySheetForm").serialize() );
				} else if (searchType == "B") {
					// 개인별급여세부내역용 쿼리호출
					sheet1.DoSearch( "${ctx}/PayDayPopup.do?cmd=getPayDayUserPopupList", $("#mySheetForm").serialize() );
				} else {
					sheet1.DoSearch( "${ctx}/PayDayPopup.do?cmd=getPayDayPopupList", $("#mySheetForm").serialize() );
				}
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);	} sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	/* function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		if ( Row > 0 ){
			var rv = new Array(5);
			rv["payActionCd"] 		= sheet1.GetCellValue(Row, "payActionCd");
			rv["payActionNm"]		= sheet1.GetCellValue(Row, "payActionNm");
			rv["payCd"] 			= sheet1.GetCellValue(Row, "payCd");
			rv["payYm"] 			= sheet1.GetCellValue(Row, "payYm");
			rv["paymentYmd"] 		= sheet1.GetCellValue(Row, "paymentYmd");
			rv["paymentYmdHyphen"] 	= sheet1.GetCellValue(Row, "paymentYmdHyphen");
			rv["payNm"] 			= sheet1.GetCellValue(Row, "payNm");
			rv["ordSymd"] 			= sheet1.GetCellValue(Row, "ordSymd");
			rv["ordEymd"] 			= sheet1.GetCellValue(Row, "ordEymd");
			rv["closeYn"] 			= sheet1.GetCellValue(Row, "closeYn");
			rv["runType"] 			= sheet1.GetCellValue(Row, "runType");

			p.popReturnValue(rv);
			p.window.close();
		}

	} */

	function confirm() {
		var rv = new Object();
		
		var sRow = sheet1.FindCheckedRow("chk");
		var arrRow = sRow.split("|");
		if (arrRow[0] == "") {
			alert("급여일자를 선택해 주세요.");
			return;
		}
		
		var payActionCdArr = new Array();
		var payActionNmArr = new Array();
		for(var i = 0 ; i < arrRow.length ; i++){
			payActionCdArr.push(sheet1.GetCellValue(arrRow[i], "payActionCd")+",");
			payActionNmArr.push(sheet1.GetCellValue(arrRow[i], "payActionNm"));
		}
		rv.payActionCd	= payActionCdArr;
		rv.payActionNm	= payActionNmArr;
		
		p.popReturnValue(rv);
		p.window.close();
	}
</script>
</head>
<div class="wrapper">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>급여일자 조회</li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm">
		<input type="hidden" id="callPage" name="callPage" value="" />
		<input type="hidden" id="searchSabun" name="searchSabun" value="" />
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
						<li id="txt" class="txt">급여일자 조회</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:confirm();" class="pink large">확인</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
       </div>
	</div>
</div>
</html>
