<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112014' mdef='역량 리스트 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>


<script type="text/javascript">
	var competencyLayer = { id: 'competencyLayer' };
	$(function() {
		createIBSheet3(document.getElementById('competencysheet_wrap'), "competencySheet", "100%", "100%", "${ssnLocaleCd}");
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",		Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10,	Cursor:"Pointer" },
				{Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",		Type:"Text",      Hidden:0,  Width:60,   Align:"Center",    ColMerge:0,   SaveName:"competencyCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='competencyNm' mdef='역량명'/>",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    	ColMerge:0,   SaveName:"competencyNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	            {Header:"<sht:txt mid='competencyType' mdef='역량분류'/>",		Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",    ColMerge:0,   SaveName:"competencyType",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='essentialYn' mdef='필수여부'/>",		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"essentialYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
	            {Header:"<sht:txt mid='memoV12' mdef='개요'/>",			Type:"Text",      Hidden:1,  Width:0,  	 Align:"Left",    	ColMerge:0,   SaveName:"memo",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
	            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  	ColMerge:0,   SaveName:"sdate",         	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  	ColMerge:0,   SaveName:"edate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='measureType' mdef='적용척도구분'/>", 	Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"measureType",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
	            {Header:"<sht:txt mid='competencyCdV1' mdef='척도코드'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureCd",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='gmeasureNm' mdef='척도코드명'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	            {Header:"<sht:txt mid='comGubunCd' mdef='역량구분'/>",  		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"mainAppType",     	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='renewal' mdef='갱신주기'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"renewal",  			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='danwi' mdef='단위'/>",  			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"unit",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
		];
		IBS_InitSheet(competencySheet, initdata);competencySheet.SetVisible(true);competencySheet.SetCountPosition(4);competencySheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분
		competencySheet.SetColProperty("competencyType", 		{ComboText:"역량군|역량", ComboCode:"A|C"} );	//역량분류
		competencySheet.SetColProperty("essentialYn", 			{ComboText:"|필수|선택", ComboCode:"|Y|N"} );	//필수여부
		competencySheet.SetColProperty("measureType", 			{ComboText:"|공통|기존|자체", ComboCode:"|A|C|E"} );	//적용척도구분
		competencySheet.SetColProperty("mainAppType", 			{ComboText:mainAppType[0], ComboCode:mainAppType[1]} );	//역량구분

	    $(window).smartresize(sheetResize); sheetInit();
		var sheetHeight = $(".modal_body").height() - $("#competencySheetForm").height() - $(".sheet_title").height() - 2;
		competencySheet.SetSheetHeight(sheetHeight);

	    $("#searchSdate").datepicker2();
	    doAction("Search");
        $("#searchSdate,#searchCompetencyNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        });

	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			competencySheet.DoSearch( "${ctx}/Popup.do?cmd=getCompetencyPopupList", $("#competencySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function competencySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function competencySheet_OnDblClick(Row, Col){
		const p = { competencyCd 		: competencySheet.GetCellValue(Row, "competencyCd"),
				competencyNm		: competencySheet.GetCellValue(Row, "competencyNm"),
				competencyType	: competencySheet.GetCellValue(Row, "competencyType"),
				sdate				: competencySheet.GetCellValue(Row, "sdate"),
				edate				: competencySheet.GetCellValue(Row, "edate"),
				memo				: competencySheet.GetCellValue(Row, "memo"),
				mainAppType		: competencySheet.GetCellValue(Row, "mainAppType") };
		var modal = window.top.document.LayerModalUtility.getModal(competencyLayer.id);
		modal.fire(competencyLayer.id + 'Trigger', p).hide();
	}

	function competencySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && competencySheet.ColSaveName(Col) == "detail"){
		    	competencyMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function competencyMgrPopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 940;
		var h 		= 720;
		var url 	= "${ctx}/CompetencyMgr.do?cmd=viewCompetencyMgrLayer&authPg=R";
		const p = {competencyCd 	: competencySheet.GetCellValue(Row, "competencyCd"),
				competencyNm 	: competencySheet.GetCellValue(Row, "competencyNm"),
				competencyType 	: competencySheet.GetCellValue(Row, "competencyType"),
				mainAppType 	: competencySheet.GetCellValue(Row, "mainAppType"),
				sdate 			: competencySheet.GetCellText(Row, "sdate"),
				edate 			: competencySheet.GetCellText(Row, "edate"),
				memo 			: competencySheet.GetCellValue(Row, "memo"),
				gmeasureCd 		: competencySheet.GetCellValue(Row, "gmeasureCd"),
				gmeasureNm 		: competencySheet.GetCellValue(Row, "gmeasureNm")};
		
		var layer = new window.top.document.LayerModal({
	      		id : 'competencyMgrLayer'
	          , url : url
	          , parameters: p
	          , width : w
	          , height : h
	          , title : "<tit:txt mid='competencyMgrDetail' mdef='역량사전 세부내역'/>"
	      });
  		layer.show();
	}
</script>


</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
        <div class="modal_body">
			<form id="competencySheetForm" name="competencySheetForm" tabindex="1">
				<div class="sheet_search outer">
					<table>
						<tr>
							<th><tit:txt mid='104352' mdef='기준일자'/></th>
							<td>
								<input type="text" id="searchSdate" name="searchSdate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
							</td>
							<th><tit:txt mid='112683' mdef='역량명'/></th>
							<td>  <input id="searchCompetencyNm" name ="searchCompetencyNm" type="text" class="text" /> </td>
							<td>
							<a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
							</td>
						</tr>
					</table>
				</div>
			</form>

			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112014' mdef='역량 리스트 조회'/></li>
						</ul>
						</div>
					</div>
					<div id="competencysheet_wrap"></div>
					<!-- <script type="text/javascript">createIBSheet("competencySheet", "100%", "100%","${ssnLocaleCd}"); </script> -->
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('competencyLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
	</div>
</body>
</html>



