<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수명세서 및 납부세액</title>
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
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:50, MergeSheet:msPrevColumnMerge+msHeaderOnly};
	initdata1.HeaderMode = {Sort:0, ColMove:1, ColResize:1, HeaderCheck:0, Hidden:1};
	initdata1.Cols = [
		{Header:"No|No",							Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
		{Header:"삭제|삭제",							Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },			
		{Header:"상태|상태",							Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
		{Header:"문서번호|문서번호",						Type:"Text",		Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"tax_doc_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"신고일자|신고일자",						Type:"Date",		Hidden:1,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"report_ymd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8 },
		{Header:"사업장|사업장",							Type:"Text",		Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"소득자\n신고구분|소득자\n신고구분",				Type:"Text",		Hidden:0,	Width:50,			Align:"Center",	ColMerge:1,	SaveName:"income_nm1",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,	Wrap:1 },
		{Header:"소득자\n신고구분|소득자\n신고구분",				Type:"Text",		Hidden:0,	Width:30,			Align:"Center",	ColMerge:1,	SaveName:"income_nm2",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,	Wrap:1 },
		{Header:"소득자\n신고구분|소득자\n신고구분",				Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"income_nm3",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,	Wrap:1 },
		{Header:"코드|코드",							Type:"Text",		Hidden:0,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"tax_ele_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"소득지급\n(과세미달,비과세포함)|4.인원",			Type:"Int",			Hidden:0,	Width:60,			Align:"Right",	ColMerge:0,	SaveName:"inwon_cnt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"소득지급\n(과세미달,비과세포함)|5.총지급액",		Type:"Int",			Hidden:0,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"payment_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"징수세액|6.소득세등",						Type:"Int",			Hidden:0,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"paye_itax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"징수세액|7.농특세",						Type:"Int",			Hidden:0,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"paye_atax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"징수세액|8.가산세",						Type:"Int",			Hidden:0,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"paye_addtax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"당월조정\n환급세액|당월조정\n환급세액",			Type:"Int",			Hidden:0,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"refund_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"납부할세액|10.소득세등",					Type:"Int",			Hidden:0,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"pay_itax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"납부할세액|11.농특세",					Type:"Int",			Hidden:0,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"pay_atax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"인원_여부|인원_여부",						Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"inwon_yn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"총지급액(여부)|총지급액(여부)",				Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"payment_mon_yn",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"징수세액_소득세등(여부)|징수세액_소득세등(여부)",	Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"paye_itax_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"징수세액_농특세(여부)|징수세액_농특세(여부)",		Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"paye_atax_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"징수세액_가산세_여부|징수세액_가산세_여부",		Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"paye_addtax_yn",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"당월조정환급세액(여부)|당월조정환급세액(여부)",		Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"refund_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"납부세액_소득세(가산세포함)(여부)|납부세액_소득세(가산세포함)(여부)",Type:"Text",Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"pay_itax_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"납부세액_농특세(여부)|납부세액_농특세(여부)",		Type:"Text",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"pay_atax_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
		{Header:"대상자\n확인|대상자\n확인",					Type:"Image",	Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"detail_list",		Cursor:"Pointer",		UpdateEdit:0,	EditLen:1 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
	sheet1.SetDataAlternateBackColor("#ffffff");
	
	sheet1.SetDataLinkMouse("detail_list", 1);
	sheet1.SetImageList(0,"<%=imagePath%>/icon/icon_popup.png");

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata2.HeaderMode = {Sort:0, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata2.Cols = [
		{Header:"No|No|No",								Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
		{Header:"삭제|삭제|삭제",							Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },			
		{Header:"상태|상태|상태",							Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
		{Header:"문서번호|문서번호|문서번호",					Type:"Text",		Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"tax_doc_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
		{Header:"신고일자|신고일자|신고일자",					Type:"Date",		Hidden:1,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"report_ymd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:8 },
		{Header:"사업장코드|사업장코드|사업장코드",				Type:"Text",		Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
		{Header:"전월 미환급세액의계산|12.전월\n미환급세액|12.전월\n미환급세액",			Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_12",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"전월 미환급세액의계산|13.기환급\n신청세액|13.기환급\n신청세액",			Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_13",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"전월 미환급세액의계산|14.차감잔액\n(12-13)|14.차감잔액\n(12-13)",	Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_14",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"당월발생환급세액|15.일반환급|15.일반환급",						Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_15",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"당월발생환급세액|16.신탁재산\n(금융기관)|16.신탁재산\n(금융기관)",		Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_16",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"당월발생환급세액|17.그밖의환급세액|금융회사등",						Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_17_1",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"당월발생환급세액|17.그밖의환급세액|합병등",						Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_17_2",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"18.조정대상\n환급세액\n(14+15+16+17)|18.조정대상\n환급세액\n(14+15+16+17)|18.조정대상\n환급세액\n(14+15+16+17)",Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_18",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"19.당월조정\n환급세액|19.당월조정\n환급세액|19.당월조정\n환급세액",								Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_19",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"20.차월이월\n환급세액\n(18-19)|20.차월이월\n환급세액\n(18-19)|20.차월이월\n환급세액\n(18-19)",	Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_20",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"21.환급신청액|21.환급신청액|21.환급신청액",												Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"amt_21",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	callSearch();
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

	if (sAction == "Search") {
		if (parent.$("#reportYmd").val() == "") {
			alert("신고일자를 확인하십시오.");
			return false;
		}
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

			$("#businessPlaceCd").val(parent.$("#businessPlaceCd").val());
			$("#taxDocNo").val(parent.$("#taxDocNo").val());
			$("#reportYmd").val(parent.$("#reportYmd").val());

			// 원천징수명세서 및 납부세액 조회
			sheet1.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab1List", $("#sheet1Form").serialize() );
			break;

		case "Save":
			sheet1.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab1");
			break;

		case "PrcP_CPN_ORIGIN_TAX_INS":
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

			if (confirm("자료생성시 기존 자료는 모두 삭제됩니다. \n자료생성을 하시겠습니까?")) {

				var taxDocNo		= parent.$("#taxDocNo").val();
				var businessPlaceCd	= parent.$("#businessPlaceCd").val();

				if ( businessPlaceCd == "%") businessPlaceCd = "ALL";
				
				// 자료생성
				var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=prcP_CPN_ORIGIN_TAX_INS", "taxDocNo="+taxDocNo+"&businessPlaceCd="+businessPlaceCd, false);
				/*
				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "0") {
						alert("자료생성 되었습니다.");
						// 프로시저 호출 후 재조회
						callSearch();
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("자료생성 오류입니다.");
				}
				*/
				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "1") {
						callSearch();
					} 
				} 			
			}
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;
	}
}

function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#taxDocNo").val(parent.$("#taxDocNo").val());
			$("#businessPlaceCd").val(parent.$("#businessPlaceCd").val());
			$("#reportYmd").val(parent.$("#reportYmd").val());

			// 원천징수명세서 및 납부세액 조회
			sheet2.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab1DtlList", $("#sheet1Form").serialize());
			break;

		case "Save":
			sheet2.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab1Dtl");
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

function callSave(sAction) {
	
	// 2016-09-19 YHCHOI ADD START
	// 마감여부 체크
	if (!chkClose(sAction)) {
		return;
	}
	// 2016-09-19 YHCHOI ADD END
	
	var modifyCnt = 0;
	var sheet1RowCnt = sheet1.RowCount();
	var sheet2RowCnt = sheet2.RowCount();

	for (var i = 2; i <= sheet1RowCnt; i++) {
		if(sheet1.GetCellValue(i, "sStatus") == "U"){
			modifyCnt++;
		}
	}
	if (modifyCnt > 0) {
		doAction1("Save");
	}

	modifyCnt = 0;
	for (var i = 3; i <= sheet2RowCnt+2; i++) {
		if(sheet2.GetCellValue(i, "sStatus") == "U"){
			modifyCnt++;
		}
	}
	if (modifyCnt > 0) {
		doAction2("Save");
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		var rowCnt = sheet1.RowCount();
		if (rowCnt > 1) {
			for (var i=sheet1.HeaderRows(); i<rowCnt+sheet1.HeaderRows(); i++) {
				if (sheet1.GetCellValue(i, "inwon_yn") != "Y") {
					sheet1.SetCellBackColor(i,"inwon_cnt","#F4F4F4");
					sheet1.SetCellEditable(i,"inwon_cnt", 0);
				}
				if (sheet1.GetCellValue(i, "payment_mon_yn") != "Y") {
					sheet1.SetCellBackColor(i,"payment_mon","#F4F4F4");
					sheet1.SetCellEditable(i,"payment_mon", 0);
				}
				if (sheet1.GetCellValue(i, "paye_itax_yn") != "Y") {
					sheet1.SetCellBackColor(i,"paye_itax_mon","#F4F4F4");
					sheet1.SetCellEditable(i,"paye_itax_mon", 0);
				}
				if (sheet1.GetCellValue(i, "paye_atax_yn") != "Y") {
					sheet1.SetCellBackColor(i,"paye_atax_mon","#F4F4F4");
					sheet1.SetCellEditable(i,"paye_atax_mon", 0);
				}
				if (sheet1.GetCellValue(i, "paye_addtax_yn") != "Y") {
					sheet1.SetCellBackColor(i,"paye_addtax_mon","#F4F4F4");
					sheet1.SetCellEditable(i,"paye_addtax_mon", 0);
				}
				if (sheet1.GetCellValue(i, "refund_yn") != "Y") {
					sheet1.SetCellBackColor(i,"refund_mon","#F4F4F4");
					sheet1.SetCellEditable(i,"refund_mon", 0);
				}
				if (sheet1.GetCellValue(i, "pay_itax_yn") != "Y") {
					sheet1.SetCellBackColor(i,"pay_itax_mon","#F4F4F4");
					sheet1.SetCellEditable(i,"pay_itax_mon", 0);
				}
				if (sheet1.GetCellValue(i, "pay_atax_yn") != "Y") {
					sheet1.SetCellBackColor(i,"pay_atax_mon","#F4F4F4");
					sheet1.SetCellEditable(i,"pay_atax_mon", 0);
				}
			}
		}

		if (Msg != "") {
			alert(Msg);
		}
		sheetResize();
	} catch (ex) {
		alert("sheet1 OnSearchEnd Event Error : " + ex);
	}
}


function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if(colName == "detail_list" && sheet1.GetCellValue(Row, "detail_list") != "") {
				// 상세대상자 팝업
				openEarnIncomeTaxMgrDtl1Tab1EmpPopup(Row);
			}
		}
	} catch (ex) {
		alert("OnClick Event Error : " + ex);
	}
}

//대상자 팝업
function openEarnIncomeTaxMgrDtl1Tab1EmpPopup(Row) {
	var w	= 700;
	var h	= 800;
	var url	= "";
	var args= new Array();

	url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl1Tab1EmpPopup.jsp";
	
	args["tax_doc_no"] 			= sheet1.GetCellValue(Row, "tax_doc_no");
	args["business_place_cd"] 	= sheet1.GetCellValue(Row, "business_place_cd");
	args["tax_ele_cd"] 			= sheet1.GetCellValue(Row, "tax_ele_cd");

	openPopup(url+"?authPg=<%=authPg%>", args, w, h);
}

function sheet1_OnChange(Row, Col, Value) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (Row > 1) {
			if (colName == "paye_itax_mon" || colName == "paye_addtax_mon" || colName == "refund_mon") {
				if (sheet1.GetCellEditable(Row, "pay_itax_mon") == 1) {
					// 납부할세액(소득세등) = 징수세액(소득세 ) + 징수세액(가산세) - 당월조정환급세액
					var payItaxMon = parseInt(parseIntCheck(sheet1.GetCellValue(Row, "paye_itax_mon"))) + parseInt(parseIntCheck(sheet1.GetCellValue(Row, "paye_addtax_mon"))) - parseInt(parseIntCheck(sheet1.GetCellValue(Row, "refund_mon")));
					sheet1.SetCellValue(Row, "pay_itax_mon", payItaxMon);
				}
			}

			if (colName == "inwon_cnt" || colName == "payment_mon" || colName == "paye_itax_mon" || colName == "paye_atax_mon" ||
				colName == "paye_addtax_mon" || colName == "refund_mon" || colName == "pay_itax_mon" || colName == "pay_atax_mon") {
				
				if(colName == "paye_atax_mon"){
					if(sheet1.GetCellEditable(Row, "pay_atax_mon") == "1"){
						sheet1.SetCellValue(Row, "pay_atax_mon", sheet1.GetCellValue(Row, "paye_atax_mon"));	
					}
					
				}
				
				// 2016-02-19 YHCHOI COMMENT OUT START
				//if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A01" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A02" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A03" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A04") {
				//	totSumStr("1", Col, colName);
				//} else 
				// 2016-02-19 YHCHOI COMMENT OUT END
				if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A25" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A26") {
					totSumStr("2", Col);
				} else if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A45" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A46" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A48") {
					totSumStr("3", Col);
				} else if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A21" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A22") {
					totSumStr("5", Col);
				} else if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A41" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A42") {
					totSumStr("6", Col);
				}
			}
			
			// 2016-02-19 YHCHOI ADD START
			if (colName == "inwon_cnt" || colName == "payment_mon") {
				if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A01" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A02" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A03" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A04"|| sheet1.GetCellValue(Row, "tax_ele_cd") == "A05"|| sheet1.GetCellValue(Row, "tax_ele_cd") == "A06") {
					totSumStr("1", Col, colName);
				}
			} else if (colName == "paye_itax_mon" || colName == "paye_atax_mon" ||
				colName == "paye_addtax_mon" || colName == "refund_mon" || colName == "pay_itax_mon" || colName == "pay_atax_mon") {
				
				if(colName == "paye_atax_mon"){
					if(sheet1.GetCellEditable(Row, "pay_atax_mon") == "1"){
						sheet1.SetCellValue(Row, "pay_atax_mon", sheet1.GetCellValue(Row, "paye_atax_mon"));	
					}
					
				}
				
				if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A01" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A02" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A03" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A06" || sheet1.GetCellValue(Row, "tax_ele_cd") == "A04"|| sheet1.GetCellValue(Row, "tax_ele_cd") == "A05") {
					totSumStr("1", Col, colName);
				}
			}
			// 2016-02-19 YHCHOI ADD END


			if (colName == "paye_itax_mon") {
				var a04Val = sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A04", 2), Col);
				var a05Val = sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A05", 2), Col);
				var a06Val = sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A06", 2), Col);

				// 6.소득세등 a04가 변경된 경우
				if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A04") {
					a05Val = 0;
					a06Val = a04Val;

					sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A05", 2), Col, a05Val);
					sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A06", 2), Col, a06Val);
				}
				// 6.소득세등 a05가 변경된 경우
				else if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A05") {
					a06Val = a04Val - a05Val;
					sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A06", 2), Col, a06Val);
				}
				// 6.소득세등 a06가 변경된 경우
				else if (sheet1.GetCellValue(Row, "tax_ele_cd") == "A06") {
					a05Val = a04Val - a06Val;
					sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A05", 2), Col, a05Val);
				}
			}
		}

		totSumStr("4", Col);

	} catch (ex) {
		alert("sheet1 OnChange Event Error : " + ex);
	}
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("sheet2 OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("sheet1 OnSaveEnd Event Error " + ex); }
}

// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("sheet2 OnSaveEnd Event Error " + ex); }
}


function sheet2_OnChange(Row, Col, Value) {
	try {
		var colName = sheet2.ColSaveName(Col);
		if (Row > 2) {
			var amtVal = 0;
			if (colName == "amt_12" || colName == "amt_13") {
				amtVal = parseInt(parseIntCheck(sheet2.GetCellValue(Row, "amt_12"))) - parseInt(parseIntCheck(sheet2.GetCellValue(Row, "amt_13")));
				sheet2.SetCellValue(Row, "amt_14", amtVal);
			}
			if (colName == "amt_14" || colName == "amt_15" || colName == "amt_16" || colName == "amt_17_1" || colName == "amt_17_2") {
				amtVal = parseInt(parseIntCheck(sheet2.GetCellValue(Row, "amt_14"))) + parseInt(parseIntCheck(sheet2.GetCellValue(Row, "amt_15"))) + parseInt(parseIntCheck(sheet2.GetCellValue(Row, "amt_16"))) + parseInt(parseIntCheck(sheet2.GetCellValue(Row, "amt_17_1"))) + parseInt(parseIntCheck(sheet2.GetCellValue(Row, "amt_17_2")));
				sheet2.SetCellValue(Row, "amt_18", amtVal);
			}
			if (colName == "amt_18" || colName == "amt_19") {
				amtVal = parseInt(parseIntCheck(sheet2.GetCellValue(Row, "amt_18"))) - parseInt(parseIntCheck(sheet2.GetCellValue(Row, "amt_19")));
				sheet2.SetCellValue(Row, "amt_20", amtVal);
			}
		}
	} catch (ex) {
		alert("sheet2 OnChange Event Error : " + ex);
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

// 음수 체크
function parseIntCheckMinus(value){
	if(value == ""){
		return 0;
	} else {
		if (parseInt(value) < 0) {
			return 0;
		}
		else {
			return value;
		}
	}
}

function totSumStr(gubun, Col, CN){
	switch (gubun) {
		case "1":
			var a10Val = 0;

			if(CN == "inwon_cnt" || CN == "payment_mon"){
				a10Val = parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A01", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A02", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A03", 2), Col)))
						//2016-02-19 YHCHOI 정기원천세 분납기능 추가
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A04", 2), Col)));
			}else if (CN == "paye_itax_mon") {
				a10Val = parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A01", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A02", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A03", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A06", 2), Col)));
			}

			// a10Val = parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A01", 2), Col)))
			// 		+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A02", 2), Col)))
			// 		+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A03", 2), Col)))
			// 		//2016-02-19 YHCHOI 정기원천세 분납기능 추가
			// 		+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A04", 2), Col)))
			// 		+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A05", 2), Col)))
			// 		+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A06", 2), Col)));

			sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A10", 2), Col, a10Val);
			
			break;

		case "2":
			var a30Val = 0;
			a30Val = parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A25", 2), Col)))
					+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A26", 2), Col)));

			sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A30", 2), Col, a30Val);
			break;

		case "3":
			var a47Val = 0;
			a47Val = parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A45", 2), Col)))
					+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A46", 2), Col)))
					+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A48", 2), Col)));

			sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A47", 2), Col, a47Val);
			break;
			
		case "5":
			var a20Val = 0;
			a20Val = parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A21", 2), Col)))
					+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A22", 2), Col)));

			sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A20", 2), Col, a20Val);
			break;
			
		case "6":
			var a40Val = 0;
			a40Val = parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A41", 2), Col)))
					+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A42", 2), Col)));

			sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A40", 2), Col, a40Val);
			break;

		case "4":
			var a99Val = 0;
			var colName = sheet1.ColSaveName(Col);
			if (colName == "payment_mon" || colName == "paye_itax_mon" || colName == "paye_atax_mon") {

				a99Val = parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A10", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A20", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A30", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A40", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A47", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A50", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A60", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A69", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A70", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A80", 2), Col))))
						+ parseInt(parseIntCheckMinus(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A90", 2), Col))));

			} else {
				a99Val = parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A10", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A20", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A30", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A40", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A47", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A50", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A60", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A69", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A70", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A80", 2), Col)))
						+ parseInt(parseIntCheck(sheet1.GetCellValue(sheet1.FindText("tax_ele_cd", "A90", 2), Col)));
			}

			sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", "A99", 2), Col, a99Val);
			break;
	}
}


function setValTab1(mTaxEleCd, colName, val) {
	sheet1.SetCellValue(sheet1.FindText("tax_ele_cd", mTaxEleCd, 2), colName, val);
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="taxDocNo" name="taxDocNo" value="" />
		<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" class="text" value="" />
		<input type="hidden" id="reportYmd" name="reportYmd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="sheet_title outer">
				<ul>
					<li class="txt">원천징수명세서 및 납부세액</li>
					<li class="btn">
						<a href="javascript:callSearch()"							class="button authR">조회</a>
						<a href="javascript:callSave('Save')"						class="basic authA">저장</a>
						<a href="javascript:doAction1('PrcP_CPN_ORIGIN_TAX_INS')"	class="basic authA">자료생성</a>
					</li>
				</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "460px"); </script>
			</td>
		</tr>
		<tr>
			<td height="8px"></td>
		</tr>
		<tr>
			<td>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "130px"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>