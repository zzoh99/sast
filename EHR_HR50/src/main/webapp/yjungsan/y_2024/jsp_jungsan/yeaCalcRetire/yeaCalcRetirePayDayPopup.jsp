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
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchMonthFrom").datepicker2({ymonly : true});
		$("#searchMonthTo").datepicker2({ymonly : true});
		$("#searchMonthFrom").val("<%=yeaYear%>"+"-01");
		$("#searchMonthTo").val("<%=yeaYear%>"+"-12");
		$("#work_yy").val("<%=yeaYear%>") ;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
   			{Header:"No|No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:1,   SaveName:"sNo" },
   			{Header:"삭제|삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:1,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태|상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:1,   SaveName:"sStatus" , Sort:0},
   			{Header:"급여계산코드|급여계산코드",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_action_cd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
   			{Header:"작업일자명|작업일자명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_action_nm",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
   			{Header:"마감여부|마감여부",			Type:"CheckBox",Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"final_close_yn",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N"},
   			{Header:"대상년월|대상년월",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_ym",				KeyField:1,	CalcLogic:"",	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:6},
   			{Header:"급여구분|급여구분",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_cd",				KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
   			{Header:"지급일자|지급일자",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"payment_ymd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8},
   			{Header:"급여구분코드명|급여구분코드명",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"pay_nm",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
   			{Header:"대상자|대상자",         	Type:"Int",     Hidden:1,   Width:100,  Align:"Right",  ColMerge:1, SaveName:"man_cnt",     		KeyField:0, CalcLogic:"",   Format:"Integer", PointCount:2, UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
   			{Header:"발령기준일|시작일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"ord_symd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8},
   			{Header:"발령기준일|종료일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"ord_eymd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var payCd = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getRetirePayCdList2","",false).codeList, "");
		// 급여코드
		//sheet1.SetColProperty("pay_cd", {ComboText : "|퇴직자정산",ComboCode : "|Y3"});
        sheet1.SetColProperty("pay_cd", {ComboText : "|"+payCd[0], ComboCode : "|"+payCd[1]});

        //$("#searchPayCd").html("<option value='Y3'>퇴직자정산</option>");
		$("#searchPayCd").html(payCd[2]);

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
		case "Save":
			sheet1.DoSave("<%=jspPath%>/yeaCalcRetire/yeaCalcRetirePayDayPopupRst.jsp?cmd=saveYeaCalcRetirePayDayPopup",$("#sheetForm").serialize());
			break;
		case "Insert":
			var newRow = sheet1.DataInsert(0);
// 			sheet1.SetCellValue(newRow, "pay_cd", 'Y3');
// 			sheet1.SetCellValue(newRow, "pay_nm", '퇴직자정산');
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols : downcol,SheetDesign : 1,Merge : 1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
			    doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try {
			if(sheet1.GetCellValue(Row,"sStatus") == "I"
					&& (sheet1.ColSaveName(Col) == 'pay_cd' || sheet1.ColSaveName(Col) == 'pay_nm' || sheet1.ColSaveName(Col) == 'payment_ymd')) {

				var paymentYmd = sheet1.GetCellValue(Row, "payment_ymd");

	            // 급여구분이나 지급일자에 자료가 정확히 입력되지 않았으면 이하의 프로세스는 수행하지 않는다.
				if(paymentYmd.length == 8 && sheet1.GetCellValue(Row, "pay_cd") != "") {
		              var payNm = sheet1.GetCellText(Row, "pay_cd");
		              var year = paymentYmd.substr(0, 4);
		              var month = paymentYmd.substr(4, 2);
		              var day = paymentYmd.substr(6, 2);

		              sheet1.SetCellValue(Row, "pay_action_nm", year + "." + month + "." + day + " " + payNm);
				}
			}else if(sheet1.GetCellValue(Row,"sStatus") == "D" && Value=="1" && sheet1.GetCellValue(Row, "man_cnt") > 0){
				alert("해당 급여일자에 대상자가 존재합니다.\n대상자 삭제 후 진행하시기 바랍니다.");
				sheet1.SetCellValue(Row, "sDelete", 0);
			}   

		} catch (ex) {
			alert("OnChange Event Error " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>작업일자</li>
				<!-- <li class="close"></li>  -->
			</ul>
		</div>
		<div class="popup_main">
			<form id="sheetForm" name="sheetForm">
			<input type="hidden" id="menuNm" name="menuNm" value="" />
			<input type="hidden" id="work_yy" name="work_yy" value="">
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
									<li id="txt" class="txt">작업일자 정의</li>
									<li class="btn">
										<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
										<a href="javascript:doAction1('Save')" class="basic btn-save authA">저장</a>
										<a href="javascript:doAction1('Down2Excel')" class="basic btn-download authR">다운로드</a>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet1", "100%", "100%");</script>
					</td>
				</tr>
			</table>
			<!-- <div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:p.self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div> -->
		</div>
	</div>
</div>
</body>
</html>