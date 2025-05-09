<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직기산일예외관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sNo" },
		{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sDelete",			Sort:0 },
		{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sStatus",			Sort:0 },
		{Header:"사번",				Type:"Text",	Hidden:0, Width:50,	Align:"Center",	ColMerge:0, SaveName:"sabun",		KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",				Type:"Text",	Hidden:0, Width:60,	Align:"Center",	ColMerge:0, SaveName:"name",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"재직상태",     Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"statusCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"예외기산시작일",		Type:"Date",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0, SaveName:"exSepSymd",		KeyField:1, Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },		
		{Header:"수정일시",			Type:"Date",	Hidden:0, Width:90,	Align:"Center",	ColMerge:0, SaveName:"chkdate",		KeyField:0, Format:"YmdHm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"수정자",			Type:"Text",	Hidden:0, Width:60,	Align:"Center",	ColMerge:0, SaveName:"chkid",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }

	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#searchSabunName").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});

	// 재직상태
	var statusCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
	sheet1.SetColProperty("statusCd",           {ComboText:"|"+statusCdList[0], ComboCode:"|"+statusCdList[1]} );
	$("#searchStatusCd").html(statusCdList[2]);
	$("#searchStatusCd").select2({
		placeholder: "선택"
	});

	//Autocomplete	
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue) {
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
					sheet1.SetCellValue(gPRow, "name", rv["name"]);
					sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
				}
			}
		]
	});
	
	doAction1("Search");

});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
		$("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));
			sheet1.DoSearch("${ctx}/SepDayExceMgr.do?cmd=getSepDayExceMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			if (!dupChk(sheet1, "sabun|exSepSymd", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepDayExceMgr.do?cmd=saveSepDayExceMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			break;

		case "Copy":
			sheet1.DataCopy(); break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;

		case "DownTemplate":
			sheet1.Down2Excel({DownCols:"3|6",SheetDesign:1,Merge:1,DownRows:"0"});
			break;

		case "LoadExcel":
			sheet1.RemoveAll();
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
		break;
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

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		if (Code > 0) {
			doAction1("Search");
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function getMultiSelectValue( value ) {
	if( value == null || value == "" ) return "";
	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
	//return "'"+String(value).split(",").join("','")+"'";
		return value;
}


function getReturnValue(returnValue) {

	var result = $.parseJSON('{'+ returnValue+'}');

    if(pGubun == "sheetAutocompleteEmp"){
		sheet1.SetCellValue(gPRow, "sabun", result["sabun"]);
		sheet1.SetCellValue(gPRow, "name", result["name"]);
		sheet1.SetCellValue(gPRow, "statusCd", result["statusCd"]);
    }
}


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<!-- 조회조건 -->
	<input type="hidden" id="searchStatusCdHidden" name="searchStatusCdHidden" value="" />		
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>성명/사번</th>
						<td>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" style="ime-mode:active"/>
						</td>
						<th>재직상태 </th>
                        <td> 
							<select id="searchStatusCd" name ="searchStatusCd" class="box"  multiple=""></select> 
						</td>						
						<td> <a href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">퇴직기산일예외관리</li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')"	class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
								<a href="javascript:doAction1('LoadExcel')"		class="basic authA">업로드</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
