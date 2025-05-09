<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='orgSchList' mdef='조직 리스트 조회'/></title>

<script type="text/javascript">
	var orgTreeLayer = { id: 'orgTreeLayer' };
	var searchEnterCd = "";
	$(function() {
		createIBSheet3(document.getElementById('orgTreeLayerSht-wrap'), "orgTreeLayerSht", "100%", "100%", "${ssnLocaleCd}");
		const modal = window.top.document.LayerModalUtility.getModal(orgTreeLayer.id);
		$("#findOrg").val(modal.parameters.findOrg);
		searchEnterCd = modal.parameters.searchEnterCd;
		
		//조직도 select box
		var searchSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate&searchEnterCd=" + searchEnterCd,false).codeList, "");	//조직도
		$("#orgTreeLayerShtForm #searchSdate").html(searchSdate[2]);

        $("#orgTreeLayerShtForm #searchSdate").bind("change",function(event){
        	doAction1("Search");
        });

		$("#btnPlus").click(function() {
			orgTreeLayerSht.ShowTreeLevel(-1);
		});

		$("#btnStep1").click(function()	{
			orgTreeLayerSht.ShowTreeLevel(0, 1);
		});

		$("#btnStep2").click(function()	{
			orgTreeLayerSht.ShowTreeLevel(1,2);
		});

		$("#btnStep3").click(function()	{
			orgTreeLayerSht.ShowTreeLevel(-1);
		});

		//배열 선언
		var initdata1 = {};
		//SetConfig
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0, ChildPage:5, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata1.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
               	{Header:"<sht:txt mid='orgChartNmV1' mdef='조직도명'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgChartNm",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 },
               	{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",       	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sdate",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
               	{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
               	{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
               	{Header:"<sht:txt mid='orgNmV6' mdef='조직도'/>",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50,    TreeCol:1  },
               	{Header:"<sht:txt mid='codeEngNm' mdef='영문명'/>",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgEngNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50  },
    			{Header:"<sht:txt mid='inoutTypeV2' mdef='조직구분'/>", 		Type:"Combo",    Hidden:1,  Width:60,  	Align:"Center",  	ColMerge:0,   SaveName:"objectType",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
    			{Header:"<sht:txt mid='inoutType' mdef='내외구분'/>",		Type:"Combo",    Hidden:1,  Width:60,  	Align:"Center",  	ColMerge:0,   SaveName:"inoutType",    		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
    			{Header:"<sht:txt mid='orgType' mdef='조직유형'/>",		Type:"Combo",    Hidden:1,  Width:60,  	Align:"Center",  	ColMerge:0,   SaveName:"orgType",      		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
    			{Header:"<sht:txt mid='locationCdV3' mdef='LOCATION'/>",		Type:"Combo",    Hidden:1,  Width:80,  	Align:"Center",   	ColMerge:0,   SaveName:"locationCd",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
               	{Header:"직속n여부",		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"directYn",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20},
               	{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Right",   ColMerge:0,   SaveName:"seqSEQ",      KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
               	{Header:"<sht:txt mid='filePath' mdef='경로'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Right",   ColMerge:0,   SaveName:"treePath",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
               	{Header:"<sht:txt mid='locationCdV1' mdef='근무지코드'/>",     	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"workAreaCd",       KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
               	{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",       	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"workAreaNm",       KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		];IBS_InitSheet(orgTreeLayerSht, initdata1); orgTreeLayerSht.SetEditable(false);

		var orgType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&searchEnterCd=" + searchEnterCd,"W20010"), "");	//조직유형
		var inoutType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&searchEnterCd=" + searchEnterCd,"W20050"), "");	//내외구분
		var objectType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&searchEnterCd=" + searchEnterCd,"W20030"), "");	//조직구분
		var locationCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList&searchEnterCd=" + searchEnterCd,false).codeList, "");	//LOCATION

		orgTreeLayerSht.SetColProperty("orgType", 			{ComboText:"|"+orgType[0], ComboCode:"|"+orgType[1]} );	//조직유형
		orgTreeLayerSht.SetColProperty("inoutType", 			{ComboText:"|"+inoutType[0], ComboCode:"|"+inoutType[1]} );	//내외구분
		orgTreeLayerSht.SetColProperty("objectType", 		{ComboText:"|"+objectType[0], ComboCode:"|"+objectType[1]} );	//조직구분
		orgTreeLayerSht.SetColProperty("locationCd", 		{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );	//LOCATION

		orgTreeLayerSht.SetCountPosition(4);
		orgTreeLayerSht.SetColProperty("directYn", {ComboText:"|YES|NO", ComboCode:"|Y|N"} );

		sheetInit();

		// sheet 높이 계산
		let sheetHeight = $(".modal_body").height() - $("#orgTreeLayerShtForm").height() - $(".sheet_title").height() - 2;
		orgTreeLayerSht.SetSheetHeight(sheetHeight);

	    doAction1("Search");
        $("#findOrg").bind("keyup",function(event){
            if( event.keyCode == 13){ findOrg(); }
        });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			orgTreeLayerSht.DoSearch( "${ctx}/Popup.do?cmd=getOrgTreePopupList", $("#orgTreeLayerShtForm").serialize() + "&searchEnterCd=" + searchEnterCd );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function orgTreeLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
			findOrg();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function orgTreeLayerSht_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		var p = {
			orgCd 		: orgTreeLayerSht.GetCellValue(Row, "orgCd"),
			orgNm		: orgTreeLayerSht.GetCellValue(Row, "orgNm"),
			priorOrgCd	: orgTreeLayerSht.GetCellValue(Row, "priorOrgCd"),
			orgEngNm	: orgTreeLayerSht.GetCellValue(Row, "orgEngNm"),
			orgType		: orgTreeLayerSht.GetCellValue(Row, "orgType"),
			inoutType	: orgTreeLayerSht.GetCellValue(Row, "inoutType"),
			objectType	: orgTreeLayerSht.GetCellValue(Row, "objectType"),
			locationCd	: orgTreeLayerSht.GetCellValue(Row, "locationCd"),
			workAreaCd	: orgTreeLayerSht.GetCellValue(Row, "workAreaCd"),
			workAreaNm	: orgTreeLayerSht.GetCellValue(Row, "workAreaNm"),
			sdate		: orgTreeLayerSht.GetCellValue(Row, "sdate")
		};
		const modal = window.top.document.LayerModalUtility.getModal(orgTreeLayer.id);
		modal.fire(orgTreeLayer.id + 'Trigger', p).hide();
	}

	function findOrg(){
	    if($("#findOrg").val() == "") return;

	    var Row = 0;
	    if(orgTreeLayerSht.GetSelectRow() < orgTreeLayerSht.LastRow()){
	        Row = orgTreeLayerSht.FindText("orgNm", $("#findOrg").val(), orgTreeLayerSht.GetSelectRow()+1, 2,false);

	    }else{
	        Row = -1;
	    }
	    orgTreeLayerSht.SelectCell(Row,"orgNm");
	    $("#findOrg").focus();
	}

</script>


</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
        <div class="modal_body">
		<form id="orgTreeLayerShtForm" name="orgTreeLayerShtForm" tabindex="1" onsubmit="return false">
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<th><tit:txt mid='112713' mdef='조직도 '/></th>
					<td>
						<select id="searchSdate" name ="searchSdate" style="width:200px;"></select> </td>
					<th><tit:txt mid='104514' mdef='조직명'/></th>
   					<td>
   						<input id="findOrg" name ="findOrg" type="text" class="text" />
   					</td>
                  	<td>
						<btn:a href="javascript:findOrg();" id="btnSearch" css="button" mid='111684' mdef="찾기"/>
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
						<li id="txt" class="txt">조직도 조회&nbsp;
							<div class="util">
							<ul>
								<li	id="btnPlus"></li>
								<li	id="btnStep1"></li>
								<li	id="btnStep2"></li>
								<li	id="btnStep3"></li>
							</ul>
							</div>
						</li>
					</ul>
					</div>
				</div>
				<div id="orgTreeLayerSht-wrap"></div>
				</td>
			</tr>
		</table>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('orgTreeLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>


