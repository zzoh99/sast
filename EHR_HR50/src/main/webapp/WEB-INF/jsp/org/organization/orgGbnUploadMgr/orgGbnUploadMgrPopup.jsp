<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='orgMapItemMgr' mdef='조직구분항목'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"Seq",       Hidden:0,  Width:40,  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"DelCheck",  Hidden:1,  Width:40,	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",			Type:"Result",    Hidden:1,  Width:40,	Align:"Center",  ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"Status",    Hidden:1,  Width:40,	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='mapTypeCd' mdef='조직맵핑구분'/>",	Type:"Combo",     Hidden:0,  Width:150, Align:"Center",  ColMerge:0,   SaveName:"mapTypeCd",  keyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='mapCd' mdef='조직맵핑코드'/>",	Type:"Text",      Hidden:1,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"mapCd",       keyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='mapCdV2' mdef='조직맵핑명'/>",		Type:"Text",      Hidden:0,  Width:205, Align:"Left",    ColMerge:0,   SaveName:"mapNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='erpEmpCd' mdef='ERP사원구분'/>",	Type:"Combo",     Hidden:1,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"erpEmpCd",   keyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",      Hidden:0,  Width:100, Align:"Left",    ColMerge:0,   SaveName:"note",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4);


		var W20020 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20020"), "<tit:txt mid='103895' mdef='전체'/>");
		var C14050 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C14050"), "<tit:txt mid='103895' mdef='전체'/>");

// 		var W20020 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20020"), "<tit:txt mid='103895' mdef='전체'/>", 2);
// 		var C14050 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C14050"), "<tit:txt mid='103895' mdef='전체'/>", 2);

		mySheet.SetColProperty("mapTypeCd", {ComboText:W20020[0], ComboCode:W20020[1]} );
		mySheet.SetColProperty("erpEmpCd", {ComboText:C14050[0], ComboCode:C14050[1]} );
	  	$("#searchMapTypeCd").html(W20020[2]);


		$("#col1,#col2,#col3,#col4").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");


		$(".sheet_search>div>table>tr input[type=text],select").each(function(){

//alert($(this).attr("id")+"  "+$.type($(this)) );
		});
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	mySheet.DoSearch( "${ctx}/OrgMappingItemMngr.do?cmd=getOrgMappingItemMngrList", $("#mySheetForm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.mySheetForm,mySheet);
							mySheet.DoSave( "${ctx}/OrgMappingItemMngr.do?cmd=saveOrgMappingItemMngr", $("#mySheetForm").serialize()); break;
		case "Insert":		mySheet.SelectCell(mySheet.DataInsert(0), "column1"); break;
		case "Copy":		mySheet.SelectCell(mySheet.DataCopy(), "column1"); break;
		case "Clear":		mySheet.RemoveAll(); break;
		case "Down2Excel":	mySheet.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; mySheet.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function mySheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			returnMappingValue(Row,Col);
		}catch(ex){alert("OnDblClick Event Error : " + ex);}
	}

	function returnMappingValue(Row,Col){

    	var returnValue = new Array(5);

    	returnValue["mapTypeCd"] 	= mySheet.GetCellValue(Row, "mapTypeCd");
 		returnValue["mapCd"] 		= mySheet.GetCellValue(Row, "mapCd");
 		returnValue["mapNm"] 		= mySheet.GetCellValue(Row, "mapNm");
 		returnValue["erpEmpCd"] 	= mySheet.GetCellValue(Row, "erpEmpCd");
 		returnValue["note"] 		= mySheet.GetCellValue(Row, "note");

		p.popReturnValue(returnValue);
		p.self.close();;
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114510' mdef='조직맵핑구분 '/></th>
						<td>  <SELECT id="searchMapTypeCd" name="searchMapTypeCd"></SELECT></td>
						<th><tit:txt mid='113436' mdef='조직맵핑명 '/></th>
						<td>  <input id="searchMapNm" name ="searchMapNm" type="text" class="text" /> </td>
						<td> <a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
							<li id="txt" class="txt"><tit:txt mid='orgMapItemMgr' mdef='조직구분항목'/></li>
							<li class="btn">
								<a href="javascript:doAction('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction('Copy')" 	class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
