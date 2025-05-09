<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<%@ page import="com.hr.common.util.DateUtil" %>

<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112184' mdef='역량사전 팝업'/></title>
<style type="text/css">
</style>
<script type="text/javascript">
<%--var p = eval("${popUpStatus}");--%>
var modal = "";

$(function(){
	createIBSheet3(document.getElementById('mysheet-wrap'), "competencyMgrSheet", "100%", "100%", "${ssnLocaleCd}");
	modal = window.top.document.LayerModalUtility.getModal('competencyMgrLayer');
	if ("${authPg}" == "A") {
		$("#sdate").datepicker2({startdate:"edate"});
		$("#edate").datepicker2({enddate:"sdate"});
	}

	var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분

	$("#mainAppType").html(mainAppType[2]);

	var competencyCd  	= modal.parameters.competencyCd;
	var competencyNm  	= modal.parameters.competencyNm;
	var competencyType	= modal.parameters.competencyType;
	var mainAppType		= modal.parameters.mainAppType;
	var sdate  			= formatDate(modal.parameters.sdate, "-");
	var edate  			= formatDate(modal.parameters.edate, "-");
	var memo  			= modal.parameters.memo;
	var gmeasureCd  	= modal.parameters.gmeasureCd;
	var gmeasureNm  	= modal.parameters.gmeasureNm;

	$("#competencyCd").val(competencyCd);
	$("#competencyNm").val(competencyNm);
	$("#competencyType").val(competencyType);
	$("#mainAppType").val(mainAppType);
	$("#sdate").val(sdate);
	$("#edate").val(edate);
	$("#memo").val(memo);
	$("#gmeasureCd").val(gmeasureCd);
	$("#gmeasureNm").val(gmeasureNm);

	//Cancel 버튼 처리
	$(".close").click(function(){
		closeCommonLayer('competencyMgrLayer');
	});
});

function setValue() {
	var rv = [];
	rv["competencyCd"] 		= $("#competencyCd").val();
	rv["competencyNm"]		= $("#competencyNm").val();
	rv["competencyType"] 	= $("#competencyType").val();
	rv["mainAppType"] 		= $("#mainAppType").val();
	rv["sdate"]				= $("#sdate").val().replace(/-/gi,"");
	rv["edate"]				= $("#edate").val().replace(/-/gi,"");
	rv["memo"]				= $("#memo").val();
	rv["gmeasureCd"]		= $("#gmeasureCd").val();
	rv["gmeasureNm"]		= $("#gmeasureNm").val();

	var rtnModal = window.top.document.LayerModalUtility.getModal('competencyMgrLayer');
	rtnModal.fire("competencyMgrTrigger", returnValue).hide();
}

$(function() {
	var initdata = {};
	initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

        {Header:"<sht:txt mid='competencyCdV1' mdef='척도코드'/>",	Type:"Text",      Hidden:1,  Width:0,    	Align:"Center",  ColMerge:0,   SaveName:"gmeasureCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"<sht:txt mid='measureCd' mdef='척도레벨'/>",	Type:"Combo",     Hidden:0,  Width:70,  	Align:"Center",  ColMerge:0,   SaveName:"measureCd",     	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"<sht:txt mid='measureNm' mdef='척도레벨명'/>",	Type:"Text",      Hidden:1,  Width:0,  		Align:"Left",    ColMerge:0,   SaveName:"measureNm",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
        {Header:"<sht:txt mid='etcPoint' mdef='점수'/>",		Type:"Float",     Hidden:0,  Width:50,    	Align:"Center",  ColMerge:0,   SaveName:"jumsu",          	KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"<sht:txt mid='sNum' mdef='범위\r\n시작'/>",	Type:"Float",     Hidden:0,  Width:50,    	Align:"Center",  ColMerge:0,   SaveName:"sNum",  			KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"<sht:txt mid='eNum' mdef='범위\r\n끝'/>",	Type:"Float",     Hidden:0,  Width:50,    	Align:"Center",  ColMerge:0,   SaveName:"eNum",     		KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"<sht:txt mid='keyWord' mdef='키워드'/>",		Type:"Text",  	  Hidden:0,  Width:120,    	Align:"Left",  	 ColMerge:0,   SaveName:"keyWord",         	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000,	MultiLineText:1,	Wrap:1 },
        {Header:"<sht:txt mid='memoV13' mdef='레벨설명'/>", 	Type:"Text",      Hidden:0,  Width:350,  	Align:"Left",    ColMerge:0,   SaveName:"memo",           	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000,	MultiLineText:1,	Wrap:1 },
        {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>", 		Type:"Int",  	  Hidden:1,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"seq",     			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:3 }
	]; IBS_InitSheet(competencyMgrSheet, initdata);competencyMgrSheet.SetVisible(true);competencyMgrSheet.SetCountPosition(4);


	var measureCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30100"), "");	//척도레벨

	competencyMgrSheet.SetColProperty("measureCd", 			{ComboText:measureCd[0], ComboCode:measureCd[1]} );	//척도레벨

	$(window).smartresize(sheetResize); sheetInit();
	var sheetHeigth = $(".modal_body").height() - $("#srchFrm").height() -  $(".sheet_title").height() -2;
	competencyMgrSheet.SetSheetHeight(sheetHeigth);
	doAction1("Search");
});

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search": 	 	competencyMgrSheet.DoSearch( "${ctx}/MeasureCdMgr.do?cmd=getMeasureDetailCdMgrList", $("#srchFrm").serialize() ); break;
	case "Clear":		competencyMgrSheet.RemoveAll(); break;
    case "Down2Excel":
		var downcol = makeHiddenSkipCol(competencyMgrSheet);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
		competencyMgrSheet.Down2Excel(param);
		break ;
	}
}

// 조회 후 에러 메시지
function competencyMgrSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function competencyMgrSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function competencyMgrSheet_OnChange(Row, Col, Value) {
	try{
	    if(Row > 0 && competencyMgrSheet.ColSaveName(Col) == "measureCd"){
	    	competencyMgrSheet.SetCellText(Row, "measureNm", competencyMgrSheet.GetCellText(Row, "measureCd"));
	    }
  	}catch(ex){alert("OnChange Event Error : " + ex);}
}

// 초기화
function clear() {
	$("#gmeasureCd").val("");
	$("#gmeasureNm").val("");

	doAction1("Clear");
}

// 척도 팝업
function measureCdPopup() {
	if(!isPopup()) {return;}

    openPopup("/Popup.do?cmd=viewMeasureCdPopup&authPg=R", "", "740","720");
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

	$("#gmeasureCd").val(rv["gmeasureCd"]);
	$("#gmeasureNm").val(rv["gmeasureNm"]);

	doAction1("Search");
}

</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
	<div class="modal_body">
		<div class="inner">
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="20%" />
				<col width="30%" />
			</colgroup>
			<form id="srchFrm" name="srchFrm" >
				<input type="hidden" id="competencyCd" name="competencyCd">

			<tr>
				<th><tit:txt mid='112683' mdef='역량명'/></th>
				<td>
					<input id="competencyNm" name="competencyNm" type="text" class="${textCss} text" ${readonly} style="width:99%;"/>
				</td>
				<th><tit:txt mid='114674' mdef='역량분류'/></th>
				<td>
					<select id="competencyType" name="competencyType" class="${selectCss}" ${disabled}>
						<option value='A'><tit:txt mid='113603' mdef='역량군'/></option>
						<option value='C'><tit:txt mid='appSelf3' mdef='역량'/></option>
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112413' mdef='유효기간'/></th>
				<td>
					<input id="sdate" name="sdate" type="text" size="10" class="${dateCss} date2" ${readonly}/> ~
					<input id="edate" name="edate" type="text" size="10" class="${dateCss} date2" ${readonly}/>
				</td>
				<th><tit:txt mid='112167' mdef='역량구분'/></th>
				<td>
					<select id="mainAppType" name="mainAppType" class="${selectCss}" ${disabled}>
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112522' mdef='개요(한글)'/></th>
				<td colspan="3">
					<textarea id="memo" name="memo" class="${textCss}" ${readonly} style="width:99%;height:100px"></textarea>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='113947' mdef='적용척도'/></th>
				<td colspan="3">
				<input id="gmeasureCd" name="gmeasureCd" type="text" class="hide" readonly>
				<input id="gmeasureNm" name="gmeasureNm" type="text" class="text w200" readonly>
				<a href="javascript:clear()" class="button7 authA"><img src="/common/${theme}/images/icon_undo.gif"/></a>
				<a href="javascript:measureCdPopup();" class="button6 authA"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>
			</form>
		</table>
		</div>

		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='gmeasureDetail' mdef='척도세부'/></li>
				<li class="btn">
					<!-- <a href="javascript:doAction1('Search')" 	class="basic authR"><tit:txt mid='104081' mdef='조회'/></a> -->
					<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
				</li>
			</ul>
			</div>
		</div>
<%--		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
		<div id="mysheet-wrap"></div>

	</div>
	<div class="modal_footer">
		<a href="javascript:setValue();" class="btn filled">확인</a>
		<a href="javascript:closeCommonLayer('competencyMgrLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>

</body>
</html>
