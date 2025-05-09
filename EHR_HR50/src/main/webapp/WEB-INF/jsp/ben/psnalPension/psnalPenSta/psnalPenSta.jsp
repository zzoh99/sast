<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>개인연금현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	
	$(function() {
	
		$("#searchYm").datepicker2({ymonly:true, onReturn:function(){doAction1("Search");}});
		
		$("#searchDiffYn, :radio[name='searchDiffYn']").on("change", function(e) {
			doAction1("Search");
		})
		
		
		$("#searchSabunName, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		init_sheet();
		
		
		doAction1("Search");
	});

	

	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:1, FrozenColRight:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			//신청자정보
			{Header:"사번|사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
			{Header:"성명|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
			{Header:"부서|부서",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"직책|직책",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
			{Header:"직위|직위",			Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"직급|직급",			Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
			{Header:"재직상태|재직상태",		Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"statusNm", 		Edit:0},
			{Header:"입사일자|입사일자",		Type:"Date",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"empYmd", 		Edit:0},
			{Header:"퇴직일자|퇴직일자",		Type:"Date",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"retYmd", 		Edit:0},
			
			//전월가입정보
			{Header:"전월|가입상품",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"pensCd1",		Edit:0 },
			{Header:"전월|회사지원금",		Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	SaveName:"compMon1",	Format:"",	Edit:0 },
			{Header:"전월|개인부담금",		Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	SaveName:"psnlMon1",	Format:"",	Edit:0 },
			{Header:"전월|계",			Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	SaveName:"totMon1",		Format:"",	Edit:0 },
			//당월가입정보
			{Header:"당월|가입상품",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"pensCd2",		Edit:0 },
			{Header:"당월|회사지원금",		Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	SaveName:"compMon2",	Format:"",	Edit:0 },
			{Header:"당월|개인부담금",		Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	SaveName:"psnlMon2",	Format:"",	Edit:0 },
			{Header:"당월|계",			Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	SaveName:"totMon2",		Format:"",	Edit:0 },
			//익월가입정보
			{Header:"익월|가입상품",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"pensCd3",		Edit:0 },
			{Header:"익월|회사지원금",		Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	SaveName:"compMon3",	Format:"",	Edit:0 },
			{Header:"익월|개인부담금",		Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	SaveName:"psnlMon3",	Format:"",	Edit:0 },
			{Header:"익월|계",			Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	SaveName:"totMon3",		Format:"",	Edit:0 },
			
  		];
  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

  		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

 		//==============================================================================================================================
		var pensCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B65110"), "");
		sheet1.SetColProperty("pensCd1", {ComboText:"|"+pensCdList[0], ComboCode:"|"+pensCdList[1]} );
		sheet1.SetColProperty("pensCd2", {ComboText:"|"+pensCdList[0], ComboCode:"|"+pensCdList[1]} );
		sheet1.SetColProperty("pensCd3", {ComboText:"|"+pensCdList[0], ComboCode:"|"+pensCdList[1]} );
		//==============================================================================================================================
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if( $("#searchYm").val() == ""){
				alert("기준년월을 입력 해주세요.");
				$("#searchYm").focus();
				return;
			}
			sheet1.SetCellValue(0, "pensCd1", "전월( "+fn_add_months($("#searchYm").val()+"-01", -1)+" )");
			sheet1.SetCellValue(0, "pensCd2", "당월( "+$("#searchYm").val()+" )");
			sheet1.SetCellValue(0, "pensCd3", "익월( "+fn_add_months($("#searchYm").val()+"-01", 1)+" )");
			
			sheet1.DoSearch( "${ctx}/PsnalPenSta.do?cmd=getPsnalPenStaList", $("#sheet1Form").serialize() );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}
	
	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function fn_add_months(pdate, diff_m) {
	    var add_m;
	    var lastDay;    // 마지막 날(30,31..)
	    var pyear, pmonth, pday;

	    pdate = makeDateFormat(pdate); // javascript 날짜형변수로 변환
	    if (pdate == "") return "";

	    pyear = pdate.getFullYear();
	    pmonth= pdate.getMonth() + 1;
	    pday  = pdate.getDate();

	    add_m = new Date(pyear, pmonth + diff_m, 1);    // 더해진 달의 첫날로 세팅

	    lastDay = new Date(pyear, pmonth, 0).getDate(); // 현재월의 마지막 날짜를 가져온다.
	    if (lastDay == pday) {  // 현재월의 마지막 일자라면 더해진 월도 마지막 일자로
	        pday = new Date(add_m.getFullYear(), add_m.getMonth(), 0).getDate();
	    }

	    add_m = new Date(add_m.getFullYear(), add_m.getMonth()-1, pday);

		var pyear = add_m.getFullYear();
		var pmonth = lpad((add_m.getMonth() + 1).toString(), '0', 2);

		return pyear + "-" + pmonth;
		
	    return add_m;
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준년월</th>
			<td>
				<input type="text" id="searchYm" name="searchYm" class="date2 required" value="${curSysYyyyMMHyphen}">
			</td>
			<th>소속</th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" style="ime-mode:active;"/>
			</td>
			<th>사번/성명</th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<span><label for="searchDiffYn0">전체</label></span>
				<input type="radio" id="searchDiffYn0" name="searchDiffYn" value="0" checked>
				<span><label for="searchDiffYn1">당월변동자</label></span>
				<input type="radio" id="searchDiffYn1" name="searchDiffYn" value="1">
				<span><label for="searchDiffYn2">익월변동자</label></span>
				<input type="radio" id="searchDiffYn2" name="searchDiffYn" value="2">
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">개인연금현황</li> 
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
