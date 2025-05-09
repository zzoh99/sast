<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112392' mdef='조건 검색 관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>


<script type="text/javascript">
	var srchBizCdList = null;
	var srchTypeCdList = null;
	var conditionLayer = { id: 'conditionLayer' }
	var searchDesc = null;
	$(function(){
		createIBSheet3(document.getElementById('conditionLayerSht-wrap'), "conditionLayerSht", "100%", "100%","${ssnLocaleCd}");
		let modal = window.top.document.LayerModalUtility.getModal(conditionLayer.id);
		searchDesc = modal.parameters.searchDesc;
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
	        //{Header:"<sht:txt mid='sNo' mdef='No'/>",  				Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo", UpdateEdit:0 },
			{Header:"인재유형",      	Type:"Text",    Hidden:0,  	Width:30,	Align:"Center",  ColMerge:0,   SaveName:"searchDesc",    UpdateEdit:0 },
			{Header:"seq",      		Type:"Text",    Hidden:1,  	Width:30,	Align:"Center",  ColMerge:0,   SaveName:"searchSeq",    UpdateEdit:0 },
		];IBS_InitSheet(conditionLayerSht, initdata); conditionLayerSht.SetEditable("${editable}");conditionLayerSht.SetEditableColorDiff (0);
	    $(window).smartresize(sheetResize); sheetInit();


		var sheetHeight = $(".modal_body").height() - $("#mySheetForm").height() - 2;
		conditionLayerSht.SetSheetHeight(sheetHeight);


	    doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			var Row = conditionLayerSht.DataInsert(0);
			conditionLayerSht.SetCellValue(Row, 'searchDesc', '기술전문가');
			conditionLayerSht.SetCellValue(Row, 'searchSeq', '1');

			Row = conditionLayerSht.DataInsert(0);
			conditionLayerSht.SetCellValue(Row, 'searchDesc', '차세대 리더');
			conditionLayerSht.SetCellValue(Row, 'searchSeq', '2');

			Row = conditionLayerSht.DataInsert(0);
			conditionLayerSht.SetCellValue(Row, 'searchDesc', '영어능통자');
			conditionLayerSht.SetCellValue(Row, 'searchSeq', '3');

			if(searchDesc != '') {
				Row = conditionLayerSht.DataInsert(0);
				conditionLayerSht.SetCellValue(Row, 'searchDesc', searchDesc);
				conditionLayerSht.SetCellValue(Row, 'searchSeq', '4');
			}
			break;
		}
    }

	// 	조회 후 에러 메시지
	function conditionLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function conditionLayerSht_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		const modal = window.top.document.LayerModalUtility.getModal(conditionLayer.id);

		modal.fire('conditionLayerTrigger', {
			  searchSeq : conditionLayerSht.GetCellValue(Row, "searchSeq")
			, searchDesc : conditionLayerSht.GetCellValue(Row, "searchDesc")
		}).hide();
	}

	function init_value() {
		const modal = window.top.document.LayerModalUtility.getModal(conditionLayer.id);
		modal.fire('conditionLayerTrigger', {
			  searchSeq : ''
			, searchDesc : ''
		}).hide();
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="mySheetForm" name="mySheetForm">
			</form>
			<div id="conditionLayerSht-wrap"></div>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('conditionLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>



