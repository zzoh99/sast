<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='dedEleMgrPop' mdef='연말정산 코드항목 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;
	var p = eval("${popUpStatus}");
	$(function() {

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",   Hidden:1, Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",   Hidden:1, Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
			{Header:"<sht:txt mid='appraisalYy' mdef='년도'/>",			Type:"Text",      Hidden:0,  Width:50,  Align:"Center",    ColMerge:0,   SaveName:"workYy",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='adjElementCd' mdef='연말정산항목코드'/>", Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"adjElementCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='adjElementNm' mdef='연말정산항목명'/>",   Type:"Text",      Hidden:0,  Width:390,  Align:"Left",    ColMerge:0,   SaveName:"adjElementNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
		];

		IBS_InitSheet(mySheet, initdata);
		mySheet.SetEditable("${editable}");

		mySheet.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		doAction("Search");

		$(".close").click(function() {
			p.self.close();
		});

		$("#searchWorkYY, #sAdjElementNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search");
			}
		});

		$("#searchWorkYY").bind("keyup",function(event){
			makeNumber(this,"A");
		});
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": 		//조회
				mySheet.DoSearch( "${ctx}/DedEleMgr.do?cmd=getDedEleMgrPopupList", $("#mySheetForm").serialize() );
				break;

			case "Clear":		// 항목코드 초기화 적용
				setElementData("", "");
				break;
		}
	}

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		var _adjCd = mySheet.GetCellValue(Row, "adjElementCd");
		var _adjNm = mySheet.GetCellValue(Row, "adjElementNm");

		setElementData(_adjCd, _adjNm);
	}

	// 항목코드값 적용 후 창 닫기 적용
	function setElementData(adjCd, adjNm){
		var rv = new Array(5);
		rv["adjElementCd"]		= adjCd;
		rv["adjElementNm"]		= adjNm;

		//p.window.returnValue 	= rv;
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close();
	}
</script>

</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='dedEleMgrPop' mdef='연말정산 코드항목 조회'/></li>
				<li class="close"></li>
			</ul>
		</div>

		<div class="popup_main">
			<form id="mySheetForm" name="mySheetForm">
				<div class="sheet_search outer">
					<div>
						<table>
							<tr>
								<th><tit:txt mid='113322' mdef='년도'/></th>
								<td>  <input id="searchWorkYY" name ="searchWorkYY" type="text" class="text" maxlength="4" /> </td>
								<th><tit:txt mid='itemNm' mdef='항목명'/></th>
								<td>  <input id="sAdjElementNm" name ="sAdjElementNm" type="text" class="text" maxlength="30" style="ime-mode:active;" /> </td>
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
								<li id="txt" class="txt"><tit:txt mid='dedEleMgrPop' mdef='연말정산 코드항목 조회'/></li>
								<li class="btn">
									<a href="javascript:doAction('Clear')" class="basic authA"><tit:txt mid='adjElementReset' mdef='코드항목 초기화'/></a>
								</li>
							</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("mySheet", "100%", "100%","${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
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
