<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#searchFromYmd").datepicker2({startdate:"searchToYmd"});
		$("#searchToYmd").datepicker2({enddate:"searchFromYmd"});
		
		$("#searchFromYmd,#searchToYmd,#searchName,#searchQueryId,#searchUrl,#searchPrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
		

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:10};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"회사",			Type:"Combo",    Hidden:1,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"enterCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"사번",			Type:"Text",     Hidden:0,  Width:60,	Align:"Center",  	ColMerge:0,   SaveName:"sabun",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"로그발생자",		Type:"Text",     Hidden:0,  Width:80, 	Align:"Center",  	ColMerge:0,   SaveName:"name",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"호칭",			Type:"Text",     Hidden:Number("${aliasHdn}"),  Width:60, 	Align:"Center",  	ColMerge:0,   SaveName:"alias",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"직급",			Type:"Text",     Hidden:Number("${jgHdn}"),  Width:60, 	Align:"Center",  	ColMerge:0,   SaveName:"jikgubNm",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"직위",			Type:"Text",     Hidden:Number("${jwHdn}"),  Width:60, 	Align:"Center",  	ColMerge:0,   SaveName:"jikweeNm",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"순번",			Type:"Text",     Hidden:0,  Width:100, 	Align:"Center",   	ColMerge:0,   SaveName:"seq",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"작업구분",		Type:"Text",     Hidden:0,  Width:60, 	Align:"Center",  	ColMerge:0,   SaveName:"job",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"메뉴명",			Type:"Text",     Hidden:0,  Width:100, 	Align:"Center",  	ColMerge:0,   SaveName:"prgNm",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"URL",			Type:"Text",     Hidden:0,  Width:200, 	Align:"Left",  		ColMerge:0,   SaveName:"requestUrl",KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"CONTROLLER",	Type:"Text",     Hidden:0,  Width:200,	Align:"Center",  	ColMerge:0,   SaveName:"controller",KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"쿼리ID",		Type:"Text",     Hidden:0,  Width:150,	Align:"Center",  	ColMerge:0,   SaveName:"queryId",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"PARAMETER",	Type:"Text",     Hidden:0,  Width:200,	Align:"Left",  		ColMerge:0,   SaveName:"parameter", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"쿼리",			Type:"Text",     Hidden:1,  Width:200,	Align:"Left",  		ColMerge:0,   SaveName:"queryString", KeyField:0,   CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"로그내용",		Type:"Text",     Hidden:1,  Width:300,	Align:"Left",  		ColMerge:0,   SaveName:"memo",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"로그일자",		Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  	ColMerge:0,   SaveName:"ymd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"로그시간",		Type:"Text",     Hidden:0,  Width:80, 	Align:"Center",  	ColMerge:0,   SaveName:"hms",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"IP",			Type:"Text",     Hidden:0,  Width:100, 	Align:"Center",  	ColMerge:0,   SaveName:"ip",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"세부\n내역",		Type:"Image",	 Hidden:0,  Width:45,	Align:"Center", 	ColMerge:1,   SaveName:"detail",	KeyField:0,	  Format:"",	  UpdateEdit:0,			InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

 		sheet1.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("detail", 1);
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});

	function chkInVal() {
		if ($("#searchFromYmd").val() != "" && $("#searchToYmd").val() != "") {
			if (!checkFromToDate($("#searchFromYmd"),$("#searchToYmd"),"메뉴HIT일자","메뉴HIT일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			sheet1.DoSearch( "${ctx}/AcessLogSht.do?cmd=getAcessLogShtList", $("#srchFrm").serialize() ); break;
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
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if( Row < sheet1.HeaderRows() ) { 
			return;
		}
		
		if( sheet1.ColSaveName(Col) == "detail" ) {
			if(sheet1.GetCellValue(Row, "queryString") == "") {
				return;
			}
			if(!isPopup()) {return;}

			let modalLayer = new window.top.document.LayerModal({
				id: 'acessLogShtLayer',
				url: '/AcessLogSht.do?cmd=viewAcessLogShtLayer',
				parameters: {"seq": sheet1.GetCellValue(Row, "seq")},
				width: 950,
				height: 815,
				title: '쿼리 상세보기'
			});
			modalLayer.show();
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<!--
						<th>회사 </th>
						<td>  <select id="searchEnterCd" name="searchEnterCd"> </select> </td>
						-->
						<th>로그일자</th>
						<td>
							<input id="searchFromYmd" name="searchFromYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),0)%>"/> ~
							<input id="searchToYmd" name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>							
						</td>
						<th>로그발생자 </th>
						<td> 
							<input id="searchName" name ="searchName" type="text" class="text" /> 
						</td>
						<th>작업구분 </th>
						<td> 
							<select id="searchJob" name="searchJob" onchange="doAction1('Search');">
								<option value="getList,getMap">조회</option>
								<option value="update,excute" selected>저장</option>
								<!-- <option value="'delete'">삭제</option> -->
							</select> 
						</td>
						<td colspan=2> 
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
						</td>
					</tr>
					<tr>
						<th>URL</th>
						<td>
							<input id="searchUrl" name="searchUrl" type="text" class="text w250"/>
						</td>
						<th>메뉴명</th>
						<td>
							<input id="searchPrgNm" name="searchPrgNm" type="text" class="text w120"/>
						</td>
						<th>쿼리ID</th>
						<td>
							<input id="searchQueryId" name="searchQueryId" type="text" class="text w120"/>
						</td>
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
							<li id="txt" class="txt">데이터로그조회</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
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
