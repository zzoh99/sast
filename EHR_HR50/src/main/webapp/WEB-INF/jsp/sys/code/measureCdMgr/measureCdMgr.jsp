<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",     Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"detail", 		   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
            {Header:"<sht:txt mid='competencyCdV1' mdef='척도코드'/>",	Type:"Text",      Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"gmeasureCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='gmeasureNmV1' mdef='척도명'/>",		Type:"Text",      Hidden:0,  Width:150,  	Align:"Left",    ColMerge:0,   SaveName:"gmeasureNm",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
            {Header:"<sht:txt mid='typeV1' mdef='척도구분'/>",	Type:"Combo",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"type",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='gmeasureType' mdef='척도유형'/>",	Type:"Combo",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"gmeasureType",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='levelType' mdef='범위유형'/>",	Type:"Combo",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"levelType",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='commonYnV1' mdef='공통척도'/>",	Type:"CheckBox",  Hidden:0,  Width:50,    	Align:"Center",  ColMerge:0,   SaveName:"commonYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1,	TrueValue:"Y", FalseValue:"N" },
            {Header:"<sht:txt mid='memoV14' mdef='척도개요'/>", 	Type:"Text",      Hidden:0,  Width:200,  	Align:"Left",    ColMerge:0,   SaveName:"memo",           	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000,	MultiLineText:1 },
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>", 		Type:"Int",  	  Hidden:0,  Width:50,   	Align:"Center",  ColMerge:0,   SaveName:"orderSeq",     	KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


		var gmeasureType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20030"), "");	//척도유형
		var levelType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20050"), "");	//척도범위유형

		sheet1.SetColProperty("type", {ComboText:"정성|정량", ComboCode:"A|C"} );	//척도구분
		sheet1.SetColProperty("gmeasureType", 			{ComboText:gmeasureType[0], ComboCode:gmeasureType[1]} );	//척도유형
		sheet1.SetColProperty("levelType", 			{ComboText:levelType[0], ComboCode:levelType[1]} );	//척도범위유형

		$("#searchGmeasureNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/MeasureCdMgr.do?cmd=getMeasureCdMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		if(!dupChk(sheet1,"gmeasureCd", true, true)){break;}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/MeasureCdMgr.do?cmd=saveMeasureCdMgr", $("#srchFrm").serialize() );
							doAction1("Search");break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "gmeasureCd"); break;
		case "Copy":
			var Row = sheet1.DataCopy();
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
		    	measureCdMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function measureCdMgrPopup(Row){
  		var w 		= 940;
		var h 		= 720;
		var url 	= "${ctx}/MeasureCdMgr.do?cmd=viewMeasureCdMgrLayer&authPg=${authPg}";
		const p = {gmeasureCd 		: sheet1.GetCellValue(Row, "gmeasureCd"),
				gmeasureNm 		: sheet1.GetCellValue(Row, "gmeasureNm"),
				type 			: sheet1.GetCellValue(Row, "type"),
				gmeasureType 	: sheet1.GetCellValue(Row, "gmeasureType"),
				levelType 		: sheet1.GetCellValue(Row, "levelType"),
				memo 			: sheet1.GetCellValue(Row, "memo"),
				commonYn 		: sheet1.GetCellValue(Row, "commonYn"),
				orderSeq 		: sheet1.GetCellValue(Row, "orderSeq")};
		var layer = new window.top.document.LayerModal({
	      		id : 'measureCdMgrLayer'
	          , url : url
	          , parameters: p
	          , width : w
	          , height : h
	          , title : "<tit:txt mid='measureCdMgr' mdef='척도관리 세부내역'/>"
	          , trigger :[
	              {
	                    name : 'measureCdMgrLayerTrigger'
	                  , callback : function(rv){
	                	  	sheet1.SetCellValue(Row, "gmeasureCd", 	rv["gmeasureCd"] );
		          			sheet1.SetCellValue(Row, "gmeasureNm", 	rv["gmeasureNm"] );
		          			sheet1.SetCellValue(Row, "type", 		rv["type"] );
		          			sheet1.SetCellValue(Row, "gmeasureType",rv["gmeasureType"] );
		          			sheet1.SetCellValue(Row, "levelType", 	rv["levelType"] );
		          			sheet1.SetCellValue(Row, "memo", 		rv["memo"] );
		          			sheet1.SetCellValue(Row, "commonYn", 	rv["commonYn"] );
		          			sheet1.SetCellValue(Row, "orderSeq", 	rv["orderSeq"] );
	                  }
	              }
	          ]
	      });
	  	layer.show();
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
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
						<th><tit:txt mid='112706' mdef='척도명 '/></th>
						<td>  <input id="searchGmeasureNm" name ="searchGmeasureNm" type="text" class="text" /> </td>
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
							<li id="txt" class="txt"><tit:txt mid='measureMgr' mdef='척도관리'/></li>
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
