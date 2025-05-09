<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
<%-- <script src="${ctx}/common/js/commonIBSheet.js" type="text/javascript" charset="utf-8"></script> --%>
<title><tit:txt mid='112184' mdef='역량사전 팝업'/></title>
<%-- <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%> --%>
<style type="text/css">
</style>
<script type="text/javascript">
$(function(){
	if ("${authPg}" == "A") {
		$("#dicsheetFrm #sdate").datepicker2({startdate:"edate"});
		$("#dicsheetFrm #edate").datepicker2({enddate:"sdate"});
	}
	var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분
	$("#dicsheetFrm #mainAppType").html(mainAppType[2]);

	var modal = window.top.document.LayerModalUtility.getModal('competencyMgrLayer');
	var { competencyCd, competencyNm, competencyType, mainAppType, sdate, edate, memo, gmeasureCd, gmeasureNm } = modal.parameters;
	sdate = formatDate(sdate, '-');
	edate = formatDate(edate, '-');
	$("#dicsheetFrm #competencyCd").val(competencyCd);
	$("#dicsheetFrm #competencyNm").val(competencyNm);
	$("#dicsheetFrm #competencyType").val(competencyType);
	$("#dicsheetFrm #mainAppType").val(mainAppType);
	$("#dicsheetFrm #sdate").val(sdate);
	$("#dicsheetFrm #edate").val(edate);
	$("#dicsheetFrm #memo").val(memo);
	$("#dicsheetFrm #gmeasureCd").val(gmeasureCd);
	$("#dicsheetFrm #gmeasureNm").val(gmeasureNm);

	createIBSheet3(document.getElementById('dicsheet-wrap'), "dicsheet", "100%", "100%", "${ssnLocaleCd}");
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
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
        {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>", 		Type:"Int",  	  Hidden:1,  Width:0,   	Align:"Center",  ColMerge:0,   SaveName:"seq",     			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:3 }
	]; 
	IBS_InitSheet(dicsheet, initdata); 
	dicsheet.SetVisible(true); 
	dicsheet.SetCountPosition(4);
	var measureCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30100"), "");	//척도레벨
	dicsheet.SetColProperty("measureCd", 			{ComboText:measureCd[0], ComboCode:measureCd[1]} );	//척도레벨
	$(window).smartresize(sheetResize); sheetInit();

	var sheetHeight = $(".modal_body").height() - $("#dicsheetFrm").height() - $(".sheet_title").height() - 2;
	dicsheet.SetSheetHeight(sheetHeight);

	doAction1("Search");
});

function setValue() {
	const p = {
			competencyCd:$("#dicsheetFrm #competencyCd").val(),
			competencyNm:$("#dicsheetFrm #competencyNm").val(),
			competencyType:$("#dicsheetFrm #competencyType").val(),
			mainAppType:$("#dicsheetFrm #mainAppType").val(),
			sdate:$("#dicsheetFrm #sdate").val().replace(/-/gi,""),
			edate:$("#dicsheetFrm #edate").val().replace(/-/gi,""),
			memo:$("#dicsheetFrm #memo").val(),
			gmeasureCd:$("#dicsheetFrm #gmeasureCd").val(),
			gmeasureNm:$("#dicsheetFrm #gmeasureNm").val()
		};
	var modal = window.top.document.LayerModalUtility.getModal('competencyMgrLayer');
	modal.fire('competencyMgrLayerTrigger', p).hide();
}

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search": 	 	dicsheet.DoSearch( "${ctx}/MeasureCdMgr.do?cmd=getMeasureDetailCdMgrList", $("#dicsheetFrm").serialize() ); break;
	case "Clear":		dicsheet.RemoveAll(); break;
    case "Down2Excel":
		var downcol = makeHiddenSkipCol(dicsheet);
		var param  = {FileName:"척도세부_${curSysYyyyMMdd}", DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
		dicsheet.Down2Excel(param);
		break ;
	}
}

// 조회 후 에러 메시지
function dicsheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function dicsheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function dicsheet_OnChange(Row, Col, Value) {
	try{
	    if(Row > 0 && dicsheet.ColSaveName(Col) == "measureCd"){
	    	dicsheet.SetCellText(Row, "measureNm", dicsheet.GetCellText(Row, "measureCd"));
	    }
  	}catch(ex){alert("OnChange Event Error : " + ex);}
}

// 초기화
function clear() {
	$("#dicsheetFrm #gmeasureCd").val("");
	$("#dicsheetFrm #gmeasureNm").val("");
	doAction1("Clear");
}

// 척도 팝업
function measureCdPopup() {
	if(!isPopup()) {return;}
	var url = '/Popup.do?cmd=viewMeasureCdLayer&authPg=R';
	var layer = new window.top.document.LayerModal({
	  		id : 'measureCdLayer'
	      , url : url
	      , width : 740
	      , height : 720
	      , title : "<tit:txt mid='112705' mdef='척도 리스트 조회'/>"
	      , trigger :[
	          {
	                name : 'measureCdLayerTrigger'
	              , callback : function(rv){
	            	  $("#dicsheetFrm #gmeasureCd").val(rv.gmeasureCd);
	            	  $("#dicsheetFrm #gmeasureNm").val(rv.gmeasureNm);
	            	  doAction1("Search");
	              }
	          }
	      ]
	  });
	layer.show();
}

</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="dicsheetFrm" name="dicsheetFrm" >
				<input type="hidden" id="competencyCd" name="competencyCd" />
				<div class="outer">
					<table class="table">
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="20%" />
							<col width="30%" />
						</colgroup>
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
					</table>
				</div>
			</form>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt"><tit:txt mid='gmeasureDetail' mdef='척도세부'/></li>
									<li class="btn">
										<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
									</li>
								</ul>
							</div>
						</div>
					</td>
				</tr>
			</table>
			<div id="dicsheet-wrap"></div>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('competencyMgrLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
			<btn:a href="javascript:setValue();" css="btn filled" mid='110716' mdef="확인"/>
		</div>
	</div>
</body>
</html>
