<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title>팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!-- Jquery -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%><!-- IBSheet -->
<style type="text/css">
</style>
<script type="text/javascript">
var p           = eval("${popUpStatus}");
var gCheckBtn   = false;
var payActionCd = "";
var searchType  = "";
var searchSabun = "";

	$(function() {

		$(".close").click(function() {
			closePopup();
		});

		var arg = p.window.dialogArguments;
		if( arg != undefined ) {
			payActionCd 	= arg["payActionCd"];
		}else{
			if(p.popDialogArgument("payActionCd")!=null)		payActionCd  	= p.popDialogArgument("payActionCd");
		}

		$("").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchPayActionCd").val(payActionCd);

		initSheet1();
		initSheet2();
		
		// Seearch
		doAction1("Search");
		doAction2("Search");

	});
	
	function initSheet1() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"급여계산코드(TCPN201)",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payActionCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"대상급여계산코드",		Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"targetPayActionCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상급여계산명",			Type:"Text",		Hidden:0,	Width:190,	Align:"Left",	ColMerge:0,	SaveName:"targetPayActionNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"급여년월",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payYm",				KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"비고",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"bigo",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		$(window).smartresize(sheetResize); sheetInit();
	}

	function closePopup(){
		var rv = new Array(1);
		p.popReturnValue(rv);
		p.window.close();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!checkList()) return ;
			sheet1.DoSearch( "${ctx}/PayDayMgr.do?cmd=getPayDayMgrPopList", $("#sendForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"payActionCd|targetPayActionCd", true, true)){break;}
			IBS_SaveName(document.sendForm,sheet1);
			sheet1.DoSave( "${ctx}/PayDayMgr.do?cmd=savePayDayMgrPop", $("#sendForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue( row, "payActionCd", payActionCd );
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"", ExcelFontSize:"9", ExcelRowHeight:"20"});
			break;
		case "Clear":
			sheet1.RemoveAll();
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
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col) {
		try{
			var colName = sheet1.ColSaveName(Col);
			var rv = null;
			/* 2022.06.03 sheet2 추가로 사용안함
			if(colName == "targetPayActionNm" && Row > 0 ) {
				if(!isPopup()) {return;}
				var args 	= new Array();
				args["payActionCd"] = payActionCd;
				openPopup("/PayDayMgr.do?cmd=viewPayDayChPopup&authPg=R", args, 800, 520, function(rv) {
					sheet1.SetCellValue( Row, "targetPayActionCd", rv["payActionCd"] );
					sheet1.SetCellValue( Row, "targetPayActionNm", rv["payActionNm"] );
					sheet1.SetCellValue( Row, "payYm",			   rv["payYm"] );
				});
			}
			*/
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getMonthEndDate(year, month) {
		var dt = new Date(year, month, 0);
		return dt.getDate();
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');
	}
</script>
<!-- Sheet2  -->
<script type="text/javascript">
	function initSheet2() {
		var runType = "";
		var payCd   = "";

		$("#searchMonthFrom", "#mySheetForm").datepicker2({ymonly:true});
		$("#searchMonthTo", "#mySheetForm").datepicker2({ymonly:true});

		$("#searchMonthFrom, #searchMonthTo", "#mySheetForm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction2("Search"); }
		});	
		
		// set payActionCd
		$("#searchPayActionCd", "#mySheetForm").val(payActionCd);
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"선택",			Type:"DummyCheck",Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"chk",              KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y",   FalseValue:"N" },
			{Header:"세부\n내역",		Type:"Image",     Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"selectImg",        KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"급여계산코드",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"payActionCd",      KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"급여계산명",		Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:1,   SaveName:"payActionNm",      KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"대상년월",			Type:"Date",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"payYm",            KeyField:0,   CalcLogic:"",   Format:"Ym",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:7 },
			{Header:"급여구분",			Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"payCd",            KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"RUN_TYPE",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"runType",          KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"지급일자",			Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"paymentYmd",       KeyField:0,   CalcLogic:"",   Format:"Ymd", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"마감",			Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"closeYn",          KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
			{Header:"급여구분코드명",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"payNm",            KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"지급일자",			Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"paymentYmdHyphen", KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"발령기준\n시작일",	Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"ordSymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령기준\n종료일",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"ordEymd",          KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"비고",			Type:"Text",      Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"bigo",             KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
			{Header:"지급일",			Type:"Text",      Hidden:1,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"day",              KeyField:0,   CalcLogic:"",   Format:"",    PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 } ];
		IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		// 급여코드
		var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayChPopupNotInCdList",false).codeList, "전체");
		sheet2.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );

		// 조회조건
		var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayChPopupNotInCdList",false).codeList, "전체");
		$("#searchPayCd", "#mySheetForm").html(searchPayCdList[2]);
		if(payCd != undefined){
			$("#searchPayCd", "#mySheetForm").val(payCd);
		}
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	// 지정 급여계산코드가 sheet1에 존재하느지 체크 
	function isContainTargetPayActionCd(payActionCd) {
		var isExists = false;
		if(sheet1.LastRow() > 0) {
			var Row = sheet1.FindText("targetPayActionCd", payActionCd, 0);
			if( Row > 0 ) isExists = true;
		}
		return isExists;
	}
	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/GetDataList.do?cmd=getPayDayChPopupList", $("#mySheetForm").serialize() );
				break;
			case "Insert" :
				var chkRows = sheet2.FindCheckedRow("chk"), arr, Row, newRow;
				if(chkRows && chkRows != null && chkRows != "") {
					arr = chkRows.split("|");
					arr.forEach(function(item, idx, arr) {
						Row = item;
						if( !isContainTargetPayActionCd(sheet2.GetCellValue(Row, "payActionCd")) ) {
							newRow = sheet1.DataInsert(0);
							sheet1.SetCellValue( newRow, "payActionCd",       payActionCd );
							sheet1.SetCellValue( newRow, "targetPayActionCd", sheet2.GetCellValue(Row, "payActionCd") );
							sheet1.SetCellValue( newRow, "targetPayActionNm", sheet2.GetCellValue(Row, "payActionNm") );
							sheet1.SetCellValue( newRow, "payYm",             sheet2.GetCellValue(Row, "payYm") );
							// 체크박스 선택 초기화
							sheet2.SetCellValue(Row, "chk", "N");
						}
					});
				} else {
					alert("등록대상 급여계산을 선택해주십시오.");
				}
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("sheet2 OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction2('Search'); } catch (ex) { alert("sheet2 OnSaveEnd Event Error " + ex); }
	}
</script>
<!-- // Sheet2  -->
</head>
<body class="bodywrap">
	<form name="sendForm" id="sendForm" method="post">
		<input id="searchPayActionCd" name="searchPayActionCd" type="hidden" />
	</form>
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>기간별정산시 대상 급여일자</li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<table class="sheet_main">
				<colgroup>
					<col width="*" />
					<col width="30px" />
					<col width="*" />
				</colgroup>
				<tr>
					<td>
						<form id="mySheetForm" name="mySheetForm">
							<input type="hidden" id="callPage"          name="callPage"          value="" />
							<input type="hidden" id="searchSabun"       name="searchSabun"       value="" />
							<input type="hidden" id="searchRunType"     name="searchRunType"     value="" />
							<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
							<input type="hidden" id="multiRunType"      name="multiRunType"      value="" />
							<div class="sheet_title inner">
								<ul>
									<li id="txt" class="txt">급여일자 조회</li>
									<li class="btn">
									<!--  급여구분  -->
										<span>급여구분 </span>
										<select id="searchPayCd" name="searchPayCd"></select>
									<!--  대상년월   -->
										<span class="mal10">대상년월 </span>
										<input id="searchMonthFrom" name="searchMonthFrom" type="text" class="date2" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-11)%>" />
										~
										<input id="searchMonthTo" name="searchMonthTo" type="text" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" />
									<!--  조회  -->
										<a href="javascript:doAction2('Search');" id="btnSearch" class="button">조회</a>
									</li>
								</ul>
							</div>
						</form>
						<script type="text/javascript">createIBSheet("sheet2", "50%", "100%","${ssnLocaleCd}"); </script>
					</td>
					<td align=center>
						<a href="javascript:doAction2('Insert');"><img src="/common/images/common/arrow_right1.gif"/></a>
					</td>
					<td>
						<div class="sheet_title inner">
							<ul>
								<li class="txt">기간별정산시 대상 급여일자</li>
								<li class="btn">
									<!-- 
									<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
									<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
									 -->
									<a href="javascript:doAction1('Clear')" 		class="basic authA">초기화</a>
									<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
									<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
								</li>
							</ul>
						</div>
						<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
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
</body>
</html>