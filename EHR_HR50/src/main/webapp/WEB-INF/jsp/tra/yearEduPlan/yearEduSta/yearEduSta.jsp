<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>연간교육계획현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var grpCd           = "${grpCd}";
	
	$(function() {

		$("#searchPriorOrgNm, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchInOutType, #searchYear, #searchPriorityCd, #searchGubun").on("change", function(e) {
			doAction1("Search");
		});

		$("#searchYear").change(function (){
			getCommonCodeList();
		})
		
		init_sheet();

		doAction1("Search");
	});
	
	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0,FrozenColRight:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata.Cols = [
			
				{Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
				//신청자정보
				{Header:"사번|사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
				{Header:"성명|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
				{Header:"부서|부서",			Type:"Text",   	Hidden:0, Width:90, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
				{Header:"본부|본부",			Type:"Text",   	Hidden:0, Width:90, 	Align:"Left", ColMerge:0,  SaveName:"priorOrgNm", 		Edit:0},
				{Header:"직위|직위",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
				{Header:"교육과정명|교육과정명", 		Type:"Text", 	 Hidden:0, Width:150,  Align:"Left",   SaveName:"eduCourseNm", 	KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"사내/외\n구분|사내/외\n구분", 	Type:"Combo", 	 Hidden:0, Width:100,  Align:"Center", SaveName:"inOutType", 	KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"금액합계|금액합계", 			Type:"AutoSum",  Hidden:0, Width:70,   Align:"Center", SaveName:"totMon", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0, CalcLogic:"|mon01|+|mon02|+|mon03|+|mon04|+|mon05|+|mon06|+|mon07|+|mon08|+|mon09|+|mon10|+|mon11|+|mon12|" },
				{Header:"월별교육비용|1월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon01", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|2월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon02", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|3월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon03", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|4월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon04", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|5월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon05", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|6월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon06", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|7월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon07", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|8월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon08", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|9월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon09", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|10월",			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon10", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|11월",			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon11", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"월별교육비용|12월",			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon12", 		KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				{Header:"교육우선순위|교육우선순위", 	Type:"Combo", 	 Hidden:0, Width:260,  Align:"Left", SaveName:"priorityCd", 	KeyField:0, Format:"", 	UpdateEdit:0, InsertEdit:0 },
				
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");sheet1.SetDataLinkMouse("detail", 1);
		
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet1.SetEditableColorDiff(1); //편집불가 배경색 적용안함

		//==============================================================================================================================
		//공통코드 한번에 조회
		var codeList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getYearEduStaYearCode", false).codeList
        , "sdate,edate"
        , "");
		$("#searchYear").html(codeList[2]);
		//==============================================================================================================================
		getCommonCodeList();

		$(window).smartresize(sheetResize); sheetInit();
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchYear").val() + "-01-01";
		let baseEYmd = $("#searchYear").val() + "-12-31";

		let grpCds = "R10010,L20020,L15010";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;

		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "전체");
		sheet1.SetColProperty("applStatusCd",  		{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} ); //결제
		sheet1.SetColProperty("inOutType",  		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} ); //사내/사외구분
		sheet1.SetColProperty("priorityCd",  		{ComboText:"|"+codeLists["L15010"][0], ComboCode:"|"+codeLists["L15010"][1]} ); //교육우선순위

		$("#searchInOutType").html(codeLists["L20020"][2]);
		$("#searchPriorityCd").html(codeLists["L15010"][2]);
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/YearEduSta.do?cmd=getYearEduStaList", $("#sheet1Form").serialize() );
			sheet1.LoadSearchData(sXml );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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
			if ($('#searchGubun').val() && $('#searchGubun').val() == 'gubun2') {
				sheet1.SetColHidden("sabun",1);
				sheet1.SetColHidden("name",1);
				sheet1.SetColHidden("jikweeNm",1);
				sheet1.SetColHidden("eduCourseNm",1);
				sheet1.SetColHidden("inOutType",1);
				sheet1.SetColHidden("priorityCd",1);
			} else {
				sheet1.SetColHidden("sabun",0);
				sheet1.SetColHidden("name",0);
				sheet1.SetColHidden("jikweeNm",0);
				sheet1.SetColHidden("eduCourseNm",0);
				sheet1.SetColHidden("inOutType",0);
				sheet1.SetColHidden("priorityCd",0);
				
			}
			//$(window).smartresize(sheetResize); 
			sheetInit();
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준년도</th>
			<td>
				<select id="searchYear" name="searchYear">
				</select>
			</td>
			<th>조회구분</th>
			<td>
				<select id="searchGubun" name="searchGubun">
					<option value="gubun1">개인별</option>
					<option value="gubun2">부서별</option>
				</select>
			</td>
			<th>사내/외</th>
			<td colspan="2">
				<select id="searchInOutType" name="searchInOutType">
				</select>
			</td>
		</tr>
		<tr>
			<th>부서명</th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" style="ime-mode:active;"/>
			</td>
			<th>본부명</th>
			<td>
				<input type="text" id="searchPriorOrgNm" name="searchPriorOrgNm" class="text w150" style="ime-mode:active;" />
			</td>
			<th>교육우선순위</th>
			<td>
				<select id="searchPriorityCd" name="searchPriorityCd">
				</select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn filled"/>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">연간교육계획현황</li> 
				<li class="btn">(단위 :천원)&nbsp;
					<btn:a href="javascript:doAction1('Down2Excel');" 	css="basic authR" mid='down2excel' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
