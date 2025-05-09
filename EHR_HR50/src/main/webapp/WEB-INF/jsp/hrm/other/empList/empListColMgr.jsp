<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.hr.common.util.DateUtil" %> --%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/jquery/select2.js"></script>

<script type="text/javascript">
var pRow = "";
var pGubun = "";

var eleCd = null;
var titleList = new Array();

	$(function() {
		
		eleCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getPsnalBasicViewColumn",false).codeList, "");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:4};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='eleId' mdef='항목ID'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"colId",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='elementNmV6' mdef='항목'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"colName",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$("input[type='text'], textarea").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

		$("#searchDate").datepicker2();
		$("#searchDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search":
		searchTitleList();
		break;
	case "Insert":
		var Row = sheet1.DataInsert(0);
		break;
	case "Save":
		if(!dupChk(sheet1,"columnName", true, true)){break;}
		IBS_SaveName(document.srchFrm,sheet1);
		sheet1.DoSave( "${ctx}/EmpList.do?cmd=saveEmpListColMgr", $("#srchFrm").serialize());
		break;
	case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet1);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
		sheet1.Down2Excel(param);
		break;
	}
}

function searchTitleList() {

	var dataList = ajaxCall("${ctx}/EmpList.do?cmd=getEmpListColMgrTitleList", $("#srchFrm").serialize(), false);

	for(var i=0; i < dataList.DATA.length; i++) {
		titleList["colSaveName"] = dataList.DATA[i].colSaveName.split("|");
		titleList["colHeader"] = dataList.DATA[i].colHeader.split("|");
		titleList["colName"] = dataList.DATA[i].colName.split("|");
		titleList["colValue"] = dataList.DATA[i].colValue.split("|");
	}

	sheet1.Reset();

	if (dataList != null && dataList.DATA != null) {

		var v = 0;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22 , FrozenCol:4 };
		initdata1.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:1};

		initdata1.Cols = [];

		initdata1.Cols[v++] = {Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='eleId' mdef='항목ID'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"colId",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='elementNmV6' mdef='항목'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"colName",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0};

		var columnInfo = "";

		for(var i=0; i<titleList["colSaveName"].length; i++){
			initdata1.Cols[v++]  = { Header:titleList["colHeader"][i],	Type:"CheckBox",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:titleList["colSaveName"][i],	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N"};
			columnInfo = columnInfo + "'" + titleList["colValue"][i] + "' AS " + titleList["colName"][i]+",";
		}

		columnInfo = columnInfo.slice(0,columnInfo.length-1)

		$("#columnInfo").val(columnInfo);

		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);
		
		sheet1.SetColProperty("colId", {ComboText:"|"+eleCd[0], ComboCode:"|"+eleCd[1]} );
		
		sheet1.DoSearch( "${ctx}/EmpList.do?cmd=getEmpListColMgrList", $("#srchFrm").serialize() );
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 이벤트
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") alert(Msg);

		doAction1("Search");
	} catch(ex) {
		alert("OnSaveEnd Event Error : " + ex);
	}
}

function sheet1_OnChange(Row, Col, Value) {
	 try{
		if(sheet1.ColSaveName(Col) == "colId"){
			sheet1.SetCellValue(Row, "colName", sheet1.GetCellText(Row, "colId"));
		}
	}catch(ex){alert("OnChange Event Error : " + ex);}
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "orgBasicPopup"){
		$("#searchOrgCd").val(rv["orgCd"]);
		$("#searchOrgNm").val(rv["orgNm"]);
    }
}

function getMultiSelectValue( value ) {
	if( value == null || value == "" ) return "";
	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
	//return "'"+String(value).split(",").join("','")+"'";
		return value;
}

function orgSearchPopup(){
	try{
		var w 		= 840;
		var h 		= 520;
		var url 	= "/Popup.do?cmd=orgBasicPopup";
		var args 	= new Array();

		args["orgCd"] = "";
		args["orgNm"] = "";

		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "orgBasicPopup";
		openPopup(url+"&authPg=A", args, w, h);

	}catch(ex){alert("Open Popup Event Error : " + ex);}
}

</script>



</head>
<body class="hidden">
<div class="wrapper">
<form id="srchFrm" name="srchFrm" >

	<input type="hidden" id="columnInfo" name="columnInfo" value="" />

</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='2017082500491' mdef='인원명부항목정의'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
