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
		{Header:"소득구분|소득구분",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"income_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"소득종류|소득종류",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"tax_ele_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"귀속연월|귀속연월",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"belong_ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:6 },
		{Header:"지급연월|지급연월",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payment_ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:6 },
		{Header:"인원|인원",					Type:"AutoSum",			Hidden:0,					Width:50,			Align:"Right",	ColMerge:0,	SaveName:"inwon_cnt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"총지급액|총지급액",				Type:"AutoSum",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"payment_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"징수세액|소득세등",				Type:"AutoSum",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"paye_itax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"징수세액|농특세",				Type:"AutoSum",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"paye_atax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"징수세액|가산세",				Type:"AutoSum",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"paye_addtax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
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
		{Header:"소득구분|소득구분",				Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"income_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
		{Header:"사번|사번",					Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
		{Header:"성명|성명",					Type:"Popup",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
		{Header:"주민번호|주민번호",				Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"res_no",			KeyField:1,	Format:"IdNo",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
		{Header:"seq|seq",					Type:"Int",			Hidden:1,					Width:10,			Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"주/현(종/전)근무지|구분",			Type:"Combo",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"ty_gubun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
		{Header:"주/현(종/전)근무지|근무지명",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"enter_nm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"주/현(종/전)근무지|사업자등록번호",	Type:"Text",		Hidden:0,					Width:80,			Align:"Left",	ColMerge:0,	SaveName:"enter_no",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"주/현(종/전)근무지|소득세등",		Type:"AutoSum",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"paye_itax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"주/현(종/전)근무지|농특세",		Type:"AutoSum",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"paye_atax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);
	
	var initdata3 = {};
	initdata3.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msPrevColumnMerge+msHeaderOnly};
	initdata3.HeaderMode = {Sort:0, ColMove:1, ColResize:1, HeaderCheck:0, Hidden:1,HeaderCheck:1};
	initdata3.Cols = [
		{Header:"No|No",					Type:"<%=sNoTy%>",  Hidden:1,   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
		{Header:"삭제|삭제",					Type:"<%=sDelTy%>",	Hidden:1,	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },			
		{Header:"상태|상태",					Type:"<%=sSttTy%>",	Hidden:1,  	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
		{Header:"문서번호|문서번호",				Type:"Text",		Hidden:1,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"tax_doc_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"사업장|사업장",					Type:"Text",		Hidden:1,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"소득세등|소득세등 합계",			Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_1",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"소득세등|주소득세 합계",			Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_3",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"소득세등|차이금액",				Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_3_1",	CalcLogic:"|amt_3|-|amt_1|",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"농어촌특별세|농특세 합계",			Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_2",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"농어촌특별세|주농특세 합계",			Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_4",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"농어촌특별세|차이금액",			Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"amt_4_2",	CalcLogic:"|amt_4|-|amt_2|",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사유|중퇴",					Type:"CheckBox",	Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"reason_1_yn",	TrueValue:"Y", FalseValue:"N", KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },		
		{Header:"사유|전입",					Type:"CheckBox",	Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"reason_2_yn",	TrueValue:"Y", FalseValue:"N", KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"사유|전출",					Type:"CheckBox",	Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"reason_3_yn",	TrueValue:"Y", FalseValue:"N", KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"사유|합병",					Type:"CheckBox",	Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"reason_4_yn",	TrueValue:"Y", FalseValue:"N", KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"사유|기타",					Type:"CheckBox",	Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"reason_5_yn",	TrueValue:"Y", FalseValue:"N", KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"사유|사유내용",					Type:"Text",		Hidden:1,					Width:80,			Align:"Left",	ColMerge:0,	SaveName:"reason_memo",	TrueValue:"Y", FalseValue:"N", KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 }
	]; IBS_InitSheet(sheet3, initdata3); sheet3.SetCountPosition(0);
	
	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 원천세항목(TCPN911)
	var tcpn911Cd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&reportYmd="+parent.$("#reportYmd").val(), "getTcpn911List") , "");
	sheet1.SetColProperty("tax_ele_cd", {ComboText:"|"+tcpn911Cd[0], ComboCode:"|"+tcpn911Cd[1]});
	
	var incomeCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+parent.$("#belongYm").val(), "C00599") , "전체");
	sheet1.SetColProperty("income_cd", {ComboText:"|"+incomeCd[0], ComboCode:"|"+incomeCd[1]});
	sheet2.SetColProperty("income_cd", {ComboText:"|"+incomeCd[0], ComboCode:"|"+incomeCd[1]});
	
	var tyGubun = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+parent.$("#belongYm").val(), "C00598") , "");
	sheet2.SetColProperty("ty_gubun", {ComboText:"|"+tyGubun[0], ComboCode:"|"+tyGubun[1]});
	
	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
	doAction2("Search");
	doAction3("Search");
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
			sheet1.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab4List940", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			// 중복체크
			//if(!dupChk(sheet1, "tax_doc_no|business_place_cd|tax_ele_cd", false, true)) {break;}
			sheet1.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab4List940");
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

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "tax_doc_no", parent.$("#taxDocNo").val());
			sheet1.SetCellValue(Row, "business_place_cd", parent.$("#businessPlaceCd").val());
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
			sheet2.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab4List941", $("#sheet1Form").serialize());
			break;

		case "PrcP_CPN_ORIGIN_TAX_GI_PAY_INS":
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
				var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=prcP_CPN_ORIGIN_TAX_GI_PAY_INS", "taxDocNo="+taxDocNo+"&businessPlaceCd="+businessPlaceCd, false);
				
				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "1") {
						callSearch();
					} 
				} 			
			}
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
			sheet2.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab4List941");
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

			var Row = sheet2.DataInsert(0);
			/*
			var seq = 1;
			for(var i = sheet2.HeaderRows() ; i <= sheet2.RowCount(); i++) {
				alert(sheet2.GetCellValue(i, "seq"));
			}
			*/
			sheet2.SetCellValue(Row, "tax_doc_no", parent.$("#taxDocNo").val());
			sheet2.SetCellValue(Row, "business_place_cd", parent.$("#businessPlaceCd").val());
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
			
        case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;			
	}
}

function doAction3(sAction) {
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
			sheet3.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab4List942", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			// 중복체크
			//if(!dupChk(sheet3, "tax_doc_no|business_place_cd|tax_ele_cd", false, true)) {break;}
			var reason_txt = $("#reasonTxt").val();
			sheet3.SetCellValue(sheet3.GetSelectRow(), "reason_memo", reason_txt);
			sheet3.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab4List942");
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

			var Row = sheet3.DataInsert(0);
			sheet3.SetCellValue(Row, "tax_doc_no", parent.$("#taxDocNo").val());
			sheet3.SetCellValue(Row, "business_place_cd", parent.$("#businessPlaceCd").val());
			sheet3.SelectCell(Row, 2);
			break;

		case "Copy":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			var Row = sheet3.DataCopy();
			sheet3.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet3.RemoveAll();
			break;
	}
}

function callSearch() {
	doAction1("Search");
	doAction2("Search");
	doAction3("Search");
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		doAction3("Search");
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnChange(Row, Col, Value) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (Row > 1) {
			
		}
	} catch (ex) {
		alert("OnChange Event Error : " + ex);
	}
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		  doAction3("Search");
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 팝업 클릭시 발생
function sheet2_OnPopupClick(Row,Col) {
	try {
		if(sheet2.ColSaveName(Col) == "name") {
			openOwnerPopup(Row) ;
		}
	} catch(ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}
function sheet2_OnChange(Row, Col, Value) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (Row > 1) {
			
		}
	} catch (ex) {
		alert("OnChange Event Error : " + ex);
	}
}

//조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { alert(Msg); }
		if(sheet3.GetSelectRow() > 0) {
			$("#reasonTxt").val(sheet3.GetCellValue(sheet3.GetSelectRow(), "reason_memo"));
		}
		sheetResize(); 
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet3_OnChange(Row, Col, Value) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (Row > 1) {
			
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

var gPRow  = "";
var pGubun = "";

// 사원 조회
function openOwnerPopup(Row){
    try{
    	gPRow  = Row;
		pGubun = "ownerPopup";
	    var args    = new Array();
	    args["ownerOnlyYn"] = "N";
	    args["earnerCd"]= "";
	    var rv = openPopup("<%=jspPath%>/common/ownerPopup.jsp?authPg=<%=authPg%>", args, "740","520");
    } catch(ex) {
    	alert("Open Popup Event Error : " + ex);
    }
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{'+ returnValue+'}');
	if ( pGubun == "ownerPopup" ){
		sheet2.SetCellValue(gPRow, "name", 		rv["name"] );
		sheet2.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
		sheet2.SetCellValue(gPRow, "res_no", 	rv["res_no"] );
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
					<li class="txt">원천징수신고 납부현황</li>
					<li class="btn">
						<a href="javascript:doAction1('Search')"		class="button">조회</a>
						<a href="javascript:doAction1('Insert')"	class="basic authA">입력</a>
						<a href="javascript:doAction1('Copy')"		class="basic authA">복사</a>
						<a href="javascript:doAction1('Save')"		class="basic authA">저장</a>
					</li>
				</ul>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "180px"); </script>
			</td>
		</tr>
	</table>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="sheet_title outer">
				<ul>
					<li class="txt">지급명세서 기납부세액 현황</li>
					<li class="btn">
						<a href="javascript:doAction2('PrcP_CPN_ORIGIN_TAX_GI_PAY_INS')"		class="pink authA">자료생성</a>					
						<a href="javascript:doAction2('Search');"	class="button">조회</a>
						<a href="javascript:doAction2('Insert')"	class="basic authA">입력</a>
						<a href="javascript:doAction2('Save')"		class="basic authA">저장</a>
						<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a>
					</li>
				</ul>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "180px"); </script>
			</td>
		</tr>
	</table>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="sheet_title outer">
				<ul>
					<li class="txt">기납부세액 차이 조정 현황</li>
					<li class="btn">
						<a href="javascript:doAction3('Search');"	class="button">조회</a>
						<a href="javascript:doAction3('Save')"		class="basic authA">저장</a>
					</li>
				</ul>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "100%", "90px"); </script>
			</td>
		</tr>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<tr>
			<th style="width: 10%"> 사 유 </th>
			<td>
				<textarea id="reasonTxt" name="reasonTxt" rows="4" style="width: 100%"></textarea>
			</td>
		</tr>
	</table>
	</form>
</div>
</body>
</html>