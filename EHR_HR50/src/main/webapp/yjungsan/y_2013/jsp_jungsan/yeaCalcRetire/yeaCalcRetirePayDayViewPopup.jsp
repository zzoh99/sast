<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>작업일자</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	var arg = p.window.dialogArguments;
	
	$(function() {

		$("#searchMonthFrom").datepicker2({ymonly : true});
		$("#searchMonthTo").datepicker2({ymonly : true});
		$("#searchMonthFrom").val("<%=yeaYear%>"+"-01");
		$("#searchMonthTo").val("<%=yeaYear%>"+"-12");

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, DataRowMerge:0};                                                                                                                                                                                              
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};                                                                                                                                                                          
		initdata1.Cols = [
   			{Header:"No|No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:1,   SaveName:"sNo" },    
   			{Header:"급여계산코드|급여계산코드",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_action_cd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
   			{Header:"작업일자명|작업일자명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_action_nm",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
   			{Header:"대상년월|대상년월",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_ym",				KeyField:1,	CalcLogic:"",	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:6},
   			{Header:"급여구분|급여구분",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_cd",				KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
   			{Header:"지급일자|지급일자",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"payment_ymd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8},
   			{Header:"급여구분코드명|급여구분코드명",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_nm",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
   			{Header:"발령기준일|시작일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"ord_symd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8},
   			{Header:"발령기준일|종료일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"ord_eymd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 급여코드
		sheet1.SetColProperty("pay_cd", {ComboText : "|퇴직자정산",ComboCode : "|Y3"});

		$("#searchPayCd").html("<option value='Y3'>퇴직자정산</option>");

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
		$(".close").click(function() {
			p.self.close();
		});
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch("<%=jspPath%>/yeaCalcRetire/yeaCalcRetirePayDayPopupRst.jsp?cmd=selectYeaCalcRetirePayDayPopupList",$("#sheetForm").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols : downcol,SheetDesign : 1,Merge : 1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//더블 클릭시 발생
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			returnFindUser(Row,Col);
		} catch(ex){
			alert("OnDblClick Event Error : " + ex);
		} finally{
			p.self.close();; 
		}
	}

	//값 리턴
	function returnFindUser(Row,Col){
		var rv = [];
		rv["payActionCd"] 		= sheet1.GetCellValue(Row, "pay_action_cd");
		rv["payActionNm"]		= sheet1.GetCellValue(Row, "pay_action_nm");
		rv["payCd"] 			= sheet1.GetCellValue(Row, "pay_cd");
		rv["payYm"] 			= sheet1.GetCellValue(Row, "pay_ym");
		rv["paymentYmd"] 		= sheet1.GetCellValue(Row, "payment_ymd");
		rv["paymentYmdHyphen"] 	= sheet1.GetCellText(Row, "payment_ymd");
		rv["payNm"] 			= sheet1.GetCellValue(Row, "pay_Nm");
		rv["ordSymd"] 			= sheet1.GetCellValue(Row, "ord_symd");
		rv["ordEymd"] 			= sheet1.GetCellValue(Row, "ord_eymd");
		
		//p.window.returnValue 	= rv;
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close();
	}
	
</script>
</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>작업일자 정의</li>
				<!-- <li class="close"></li>  -->
			</ul>
		</div>
		<div class="popup_main">
			<form id="sheetForm" name="sheetForm">
				<div class="sheet_search outer">
					<div>
						<table>
							<tr>
								<td><span>급여구분 </span>
									<select id="searchPayCd" name="searchPayCd">
									</select>
								</td>
								<td><span>대상년월 </span> 
									<input id="searchMonthFrom" name="searchMonthFrom" class="date2" /> ~ <input id="searchMonthTo" name="searchMonthTo" class="date2" />
								</td>
								<td>
									<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
									<li id="txt" class="txt">작업일자</li>
									<li class="btn">
										<a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
									</li>
								</ul>
							</div>
						</div> 
						<script type="text/javascript">createIBSheet("sheet1", "100%", "100%");</script>
					</td>
				</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:p.self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>