<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>퇴직금중간정산내역관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {

	$("input[type='text']").keydown(function(event){
		if(event.keyCode == 27){
			return false;
		}
	});

	$("#searchSdate").datepicker2({startdate:"searchEdate"});
	$("#searchEdate").datepicker2({enddate:"searchSdate"});

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='adjYmd' mdef='중도정산일'/>",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"rmidYmd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='incomeAnnualPaymentYmd' mdef='지급일자'/>",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"근속년월",			Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"wkpYm",			KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='avgMon' mdef='평균임금'/>",			Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"avgMon",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"퇴직소득",			Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"earningMon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"차감소득세",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"tItaxMon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"차감주민세",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"tRtaxMon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"차감농특세",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"tStaxMon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"기타지급",			Type:"Int",			Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"etcAllowMon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='etcDecMon_V1' mdef='기타공제'/>",			Type:"Int",			Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"etcDedMon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"중도정산금액",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"rmidMon",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"누진근속개월",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cumulativeCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	// 재직상태
	var statusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
	$("#searchStatusCd").html(statusCdList[2]);
	$("#searchStatusCd").select2({
		placeholder: "<tit:txt mid='111914' mdef='선택'/>"
	});

	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCdList[0], ComboCode:"|"+statusCdList[1]});

	$(window).smartresize(sheetResize); sheetInit();
	doAction1("Search");

	$("#searchSdate, #searchEdate, #searchNm").bind("keyup",function(event){
		if( event.keyCode == 13){
			doAction1("Search");
		}
	});
	
	//Autocomplete	
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue) {
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow,"name", rv["name"]);
					sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
				}
			}
		]
	});

});

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search":
					$("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));
					sheet1.DoSearch( "${ctx}/SepRmidMgr.do?cmd=getSepRmidMgrList", $("#sendForm").serialize() );
					break;
	case "Save":
					if(!dupChk(sheet1,"sabun|rmidYmd", true, true)){break;}
					IBS_SaveName(document.sendForm,sheet1);
					sheet1.DoSave( "${ctx}/SepRmidMgr.do?cmd=saveSepRmidMgr", $("#sendForm").serialize());
					break;
	case "Insert":
					var row = sheet1.DataInsert(0);
					break;
	case "Copy":
					var row = sheet1.DataCopy();
					//sheet1.SetCellValue(row, "payActionCd", "");
					break;
	case "Down2Excel":
					var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
					sheet1.Down2Excel(param);
					break;
	case "LoadExcel":
					var params = {Mode:"HeaderMatch", WorkSheetNo:1};
					sheet1.LoadExcel(params);
					break;
	case "DownTemplate":
					sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|6|7|9|10|11|12|13|16"});
					break;
	}
}

function getMultiSelectValue( value ) {
	if( value == null || value == "" ) return "";
	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
	//return "'"+String(value).split(",").join("','")+"'";
		return value;
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
		doAction1("Search");
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

//팝업 클릭시 발생
function sheet1_OnPopupClick(Row,Col) {
	try {

	} catch (ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<input type="hidden" id="searchStatusCdHidden" name="searchStatusCdHidden" value="" />
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>중도정산일</th>
			<td>
				<input id="searchSdate" name="searchSdate" type="text" size="10" class="date2 center" value="" /> ~
				<input id="searchEdate" name="searchEdate" type="text" size="10" class="date2 center" value="" />
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchNm" name="searchNm" type="text" class="text" />
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
		</tr>
			<tr>
				<th><tit:txt mid='114198' mdef='재직상태 '/></th>
				<td> 
					<select id="searchStatusCd" name ="searchStatusCd" multiple=""></select>
				</td>
			</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">퇴직금중간정산내역관리</li>
			<li class="btn">
				<a href="javascript:doAction1('DownTemplate')" 	class="basic authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
				<a href="javascript:doAction1('Save')" 			class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic authA"><tit:txt mid='104242' mdef='업로드'/></a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
