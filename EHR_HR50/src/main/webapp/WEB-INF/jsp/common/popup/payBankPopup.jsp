<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
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

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"<sht:txt mid='bankCd' mdef='은행명'/>",    Type:"Text",      Hidden:0,  Width:200,    Align:"Left",  ColMerge:1,   SaveName:"bankNm",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='bankCd_V4296' mdef='은행코드'/>",  Type:"Text",      Hidden:0,  Width:150,   Align:"Center",  ColMerge:1,   SaveName:"bankCd", KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
            ];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


        // 조회조건

		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
	    $(".close").click(function() {
	    	p.self.close();
	    });
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":

				sheet1.DoSearch( "${ctx}/PayBankPopup.do?cmd=getPayBankPopupList", $("#mySheetForm").serialize() );
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

	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var rv = new Array(5);
		rv["bankCd"] 		= sheet1.GetCellValue(Row, "bankCd");
		rv["bankNm"]		= sheet1.GetCellValue(Row, "bankNm");
		p.window.returnValue 	= rv;
		p.window.close();
	}

</script>
</head>
<div class="wrapper">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='113792' mdef='금융사 조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm">
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='112036' mdef='금융사명 '/></th>
						<td> 
							<input id="searchName" name ="searchName" class="text" />
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
