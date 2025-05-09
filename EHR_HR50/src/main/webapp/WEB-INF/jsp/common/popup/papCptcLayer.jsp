<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114517' mdef='항목값 정의'/></title>
<script type="text/javascript">

	$(function() {

		var arg = window.top.document.LayerModalUtility.getModal('papCptcLayer').parameters;
	    if( arg != undefined ) {
	    	$("#searchAppraisalCd").val(arg["appraisalCd"]);
	    	$("#searchItemCd").val(arg["itemCd"]);
	    	$("#sItemNm").text(arg["itemNm"]);
	    }

		createIBSheet3(document.getElementById('papCptcLayerSht-wrap'), "papCptcLayerSht", "100%", "100%", "${ssnLocaleCd}");

	    var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='priorCompetencyCd' mdef='역량상위코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"priorCompetencyCd", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",		Type:"Text",      Hidden:1,  Width:0,   Align:"Center",    ColMerge:0,   SaveName:"competencyCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='competencyNmV2' mdef='역량체계'/>",		Type:"Popup",     Hidden:0,  Width:200,  Align:"Left",    	ColMerge:0,   SaveName:"competencyNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100,	TreeCol:1,  LevelSaveName:"sLevel" },
            {Header:"<sht:txt mid='competencyType' mdef='역량분류'/>",		Type:"Combo",      Hidden:0,  Width:60,   Align:"Center",    ColMerge:0,   SaveName:"competencyType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='comGubunCd' mdef='역량구분'/>",  		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"mainAppType",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>", 			Type:"Int",  	  Hidden:0,  Width:30,   Align:"Center",  	ColMerge:0,   SaveName:"seq",     			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
            {Header:"<sht:txt mid='memoV12' mdef='개요'/>",			Type:"Text",      Hidden:0,  Width:400,  	 Align:"Left",    	ColMerge:0,   SaveName:"memo",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000   },
            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",      Hidden:1,  Width:0,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>", 		Type:"Date",      Hidden:1,  Width:0,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='competencyCdV1' mdef='척도코드'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureCd",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='gmeasureNm' mdef='척도코드명'/>", 	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(papCptcLayerSht, initdata);papCptcLayerSht.SetEditable("${editable}");papCptcLayerSht.SetVisible(true);papCptcLayerSht.SetCountPosition(4);papCptcLayerSht.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분

		papCptcLayerSht.SetColProperty("competencyType", 		{ComboText:"역량군|역량", ComboCode:"A|C"} );	//역량분류
		papCptcLayerSht.SetColProperty("mainAppType", 			{ComboText:mainAppType[0], ComboCode:mainAppType[1]} );	//역량구분


		// 트리레벨 정의
		$("#btnPlus").click(function() {
			papCptcLayerSht.ShowTreeLevel(-1);
		});
		$("#btnStep1").click(function()	{
			papCptcLayerSht.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			papCptcLayerSht.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			papCptcLayerSht.ShowTreeLevel(-1);
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	papCptcLayerSht.DoSearch( "${ctx}/PapCptcPopup.do?cmd=getPapCptcPopupList", $("#papCptcLayerFrm").serialize() ); break;
		case "Save":
			IBS_SaveName(document.papCptcLayerFrm,papCptcLayerSht);
			papCptcLayerSht.DoSave( "${ctx}/AppSelfReportItemMgr.do?cmd=saveAppSelfReportItemMgrValuePop", $("#papCptcLayerFrm").serialize()); break;
		case "Insert":
			var Row = papCptcLayerSht.DataInsert(0);
			papCptcLayerSht.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
			papCptcLayerSht.SetCellValue(Row, "itemCd", $("#searchItemCd").val());
			papCptcLayerSht.SelectCell(Row, "valueNm");
		break;
		case "Copy":		papCptcLayerSht.DataCopy(); break;
		case "Clear":		papCptcLayerSht.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(papCptcLayerSht);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			papCptcLayerSht.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; papCptcLayerSht.LoadExcel(params); break;
		}
	}

	// 	조회 후 에러 메시지
	function papCptcLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function papCptcLayerSht_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			 doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function papCptcLayerSht_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		try{
			if(papCptcLayerSht.GetCellValue(Row, "competencyType") == 'C' ){
				var rv = new Array();
				rv["competencyNm"] = papCptcLayerSht.GetCellValue(Row, "competencyNm");    //역량명
				rv["competencyCd"] = papCptcLayerSht.GetCellValue(Row, "competencyCd");    //역량코드
				rv["mainAppType"] = papCptcLayerSht.GetCellValue(Row, "mainAppType");      //역량구분
				rv["memo"] = papCptcLayerSht.GetCellValue(Row, "memo");             //개요

				const modal = window.top.document.LayerModalUtility.getModal('papCptcLayer');
				modal.fire('papCptcLayerTrigger', rv).hide();

			}else{
				alert("역량분류가 '역량' 인 항목만 선택 가능 합니다.");
			}
		}catch(ex){
			alert("OnDblClick Event Error " + ex);
		}

	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper modal_layer">
        <div class="modal_body">
			<form id="papCptcLayerFrm" name="papCptcLayerFrm" tabindex="1">
	            <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
	            <input type="hidden" id="searchItemCd" name="searchItemCd" />
			</form>

			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">
								<span id="sItemNm"></span> 역량조회
								<div class="util">
									<ul>
										<li	id="btnPlus"></li>
										<li	id="btnStep1"></li>
										<li	id="btnStep2"></li>
										<li	id="btnStep3"></li>
									</ul>
								</div>
							 </li>
							<li class="btn">
								<a href="javascript:doAction1('Search')"		class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
							</li>
						</ul>
						</div>
					</div>
					<div id="papCptcLayerSht-wrap"></div>
					</td>
				</tr>
			</table>

		</div>
		<div class="modal_footer">
			<ul>
				<li>
					<a href="javascript:closeCommonLayer('papCptcLayer')" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>



