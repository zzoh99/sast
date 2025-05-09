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
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",    Hidden:0,  Width:10,   Align:"Center", ColMerge:0,   SaveName:"detail", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"Pointer" },
            {Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",	Type:"Combo",    Hidden:0,  Width:25,   Align:"Center", ColMerge:0,   SaveName:"bizCd",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='stdCd' mdef='기준코드'/>",	Type:"Text",     Hidden:0,  Width:100, 	Align:"Left",  	ColMerge:0,   SaveName:"stdCd",   		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='stdNm' mdef='기준코드명'/>",	Type:"Text",     Hidden:0,  Width:120,	Align:"Left",  	ColMerge:0,   SaveName:"stdNm",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='description' mdef='설명'/>",		Type:"Text",     Hidden:0,  Width:170,   Align:"Left", ColMerge:0,   SaveName:"stdCdDesc", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='dataTypeV1' mdef='데이터타입'/>",	Type:"Combo",    Hidden:0,  Width:30, 	Align:"Center", ColMerge:0,   SaveName:"dataType",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='stdCdValue' mdef='기준값'/>",		Type:"Text",     Hidden:0,  Width:80,   Align:"Center", ColMerge:0,   SaveName:"stdCdValue",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var dataType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00025"), "");	//DATA_TYPE
		//var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "<tit:txt mid='103895' mdef='전체'/>");	//업무구분
		var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");

		sheet1.SetColProperty("dataType", 			{ComboText:dataType[0], ComboCode:dataType[1]} ) ;
		sheet1.SetColProperty("bizCd", 			{ComboText:bizCd[0], ComboCode:bizCd[1]} ) ;

		$("#searchBizCd").html(bizCd[2]);

		$("#searchStdCd,#searchStdNm").bind("keyup",function(event){
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
		case "Search": 	 	sheet1.DoSearch( "${ctx}/SysUsingMgr.do?cmd=getSysUsingMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/SysUsingMgr.do?cmd=saveSysUsingMgr", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "stdCd"); break;
		case "Copy":		sheet1.DataCopy(); break;
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
		    	sysUsingMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function sysUsingMgrPopup(Row){
		if(!isPopup()) {return;}
		var title = "<tit:txt mid='sysUsingMgrPop' mdef='시스템사용기준관리 세부내역'/>";
  		var w 		= 640;
		var h 		= 530;
		var url 	= "${ctx}/SysUsingMgr.do?cmd=viewSysUsingMgrLayer&authPg=${authPg}";
		var p = {stdCd 	: sheet1.GetCellValue(Row, "stdCd"),
				 stdNm 	: sheet1.GetCellValue(Row, "stdNm"),
				 stdCdDesc : sheet1.GetCellValue(Row, "stdCdDesc"),
				 dataType 	: sheet1.GetCellValue(Row, "dataType"),
				 stdCdValue 	: sheet1.GetCellValue(Row, "stdCdValue"),
				 bizCd 		: sheet1.GetCellValue(Row, "bizCd"),
				 sysYn 		: sheet1.GetCellValue(Row, "sysYn")};

		var layerModal = new window.top.document.LayerModal({
			  id : 'sysUsingMgrLayer', 
			  url : url,
			  parameters: p,
			  width : w, 
			  height : h,
			  title : title,
			  trigger: [
				  {
					  name: 'sysUsingMgrLayerTrigger',
					  callback: function(rv) {
						  sheet1.SetCellValue(Row, "stdCd", 	rv["stdCd"] );
						  sheet1.SetCellValue(Row, "stdNm", 	rv["stdNm"] );
						  sheet1.SetCellValue(Row, "stdCdDesc", rv["stdCdDesc"] );
						  sheet1.SetCellValue(Row, "dataType", 	rv["dataType"] );
						  sheet1.SetCellValue(Row, "stdCdValue", 	rv["stdCdValue"] );
						  sheet1.SetCellValue(Row, "bizCd", 		rv["bizCd"] );
						  sheet1.SetCellValue(Row, "sysYn", 		rv["sysYn"] );
					  }
				  }
			  ]
		});
		layerModal.show();
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "sysUsingMgrPopup"){
			sheet1.SetCellValue(gPRow, "stdCd", 	rv["stdCd"] );
			sheet1.SetCellValue(gPRow, "stdNm", 	rv["stdNm"] );
			sheet1.SetCellValue(gPRow, "stdCdDesc", rv["stdCdDesc"] );
			sheet1.SetCellValue(gPRow, "dataType", 	rv["dataType"] );
			sheet1.SetCellValue(gPRow, "stdCdValue", 	rv["stdCdValue"] );
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
						<th><tit:txt mid='114700' mdef='기준코드 '/></th>
					    <td>  <input id="searchStdCd" name ="searchStdCd" type="text" class="text" style="ime-mode:inactive;"/> </td>
					    <th><tit:txt mid='114310' mdef='기준코드명 '/></th>
						<td>  <input id="searchStdNm" name ="searchStdNm" type="text" class="text" style="ime-mode:active;"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='sysUsingMgr' mdef='시스템사용기준관리'/></li>
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
