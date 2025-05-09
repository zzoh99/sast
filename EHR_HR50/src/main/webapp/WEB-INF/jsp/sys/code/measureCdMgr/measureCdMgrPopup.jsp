<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114387' mdef='척도관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.popDialogArgumentAll();
	var gmeasureType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20030"), "");	//척도유형
	var levelType 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S20050"), "");	//척도범위유형
	
	$("#gmeasureType").html(gmeasureType[2]);
	$("#levelType").html(levelType[2]);
	
	var gmeasureCd  	= arg["gmeasureCd"];
	var gmeasureNm  	= arg["gmeasureNm"];
	var type			= arg["type"];
	var gmeasureType	= arg["gmeasureType"];
	var levelType  		= arg["levelType"];
	var commonYn  		= arg["commonYn"];
	var memo  			= arg["memo"];
	var orderSeq  		= arg["orderSeq"];
	
	$("#gmeasureCd").val(gmeasureCd);
	$("#gmeasureNm").val(gmeasureNm);
	$("#type").val(type);
	$("#gmeasureType").val(gmeasureType);
	$("#levelType").val(levelType);
	$("#commonYn").val(commonYn);
	$("#memo").val(memo);
	$("#orderSeq").val(orderSeq);
	
	// 숫자만 입력
	$("#orderSeq").keyup(function() {
	     makeNumber(this,'A')
	 });
	
	//Cancel 버튼 처리 
	$(".close").click(function(){
		p.self.close(); 
	});
});

function setValue() {
	var rv = new Array(6);
	rv["gmeasureCd"] 	= $("#gmeasureCd").val();
	rv["gmeasureNm"]	= $("#gmeasureNm").val();
	rv["type"] 	= $("#type").val();
	rv["gmeasureType"] 	= $("#gmeasureType").val();	
	rv["levelType"]		= $("#levelType").val();
	rv["commonYn"]	= $("#commonYn").val();
	rv["memo"]	= $("#memo").val();
	rv["orderSeq"]		= $("#orderSeq").val();
	
	p.popReturnValue(rv);
	p.window.close();
}

$(function() {	
	var initdata = {};
	initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		
        {Header:"<sht:txt mid='competencyCdV1' mdef='척도코드'/>",	Type:"Text",      Hidden:1,  Width:0,    	Align:"Center",  ColMerge:0,   SaveName:"gmeasureCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
        {Header:"<sht:txt mid='measureCd' mdef='척도레벨'/>",	Type:"Combo",     Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"measureCd",     	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },			
        {Header:"<sht:txt mid='measureNm' mdef='척도레벨명'/>",	Type:"Text",      Hidden:1,  Width:0,  		Align:"Left",    ColMerge:0,   SaveName:"measureNm",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
        {Header:"<sht:txt mid='etcPoint' mdef='점수'/>",		Type:"Float",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"jumsu",          	KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"<sht:txt mid='sNum' mdef='범위\n시작'/>",	Type:"Float",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"sNum",  			KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"<sht:txt mid='eNum' mdef='범위\n끝'/>",	Type:"Float",     Hidden:0,  Width:60,    	Align:"Center",  ColMerge:0,   SaveName:"eNum",     		KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"<sht:txt mid='keyWord' mdef='키워드'/>",		Type:"Text",  	  Hidden:0,  Width:150,    	Align:"Left",  	 ColMerge:0,   SaveName:"keyWord",         	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000,	MultiLineText:1 }, 
        {Header:"<sht:txt mid='memoV13' mdef='레벨설명'/>", 	Type:"Text",      Hidden:0,  Width:300,  	Align:"Left",    ColMerge:0,   SaveName:"memo",           	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000,	MultiLineText:1 },
        {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>", 		Type:"Int",  	  Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"seq",     			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
	]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	
	
	var measureCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30100"), "");	//척도레벨

	sheet1.SetColProperty("measureCd", 			{ComboText:measureCd[0], ComboCode:measureCd[1]} );	//척도레벨

	$(window).smartresize(sheetResize); sheetInit();
	doAction1("Search");
});

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search": 	 	sheet1.DoSearch( "${ctx}/MeasureCdMgr.do?cmd=getMeasureDetailCdMgrList", $("#srchFrm").serialize() ); break;
	case "Save": 		if(!dupChk(sheet1,"measureCd", true, true)){break;}
						IBS_SaveName(document.srchFrm,sheet1);
						sheet1.DoSave( "${ctx}/MeasureCdMgr.do?cmd=saveMeasureDetailCdMgr", $("#srchFrm").serialize() ); break;
	case "Insert":		var Row = sheet1.DataInsert(0);						
						sheet1.SetCellValue(Row, "gmeasureCd", $("#gmeasureCd").val());
						sheet1.SetCellText(Row, "measureNm", sheet1.GetCellText(Row, "measureCd"));
						sheet1.SelectCell(Row, "measureCd"); 
						break;
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
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnChange(Row, Col, Value) {
	try{
	    if(Row > 0 && sheet1.ColSaveName(Col) == "measureCd"){
	    	sheet1.SetCellText(Row, "measureNm", sheet1.GetCellText(Row, "measureCd"));	    	
	    }
  	}catch(ex){alert("OnChange Event Error : " + ex);}		
}

</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='measureCdMgr' mdef='척도관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>
	
	<div class="popup_main">
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
			<form id="srchFrm" name="srchFrm" >
				<input type="hidden" id="gmeasureCd" name="gmeasureCd">
			</form>
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
					<btn:a href="javascript:doAction1('Search')" 	css="basic authR" mid='110697' mdef="조회"/>
					<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
					<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>		
		
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large authA" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
