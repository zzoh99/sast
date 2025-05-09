<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <head> <title>원천징수세액환급신청서</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<!--
 * 원천징수이행상황신고서
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msPrevColumnMerge+msHeaderOnly};
	initdata1.HeaderMode = {Sort:0, ColMove:1, ColResize:1, HeaderCheck:0, Hidden:1,HeaderCheck:1};
	initdata1.Cols = [
		{Header:"No|No",					Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
		{Header:"삭제|삭제",					Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },			
		{Header:"상태|상태",					Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
		{Header:"문서번호|문서번호",				Type:"Text",		Hidden:1,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"tax_doc_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"사업장|사업장",					Type:"Text",		Hidden:1,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"귀속연월|귀속연월",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"belong_ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:6 },
		{Header:"지급연월|지급연월",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payment_ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:6 },
		{Header:"신고구분|신고구분",				Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"origin_rpt_type",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"세목코드|세목코드",				Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"income_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"발생환급세액\n(1)|발생환급세액\n(1)",		Type:"AutoSum",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"amt_1",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"같은세목의 납부할세액\n(2)|같은세목의 납부할세액\n(2)",	Type:"AutoSum",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"amt_2",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"당월발생환급세액\n(1)-(2)|당월발생환급세액\n(1)-(2)",	Type:"AutoSum",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"amt_3",	CalcLogic:"|amt_1|-|amt_2|", KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msPrevColumnMerge+msHeaderOnly};
	initdata2.HeaderMode = {Sort:0, ColMove:1, ColResize:1, HeaderCheck:0, Hidden:1,HeaderCheck:1};
	initdata2.Cols = [
		{Header:"No|No",					Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
		{Header:"삭제|삭제",					Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },			
		{Header:"상태|상태",					Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
		{Header:"문서번호|문서번호",				Type:"Text",		Hidden:1,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"tax_doc_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"사업장|사업장",					Type:"Text",		Hidden:1,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"seq|seq",					Type:"Int",			Hidden:1,					Width:10,			Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"귀속연월|귀속연월",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"belong_ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:6 },
		{Header:"지급연월|지급연월",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payment_ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:6 },
		{Header:"전월미환급액|전월미환급(4)",		Type:"AutoSum",		Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_4",			KeyField:0,	Format:"Integer",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"전월미환급액|기환급세액(5)",		Type:"AutoSum",		Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_5",			KeyField:0,	Format:"Integer",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"전월미환급액|차감세액(6)",			Type:"AutoSum",		Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_6",			KeyField:0,	Format:"Integer",	CalcLogic:"|amt_4|-|amt_5|",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"당월발생환급\n(7)|당월발생환급\n(7)",		Type:"AutoSum",		Hidden:0,			Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_7",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"조정대상환급\n(8)|조정대상환급\n(8)",		Type:"AutoSum",		Hidden:0,			Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_8",	KeyField:0,	Format:"Integer",	CalcLogic:"|amt_6|+|amt_7|",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"당월조정환급\n(9)|당월조정환급\n(9)",		Type:"AutoSum",		Hidden:0,			Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_9",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"차월이월환급\n(10)|차월이월환급\n(10)",		Type:"AutoSum",		Hidden:0,			Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_10",	KeyField:0,	Format:"Integer",	CalcLogic:"|amt_8|-|amt_9|", PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	
	//------------------------------------- 그리드 콤보 -------------------------------------//
	
	var incomeCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+parent.$("#belongYm").val(), "C00599") , "전체");
	sheet1.SetColProperty("income_cd", {ComboText:"|"+incomeCd[0], ComboCode:"|"+incomeCd[1]});
	
	var originRptType = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+parent.$("#belongYm").val(), "C00597") , "");
	sheet1.SetColProperty("origin_rpt_type", {ComboText:"|"+originRptType[0], ComboCode:"|"+originRptType[1]});
	
	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
	doAction2("Search");
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if (parent.$("#taxDocNo").val() == "") {
		alert("문서번호를 확인하십시오.");
		return false;
	}
	if (parent.$("#businessPlaceCd").val() == "") {
		alert("급여사업장코드를 확인하십시오.");
		return false;
	}

	return true;
}

//2016-09-19 YHCHOI ADD START
//마감여부 체크
function chkClose(sAction) {
	if (parent.$("#closeYn").val() == "Y" || parent.$("#closeYn").val() == "1") {
		alert("이미 마감된 자료입니다.");
		return false;
	}
	
	return true;
}
//2016-09-19 YHCHOI ADD END

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#reportYmd").val(parent.$("#reportYmd").val());
			$("#taxDocNo").val(parent.$("#taxDocNo").val());
			$("#businessPlaceCd").val(parent.$("#businessPlaceCd").val());

			// 원천징수세액환급신청서 조회
			sheet1.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab5List943", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			// 중복체크
			if(!dupChk(sheet1, "tax_doc_no|business_place_cd|belong_ym|payment_ym|origin_rpt_type|income_cd", false, true)) {break;}
			sheet1.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab5List943");
			break;
			

		case "Insert":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			var Row = sheet1.DataInsert(-1);
			sheet1.SetCellValue(Row, "tax_doc_no", parent.$("#taxDocNo").val());
			sheet1.SetCellValue(Row, "business_place_cd", parent.$("#businessPlaceCd").val());
			if(Row-1 > 1) {
				sheet1.SetCellValue(Row, "belong_ym", sheet1.GetCellValue(Row-1, "belong_ym"));	
				sheet1.SetCellValue(Row, "payment_ym", sheet1.GetCellValue(Row-1, "payment_ym"));
				sheet1.SetCellEditable(Row, "belong_ym",0);
				sheet1.SetCellEditable(Row, "payment_ym",0);
			}
			
			sheet1.SelectCell(Row, 2);
			break;
			
		case "Copy":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;
	}
}

var msgYn = "Y";

function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#reportYmd").val(parent.$("#reportYmd").val());
			$("#taxDocNo").val(parent.$("#taxDocNo").val());
			$("#businessPlaceCd").val(parent.$("#businessPlaceCd").val());

			// 원천징수세액환급신청서 조회
			sheet2.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab5List944", $("#sheet1Form").serialize());
			break;
			
		case "Save":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			// 중복체크
			//if(!dupChk(sheet2, "tax_doc_no|business_place_cd|tax_ele_cd", false, true)) {break;}
			msgYn = "Y";
			sheet2.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab5List944");
			break;
			

		case "Insert":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if(sheet2.RowCount() == 0) {
				alert("전월미환급세액 내역이 존재하여야 합니다.");
				return;	
			}
			
			var Row = sheet2.DataInsert(-1);
			
			sheet2.SetCellValue(Row, "tax_doc_no", parent.$("#taxDocNo").val());
			sheet2.SetCellValue(Row, "business_place_cd", parent.$("#businessPlaceCd").val());
			if(Row-1 > 1) {
				sheet2.SetCellValue(Row, "belong_ym", sheet2.GetCellValue(Row-1, "belong_ym"));	
				sheet2.SetCellValue(Row, "payment_ym", sheet2.GetCellValue(Row-1, "payment_ym"));
				sheet2.SetCellValue(Row, "amt_4", sheet2.GetCellValue(Row-1, "amt_10"));
				sheet2.SetCellValue(Row, "seq", parseInt(sheet2.GetCellValue(Row-1, "seq"))+1);
				sheet1.SetCellEditable(Row, "amt_4",1);
				sheet1.SetCellEditable(Row, "amt_5",1);
			}			
			sheet2.SelectCell(Row, 2);
			break;

		case "Copy":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			var Row = sheet2.DataCopy();
			sheet2.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet2.RemoveAll();
			break;
	}
}


function callSearch() {
	doAction1("Search");
	doAction2("Search");
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		doAction2("Search");
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnChange(Row, Col, Value) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (Row > 1) {
			if(colName == "amt_1" || colName == "amt_2") {
				if(parseInt(sheet1.GetCellValue(Row, colName)) < 0) {
					sheet1.SetCellValue(Row, colName, 0);
					alert("양수만 입력 가능합니다.");
				}
			}
		}
	} catch (ex) {
		alert("OnChange Event Error : " + ex);
	}
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } 
		sheetResize();
		if(sheet2.RowCount() > 0) {
			sheet2.SetCellEditable(2, "amt_4",0);
			sheet2.SetCellEditable(2, "amt_5",0);
		}
		
		var dataRows = sheet2.RowCount() + sheet2.HeaderRows();
		for(var i = sheet2.HeaderRows()+1 ; i <= dataRows ; i++) {
			sheet2.SetCellValue(i, "amt_4", sheet2.GetCellValue(i-1, "amt_10"));
		}
		//상태가 수정인 데이타가 있으면 Save메서드 실행
		if(sheet2.RowCount("U") > 0) {
			sheet2.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab5List944", "", -1, 0);
		}
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "" && msgYn == "Y") { 
			alert(Msg); 
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet2_OnChange(Row, Col, Value) {
	try {
		var colName = sheet2.ColSaveName(Col);
		if (Row > 1) {
			if(colName == "amt_4"||colName == "amt_5"||colName == "amt_7"||colName == "amt_9") {
				if(colName == "amt_4"||colName == "amt_5") {
					if(parseInt(sheet2.GetCellValue(Row, "amt_6")) < 0) {
						sheet2.SetCellValue(Row, "amt_5", 0);
						alert("기환급세액이 전월미환급액을 초과하였습니다.");
					}
				}
				if(colName == "amt_7") {
					if(parseInt(sheet2.GetCellValue(Row, "amt_8")) < 0) {
						sheet2.SetCellValue(Row, colName, 0);
						alert("조정대상환급액이 음수입니다.");
					}
				}			
				if(colName == "amt_9") {
					if(parseInt(sheet2.GetCellValue(Row, "amt_10")) < 0) {
						sheet2.SetCellValue(Row, colName, 0);
						alert("당월조정환급이 조정대상환급액을 초과하였습니다.");
					}
				}
				//alert(sheet2.GetCellValue(Row+1, "amt_4"));
				var dataRows = sheet2.RowCount() + sheet2.HeaderRows();
				for(var i = Row+1 ; i <= dataRows ; i++) {
					sheet2.SetCellValue(i, "amt_4", sheet2.GetCellValue(i-1, "amt_10"));
				}
			}
		}
	} catch (ex) {
		alert("OnChange Event Error : " + ex);
	}
}

// 빈값 체크
function parseIntCheck(value){
	if(value == ""){
		return 0;
	} else {
		return value;
	}
}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="taxDocNo" name="taxDocNo" value="" />
		<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" class="text" value="" />
		<input type="hidden" id="reportYmd" name="reportYmd" value="" />
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="sheet_title outer">
				<ul>
					<li class="txt">환급신청서 전월미환급세액 내역</li>
					<li class="btn">
						<a href="javascript:doAction1('Search')"	class="button">조회</a>
						<a href="javascript:doAction1('Insert')"	class="basic authA">입력</a>
						<a href="javascript:doAction1('Copy')"		class="basic authA">복사</a>
						<a href="javascript:doAction1('Save')"		class="basic authA">저장</a>
					</li>
				</ul>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "240px"); </script>
			</td>
		</tr>
	</table>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="sheet_title outer">
				<ul>
					<li class="txt">환급세액 조정 현황</li>
					<li class="btn">
						<a href="javascript:doAction2('Search')"	class="button">조회</a>
						<a href="javascript:doAction2('Insert')"	class="basic authA">입력</a>
						<a href="javascript:doAction2('Copy')"		class="basic authA">복사</a>
						<a href="javascript:doAction2('Save')"		class="basic authA">저장</a>
					</li>
				</ul>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "400px"); </script>
			</td>
		</tr>
	</table>
	</form>
</div>
</body>
</html>