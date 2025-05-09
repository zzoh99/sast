<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",		Type:"Image",    Hidden:0,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"detail", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"Pointer" },
            {Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",		Type:"Combo",    Hidden:0,  Width:80,   Align:"Center", ColMerge:0,   SaveName:"bizCd",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",			Type:"Text",     Hidden:0,  Width:80, 	Align:"Left",  	ColMerge:0,   SaveName:"dbItemCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='dbItemNm' mdef='ITEM명'/>",		Type:"Text",     Hidden:0,  Width:100,	Align:"Left",  	ColMerge:0,   SaveName:"dbItemNm",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='description' mdef='설명'/>",			Type:"Text",     Hidden:1,  Width:200,  Align:"Left", 	ColMerge:0,   SaveName:"description", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='dataTypeV1' mdef='데이터타입'/>",		Type:"Combo",    Hidden:0,  Width:60, 	Align:"Center", ColMerge:0,   SaveName:"dataType",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='sqlSyntaxV2' mdef='SQL구문'/>",		Type:"Text",     Hidden:0,  Width:300,  Align:"Left", 	ColMerge:0,   SaveName:"sqlSyntax",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000,	MultiLineText:1 },
            {Header:"<sht:txt mid='sysYn' mdef='시스템\n자료여부'/>",	Type:"Combo",    Hidden:1,  Width:0, 	Align:"Center", ColMerge:0,   SaveName:"sysYn",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var dataType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00025"), "");	//DATA_TYPE
		//var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "<tit:txt mid='103895' mdef='전체'/>");	//업무구분
		var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");

		sheet1.SetColProperty("dataType", 			{ComboText:dataType[0], ComboCode:dataType[1]} ) ;
		sheet1.SetColProperty("bizCd", 			{ComboText:bizCd[0], ComboCode:bizCd[1]} ) ;

		$("#searchBizCd").html(bizCd[2]);

		$("#searchDbItemNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchBizCd").change(function(){
			doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/DbItemMgr.do?cmd=getDbItemMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/DbItemMgr.do?cmd=saveDbItemMgr", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "dbItemCd"); break;
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
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
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
		    	dbItemMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function dbItemMgrPopup(Row){
		let layerModal = new window.top.document.LayerModal({
			id : 'dbItemLayer'
			, url : '${ctx}/DbItemMgr.do?cmd=viewDbItemMgrLayer&authPg=${authPg}'
			, parameters : {
				dbItemCd : sheet1.GetCellValue(Row, "dbItemCd")
				, dbItemNm : sheet1.GetCellValue(Row, "dbItemNm")
				, description : sheet1.GetCellValue(Row, "description")
				, dataType : sheet1.GetCellValue(Row, "dataType")
				, sqlSyntax : sheet1.GetCellValue(Row, "sqlSyntax")
				, bizCd : sheet1.GetCellValue(Row, "bizCd")
				, sysYn : sheet1.GetCellValue(Row, "sysYn")
			}
			, width : 640
			, height : 840
			, title : '<tit:txt mid='dbItemMgrPop' mdef='DB Item관리 세부내역'/>'
			, trigger :[
				{
					name : 'dbItemTrigger'
					, callback : function(result){
						sheet1.SetCellValue(Row, "dbItemCd", 	result.dbItemCd);
						sheet1.SetCellValue(Row, "dbItemNm", 	result.dbItemNm);
						sheet1.SetCellValue(Row, "description", result.description);
						sheet1.SetCellValue(Row, "dataType", 	result.dataType);
						sheet1.SetCellValue(Row, "sqlSyntax", 	result.sqlSyntax);
						sheet1.SetCellValue(Row, "bizCd", 		result.bizCd);
						sheet1.SetCellValue(Row, "sysYn", 		result.sysYn);
					}
				}
			]
		});
		layerModal.show();


		<%--if(!isPopup()) {return;}--%>
		<%--gPRow = Row;--%>
		<%--pGubun = "dbItemMgrPopup";--%>

  		<%--var w 		= 640;--%>
		<%--var h 		= 740;--%>
		<%--var url 	= "${ctx}/DbItemMgr.do?cmd=viewDbItemMgrPopup&authPg=${authPg}";--%>
		<%--var args 	= new Array();--%>
		<%--args["dbItemCd"] 	= sheet1.GetCellValue(Row, "dbItemCd");--%>
		<%--args["dbItemNm"] 	= sheet1.GetCellValue(Row, "dbItemNm");--%>
		<%--args["description"] = sheet1.GetCellValue(Row, "description");--%>
		<%--args["dataType"] 	= sheet1.GetCellValue(Row, "dataType");--%>
		<%--args["sqlSyntax"] 	= sheet1.GetCellValue(Row, "sqlSyntax");--%>
		<%--args["bizCd"] 		= sheet1.GetCellValue(Row, "bizCd");--%>
		<%--args["sysYn"] 		= sheet1.GetCellValue(Row, "sysYn");--%>

		<%--var rv = openPopup(url,args,w,h);--%>
		/*
		if(rv!=null){
			sheet1.SetCellValue(Row, "dbItemCd", 	rv["dbItemCd"] );
			sheet1.SetCellValue(Row, "dbItemNm", 	rv["dbItemNm"] );
			sheet1.SetCellValue(Row, "description", rv["description"] );
			sheet1.SetCellValue(Row, "dataType", 	rv["dataType"] );
			sheet1.SetCellValue(Row, "sqlSyntax", 	rv["sqlSyntax"] );
			sheet1.SetCellValue(Row, "bizCd", 		rv["bizCd"] );
			sheet1.SetCellValue(Row, "sysYn", 		rv["sysYn"] );
		}
		*/
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "dbItemMgrPopup"){
			sheet1.SetCellValue(gPRow, "dbItemCd", 	rv["dbItemCd"] );
			sheet1.SetCellValue(gPRow, "dbItemNm", 	rv["dbItemNm"] );
			sheet1.SetCellValue(gPRow, "description", rv["description"] );
			sheet1.SetCellValue(gPRow, "dataType", 	rv["dataType"] );
			sheet1.SetCellValue(gPRow, "sqlSyntax", 	rv["sqlSyntax"] );
			sheet1.SetCellValue(gPRow, "bizCd", 		rv["bizCd"] );
			sheet1.SetCellValue(gPRow, "sysYn", 		rv["sysYn"] );

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
						<th><tit:txt mid='112937' mdef='ITEM명 '/></th>
						<td>  <input id="searchDbItemNm" name ="searchDbItemNm" type="text" class="text" /> </td>
						<th><tit:txt mid='113970' mdef='업무구분 '/></th>
						<td>  <select id="searchBizCd" name="searchBizCd"> </select> </td>
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
							<li id="txt" class="txt"><tit:txt mid='dbItemMgr' mdef='DB Item관리'/></li>
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
