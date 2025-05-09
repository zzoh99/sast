<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='payDayPop' mdef='급여일자 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		
		var runType = "";
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			runType 	= arg["runType"];
		}		

		$("#searchRunType").val(runType);		
		$("#multiRunType").val(getMultiSelect($("#searchRunType").val()));

		$("#searchFromSdate").datepicker2({startdate:"searchToSdate"});
		$("#searchToSdate").datepicker2({enddate:"searchFromSdate"});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"<sht:txt mid='sdateV19' mdef='기준일자'/>",  Type:"Date",  Hidden:0, Width:80,  Align:"Center", ColMerge:0, SaveName:"yearPayDate", KeyField:1, Format:"Ymd",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10 },
			{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",      Type:"Combo", Hidden:0, Width:80,  Align:"Center", ColMerge:0, SaveName:"workType",    KeyField:1, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8 },
			{Header:"<sht:txt mid='appSeqCd' mdef='차수'/>",      Type:"Text",  Hidden:0, Width:50,  Align:"Center", ColMerge:0, SaveName:"degCd",       KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20 },
			{Header:"<sht:txt mid='degNm' mdef='차수명'/>",    Type:"Text",  Hidden:0, Width:100,  Align:"Left", ColMerge:0, SaveName:"degNm",       KeyField:0, Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",      Type:"Text",  Hidden:0, Width:200,  Align:"Left",   ColMerge:0, SaveName:"bigo",        KeyField:0, Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:2000 }
			];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var workTypeCombo 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "");		//그룹코드
		
		sheet1.SetColProperty("workType", 			{ComboText:workTypeCombo[0], ComboCode:workTypeCombo[1]} );
		
		
		// 직군
		var workType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchWorkType").html(workType[2]);
		
// 		$("#col1,#col2,#col3,#col4").bind("keyup",function(event){
// 			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
// 		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/YearPayDegrePopup.do?cmd=getYearPayDegrePopupList", $("#mySheetForm").serialize() ); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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

	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var rv = new Array(5);
		rv["yearPayDate"] 		= sheet1.GetCellValue(Row, "yearPayDate");
		rv["workType"]		= sheet1.GetCellValue(Row, "workType");
		rv["workTypeNm"]		= sheet1.GetCellText(Row, "workType");
		rv["degCd"] 			= sheet1.GetCellValue(Row, "degCd");
		rv["degNm"] 			= sheet1.GetCellValue(Row, "degNm");
		rv["bigo"] 		= sheet1.GetCellValue(Row, "bigo");
		
		p.window.returnValue 	= rv;
		p.window.close();
	}

</script>
</head>
<div class="wrapper">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='113110' mdef='연봉별 차수 조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm">
		<input type="hidden" id="callPage" name="callPage" value="" />
		<input id="searchRunType" name="searchRunType" type="hidden" >
		<input type="hidden" id="multiRunType" name="multiRunType" value="" />
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='114076' mdef='조회기간'/></th>
						<td>
							<input id="searchFromSdate" name="searchFromSdate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">~
							<input id="searchToSdate" name="searchToSdate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
						</td>
						<th><tit:txt mid='104089' mdef='직군'/></th>
						<td>
							<select  id="searchWorkType" name="searchWorkType" class="box"></select>
						</td>
						<td><a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a></td>
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
						<li id="txt" class="txt"><tit:txt mid='payDayPop' mdef='급여일자 조회'/></li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
       </div>
	</div>
</div>
</html>
