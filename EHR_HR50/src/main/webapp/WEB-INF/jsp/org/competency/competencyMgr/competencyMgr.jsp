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

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='temp2' mdef='세부\r\n내역'/>",		Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",		Type:"Text",      Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"competencyCd",      KeyField:1,   CalcLogic:"",   Format:"Number",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='competencyNm' mdef='역량명'/>",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    	ColMerge:0,   SaveName:"competencyNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='competencyType' mdef='역량분류'/>",		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"competencyType",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='essentialYn' mdef='필수여부'/>",		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"essentialYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='memoV12' mdef='개요'/>",			Type:"Text",      Hidden:1,  Width:0,  	 Align:"Left",    	ColMerge:0,   SaveName:"memo",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , EndDateCol:"edate"},
            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , StartDateCol:"sdate"},
            {Header:"<sht:txt mid='measureType' mdef='적용척도구분'/>", 	Type:"Combo",     Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"measureType",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='competencyCdV1' mdef='척도코드'/>", 		Type:"Combo",      Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureCd",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='gmeasureNm' mdef='척도코드명'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"gmeasureNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='comGubunCd' mdef='역량구분'/>",  		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"mainAppType",     	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='renewal' mdef='갱신주기'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"renewal",  			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='danwi' mdef='단위'/>",  			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"unit",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetColProperty("competencyType", 		{ComboText:"<tit:txt mid='20170817000001' mdef='역량군|역량'/>", ComboCode:"A|C"} );	//역량분류
		sheet1.SetColProperty("essentialYn", 			{ComboText:"|<tit:txt mid='20170817000002' mdef='필수|선택'/>", ComboCode:"|Y|N"} );	//필수여부
		sheet1.SetColProperty("measureType", 			{ComboText:"|<tit:txt mid='20170817000003' mdef='공통|기존|자체'/>", ComboCode:"|A|C|E"} );	//적용척도구분
		var gmeasureCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getCompetencyMgrGmeasureCdList",false).codeList, ""); //척도코드
		sheet1.SetColProperty("gmeasureCd", {ComboText:gmeasureCd[0], ComboCode:gmeasureCd[1]});
		
		$("#searchCompetencyCd,#searchCompetencyNm,#searchSdate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function getCommonCodeList() {
		var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007", $("#searchSdate").val()), "");	//역량구분
		sheet1.SetColProperty("mainAppType", 			{ComboText:mainAppType[0], ComboCode:mainAppType[1]} );	//역량구분
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
					var sdate = sheet1.GetCellValue(i, "sdate");
					var edate = sheet1.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
		return true;
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			sheet1.DoSearch( "${ctx}/CompetencyMgr.do?cmd=getCompetencyMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			if (!chkInVal()) {break;}
			if(!dupChk(sheet1,"competencyCd", true, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/CompetencyMgr.do?cmd=saveCompetencyMgr", $("#srchFrm").serialize() ); break;
		case "Insert":		var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
							//sheet1.SetCellValue(Row, "edate", "99991231");
							sheet1.SelectCell(Row, "competencyCd");
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
		        sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
			if( Code > -1 ) doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
		    	competencyMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function competencyMgrPopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 1020;
		var h 		= 720;
		//var url 	= "${ctx}/CompetencyMgr.do?cmd=viewCompetencyMgrLayer&authPg=${authPg}";
		var url 	= "${ctx}/CompetencyMgr.do?cmd=viewCompetencyMgrLayer&authPg=A";
		var p = {
				competencyCd:sheet1.GetCellValue(Row, "competencyCd"),
				competencyNm:sheet1.GetCellValue(Row, "competencyNm"),
				competencyType:sheet1.GetCellValue(Row, "competencyType"),
				mainAppType:sheet1.GetCellValue(Row, "mainAppType"),
				sdate		:sheet1.GetCellText(Row, "sdate"),
				edate		:sheet1.GetCellText(Row, "edate"),
				memo		:sheet1.GetCellValue(Row, "memo"),
				gmeasureCd	:sheet1.GetCellValue(Row, "gmeasureCd"),
				gmeasureNm	:sheet1.GetCellValue(Row, "gmeasureNm")
			};
		gPRow = Row;
		pGubun = "competencyMgrPopup";
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
	                	 	sheet1.SetCellValue(gPRow, "competencyCd", 	rv["competencyCd"] );
		          			sheet1.SetCellValue(gPRow, "competencyNm", 	rv["competencyNm"] );
		          			sheet1.SetCellValue(gPRow, "competencyType",rv["competencyType"] );
		          			sheet1.SetCellValue(gPRow, "mainAppType", 	rv["mainAppType"] );
		          			sheet1.SetCellValue(gPRow, "sdate", 		rv["sdate"] );
		          			sheet1.SetCellValue(gPRow, "edate", 		rv["edate"] );
		          			sheet1.SetCellValue(gPRow, "memo", 			rv["memo"] );
		          			sheet1.SetCellValue(gPRow, "gmeasureCd", 	rv["gmeasureCd"] );
		          			sheet1.SetCellValue(gPRow, "gmeasureNm", 	rv["gmeasureNm"] );
	                  }
	              }
	          ]
	      });
	  	layer.show();
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
						<th><tit:txt mid='112521' mdef='역량코드 '/> </th>
						<td>  <input id="searchCompetencyCd" name ="searchCompetencyCd" type="text" class="text" /> </td>
						<th><tit:txt mid='114672' mdef='역량명 '/> </th>
						<td>  <input id="searchCompetencyNm" name ="searchCompetencyNm" type="text" class="text" /> </td>
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
							<li id="txt" class="txt"><tit:txt mid='competencyMgr' mdef='역량사전'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
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
