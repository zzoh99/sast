<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112463' mdef='연봉현황리스트'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 연봉현황리스트
 * @author JM
-->
<script type="text/javascript">
var columnInfo = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:0};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//

	//------------------------------------- 조회조건 콤보 -------------------------------------//

	$("#searchYmd").datepicker2({
		onReturn:function(date){
			doAction1("Search");
		}
	});
	$("#searchYmd").val("${curSysYyyyMMddHyphen}");

	$("#searchYmd").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});

	//초기값 설정
	$("#searchMaxVal").val(addComma("10000"));
	$("#searchGapVal").val(addComma("500"));
	$("#searchRowVal").val("15");

	searchTitleList();
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#searchYmd").val() == "") {
		alert("<msg:txt mid='109871' mdef='기준일자를 선택하십시오.'/>");
		$("#searchYmd").focus();
		return false;
	}
	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			var searchMaxVal = $("#searchMaxVal").val().replace(/,/g, "");
			var searchGapVal = $("#searchGapVal").val().replace(/,/g, "");
			
			$("#searchMaxVal").val(parseInt(searchMaxVal));
			$("#searchGapVal").val(parseInt(searchGapVal));
			// 항목리스트 조회
			searchTitleList();
			sheet1.DoSearch("${ctx}/PayStatusList.do?cmd=getPayStatusListList", $("#sheet1Form").serialize());


			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
	}
}

function searchTitleList() {
	// 급여구분별 항목리스트 조회
	var titleList = ajaxCall("${ctx}/PayStatusList.do?cmd=getPayStatusListTitleList", $("#sheet1Form").serialize(), false);

	if (titleList != null && titleList.DATA != null) {

		// IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
		sheet1.Reset();

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:2};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

		initdata1.Cols = [];
		initdata1.Cols[0] = {Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[1] = {Header:"<sht:txt mid='title_V4012' mdef='연봉구간\n(단위:만원)'/>",Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"title",		UpdateEdit:0,	InsertEdit:0,	Sort:0 };

		var colName = "";
		columnInfo = "";
		for(var i=0; i<titleList.DATA.length; i++) {
			colName = convCamel(titleList.DATA[i].colName);
			initdata1.Cols[i+2] = {Header:titleList.DATA[i].orgNm,Type:"Text",	Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:colName,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0, MultiLineText:true };
			//if(i > 0) columnInfo = columnInfo + "|";
			//columnInfo = columnInfo+(i+2);
		}
		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
		$(window).smartresize(sheetResize);
		sheetInit();


		//------------------------------------- 그리드 콤보 -------------------------------------//
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		} else {
			$("#searchMaxVal").val(addComma($("#searchMaxVal").val()));
			$("#searchGapVal").val(addComma($("#searchGapVal").val()));
		}

		//sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}


function addComma(n) {
	if(isNaN(n)){return 0;}
	var reg = /(^[+-]?\d+)(\d{3})/;
	n += '';
	while (reg.test(n))
		n = n.replace(reg, '$1' + ',' + '$2');
	return n;
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
						<th><tit:txt mid='104352' mdef='기준일자'/></th>
						<td>  <input type="text" id="searchYmd" name="searchYmd" class="date2 required" /></td>
						<th><tit:txt mid='113516' mdef='최대값'/></th>
						<td>  <input type="text" id="searchMaxVal" name="searchMaxVal" class="text w70 required right"  validator="number" /><tit:txt mid='112609' mdef='만원'/></td>
						<th><tit:txt mid='112109' mdef='간격값'/></th>
						<td>  <input type="text" id="searchGapVal" name="searchGapVal" class="text w70 required right"  validator="number" /><tit:txt mid='112609' mdef='만원'/></td>
						<th><tit:txt mid='112464' mdef='Row수'/></th>
						<td>  <input type="text" id="searchRowVal" name="searchRowVal" class="text w30 required center"  validator="number" /></td>

						<td>  <btn:a href="javascript:doAction1('Search')"	css="btn dark authR" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='112463' mdef='연봉현황리스트'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
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
