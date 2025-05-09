<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.hr.common.util.DateUtil" %> --%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/jquery/select2.js"></script>

<script type="text/javascript">
	var pRow       = "";
	var pGubun     = "";

	$(function() {

		$("#searchDate").datepicker2();
		$("#searchDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		doAction1("Search");
		
		$(window).smartresize(sheetResize);
		
		sheetInit();
		
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction) {
		switch(sAction){
			case "Search":	//조회
				if($("#searchDate").val() == "") {
					alert("기준일자를 입력하세요.");
					return;
				}
				
				searchTitleList();
				sheet1.DoSearch("${ctx}/HrmEmpHQSta.do?cmd=getHrmEmpHQStaList", $("#srchFrm").serialize());
			break;
	
			case "Down2Excel":  //엑셀내려받기
				var downcol = makeHiddenSkipCol(sheet1);
				var param   = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
			break;
		}
	}
	
	var year3colCount = 0;
	var year5colCount = 0;
	function searchTitleList() {
		// 본부별 인원현황 Title 다건 조회
		var titleList     = ajaxCall("${ctx}/HrmEmpHQSta.do?cmd=getHrmEmpHQStaTitleList", $("#srchFrm").serialize(), false);
			year5colCount = titleList.DATA.length;
		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			var initdata = {};
			initdata.Cfg = {FrozenCol:3,SearchMode:smLazyLoad,Page:22,MergeSheet:7};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
			
			var v = 0 ;
			initdata.Cols = [];
			initdata.Cols[v++] = {Header:"No|No",	Type:"${sNoTy}", Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}", Align:"Center", ColMerge:0, SaveName:"sNo" };
			initdata.Cols[v++] = {Header:"구분|구분",	Type:"Text",	 Hidden:0,					 Width:100,			Align:"Center",	ColMerge:1,	SaveName:"workTypeNm", KeyField:0,	Format:"", PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
			initdata.Cols[v++] = {Header:"구분|구분",	Type:"Text",	 Hidden:0,					 Width:100,			Align:"Center",	ColMerge:0,	SaveName:"hqOrgNm",    KeyField:0,	Format:"", PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };

			var sumColsInfo        = "";
			var calcLogicInfoYear3 = "";
			var calcLogicInfoYear5 = "";
			
			var baseYmd      = titleList.DATA[0].baseYmd;
			var untilBaseYmd = addDate("m", -36, baseYmd, "");

			for(var i = 0; i<titleList.DATA.length; i++) {
				var colName         = (i == 0) ? "현재" : formatDate(titleList.DATA[i].baseYmd, "-");
				var diffBaseYmd     = titleList.DATA[i].baseYmd;
				var baseYmdSaveName = "cnt"+(i+1);
				var gapSaveName     = "gap"+(i+1);

				var calcLogicInfoYear = "";
				if(i == 0) {
					calcLogicInfoYear = "|"+baseYmdSaveName+"|";
				} else {
					calcLogicInfoYear = "+|"+baseYmdSaveName+"|";
				}
				
				// 3개년 합계
				if(untilBaseYmd <= diffBaseYmd) {
					calcLogicInfoYear3 += calcLogicInfoYear;
					
					year3colCount++;
				}
				
				// 5개년 합계
				calcLogicInfoYear5 += calcLogicInfoYear;
				
				var hiddenFlag = 0;
				if(i == (titleList.DATA.length-1)) { hiddenFlag = 1; }
				sumColsInfo += baseYmdSaveName + "|" + gapSaveName + "|";
				
				initdata.Cols[v++] = {Header:colName+"|인원",	Type:"AutoSum", Hidden:0, 		   Width:100, Align:"center", ColMerge:0, SaveName:baseYmdSaveName, KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0};
				initdata.Cols[v++] = {Header:colName+"|증감",	Type:"AutoSum", Hidden:hiddenFlag, Width:100, Align:"center", ColMerge:0, SaveName:gapSaveName    , KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0};				
			}
	
			sumColsInfo += "avgYear3|avgYear5";
			
			initdata.Cols[v++] = {Header:"3개년 합계|3개년 합계", 			Type:"AutoSum", Hidden:1, Width:100, Align:"center", CalcLogic:calcLogicInfoYear3, ColMerge:0, SaveName:"sumYear3", KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0};
			initdata.Cols[v++] = {Header:"3개년 평균|3개년 평균",			Type:"AutoSum", Hidden:0, Width:100, Align:"center", 					      	   ColMerge:0, SaveName:"avgYear3", KeyField:0, Format:"", PointCount:2, UpdateEdit:0, InsertEdit:0};
			initdata.Cols[v++] = {Header:"5개년 합계|5개년 합계",			Type:"AutoSum", Hidden:1, Width:100, Align:"center", CalcLogic:calcLogicInfoYear5, ColMerge:0, SaveName:"sumYear5", KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0};
			initdata.Cols[v++] = {Header:"5개년 평균|5개년 평균",			Type:"AutoSum", Hidden:0, Width:100, Align:"center", 						  	   ColMerge:0, SaveName:"avgYear5", KeyField:0, Format:"", PointCount:2, UpdateEdit:0, InsertEdit:0};
			
			IBS_InitSheet(sheet1, initdata); sheet1.SetVisible(true); sheet1.SetCountPosition(4);
			
			var lr = sheet1.LastRow();
			sheet1.SetSumValue(0, "총인원");
			sheet1.SetMergeCell(lr, 0, 1, 3);
			sheet1.SetCellAlign(lr, 0, "Center");
			
        	//소계 추가
        	var info = [{StdCol:"workTypeNm" , SumCols:sumColsInfo, ShowCumulate:0, CaptionCol:"workTypeNm"}];
        	sheet1.ShowSubSum(info);
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			if( sheet1.RowCount() == 0 ) return;
			
			var rowCnt = sheet1.RowCount();
			for (var i=2; i<=rowCnt; i++) {				
				var sumYear3 = sheet1.GetCellValue(i, "sumYear3");
				var avgYear3 = parseInt(sumYear3) / year3colCount;
				
				var sumYear5 = sheet1.GetCellValue(i, "sumYear5");
				var avgYear5 = parseInt(sumYear5) / year5colCount;
				
				sheet1.SetCellValue(i, "avgYear3", avgYear3);
				sheet1.SetCellValue(i, "avgYear5", avgYear5);
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
						<th>기준일자</th>
						<td>
							<input id="searchDate" name="searchDate" type="text" class="text required date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" /></td>
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/></td>
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
							<li id="txt" class="txt">본부별 인원현황</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
