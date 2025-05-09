<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='prgMng' mdef='프로그램관리'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
				
				{Header:"<sht:txt mid='prgCdV2' mdef='프로그램'/>"      	,Type:"Text",	Hidden:0,	Width:140,	Align:"Left",   ColMerge:0,   SaveName:"prgCd",			KeyField:1,   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='prgNmV1' mdef='프로그램명'/>"    	,Type:"Text",	Hidden:0,	Width:135,	Align:"Left",   ColMerge:0,   SaveName:"prgNm",			KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='prgEngNmV1' mdef='프로그램영문명'/>"	,Type:"Text",	Hidden:1,	Width:100,	Align:"Left",   ColMerge:0,   SaveName:"prgEngNm",		KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='path' mdef='PATH'/>"          ,Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,   SaveName:"prgPath",		KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },	
				{Header:"<sht:txt mid='logSaveYn ' mdef='로그\n    여부'/>", 		Type:"CheckBox",  	Hidden:0, Width:40 , Align:"Center", ColMerge:0,  SaveName:"logSaveYn" ,		KeyField:0,   CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1, TrueValue:"Y", FalseValue:"N" },	
				{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",					Type:"Text",		Hidden:0,		Width:150,		Align:"Left",		ColMerge:0,		SaveName:"memo",		KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
				
				//2019 프로젝트 개선 - 하위 컬럼 사용안함. 사용할 경우 해당 프로젝트에서 확인 및 구현.
				{Header:"<sht:txt mid='version' mdef='버전'/>",					Type:"Text",		Hidden:1,		Width:50,		Align:"Center",		ColMerge:0,		SaveName:"version",		KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
				{Header:"<sht:txt mid='useYnV3' mdef='사용\n여부'/>",				Type:"CheckBox",	Hidden:1,		Width:40,		Align:"Center",		ColMerge:0,		SaveName:"use",			KeyField:0,		CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N"},	
				{Header:"<sht:txt mid='prgEngNmV1' mdef='프로그램영문명'/>",			Type:"Text",		Hidden:1,		Width:100,		Align:"Left",		ColMerge:0,		SaveName:"prgEngNm",	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
				{Header:"<sht:txt mid='dateTrackYnV1' mdef='Track'/>",				Type:"Combo",		Hidden:1,		Width:0,		Align:"Center",		ColMerge:0,		SaveName:"dateTrackYn",	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100}
				
			]; IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4);
		
			mySheet.SetColProperty("use", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
			mySheet.SetColProperty("dateTrackYn", 	{ComboText:"유|무", 	ComboCode:"Y|N"} );
			mySheet.SetColProperty("logSaveYn", 	{ComboText:"Y|N", ComboCode:"Y|N"} );
			
			$("#prgCd,#prgNm").bind("keyup",function(event){
				if( event.keyCode == 13){
					doAction("Search"); $(this).focus();
				}
			});
			$(window).smartresize(sheetResize); sheetInit();
		    doAction("Search");
	});
	
	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search"		:	mySheet.DoSearch( "${ctx}/PrgMgr.do?cmd=getPrgMgrList", $("#mySheetForm").serialize() ); break;
		case "Save"			:	
			

			// 중복체크(다수Col 은 | 로 구분 )
			if(!dupChk(mySheet,"prgCd", false, true)){break;}
			IBS_SaveName(document.mySheetForm,mySheet);
			mySheet.DoSave( "${ctx}/PrgMgr.do?cmd=savePrgMgr", $("#mySheetForm").serialize() );
			break;
			
		case "Insert"		:	mySheet.SelectCell(mySheet.DataInsert(0), "col1"); break;
		case "Copy"			:	mySheet.SelectCell(mySheet.DataCopy(), "col1"); break;
		case "Clear"		:	mySheet.RemoveAll(); break;
		case "Down2Excel"	:	mySheet.Down2Excel(); break;
		case "LoadExcel"	:	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; mySheet.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function mySheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function mySheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46
					&& mySheet.GetCellValue(Row, "sStatus") == "I") {
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
<body class="bodywrap">

<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113444' mdef='프로그램명'/></th>
						<td>
							<input id="prgNm" name ="prgNm" type="text" class="text w200"/>
						</td>
						<th><tit:txt mid='program' mdef='프로그램'/></th>
						<td>
							<input id="prgCd" name ="prgCd" type="text" class="text w200"/>
						</td>
						<th class="hide"><tit:txt mid='112334' mdef='사용유무'/></th>
						<td class="hide">
							<select id="use" name ="use">
								<option value="">전체</option>
								<option value="Y">사용</option>
								<option value="N">사용안함</option>
							</select>
						</td>
						<td>
							<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
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
							<li id="txt" class="txt"><tit:txt mid='prgMng' mdef='프로그램관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
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
