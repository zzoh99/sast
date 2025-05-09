<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html>
<html class="hidden">
<head>
<title>원천징수이행상황신고서 부표</title>
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
    initdata1.HeaderMode = {Sort:0, ColMove:1, ColResize:1, HeaderCheck:0, Hidden:1};	
	initdata1.Cols = [
        {Header:"No|No",					Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
      	{Header:"삭제|삭제",					Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },			
      	{Header:"상태|상태",					Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
		{Header:"문서번호|문서번호",					Type:"Text",		Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"tax_doc_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"신고일자|신고일자",					Type:"Text",		Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"report_ymd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"사업장|사업장",						Type:"Text",		Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"소득자\n신고구분|소득자\n신고구분",			Type:"Text",		Hidden:0,	Width:60,			Align:"Left",	ColMerge:1,	SaveName:"income_nm1",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,	Wrap:1 },
		{Header:"소득자\n신고구분|소득자\n신고구분",			Type:"Text",		Hidden:0,	Width:60,			Align:"Left",	ColMerge:1,	SaveName:"income_nm2",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,	Wrap:1 },
		{Header:"소득자\n신고구분|소득자\n신고구분",			Type:"Text",		Hidden:0,	Width:60,			Align:"Left",	ColMerge:1,	SaveName:"income_nm3",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,	Wrap:1 },
		{Header:"소득자\n신고구분|소득자\n신고구분",			Type:"Text",		Hidden:0,	Width:120,			Align:"Left",	ColMerge:0,	SaveName:"income_nm4",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,	Wrap:1 },
		{Header:"코드|코드",						Type:"Text",		Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"tax_ele_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"소득지급|인원",						Type:"Int",			Hidden:0,	Width:60,			Align:"Right",	ColMerge:0,	SaveName:"inwon_cnt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"소득지급|총지급액",					Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"payment_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"징수세액|소득세등",					Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"paye_itax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"징수세액|농어촌\n특별세",				Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"paye_atax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"징수세액|가산세",						Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"paye_addtax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"조정\n환급세액|조정\n환급세액",				Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"refund_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"납부세액|소득세등\n(가산세)",			Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"pay_itax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"납부세액|농어촌\n특별세",				Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"pay_atax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"본표합계대상|본표합계대상",				Type:"Text",		Hidden:1,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"m_tax_ele_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"부표합계대상|부표합계대상",				Type:"Text",		Hidden:1,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"att_tax_ele_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"인원_여부|인원_여부",					Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"inwon_yn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"총지급액(여부)|총지급액(여부)",			Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"payment_mon_yn",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"징수세액_소득세등(여부)|징수세액_소득세등(여부)",Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"paye_itax_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"징수세액_농특세(여부)|징수세액_농특세(여부)",	Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"paye_atax_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"징수세액_가산세_여부|징수세액_가산세_여부",	Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"paye_addtax_yn",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"당월조정환급세액(여부)|당월조정환급세액(여부)",	Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"refund_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"납부세액_소득세(가산세포함)(여부)|납부세액_소득세(가산세포함)(여부)",Type:"Text",Hidden:1,Width:40,			Align:"Center",	ColMerge:0,	SaveName:"pay_itax_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"납부세액_농특세(여부)|납부세액_농특세(여부)",	Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"pay_atax_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
	sheet1.SetDataAlternateBackColor("#ffffff");
	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
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
	if (parent.$("#reportYmd").val() == "") {
		alert("신고일자를 확인하십시오.");
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

			$("#taxDocNo").val(parent.$("#taxDocNo").val());
			$("#businessPlaceCd").val(parent.$("#businessPlaceCd").val());
			$("#reportYmd").val(parent.$("#reportYmd").val());

			// 원천징수이행상황신고서 조회
			sheet1.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab2List", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			// 원천징수명세서 및 납부세액 TAB의 저장 쿼리 사용
			sheet1.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab1");
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			var rowCnt = sheet1.RowCount();

			if (rowCnt > 1) {
				for (var i = sheet1.HeaderRows(); i < rowCnt
						+ sheet1.HeaderRows(); i++) {
					if (sheet1.GetCellValue(i, "inwon_yn") != "Y") {
						sheet1.SetCellBackColor(i, "inwon_cnt", "#F4F4F4");
						sheet1.SetCellEditable(i, "inwon_cnt", 0);
					}
					if (sheet1.GetCellValue(i, "payment_mon_yn") != "Y") {
						sheet1.SetCellBackColor(i, "payment_mon", "#F4F4F4");
						sheet1.SetCellEditable(i, "payment_mon", 0);
					}
					if (sheet1.GetCellValue(i, "paye_itax_yn") != "Y") {
						sheet1.SetCellBackColor(i, "paye_itax_mon", "#F4F4F4");
						sheet1.SetCellEditable(i, "paye_itax_mon", 0);
					}
					if (sheet1.GetCellValue(i, "paye_atax_yn") != "Y") {
						sheet1.SetCellBackColor(i, "paye_atax_mon", "#F4F4F4");
						sheet1.SetCellEditable(i, "paye_atax_mon", 0);
					}
					if (sheet1.GetCellValue(i, "paye_addtax_yn") != "Y") {
						sheet1
								.SetCellBackColor(i, "paye_addtax_mon",
										"#F4F4F4");
						sheet1.SetCellEditable(i, "paye_addtax_mon", 0);
					}
					if (sheet1.GetCellValue(i, "refund_yn") != "Y") {
						sheet1.SetCellBackColor(i, "refund_mon", "#F4F4F4");
						sheet1.SetCellEditable(i, "refund_mon", 0);
					}
					if (sheet1.GetCellValue(i, "pay_itax_yn") != "Y") {
						sheet1.SetCellBackColor(i, "pay_itax_mon", "#F4F4F4");
						sheet1.SetCellEditable(i, "pay_itax_mon", 0);
					}
					if (sheet1.GetCellValue(i, "pay_atax_yn") != "Y") {
						sheet1.SetCellBackColor(i, "pay_atax_mon", "#F4F4F4");
						sheet1.SetCellEditable(i, "pay_atax_mon", 0);
					}
				}
			}

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
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try {
			var colName = sheet1.ColSaveName(Col);
			if (Row > 1) {

				var mTaxEleCd = sheet1.GetCellValue(Row, "m_tax_ele_cd");
				var attTaxEleCd = sheet1.GetCellValue(Row, "att_tax_ele_cd");
				var mTaxEleCdSum = 0;
				var attTaxEleCdSum = 0;

				if (colName == "inwon_cnt" || colName == "payment_mon"
						|| colName == "paye_itax_mon"
						|| colName == "paye_atax_mon"
						|| colName == "paye_addtax_mon"
						|| colName == "refund_mon" || colName == "pay_itax_mon"
						|| colName == "pay_atax_mon") {

					var rowCnt = sheet1.RowCount();

					if (attTaxEleCd != "") {
						for (var i = 2; i <= rowCnt; i++) {
							if (attTaxEleCd == sheet1.GetCellValue(i,
									"att_tax_ele_cd")) {
								attTaxEleCdSum = attTaxEleCdSum
										+ parseInt(parseIntCheck(sheet1
												.GetCellValue(i, colName)));
							}
						}

						sheet1.SetCellValue(sheet1.FindText("tax_ele_cd",
								attTaxEleCd, 2), colName, attTaxEleCdSum);
					}

					if (mTaxEleCd != "") {
						for (var i = 2; i <= rowCnt; i++) {
							if (mTaxEleCd == sheet1.GetCellValue(i,
									"m_tax_ele_cd")) {
								mTaxEleCdSum = mTaxEleCdSum
										+ parseInt(parseIntCheck(sheet1
												.GetCellValue(i, colName)));
							}
						}

						// 원천징수명세서 및 납부세액 TAB에 값 셋팅
						parent.setValTab1(mTaxEleCd, colName, mTaxEleCdSum); 
					}
				}
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	// 빈값 체크
	function parseIntCheck(value) {
		if (value == "") {
			return 0;
		} else {
			return value;
		}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form">
			<input type="hidden" id="taxDocNo" name="taxDocNo" value="" /> <input
				type="hidden" id="businessPlaceCd" name="businessPlaceCd"
				class="text" value="" /> <input type="hidden" id="reportYmd"
				name="reportYmd" value="" />
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="sheet_title outer">
						<ul>
							<li class="txt">원천징수이행상황신고서</li>
							<li class="btn"><a href="javascript:doAction1('Search')"
								class="button authR">조회</a> <a
								href="javascript:doAction1('Save')" class="basic authA">저장</a></li>
						</ul>
					</div> <script type="text/javascript">
						createIBSheet("sheet1", "100%", "580px");
					</script>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>