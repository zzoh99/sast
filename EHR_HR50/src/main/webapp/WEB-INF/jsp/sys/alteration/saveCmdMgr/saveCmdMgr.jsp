<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>저장기능관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
			  		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
					{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
					
					{Header:"CMD",		Type:"Text",		Hidden:0,	Width:140,	Align:"Left",   ColMerge:0,   SaveName:"cmdData",		KeyField:1,   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"저장테이블",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMerge:0,   SaveName:"tableName",		KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"PK체크",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0,   SaveName:"dupCheck",		KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
					{Header:"비고",		Type:"Text",		Hidden:0,	Width:300,	Align:"Left",   ColMerge:0,   SaveName:"note",			KeyField:0,   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:300 },
			]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

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
		case "Search":	
			sheet1.DoSearch( "${ctx}/SaveCmdMgr.do?cmd=getSaveCmdMgrList", $("#sheet1Form").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"cmdData", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/SaveCmdMgr.do?cmd=saveSaveCmdMgr", $("#sheet1Form").serialize() );
			break;

		case "Insert"		:	var row = sheet1.DataInsert(0); sheet1.SetCellValue(row, "dupCheck", "Y");break;
		case "Copy"			:	sheet1.SelectCell(sheet1.DataCopy(), "col1"); break;
		case "Clear"		:	sheet1.RemoveAll(); break;
		case "Down2Excel"	:	sheet1.Down2Excel(); break;
		case "LoadExcel"	:	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 )  doAction("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<table>
			<tr>
				<th>CMD</th>
				<td>
					<input id="searchCmd" name ="searchCmd" type="text" class="text" />
				</td>
				<th>저장테이블</th>
				<td>
					<input id="searchTableName" name ="searchTableName" type="text" class="text" />
				</td>
				<td>
					<btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
				</td>
			</tr>
			</table>
			
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">저장기능관리</li>
				<li class="btn">
					<btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doAction('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
