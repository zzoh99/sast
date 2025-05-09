<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114387' mdef='척도관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
<style type="text/css">
</style>
<script type="text/javascript">
$(function(){
	var gmeasureType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20030"), "");	//척도유형
	var levelType 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20050"), "");	//척도범위유형
	$("#gmeasureType").html(gmeasureType[2]);
	$("#levelType").html(levelType[2]);
	var modal = window.top.document.LayerModalUtility.getModal('measureCdMgrLayer');
	var { gmeasureCd
		, gmeasureNm
		, type
		, gmeasureType
		, levelType
		, commonYn
		, memo
		, orderSeq } = modal.parameters;
	$('#modal-' + 'measureCdMgrLayer').find("#gmeasureCd").val(gmeasureCd);
	$('#modal-' + 'measureCdMgrLayer').find("#gmeasureNm").val(gmeasureNm);
	$('#modal-' + 'measureCdMgrLayer').find("#type").val(type);
	$('#modal-' + 'measureCdMgrLayer').find("#gmeasureType").val(gmeasureType);
	$('#modal-' + 'measureCdMgrLayer').find("#levelType").val(levelType);
	$('#modal-' + 'measureCdMgrLayer').find("#commonYn").val(commonYn);
	$('#modal-' + 'measureCdMgrLayer').find("#memo").val(memo);
	$('#modal-' + 'measureCdMgrLayer').find("#orderSeq").val(orderSeq);
	
	// 숫자만 입력
	$("#orderSeq").keyup(function() {
	     makeNumber(this,'A')
	 });

	createIBSheet3(document.getElementById('sheet1Layer-wrap'), "sheet1Layer", "100%", "100%", "${ssnLocaleCd}");

	init_Sheet1Layer();
	$(window).smartresize(sheetResize); sheetInit();

	doAction1("Search");
});

function setValue() {
	const p = {gmeasureCd 	: $("#gmeasureCd").val(),
			gmeasureNm	: $("#gmeasureNm").val(),
			type 	: $("#type").val(),
			gmeasureType 	: $("#gmeasureType").val(),	
			levelType		: $("#levelType").val(),
			commonYn	: $("#commonYn").val(),
			memo	: $("#memo").val(),
			orderSeq		: $("#orderSeq").val()};
	var modal = window.top.document.LayerModalUtility.getModal('measureCdMgrLayer');
	modal.fire('measureCdMgrLayer' + 'Trigger', p).hide();
}

function init_Sheet1Layer() {
	var initdata = {};
	initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"척도코드",	Type:"Text",      Hidden:1,  Width:0,    	Align:"Center",  ColMerge:0,   SaveName:"gmeasureCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		{Header:"척도레벨",	Type:"Combo",     Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"measureCd",     	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		{Header:"척도레벨명",	Type:"Text",      Hidden:1,  Width:0,  		Align:"Left",    ColMerge:0,   SaveName:"measureNm",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"점수",		Type:"Float",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"jumsu",          	KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"범위\n시작",	Type:"Float",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"sNum",  			KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"범위\n끝",	Type:"Float",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"eNum",     		KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"키워드",	Type:"Text",  	  Hidden:0,  Width:150,    	Align:"Left",  	 ColMerge:0,   SaveName:"keyWord",         	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000,	MultiLineText:1 },
		{Header:"레벨설명", 	Type:"Text",      Hidden:0,  Width:300,  	Align:"Left",    ColMerge:0,   SaveName:"memo",           	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000,	MultiLineText:1 },
		{Header:"순서", 		Type:"Int",  	  Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"seq",     			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
	]; IBS_InitSheet(sheet1Layer, initdata);sheet1Layer.SetEditable("${editable}");sheet1Layer.SetVisible(true);sheet1Layer.SetCountPosition(4);
	$(window).smartresize(sheetResize); sheetInit();
	var measureCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30100"), "");	//척도레벨
	sheet1Layer.SetColProperty("measureCd", 			{ComboText:measureCd[0], ComboCode:measureCd[1]} );	//척도레벨

	var sheetHeight = $(".modal_body").height() - $(".table").height() - $(".sheet_title").height() - 2;
	sheet1Layer.SetSheetHeight(sheetHeight);
}

//sheet1Layer Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search": 	 	sheet1Layer.DoSearch( "${ctx}/MeasureCdMgr.do?cmd=getMeasureDetailCdMgrList", $("#srchFrm").serialize() ); break;
	case "Save": 		if(!dupChk(sheet1Layer,"measureCd", true, true)){break;}
						IBS_SaveName(document.srchFrm,sheet1Layer);
						sheet1Layer.DoSave( "${ctx}/MeasureCdMgr.do?cmd=saveMeasureDetailCdMgr", $("#srchFrm").serialize() ); break;
	case "Insert":		var Row = sheet1Layer.DataInsert(0);						
						sheet1Layer.SetCellValue(Row, "gmeasureCd", $("#gmeasureCd").val());
						sheet1Layer.SetCellText(Row, "measureNm", sheet1Layer.GetCellText(Row, "measureCd"));
						sheet1Layer.SelectCell(Row, "measureCd"); 
						break;
	case "Copy":		sheet1Layer.DataCopy(); break;
	case "Clear":		sheet1Layer.RemoveAll(); break;
	case "Down2Excel":	
						var downcol = makeHiddenSkipCol(sheet1Layer);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet1Layer.Down2Excel(param); 
						break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1Layer.LoadExcel(params); break;
	}
}

// 조회 후 에러 메시지
function sheet1Layer_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1Layer_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1Layer_OnChange(Row, Col, Value) {
	try{
	    if(Row > 0 && sheet1Layer.ColSaveName(Col) == "measureCd"){
	    	sheet1Layer.SetCellText(Row, "measureNm", sheet1Layer.GetCellText(Row, "measureCd"));	    	
	    }
  	}catch(ex){alert("OnChange Event Error : " + ex);}		
}

</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="srchFrm" name="srchFrm" >
			<input type="hidden" id="gmeasureCd" name="gmeasureCd">
			<div class="inner">
			<table class="table">
				<colgroup>
					<col width="10%" />
					<col width="15%" />
					<col width="10%" />
					<col width="15%" />
					<col width="10%" />
					<col width="15%" />
					<col width="10%" />
					<col width="15%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='114331' mdef='척도명'/></th>
					<td colspan="5">
						<input id="gmeasureNm" name="gmeasureNm" type="text" class="text" style="width:99%;"/>
					</td>
					<th><tit:txt mid='111896' mdef='순서'/></th>
					<td>
						<input id="orderSeq" name="orderSeq" type="text" class="text" maxlength="3" vtxt="MaxLength Text"/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='113277' mdef='척도구분'/></th>
					<td>
						<select id="type" name="type">
							<option value='A'>정성</option>
							<option value='C'>정량</option>
						</select>
					</td>
					<th><tit:txt mid='114333' mdef='척도유형'/></th>
					<td>
						<select id="gmeasureType" name="gmeasureType">
						</select>
					</td>
					<th><tit:txt mid='114459' mdef='범위유형'/></th>
					<td>
						<select id="levelType" name="levelType">
						</select>
					</td>
					<th><tit:txt mid='112560' mdef='공통척도'/></th>
					<td>
						<select id="commonYn" name="commonYn">
							<option value='Y'>YES</option>
							<option value='N'>NO</option>
						</select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='114716' mdef='척도개요'/></th>
					<td colspan="7">
						<textarea id="memo" name="memo" style="width:99%;height:100px"></textarea>
					</td>
				</tr>
			</table>
			</div>

			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='gmeasureDetail' mdef='척도세부'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
						<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
						<btn:a href="javascript:doAction1('Search')" 	css="btn dark authR" mid='110697' mdef="조회"/>
					</li>
				</ul>
				</div>
			</div>
			</form>
		<!-- <script type="text/javascript"> createIBSheet("sheet1Layer", "100%", "100%", "${ssnLocaleCd}"); </script> -->
		<div id="sheet1Layer-wrap"></div>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('measureCdMgrLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		<btn:a href="javascript:setValue();" css="btn filled" mid='110716' mdef="확인"/>
	</div>
</div>

</body>
</html>
