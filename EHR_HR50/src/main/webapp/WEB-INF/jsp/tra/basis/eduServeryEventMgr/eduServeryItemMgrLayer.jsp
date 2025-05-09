<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<script type="text/javascript">
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('eduServeryItemMgrLayer');
		var arg = modal.parameters;
		if( arg != undefined ) {
			$("#surveyItemType").val(arg["surveyItemType"]);
	    }

		createIBSheet3(document.getElementById('eduServeryItemMgrLayerSht-wrap'), "eduServeryItemMgrLayerSht", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",       Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",               KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
            {Header:"<sht:txt mid='deductionType' mdef='항목분류'/>",			Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"surveyItemType",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='surveyGb' mdef='만족도조사구분'/>",		Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"surveyGb",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='surveyItemCd' mdef='설문항목코드'/>",		Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"surveyItemCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
            {Header:"<sht:txt mid='surveyItemNm' mdef='설문항목명'/>",			Type:"Text",      Hidden:0,  Width:410,  Align:"Left",    ColMerge:0,   SaveName:"surveyItemNm",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",				Type:"Date",      Hidden:1,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"startYmd",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",				Type:"Date",      Hidden:1,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"endYmd",           KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='description' mdef='설명'/>",				Type:"Text",      Hidden:1,  Width:200,	 Align:"Left",    ColMerge:0,   SaveName:"surveyItemDesc",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 }
        ]; IBS_InitSheet(eduServeryItemMgrLayerSht, initdata);eduServeryItemMgrLayerSht.SetEditable("${editable}");eduServeryItemMgrLayerSht.SetVisible(true);eduServeryItemMgrLayerSht.SetCountPosition(4);eduServeryItemMgrLayerSht.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

        var list1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10230"), "");

		eduServeryItemMgrLayerSht.SetColProperty("surveyItemType", 			{ComboText:"|"+list1[0], ComboCode:"|"+list1[1]} );


	    $(window).smartresize(sheetResize); sheetInit();

	    doEduServeryItemMgrAction1("Search");
	});

	/*Sheet1 Action*/
	function doEduServeryItemMgrAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			eduServeryItemMgrLayerSht.DoSearch( "${ctx}/Popup.do?cmd=getEduServeryItemMgrList", $("#eduServeryItemMgrLayerShtForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function eduServeryItemMgrLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function eduServeryItemMgrLayerSht_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var rv = new Array();

		rv["surveyItemType"	]	=	eduServeryItemMgrLayerSht.GetCellValue(Row,"surveyItemType"	);
		rv["surveyItemCd"	]	=	eduServeryItemMgrLayerSht.GetCellValue(Row,"surveyItemCd"		);
		rv["surveyItemNm"	]	=	eduServeryItemMgrLayerSht.GetCellValue(Row,"surveyItemNm"		);

		const modal = window.top.document.LayerModalUtility.getModal('eduServeryItemMgrLayer');
		modal.fire('eduServeryItemMgrLayerTrigger', rv).hide();
	}

</script>


</head>
<body class="bodywrap">
<form id="eduServeryItemMgrLayerShtForm" name="eduServeryItemMgrLayerShtForm" >
	<input type="hidden" id="searchApplSabun" name="searchApplSabun" value=""/>
	<input type="hidden" id="surveyItemType" name="surveyItemType" value=""/>

</form>
	<div class="wrapper modal_layer">
        <div class="modal_body">
        	<div id="tabs">
				<ul class="outer tab_bottom">
				</ul>
				<div id="tabs-1">
					<div id="eduServeryItemMgrLayerSht-wrap"></div>
				</div>
			</div>
		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('eduServeryItemMgrLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
	</div>
</body>
</html>
