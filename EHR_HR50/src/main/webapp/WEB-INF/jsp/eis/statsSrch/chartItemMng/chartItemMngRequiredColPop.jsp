<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>데이터 필수 정의 컬럼</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript"></script>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		var args = p.popDialogArgumentAll();
		var pluginObjNm = args["pluginObjNm"];
		
		// 지정 차트의 데이터 필수 정의 컬럼 정보 조회
		var requiredCols = null;
		if( pluginObjNm && pluginObjNm != null && pluginObjNm !="" ) {
			if( (HR_CHART[pluginObjNm] && HR_CHART[pluginObjNm] != null)
					&& (HR_CHART[pluginObjNm].DATA_SQL_SCHEME && HR_CHART[pluginObjNm].DATA_SQL_SCHEME != null) ) {
				requiredCols = HR_CHART[pluginObjNm].DATA_SQL_SCHEME;
			}
		}
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"필수여부",		Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",   ColMerge:0,   SaveName:"check",	KeyField:0, UpdateEdit:0, InsertEdit:0 },
			{Header:"컬럼ID",		Type:"Text",		Hidden:0,	Width:80,	Align:"Left",     ColMerge:0,   SaveName:"colId",	KeyField:0, UpdateEdit:0, InsertEdit:0 },
			{Header:"컬럼설명",		Type:"Text",		Hidden:0,	Width:130,	Align:"Left",     ColMerge:0,   SaveName:"colNm",	KeyField:0, UpdateEdit:0, InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		// HR_CHART_DATA_SQL_COL 객체를 기반으로 시트 Row 생성
		var colIdArrs = Object.keys(HR_CHART_DATA_SQL_COL);
		if( colIdArrs && colIdArrs != null && colIdArrs.length > 0 ) {
			var row = 0;
			colIdArrs.forEach(function(item) {
				// add row
				row = sheet1.DataInsert(row + 1);
				
				// set value
				sheet1.SetCellValue(row, "colId", item);
				sheet1.SetCellValue(row, "colNm", HR_CHART_DATA_SQL_COL[item]);
				
				// 필수 정의 컬럼인지 체트
				if( requiredCols != null ) {
					requiredCols.forEach(function(col) {
						if( col ==  item) {
							sheet1.SetCellValue(row, "check", "1");
							return false;
						}
					});
				}
			})
		}
		
		// 닫기 버튼 이벤트
		$(".close").click(function(){
			p.self.close(); 
		});
	});
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>데이터 필수 정의 컬럼</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="sheetForm" name="sheetForm" tabindex="1">
			<input id="searchProCd" name="searchProCd" type="hidden" >
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">데이터 필수 정의 컬럼</li>
							<li class="btn">
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:return false;" css="close gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>