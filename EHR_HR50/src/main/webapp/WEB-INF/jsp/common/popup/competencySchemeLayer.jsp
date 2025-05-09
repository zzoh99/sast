<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112364' mdef='역량분류표 조회'/></title>
<script type="text/javascript">
	$(function() {

		const modal = window.top.document.LayerModalUtility.getModal('competencySchemeLayer');
		createIBSheet3(document.getElementById('competencySchemeLayerSht1-wrap'), "competencySchemeLayerSht1", "100%", "100%", "${ssnLocaleCd}");

		// 2020.07.16 추가 : 역량분류(competencyType)가  역량(C)만 선택하도록..
		var selectType = "";
		var arg = modal.parameters;
		selectType = arg.selectType;
		
		$("#selectType").val(selectType);
		
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:6, DataRowMerge:0, ChildPage:5};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },

				{Header:"<sht:txt mid='detailV4' mdef='역량\n사전'/>",		Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
				{Header:"<sht:txt mid='priorCompetencyCd' mdef='역량상위코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"priorCompetencyCd", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"competencyCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='competencyNm' mdef='역량명'/>",			Type:"Popup",     Hidden:0,  Width:200,  Align:"Left",    	ColMerge:0,   SaveName:"competencyNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,	TreeCol:1,  LevelSaveName:"sLevel" },
	            {Header:"<sht:txt mid='competencyType' mdef='역량분류'/>",		Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",    ColMerge:0,   SaveName:"competencyType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='memoV12' mdef='개요'/>",			Type:"Text",      Hidden:1,  Width:0,  	 Align:"Left",    	ColMerge:0,   SaveName:"memo",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
	            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  	ColMerge:0,   SaveName:"sdate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  	ColMerge:0,   SaveName:"edate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='comGubunCd' mdef='역량구분'/>",  		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"mainAppType",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='competencyCdV1' mdef='척도코드'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureCd",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"<sht:txt mid='gmeasureNm' mdef='척도코드명'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>", 			Type:"Int",  	  Hidden:1,  Width:0,    Align:"Center",  	ColMerge:0,   SaveName:"seq",     			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:3 },
	            {Header:"",	Type:"Text", Hidden:1, SaveName:"priorCompetencyNm"},
				
		];
		IBS_InitSheet(competencySchemeLayerSht1, initdata);competencySchemeLayerSht1.SetVisible(true);competencySchemeLayerSht1.SetCountPosition(4);competencySchemeLayerSht1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분

		competencySchemeLayerSht1.SetColProperty("competencyType", 		{ComboText:"역량군|역량", ComboCode:"A|C"} );	//역량분류
		competencySchemeLayerSht1.SetColProperty("mainAppType", 			{ComboText:mainAppType[0], ComboCode:mainAppType[1]} );	//역량구분

	    $(window).smartresize(sheetResize); sheetInit();
	    $("#searchSdate").datepicker2();

        $("#searchSdate,#searchCompetencyNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        });

    	// 트리레벨 정의
    	$("#btnStep1").click(function()	{
			competencySchemeLayerSht1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			competencySchemeLayerSht1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			competencySchemeLayerSht1.ShowTreeLevel(-1);
		});
		$("#btnPlus").click(function() {
			$(this).toggleClass("minus");
			$(this).hasClass("minus")?$("#btnStep3").click():$("#btnStep1").click();
		});

	    doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			competencySchemeLayerSht1.DoSearch( "${ctx}/Popup.do?cmd=getCompetencySchemePopupList", $("#competencySchemeLayerSht1Form").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function competencySchemeLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			competencySchemeLayerSht1.SetRowEditable(1, false);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function competencySchemeLayerSht1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && competencySchemeLayerSht1.ColSaveName(Col) == "detail"){
		    	competencyMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 역량사전 window open event
	 */
	function competencyMgrPopup(Row){
		if(!isPopup()) {return;}

  		var w 		= 1024;
		var h 		= 720;
		var url 	= "${ctx}/CompetencySchemeMgr.do?cmd=viewCompetencyMgrLayer&authPg=R";
		const p = {
			competencyCd 	: competencySchemeLayerSht1.GetCellValue(Row, "competencyCd"),
			competencyNm 	: competencySchemeLayerSht1.GetCellValue(Row, "competencyNm"),
			competencyType 	: competencySchemeLayerSht1.GetCellValue(Row, "competencyType"),
			mainAppType 	: competencySchemeLayerSht1.GetCellValue(Row, "mainAppType"),
			sdate 			: competencySchemeLayerSht1.GetCellValue(Row, "sdate"),
			edate 			: competencySchemeLayerSht1.GetCellValue(Row, "edate"),
			memo 			: competencySchemeLayerSht1.GetCellValue(Row, "memo"),
			gmeasureCd 		: competencySchemeLayerSht1.GetCellValue(Row, "gmeasureCd"),
			gmeasureNm 		: competencySchemeLayerSht1.GetCellValue(Row, "gmeasureNm")
		};

		var competencyMgrLayer = new window.top.document.LayerModal({
			id : 'competencyMgrLayer'
			, url : url
			, parameters: p
			, width : w
			, height : h
			, title : "<tit:txt mid='competencyMgrDetail' mdef='역량사전 세부내역'/>"
			, trigger :[
				{
					name : 'competencyMgrLayerTrigger'
					, callback : function(rv){
					}
				}
			]
		});
		competencyMgrLayer.show();

	}

	function competencySchemeLayerSht1_OnDblClick(Row, Col){
		if( Row == 1 ) {
			alert("역량분류표는 선택할 수 없습니다.");
			return;
		}
		//2020.07.16
		if( $("#selectType").val() != "" && competencySchemeLayerSht1.GetCellValue(Row, "competencyType") != $("#selectType").val() ){
			var str = ( $("#selectType").val() == "A" )?"역량군":"역량";
			alert(str+"만 선택 할 수 있습니다.");
			return;
		}
		var rv = new Array(8);
		rv["priorCompetencyCd"] = competencySchemeLayerSht1.GetCellValue(Row, "priorCompetencyCd");
		rv["priorCompetencyNm"] = competencySchemeLayerSht1.GetCellValue(Row, "priorCompetencyNm"); //2020.07.16 추가
		
		rv["competencyCd"] 		= competencySchemeLayerSht1.GetCellValue(Row, "competencyCd");
		rv["competencyNm"]		= competencySchemeLayerSht1.GetCellValue(Row, "competencyNm");

		rv["competencyType"]	= competencySchemeLayerSht1.GetCellValue(Row, "competencyType");
		rv["sdate"]				= competencySchemeLayerSht1.GetCellValue(Row, "sdate");
		rv["edate"]				= competencySchemeLayerSht1.GetCellValue(Row, "edate");

		rv["memo"]				= competencySchemeLayerSht1.GetCellValue(Row, "memo");
		rv["mainAppType"]		= competencySchemeLayerSht1.GetCellValue(Row, "mainAppType");

		const modal = window.top.document.LayerModalUtility.getModal('competencySchemeLayer');
		modal.fire('competencySchemeLayerTrigger', rv).hide();
	}
</script>


</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
        <div class="modal_body">
			<form id="competencySchemeLayerSht1Form" name="competencySchemeLayerSht1Form" tabindex="1">
				<input type="hidden" id="selectType" name="selectType" /> <!-- 2020.07.16 추가 -->
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='104352' mdef='기준일자'/></th>
						   <td>
								<input type="text" id="searchSdate" name="searchSdate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						   </td>
						   <td>
							<a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
								<li id="txt" class="txt">역량분류표 조회&nbsp;
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
					<div id="competencySchemeLayerSht1-wrap"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('competencySchemeLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
</div>
</body>
</html>



