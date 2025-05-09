<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='authScopeMgr' mdef='권한범위항목관리'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>"    	, 	Type:"Image",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"detail",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>"          	, 	Type:"Text",      Hidden:0,  Width:50,   Align:"Left",    ColMerge:0,   SaveName:"authScopeCd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='authScopeNm_V1192' mdef='권한범위항목명'/>"	, 	Type:"Text",      Hidden:0,  Width:130,	 Align:"Left",    ColMerge:0,   SaveName:"authScopeNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='scopeTypeV1' mdef='범위적용구분'/>"  	, 	Type:"Combo",     Hidden:0,  Width:75,   Align:"Center",  ColMerge:0,   SaveName:"scopeType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>"   	, 	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"prgUrl",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='sqlSyntaxV2' mdef='SQL구문'/>"       	, 	Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"sqlSyntax",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='tableNm' mdef='사용테이블'/>"    	, 	Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"tableNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4);

		mySheet.SetColProperty("scopeType", {ComboText:userCd[0], ComboCode:userCd[1]} );

		var userCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","TST01"), "");

     	$("#cd").html(userCd[2]);

	//	mySheet.SetColProperty("col5", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
		//mySheet.SetColProperty("col6", 			{ComboText:userCd[0], ComboCode:userCd[1]} );

		//$("#col5").html("<option value=''>전체</option> <option value='Y'>사용</option> <option value='N'>사용안함</option>");
		//$("#col6").html(userCd[2]);

// 		$("#col1,#col2,#col3,#col4").bind("keyup",function(event){
// 			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
// 		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");

// 		<div class="sheet_search outer">
// 		<div>
// 			<table>
// 				<tr>
// 					<td>
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	mySheet.DoSearch( "${ctx}/AuthorityScope.do?cmd=getAuthorityScopeList", $("#mySheetForm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.mySheetForm,mySheet);
							mySheet.DoSave( "${ctx}/AuthorityScope.do?cmd=saveAuthorityScope", $("#mySheetForm").serialize()); break;
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

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function mySheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && mySheet.GetCellValue(Row, "sStatus") == "I") {
				mySheet.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
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
						<th><tit:txt mid='114205' mdef='항목명 '/></th>
						<td>  <input id="searchAuchScopeNm" name ="searchAuchScopeNm" type="text" class="text" /> </td>
						<th><tit:txt mid='113306' mdef='콤보 '/></th>
						<td> <select id="cd" name="cd "></select> </td>
						<td> <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='authScopeMgr' mdef='권한범위항목관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
