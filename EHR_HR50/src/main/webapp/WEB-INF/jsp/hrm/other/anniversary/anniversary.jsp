<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114255' mdef='기념일조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 기념일조회
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {

	$("input[type='text'], textarea").keydown(function(event){
		if(event.keyCode == 27){
			return false;
		}
	});

	$("#searchYm").datepicker2({ymonly : true});

	$("#searchYm").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});


	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='photoV1' mdef='사진'/>",		Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"photo",		UpdateEdit:0,	ImgWidth:50,	ImgHeight:60 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
		{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
		{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",		Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150},
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"div",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"<sht:txt mid='ymdV9' mdef='일자'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sunDate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"<sht:txt mid='lunType2' mdef='음력'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"lunDay",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
		{Header:"<sht:txt mid='enterCd_V6917' mdef='회사코드'/>",	Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20}
	]; IBS_InitSheet(sheet1, initdata1);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	sheet1.SetEditableColorDiff(0);
	sheet1.SetAutoRowHeight(0);
	sheet1.SetDataRowHeight(60);

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");

});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			if (!chkInVal(sAction)) {break;}
			sheet1.DoSearch("${ctx}/Anniversary.do?cmd=getAnniversaryList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
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

			/*
			for(var Row = sheet1.HeaderRows(); Row<sheet1.RowCount()+sheet1.HeaderRows(); Row++){
				var result = ajaxCall("${ctx}/EmpPhotoOutPath.do?", "enterCd="+sheet1.GetCellValue(Row,"enterCd")+"&sabun="+sheet1.GetCellValue(Row,"sabun"), false);
				sheet1.SetCellValue(Row,"photo", result.Result);
			}*/
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
}

function chkInVal(sAction) {
	if ($("#searchYm").val() == "") {
		alert("<msg:txt mid='110276' mdef='년도를 입력하십시오.'/>");
		$("#searchYm").focus();
		return false;
	}

	return true;
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
						<th><tit:txt mid='114650' mdef='년월 '/></th>
						<td> 
							<input id="searchYm" name ="searchYm" type="text" class="text center" maxlength="7" style="width:50px;" value="${curSysYyyyMMHyphen}" />
						</td>
						<th><tit:txt mid='113694' mdef='구분 '/></th>
						<td> 
							<select id="searchDiv" name ="searchDiv" onchange="javascript:doAction1('Search');">
								<option value="">전체</option>
								<option value="1">생일</option>
								<option value="2">결혼기념일</option>
							</select>
						</td>
						<td> <btn:a href="javascript:doAction1('Search')"	css="btn dark authR" mid='110697' mdef="조회"/></td>
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
							<li id="txt" class="txt"><tit:txt mid='114255' mdef='기념일조회'/></li>
							<li class="btn">
								<!-- <btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline-gray authR" mid='110698' mdef="다운로드"/> -->
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
