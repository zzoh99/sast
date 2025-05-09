<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>복리후생급여항목 조회</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();
	var loanCd = arg['loanCd'];
	var loanDesc = arg['loanDesc'];
	var loanNm = arg['loanNm'];
	var sdate = arg['sdate'];
	var edate = arg['edate'];

	$(function() {

        $(".close").click(function() {
	    	p.self.close();
	    });

        var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
        	{Header:"No",         	Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"항목코드",      	Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"benefitElemCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"항목명",        	Type:"Text",      Hidden:0,  Width:250,  Align:"Left",    ColMerge:0,   SaveName:"benefitElemNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"복리후생업무구분", 	Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"benefitBizCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"급여항목코드",   	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"급여항목",      	Type:"Popup",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"elementNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		 ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable( false );sheet1.SetCountPosition(4);

		var benefitBizCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10230"), "");
		sheet1.SetColProperty("benefitBizCd", 			{ComboText:benefitBizCdList[0], ComboCode:benefitBizCdList[1]} );

	    $("#searchBenefitElemNm").bind("keyup",function(event){
	        if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
	    });

		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");

	});

	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/WelfPayItemMgr.do?cmd=getWelfPayItemMgrList", $("#sheet1Form").serialize() ); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		//더블 클릭했을 때, 선택행의 값을 전달 어미 창으로 전달.

		returnResult( Row );
	}


	function confirmCode(){

		var row1 = sheet1.GetSelectRow();

		returnResult(row1)

	}

	function returnResult( row1){

		var benefitElemCd = sheet1.GetCellValue( row1 , "benefitElemCd" );
		var benefitElemNm = sheet1.GetCellValue( row1 , "benefitElemNm" );

		var rtnValue = [];

		rtnValue["benefitElemCd"] = benefitElemCd;
		rtnValue["benefitElemNm"] = benefitElemNm;

		p.window.close();
 		p.popReturnValue(rtnValue);
	}

</script>

</head>
<body class="bodywrap">
<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li>복리후생급여항목 조회</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">

		<form id="sheet1Form" name="sheet1Form" >
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>항목명</th>
							<td>  <input id="searchBenefitElemNm" name ="searchBenefitElemNm" type="text" class="text" /> </td>
							<td> <a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a> </td>
						</tr>
					</table>
				</div>
			</div>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:confirmCode();" class="pink large">확인</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>



