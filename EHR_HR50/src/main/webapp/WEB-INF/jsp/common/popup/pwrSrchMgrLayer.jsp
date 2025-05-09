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
	var pwrSrchMgrLayer = { id: 'pwrSrchMgrLayer' }
	
	$(function(){
		createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%","${ssnLocaleCd}");

		//srchBizCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "<tit:txt mid='103895' mdef='전체'/>");
		srchBizCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");
		srchTypeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20010"), "<tit:txt mid='103895' mdef='전체'/>");

		$("#srchBizCd").html(srchBizCdList[2]);	//업무 구분
		$("#srchType").html(srchTypeCdList[2]);	//검색 구분

		sheet1.SetDataLinkMouse("sStatus", 1);
	    sheet1.SetDataLinkMouse("dbItemDesc", 1);
	    
		var srchBizCd = "";
		var srchType = "";
		var srchDesc = "";
		let modal = window.top.document.LayerModalUtility.getModal(pwrSrchMgrLayer.id);
		$("#srchDesc").val(modal.parameters.searchDesc);
		$("#srchBizCd").val(modal.parameters.srchBizCd);
		$("#srchType").val(modal.parameters.srchType);

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
	        {Header:"<sht:txt mid='sNo' mdef='No'/>",  				Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo", UpdateEdit:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",      	Type:"Image",   Hidden:1,  	Width:40,	Align:"Center",  ColMerge:0,   SaveName:"dbItemDesc",	UpdateEdit:0},
			{Header:"<sht:txt mid='searchSeq_V646' mdef='검색\n순번'/>",      	Type:"Text",    Hidden:1,  	Width:30,	Align:"Center",  ColMerge:0,   SaveName:"searchSeq",    UpdateEdit:0 },
	        {Header:"<sht:txt mid='searchType' mdef='검색구분'/>",        	Type:"Combo",   Hidden:0,  	Width:130,	Align:"Center",  ColMerge:0,   SaveName:"searchType",   UpdateEdit:0 },
	        {Header:"<sht:txt mid='searchDesc' mdef='검색설명'/>",        	Type:"Text",    Hidden:0,  	Width:200,	Align:"Left",    ColMerge:0,   SaveName:"searchDesc",   UpdateEdit:0 },
	        {Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",        	Type:"Combo",   Hidden:0, 	Width:110,	Align:"Left",    ColMerge:0,   SaveName:"bizCd",        UpdateEdit:0 },
	        {Header:"<sht:txt mid='viewCd' mdef='조회업무코드'/>",    	Type:"Text",    Hidden:1,  	Width:0,  	Align:"Left",    ColMerge:0,   SaveName:"viewCd",       UpdateEdit:0 },
	        {Header:"<sht:txt mid='viewDesc' mdef='조회업무'/>",        	Type:"Text",   Hidden:0,  	Width:100,	Align:"Left",    ColMerge:0,   SaveName:"viewDesc",     UpdateEdit:0 },
	        {Header:"<sht:txt mid='commonUseYn' mdef='공통사용\n여부'/>",  	Type:"Combo",   Hidden:1,  	Width:0,   Align:"Center",  ColMerge:0,   SaveName:"commonUseYn",   UpdateEdit:0 },
	        {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",            	Type:"Text",    Hidden:1,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"sabun",        UpdateEdit:0 },
	        {Header:"<sht:txt mid='chkId' mdef='등록자'/>",          	Type:"Text",    Hidden:1,  	Width:80,   Align:"Center",  ColMerge:0,   SaveName:"owner",        UpdateEdit:0 },
	        {Header:"<sht:txt mid='chkdateV1' mdef='최종수정일'/>",      	Type:"Date",    Hidden:1,  	Width:0,  	Align:"Center",  ColMerge:0,   SaveName:"chkdate",      UpdateEdit:0 },
	        {Header:"<sht:txt mid='viewNm' mdef='VIEW_NM'/>",         	Type:"Text",    Hidden:1,  	Width:0,    Align:"Center",  ColMerge:0,   SaveName:"viewNm",       UpdateEdit:0 },
	        {Header:"<sht:txt mid='copySearchSeq' mdef='복사_SEARCH_SEQ'/>",	Type:"Text",    Hidden:1,  	Width:0,   Align:"Center",  ColMerge:0,   SaveName:"copySearchSeq", UpdateEdit:0 }
		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");sheet1.SetEditableColorDiff (0);
     	sheet1.SetColProperty("bizCd", 		{ComboText:srchBizCdList[0], 	ComboCode:srchBizCdList[1]} );
        sheet1.SetColProperty("searchType", 	{ComboText:srchTypeCdList[0], 	ComboCode:srchTypeCdList[1]} );
        sheet1.SetColProperty("commonUseYn", 	{ComboText:"YES|NO", 		ComboCode:"Y|N"} );
        sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetCountPosition(4);

	    $(window).smartresize(sheetResize); sheetInit();


		var sheetHeight = $(".modal_body").height() - $("#mySheetForm").height() - $(".sheet_title").height() - 2;
		sheet1.SetSheetHeight(sheetHeight);

		$("#srchDesc").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

	    doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "${ctx}/Popup.do?cmd=getPwrSrchMgrPopupList", $("#mySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		const modal = window.top.document.LayerModalUtility.getModal(pwrSrchMgrLayer.id);

		modal.fire('pwrTrigger', {
			  searchSeq : sheet1.GetCellValue(Row, "searchSeq")
			, searchDesc : sheet1.GetCellValue(Row, "searchDesc")
		}).hide();
	}

	function init_value() {
		const modal = window.top.document.LayerModalUtility.getModal(pwrSrchMgrLayer.id);
		modal.fire('pwrTrigger', {
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
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='114394' mdef='업무구분'/></th>
						<td>
							<select id="srchBizCd" name="srchBizCd" onChange=""></select>
						</td>
						<th><tit:txt mid='112961' mdef='검색구분'/></th>
						<td>
							<select id="srchType" name="srchType" onChange=""></select>
						</td>
						<th><tit:txt mid='112606' mdef='검색설명'/></th>
						<td>
							<input id="srchDesc" name="srchDesc" type="text" class="text" style="ime-mode:active;" />
						</td>
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
							<li id="txt" class="txt"><tit:txt mid='112392' mdef='조건 검색 관리'/></li>
						</ul>
						</div>
					</div>
						<div id="sheet1-wrap"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('pwrSrchMgrLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
			<btn:a href="javascript:init_value();" css="btn filled" mid='110754' mdef="초기화"/>
		</div>
	</div>
</body>
</html>



