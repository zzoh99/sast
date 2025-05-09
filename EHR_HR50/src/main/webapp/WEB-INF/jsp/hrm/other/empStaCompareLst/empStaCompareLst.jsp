<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>인원현황비교표</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	
	$(function() {
		$("#searchBaseYmd").datepicker2({startdate:"searchCompareYmd"});
		$("#searchCompareYmd").datepicker2({enddate:"searchBaseYmd"});
		
		$("#searchBaseYmd, #searchCompareYmd").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Compare");
			}
		});
		
		init_sheet1();
		
// 		doAction1("Search");
	});
	
	//근무이력현황 sheet
	function init_sheet1(){ 
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"[기준] 전사인원현황|일련번호", 			Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"seq", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"[기준] 전사인원현황|기준 조직 코드", 		Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"baseOrgCd", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"[기준] 전사인원현황|기준 조직 이름", 		Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"baseName", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"[기준] 전사인원현황|기준 조직 인원수", 		Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"baseCount", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"변경 이름|변경 이름", 					Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"changeNm", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"[기준] 전사인원현황|비교 조직 코드", 		Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"compareOrgCd", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"[기준] 전사인원현황|비교 조직 이름", 		Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"compareName", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"[기준] 전사인원현황|비교 조직 인원수", 		Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"compareCount", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"전년대비 증감 인원|전년대비 증감 인원",		Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"compareCount", CalcLogic:"|compareCount|-|baseCount|", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Compare":
			if($("#searchBaseYmd").val() > $("#searchCompareYmd").val()){
				alert("기준일자는 비교일자보다 작아야 합니다.");
				break;
			}
			
			//if(confirm("비교 데이터를 새로 생성하시겠습니까?")){
				progressBar(true);
				
				setTimeout(
					function(){
						var data = ajaxCall("/EmpStaCompareLst.do?cmd=callP_HRM_ORG_COMPARE",$("#sheet1Form").serialize(),false);
			
						if(data == null || data.Result == null) {
							msg = procName+"를 사용할 수 없습니다." ;
							return msg ;
						}
			
						if(data.Result.Code == null || data.Result.Code == "OK") {
							msg = "TRUE" ;
							procCallResultMsg = data.Result.Message ;
						} else {
							msg = "행 데이터 처리도중 오류가 발생했습니다. : "+data.Result.Message;
							alert(msg);
						}
						
						progressBar(false);
						doAction1('Search');
					}
					, 100);
				break;
			//}
		case "Search":
			sheet1.DoSearch("${ctx}/EmpStaCompareLst.do?cmd=getEmpStaCompareLst", $("#sheet1Form").serialize() );
			sheet1.SetCellValue(0, 0, "[" + replaceAll($("#searchBaseYmd").val() , "-", ".") + " 기준]\n 전사 인원현황")
			sheet1.SetCellValue(0, 5, "[" + replaceAll($("#searchCompareYmd").val() , "-", ".") + " 기준]\n 전사 인원현황")
			break;

		case "Search2":
			sheet1.DoSearch("${ctx}/EmpStaCompareLst.do?cmd=getEmpStaCompareLst2", $("#sheet1Form").serialize() );
			sheet1.SetCellValue(0, 0, "[" + replaceAll($("#searchBaseYmd").val() , "-", ".") + " 기준]\n 전사 인원현황")
			sheet1.SetCellValue(0, 5, "[" + replaceAll($("#searchCompareYmd").val() , "-", ".") + " 기준]\n 전사 인원현황")
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
	
	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					gPRow = NewRow;
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
	<!--Search Tag for value  -->	
		<table>
			<tr>
				<th>기준일자</th>
				<td>
					<input type="text" id="searchBaseYmd" name="searchBaseYmd"  class="date2 required" value="<%=DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-12)%>" />
				</td>					
				<th>비교일자</th>
				<td><input type="text" id="searchCompareYmd" name="searchCompareYmd"  class="date2 required" value="${curSysYyyyMMdd}" /></td>
				<td>
					<a href="javascript:doAction1('Compare')" id="btnCompare" class="btn filled">비교 데이터 생성</a>
					<a href="javascript:doAction1('Search2')" id="btnSearch" class="btn dark">데이터 직접 조회</a>
				</td>
			<tr>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">인원현황비교표</li> 
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
