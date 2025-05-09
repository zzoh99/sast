<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>의료비진료 신청 접수기간 조회</title>
<script type="text/javascript">
	$(function() {
		var seq = "";
		const modal = window.top.document.LayerModalUtility.getModal('acessLogShtLayer');
		var arg = modal.parameters;
		
	    if( arg != undefined ) {
	    	seq    = arg["seq"];
	    }		
		$("#seq").val(seq);

		createIBSheet3(document.getElementById('acessLogShtLayerSht-wrap'), "acessLogShtLayerSht", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",			Type:"Text", 	 Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	  SaveName:"no" },
			{Header:"메뉴명|메뉴명",		Type:"Text",     Hidden:0,  Width:240,	Align:"Center",  		ColMerge:0,   SaveName:"prgNm", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"PARAMETER|Key",	Type:"Text",     Hidden:0,  Width:100,	Align:"Center",  		ColMerge:0,   SaveName:"key", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"PARAMETER|Value",	Type:"Text",     Hidden:0,  Width:200,	Align:"Center",  		ColMerge:0,   SaveName:"value", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"쿼리|쿼리",			Type:"Text",     Hidden:0,  Width:300,	Align:"Left",  			ColMerge:0,   SaveName:"queryString", KeyField:0,   CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0, MultiLineText:1}
		]; 
		IBS_InitSheet(acessLogShtLayerSht, initdata);acessLogShtLayerSht.SetEditable(false);acessLogShtLayerSht.SetVisible(true);acessLogShtLayerSht.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	// acessLogShtLayerSht Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var data = ajaxCall( "${ctx}/AcessLogSht.do?cmd=getAcessLogShtMap", $("#acessLogShtLayerFrm").serialize(),false);
				//
				if ( data != null && data.Keys != null ){
					var queryString = $.trim(data.QueryString);
					var prgNm = data.PrgNm;
					var keys = data.Keys;
					var values = data.Values;
					var totalCnt = keys.length;
					for (var i = 0; i < keys.length; i++) {
						var Row = acessLogShtLayerSht.DataInsert(0);
						acessLogShtLayerSht.SetCellValue(Row, "no", totalCnt - i);
						acessLogShtLayerSht.SetCellValue(Row, "key", keys[i]);
						acessLogShtLayerSht.SetCellValue(Row, "value", values[i]);
					}
					acessLogShtLayerSht.SetCellValue(2, "prgNm", prgNm);
					acessLogShtLayerSht.SetCellValue(2, "queryString", queryString);
					acessLogShtLayerSht.SetMergeCell(2, 1, totalCnt, 1);
					acessLogShtLayerSht.SetMergeCell(2, 4, totalCnt, 1);
				}
				sheetResize();
			break;
		}
	}

</script>
</head>
<body>
	<div class="wrapper modal_layer">
        <div class="modal_body">
			<form id="acessLogShtLayerFrm" name="acessLogShtLayerFrm">
				<input type="hidden" id="seq" name="seq" value="" />
			</form>

			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div id="acessLogShtLayerSht-wrap"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('acessLogShtLayer')" class="btn outline_gray">닫기</a>
		</div>
	</div>
</body>
</html>