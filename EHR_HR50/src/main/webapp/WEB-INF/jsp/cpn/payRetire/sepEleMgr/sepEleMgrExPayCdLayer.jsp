<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='sepEleMgrExPayCdPopup' mdef='제외급여코드'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%--<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>--%>

<!--
 * 퇴직금항목관리
 * @author JM
-->
<script type="text/javascript">
var args = new Array();
var changeYn = "N";
<%--var p = eval("${popUpStatus}");--%>
$(function() {

	createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");

	const modal = window.top.document.LayerModalUtility.getModal('sepElePayLayer');
	let elementCd = modal.parameters.elementCd || '';
	
	$("#elementCd").val(elementCd);

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",	Type:"Text",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"elementCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payActionCdV4' mdef='급여코드'/>",	Type:"Combo",		Hidden:0,					Width:150,			Align:"Center",	ColMerge:0,	SaveName:"payCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 급여구분코드(TCPN051)
	var tcpn051Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnPayCdList", false).codeList, "");
	sheet1.SetColProperty("payCd", {ComboText:"|"+tcpn051Cd[0], ComboCode:"|"+tcpn051Cd[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/SepEleMgr.do?cmd=getSepEleMgrExPayCdList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if(!dupChk(sheet1, "elementCd|payCd", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepEleMgr.do?cmd=saveSepEleMgrExPayCd", $("#sheet1Form").serialize());

			changeYn = "Y";
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "elementCd", $("#elementCd").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function pClose() {
	const modal = window.top.document.LayerModalUtility.getModal('sepElePayLayer');
	modal.fire('sepElePayTrigger', {
		changeYn : changeYn
	}).hide();
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheet1Form" name="sheet1Form">
			<input type="hidden" id="elementCd" name="elementCd" value="" />
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td class="top">
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='114598' mdef='제외급여코드 '/></li>
								<li class="btn">
									<a href="javascript:doAction1('Search')"		class="button authR"><tit:txt mid='104081' mdef='조회'/></a>
									<a href="javascript:doAction1('Insert')"		class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
									<a href="javascript:doAction1('Copy')"			class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
									<a href="javascript:doAction1('Save')"			class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
<%--									<a href="javascript:doAction1('Down2Excel')"	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>--%>
								</li>
							</ul>
						</div>
					</div>
					<div id="sheet1-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<ul>
			<li>
				<a href="javascript:pClose();" class="basic large"><tit:txt mid='104157' mdef='닫기'/></a>
			</li>
		</ul>
	</div>
</div>
</body>
</html>
