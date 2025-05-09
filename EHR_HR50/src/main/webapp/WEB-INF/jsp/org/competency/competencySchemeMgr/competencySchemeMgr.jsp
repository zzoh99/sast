<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {
	$("#searchSdate").datepicker2();

	// 트리레벨 정의
	$("#btnPlus").click(function() {
		sheet1.ShowTreeLevel(-1);
	});
	$("#btnStep1").click(function()	{
		sheet1.ShowTreeLevel(0, 1);
	});
	$("#btnStep2").click(function()	{
		sheet1.ShowTreeLevel(1,2);
	});
	$("#btnStep3").click(function()	{
		sheet1.ShowTreeLevel(-1);
	});
});

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='detailV4' mdef='역량\n사전'/>",		Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='priorCompetencyCd' mdef='역량상위코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"priorCompetencyCd", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",		Type:"Text",      Hidden:1,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"competencyCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='competencyNm' mdef='역량명'/>",			Type:"Popup",     Hidden:0,  Width:200,  Align:"Left",    	ColMerge:0,   SaveName:"competencyNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100,	TreeCol:1,  LevelSaveName:"sLevel" },
            {Header:"<sht:txt mid='competencyType' mdef='역량분류'/>",		Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",    ColMerge:0,   SaveName:"competencyType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='memoV12' mdef='개요'/>",			Type:"Text",      Hidden:1,  Width:0,  	 Align:"Left",    	ColMerge:0,   SaveName:"memo",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='comGubunCd' mdef='역량구분'/>",  		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"mainAppType",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='measureType' mdef='적용척도구분'/>", 	Type:"Combo",     Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"measureType",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
            {Header:"<sht:txt mid='competencyCdV1' mdef='척도코드'/>", 		Type:"Combo",      Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureCd",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='gmeasureNm' mdef='척도코드명'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>", 			Type:"Int",  	  Hidden:0,  Width:30,   Align:"Center",  	ColMerge:0,   SaveName:"seq",     			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetColProperty("competencyType", 		{ComboText:"<tit:txt mid='20170817000001' mdef='|역량군|역량'/>", ComboCode:"|A|C"} );	//역량분류
		sheet1.SetColProperty("measureType", 			{ComboText:"|<tit:txt mid='20170817000003' mdef='공통|기존|자체'/>", ComboCode:"|A|C|E"} );	//적용척도구분
		var gmeasureCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getCompetencyMgrGmeasureCdList",false).codeList, ""); //척도코드
		sheet1.SetColProperty("gmeasureCd", {ComboText:gmeasureCd[0], ComboCode:gmeasureCd[1]});

		$("#searchSdate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function getCommonCodeList() {
		var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007", $("#searchSdate").val()), "");	//역량구분
		sheet1.SetColProperty("mainAppType", 			{ComboText:"|"+mainAppType[0], ComboCode:"|"+mainAppType[1]} );	//역량구분
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
							getCommonCodeList();
							sheet1.DoSearch( "${ctx}/CompetencySchemeMgr.do?cmd=getCompetencySchemeMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		if(!dupChk(sheet1,"competencyCd", true, true)){break;}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/CompetencySchemeMgr.do?cmd=saveCompetencySchemeMgr", $("#srchFrm").serialize() ); break;
		case "Insert":
					        if( sheet1.GetCellValue(sheet1.GetSelectRow(), "competencyCd") == "" ) {
					            alert("<msg:txt mid='109913' mdef='역량를 선택 하세요.'/>");
					            sheet1.SelectCell(sheet1.GetSelectRow(), "competencyNm");
					            return;
					        }
							var Row = sheet1.DataInsert();
							sheet1.SetCellValue(Row,"priorCompetencyCd",sheet1.GetCellValue(Row-1, "competencyCd"));
							sheet1.SelectCell(Row, "competencyNm");
							break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
				
							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 	if (Msg != "") { alert(Msg); }
				sheet1.SetRowEditable(1, false);
		        sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
			if( Code > -1 ) doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "competencyNm") {
				competencyPopup(Row) ;
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
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
		var p = {competencyCd 	: sheet1.GetCellValue(Row, "competencyCd"),
				competencyNm 	: sheet1.GetCellValue(Row, "competencyNm"),
				competencyType 	: sheet1.GetCellValue(Row, "competencyType"),
				mainAppType 	: sheet1.GetCellValue(Row, "mainAppType"),
				sdate 			: sheet1.GetCellText(Row, "sdate"),
				edate 			: sheet1.GetCellText(Row, "edate"),
				memo 			: sheet1.GetCellValue(Row, "memo"),
				gmeasureCd 		: sheet1.GetCellValue(Row, "gmeasureCd"),
				gmeasureNm 		: sheet1.GetCellValue(Row, "gmeasureNm")};
		var layer = new window.top.document.LayerModal({
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
	                	 	sheet1.SetCellValue(gPRow, "competencyCd",		rv["competencyCd"]);
	                  		sheet1.SetCellValue(gPRow, "competencyNm",		rv["competencyNm"]);
	              			sheet1.SetCellValue(gPRow, "competencyType",	rv["competencyType"]);
	              			sheet1.SetCellValue(gPRow, "memo",				rv["memo"]);
	              			sheet1.SetCellValue(gPRow, "sdate",				rv["sdate"]);
	              			sheet1.SetCellValue(gPRow, "edate",				rv["edate"]);
	              			sheet1.SetCellValue(gPRow, "mainAppType",		rv["mainAppType"]);
	                  }
	              }
	          ]
	      });
	  	layer.show();
		//openPopup(url,args,w,h);
	}

	//  역량코드 조회
	function competencyPopup(Row){
	    try{
	    	if(!isPopup()) {return;}
			var layer = new window.top.document.LayerModal({
		      		id : 'competencyLayer'
		          , url : '/Popup.do?cmd=viewCompetencyLayer&authPg=R'
		          , width : 740
		          , height : 720
		          , title : "<tit:txt mid='112014' mdef='역량 리스트 조회'/>"
		          , trigger :[
		              {
		                    name : 'competencyLayerTrigger'
		                  , callback : function(rv){
		                	  	sheet1.SetCellValue(Row, "competencyCd",		rv["competencyCd"]);
		                  		sheet1.SetCellValue(Row, "competencyNm",		rv["competencyNm"]);
		              			sheet1.SetCellValue(Row, "competencyType",	rv["competencyType"]);
		              			sheet1.SetCellValue(Row, "memo",				rv["memo"]);
		              			sheet1.SetCellValue(Row, "sdate",				rv["sdate"]);
		              			sheet1.SetCellValue(Row, "edate",				rv["edate"]);
		              			sheet1.SetCellValue(Row, "mainAppType",		rv["mainAppType"]);
		                  }
		              }
		          ]
		      });
		  	layer.show();
	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "competencyPopup"){
        	sheet1.SetCellValue(gPRow, "competencyCd",		rv["competencyCd"]);
        	sheet1.SetCellValue(gPRow, "competencyNm",		rv["competencyNm"]);

    		sheet1.SetCellValue(gPRow, "competencyType",	rv["competencyType"]);
    		sheet1.SetCellValue(gPRow, "memo",				rv["memo"]);
    		sheet1.SetCellValue(gPRow, "sdate",				rv["sdate"]);
    		sheet1.SetCellValue(gPRow, "edate",				rv["edate"]);
    		sheet1.SetCellValue(gPRow, "mainAppType",		rv["mainAppType"]);
        }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='103906' mdef='기준일자 '/> </th>
						<td>  <input id="searchSdate" name="searchSdate" type="text" size="10" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='comSchemeMgr' mdef='역량분류표'/>&nbsp;
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
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<%-- <btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/> --%>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
