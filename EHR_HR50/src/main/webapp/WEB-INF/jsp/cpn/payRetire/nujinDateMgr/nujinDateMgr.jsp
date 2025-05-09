<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직누진일수관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
		
		{Header:"사번",								Type:"Text",	Hidden:0, Width:80, Align:"Center", ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
		{Header:"성명",								Type:"Text",	Hidden:0, Width:80, Align:"Center", ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
		{Header:"누진일수",							Type:"Int",	Hidden:0, Width:80, Align:"Center", ColMerge:0,	SaveName:"cumulativeCnt",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
		{Header:"누진일수를 정산한\n퇴직금지급일",	Type:"Date",	Hidden:0, Width:80, Align:"Center", ColMerge:0,	SaveName:"expirePaymentYmd",	KeyField:0,	Format:"Ymd",	PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
		{Header:"비고",								Type:"Text",	Hidden:0, Width:80, Align:"Left",	ColMerge:0,	SaveName:"bigo",				KeyField:0,	Format:"",		PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$("#searchSabunName").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
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
	
	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/NujinDateMgr.do?cmd=getNujinDateMgrList", $("#sheet1Form").serialize());
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/NujinDateMgr.do?cmd=saveNujinDateMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			sheet1.RemoveAll();
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			var param  = {DownCols:"sabun|cumulativeCnt|expirePaymentYmd|bigo",SheetDesign:1,Merge:1,DownRows:"0"};
			sheet1.Down2Excel(param);
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
		
		doAction1("Search");
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>성명/사번</th>
						<td>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text w100" style="ime-mode:active;"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" class="button authR">조회</a>
						</td>
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
							<li id="txt" class="txt">퇴직누진일수관리</li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')"	class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
								<a href="javascript:doAction1('LoadExcel')"	class="basic authA">업로드</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
	
 	<div class="explain outer">
		<div class="title">유의사항</div>
		<div class="txt">
1. 퇴직금 계산시 누진일수를 관리하는 화면입니다.<br/>
2. 퇴직금 계산시 [누진일수]가 등록되어 있으면, 누진일수를 포함하여 퇴직금을 계산합니다.<br/>
3. [누진일수를 정산한 퇴직금지급일]에 날짜가 등록되어 있으면, 해당 지급일자 다음에 지급되는 퇴직금에는 누진일수를 적용하지 않습니다.<br/>
4. [누진일수]가 있고, [누진일수를 정산한 퇴직금지급일]이 없는 상태에서 퇴직금을 계산하면, [누진일수를 정산한 퇴직금지급일]에 해당 퇴직금의 지급일자가 자동으로 세팅됩니다.
		</div>
	</div>
</div>
</body>
</html>