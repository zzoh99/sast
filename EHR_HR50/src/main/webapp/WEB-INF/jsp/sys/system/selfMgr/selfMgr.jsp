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
            {Header:"<sht:txt mid='stdCd' mdef='기준코드'/>",	Type:"Text",     Hidden:0,  Width:100, 	Align:"Left",  	ColMerge:0,   SaveName:"stdCd",   		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='stdNm' mdef='기준코드명'/>",	Type:"Text",     Hidden:0,  Width:120,	Align:"Left",  	ColMerge:0,   SaveName:"stdNm",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='stdCdClob' mdef='기준값'/>",		Type:"Text",     Hidden:1,  Width:80,   Align:"Center", ColMerge:0,   SaveName:"stdCdClob",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10000 },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$("#searchStdCd,#searchStdNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": 	 	sheet1.DoSearch( "${ctx}/SelfMgr.do?cmd=getSelfMgrList", $("#srchFrm").serialize() ); break;
			case "Save":
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/SelfMgr.do?cmd=saveSelfMgr", $("#srchFrm").serialize()); break;
			case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "stdCd"); break;
			case "Copy":		sheet1.DataCopy(); break;
			case "Clear":		sheet1.RemoveAll(); break;
			case "Down2Excel":	sheet1.Down2Excel(); break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	function saveClob() {
		// IBS_SaveName(document.saveFrm, sheet1);
		// sheet1.SetCellValue(sheet1.GetSelectRow(),'stdCdClob', $('#stdCdClob').val());
		<%--sheet1.DoSave( "${ctx}/SelfMgr.do?cmd=saveSelfMgrClob", $("#saveFrm").serialize());--%>
		ajaxCall("${ctx}/SelfMgr.do?cmd=saveSelfMgrClob",$("#saveFrm").serialize(),false);
		doAction1("Search");
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

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {

		$('#stdCd').val(sheet1.GetCellValue(NewRow,"stdCd"));
		$('#stdCdClob').val(sheet1.GetCellValue(NewRow,"stdCdClob").replace(/，/g, ","));
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
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='selfMgr' mdef='시스템사용기준관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
			</td>
			<td class="sheet_right">
				<div class="content">
					<div class="sheet_title">
						<ul>
							<li class="txt">기준값</li>
							<li class="btn">
								<btn:a href="javascript:saveClob();" css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sheet_left">
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
				<form id="saveFrm" name="saveFrm">
					<div class="ibsheet" fixed="false" sheet_count="1" realHeight="100">
						<input type="hidden" id="stdCd" name="stdCd" value="" />
						<textarea id="stdCdClob" name="stdCdClob" class="w100p" style="height:92%;"></textarea>
					</div>
				</form>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
