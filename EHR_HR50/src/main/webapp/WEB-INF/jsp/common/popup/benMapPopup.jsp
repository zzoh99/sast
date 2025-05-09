<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114484' mdef='조직맵핑구분조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 조직맵핑구분조회
 * @author JM
-->
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [		    
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='mapTypeCd_V5064' mdef='조직매핑구분'/>",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"mapTypeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='mapCd' mdef='조직맵핑코드'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"mapCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='mapCdV2' mdef='조직맵핑명'/>",	Type:"Text",		Hidden:0,					Width:200,			Align:"Left",	ColMerge:0,	SaveName:"mapNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 조직매핑구분코드(W20020)
	var mapTypeCd = convCode(codeList("/CommonCode.do?cmd=getCommonCodeList", "W20020"), "");
	sheet1.SetColProperty("mapTypeCd", {ComboText:mapTypeCd[0], ComboCode:mapTypeCd[1]});

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 조직매핑구분코드(W20020)
	var mapTypeCd = convCode(codeList("/CommonCode.do?cmd=getCommonCodeList", "W20020"), "<tit:txt mid='103895' mdef='전체'/>");
	$("#mapTypeCd").html(mapTypeCd[2]);

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#mapNm").bind("keyup", function(event) {
		if(event.keyCode == 13) {
			doAction1("Search");
		}
	});

	$(".close").click(function() {
		p.self.close();
	});

	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("/BenComPopup.do?cmd=getBenMapComPopupList", $("#sheet1Form").serialize());
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); sheet1.FocusAfterProcess = false; } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function sheet1_OnDblClick(Row, Col) {
	try{
		returnFindData(Row, Col);
	}catch(ex) {alert("OnDblClick Event Error : " + ex);}
}

function returnFindData(Row, Col) {
	if(sheet1.GetCellValue(1, 0) == undefined) {
		return;
	}
	if(sheet1.RowCount() <= 0) {
	  return;
	}

	var returnValue = new Array(5);
	returnValue["mapTypeCd"]= sheet1.GetCellValue(Row, "mapTypeCd");
	returnValue["mapCd"]	= sheet1.GetCellValue(Row, "mapCd");
	returnValue["mapNm"]	= sheet1.GetCellValue(Row, "mapNm");

	p.window.returnValue = returnValue;
	p.window.close();
}
</script>
</head>
<body class="hidden bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='114484' mdef='조직맵핑구분조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<form id="sheet1Form" name="sheet1Form">
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='112959' mdef='맵핑구분'/></th>
						<td>  <select id="mapTypeCd" name="mapTypeCd"> </select> </td>
						<th><tit:txt mid='112013' mdef='맵핑명'/></th>
						<td>  <input type="text" id="mapNm" name="mapNm" class="text" value="" style="ime-mode:active" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
							<li id="txt" class="txt"><tit:txt mid='114484' mdef='조직맵핑구분조회'/></li>
						</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
