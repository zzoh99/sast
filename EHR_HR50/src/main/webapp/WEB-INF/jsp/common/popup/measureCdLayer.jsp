<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112705' mdef='척도 리스트 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
<%-- <script src="${ctx}/common/js/commonIBSheet.js" type="text/javascript" charset="utf-8"></script>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%> --%>
<script type="text/javascript">
	$(function() {
		createIBSheet3(document.getElementById('mysheet-wrap'), "mySheet", "100%", "100%", "${ssnLocaleCd}");
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",     Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
	            {Header:"<sht:txt mid='competencyCdV1' mdef='척도코드'/>",	Type:"Text",      Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"gmeasureCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='gmeasureNmV1' mdef='척도명'/>",		Type:"Text",      Hidden:0,  Width:150,  	Align:"Left",    ColMerge:0,   SaveName:"gmeasureNm",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
	            {Header:"<sht:txt mid='typeV1' mdef='척도구분'/>",	Type:"Combo",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"type",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='gmeasureType' mdef='척도유형'/>",	Type:"Combo",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"gmeasureType",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='levelType' mdef='범위유형'/>",	Type:"Combo",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"levelType",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='commonYnV1' mdef='공통척도'/>",	Type:"CheckBox",  Hidden:0,  Width:50,    	Align:"Center",  ColMerge:0,   SaveName:"commonYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1,	TrueValue:"Y", FalseValue:"N" },
	            {Header:"<sht:txt mid='memoV14' mdef='척도개요'/>", 	Type:"Text",      Hidden:1,  Width:200,  	Align:"Left",    ColMerge:0,   SaveName:"memo",           	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000,	MultiLineText:1 },
	            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>", 		Type:"Int",  	  Hidden:1,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"orderSeq",     	KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:3 }
		];
		IBS_InitSheet(mySheet, initdata);mySheet.SetVisible(true);mySheet.SetCountPosition(4);mySheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var gmeasureType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20030"), "");	//척도유형
		var levelType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20050"), "");	//척도범위유형

		mySheet.SetColProperty("type", {ComboText:"정성|정량", ComboCode:"A|C"} );	//척도구분
		mySheet.SetColProperty("gmeasureType", 			{ComboText:gmeasureType[0], ComboCode:gmeasureType[1]} );	//척도유형
		mySheet.SetColProperty("levelType", 			{ComboText:levelType[0], ComboCode:levelType[1]} );	//척도범위유형
	    $(window).smartresize(sheetResize); sheetInit();

	    var sheetHeight = $(".modal_body").height() - $("#mySheetForm").height() - $(".sheet_title").height() - 2;
	    mySheet.SetSheetHeight(sheetHeight);
	    doAction("Search");
		$("#searchGmeasureNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet.DoSearch( "${ctx}/Popup.do?cmd=getMeasureCdPopupList", $("#mySheetForm").serialize() );
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

	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && mySheet.ColSaveName(Col) == "detail"){
		    	measureCdMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function mySheet_OnDblClick(Row, Col){
		const p = { gmeasureCd: mySheet.GetCellValue(Row, "gmeasureCd"), gmeasureNm:mySheet.GetCellValue(Row, "gmeasureNm") };
		var modal = window.top.document.LayerModalUtility.getModal('measureCdLayer');
		modal.fire('measureCdLayerTrigger', p).hide();
	}

	/**
	 * 상세내역 window open event
	 */
	function measureCdMgrPopup(Row){
  		var w 		= 940;
		var h 		= 720;
		var url 	= "${ctx}/MeasureCdMgr.do?cmd=viewMeasureCdMgrLayer&authPg=R";
		var p = {
				gmeasureCd 		: mySheet.GetCellValue(Row, "gmeasureCd"),
				gmeasureNm 		: mySheet.GetCellValue(Row, "gmeasureNm"),
				type 			: mySheet.GetCellValue(Row, "type"),
				gmeasureType 	: mySheet.GetCellValue(Row, "gmeasureType"),
				levelType 		: mySheet.GetCellValue(Row, "levelType"),
				memo 			: mySheet.GetCellValue(Row, "memo"),
				commonYn 		: mySheet.GetCellValue(Row, "commonYn"),
				orderSeq 		: mySheet.GetCellValue(Row, "orderSeq")
				};
		var layer = new window.top.document.LayerModal({
		  		id : 'measureCdMgrLayer'
		      , url : url
		      , parameters: p
		      , width : w
		      , height : h
		      , title : "<tit:txt mid='measureCdMgr' mdef='척도관리 세부내역'/>"
		  });
		layer.show();
		
	}
</script>


</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
        <div class="modal_body">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<th><tit:txt mid='112706' mdef='척도명 '/></th>
					<td>  <input id="searchGmeasureNm" name ="searchGmeasureNm" type="text" class="text" /> </td>
					<td> <a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
						<li id="txt" class="txt"><tit:txt mid='112705' mdef='척도 리스트 조회'/></li>
					</ul>
					</div>
				</div>
				<div id="mysheet-wrap"></div>
				<!-- <script type="text/javascript">createIBSheet("mySheet", "100%", "100%","${ssnLocaleCd}"); </script> -->
				</td>
			</tr>
		</table>

		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('measureCdLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
</div>
</body>
</html>



