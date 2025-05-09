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
		{Header:"귀속연월|귀속연월",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"belong_ym",		KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
		{Header:"지급연월|지급연월",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payment_ym",		KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
		{Header:"인원|인원",					Type:"Int",			Hidden:0,					Width:50,			Align:"Right",	ColMerge:0,	SaveName:"inwon_cnt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"소득지급액|소득지급액",			Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"taxable_pay_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"결정세액|결정세액",				Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"fin_tot_tax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"기납부 원천세액|계",				Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"gi_tot_tax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"기납부 원천세액|기납부세액\n(주,현)",	Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"curr_tot_tax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"기납부 원천세액|기납부세액\n(종,전)",	Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"pre_tot_tax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"차감\n세액|차감\n세액",	    	Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"blc_tot_tax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"분납\n금액|분납\n금액",	    	Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"ins_tot_tax_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"조정환급\n세액|조정환급\n세액",		Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"refund_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"환급\n신청액|환급\n신청액",		Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"refund_req_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 원천세항목(TCPN911)
	var tcpn911Cd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&reportYmd="+parent.$("#reportYmd").val(), "getTcpn911List") , "");
	sheet1.SetColProperty("tax_ele_cd", {ComboText:"|"+tcpn911Cd[0], ComboCode:"|"+tcpn911Cd[1]});
	var incomeCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+parent.$("#belongYm").val(), "C00599") , "전체");
	sheet1.SetColProperty("income_cd", {ComboText:"|"+incomeCd[0], ComboCode:"|"+incomeCd[1]});

	var bankCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+parent.$("#belongYm").val(), "H30001") , "");
	$("#bankCd").html(bankCd[2]);
	
	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
	doAction1("BankInfoSearch");
	
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
			sheet1.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab3List", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			// 중복체크
			if(!dupChk(sheet1, "tax_doc_no|business_place_cd|tax_ele_cd", false, true)) {break;}
			sheet1.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab3");
			break;
			
		case "BankInfoSearch":

			// 예입처 정보 조회
			var bankInfo = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl1Tab3BankInfo", $("#sheet1Form").serialize(), false);

			$("#bankCd").val("");
			$("#accountNo").val("");

			if(bankInfo.Data != null) {
				bankInfo = bankInfo.Data;
				$("#bankCd").val(bankInfo.bank_cd);
				$("#accountNo").val(bankInfo.account_no);
			}
			break;
			
		case "SaveBankInfo":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END
			
			var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl1Tab3BankInfo",$("#sheet1Form").serialize(),false);
			if (result && result.Result) {
				if (result.Result.Code > 0) {
					alert("저장되었습니다.");
				}
			}
			
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

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnChange(Row, Col, Value) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (Row > 1) {
			 
			var blcTotTaxMon = 0;
			var giTotTaxMon = 0;
			var refundReqMon = 0;

			if (colName == "fin_tot_tax_mon" || 
				colName == "curr_tot_tax_mon"||
				colName == "pre_tot_tax_mon" ||
				colName == "ins_tot_tax_mon" ||
				colName == "refund_mon"
			) {
				if(parseInt(sheet1.GetCellValue(Row, colName)) < 0) {
					alert("양수만 입력 가능합니다. : " + parseInt(sheet1.GetCellValue(Row, colName)));
					sheet1.SetCellValue(Row, colName, 0);
					return;
				} else {
					//기납부원천세액 계산
					//if(colName == "curr_tot_tax_mon" || colName == "pre_tot_tax_mon" ) {
						var gi_tot_tax_mon = parseInt(sheet1.GetCellValue(Row, "curr_tot_tax_mon"))+parseInt(sheet1.GetCellValue(Row, "pre_tot_tax_mon"));
						var fin_tot_tax_mon = parseInt(sheet1.GetCellValue(Row, "fin_tot_tax_mon"));
						var refund_mon = parseInt(sheet1.GetCellValue(Row, "refund_mon"));
						var ins_tot_tax_mon = parseInt(sheet1.GetCellValue(Row, "ins_tot_tax_mon"));
						
						//기납부세액 계
						sheet1.SetCellValue(Row, "gi_tot_tax_mon", gi_tot_tax_mon);
						//차감세액
						var blc_tot_tax_mon = fin_tot_tax_mon - gi_tot_tax_mon;
						sheet1.SetCellValue(Row, "blc_tot_tax_mon", blc_tot_tax_mon);
						
						//차감세액이 음수이면 양수로 변환
						var adj_blc_tot_tax_mon = 0;
						if(blc_tot_tax_mon < 0) blc_tot_tax_mon = parseInt(sheet1.GetCellValue(Row, "blc_tot_tax_mon"))*-1;
						
						var refund_req_mon = blc_tot_tax_mon-refund_mon-ins_tot_tax_mon;
						sheet1.SetCellValue(Row, "refund_req_mon", refund_req_mon);
						
					//}
				}
			}
			/*
			if (colName == "fin_tot_tax_mon" || colName == "gi_tot_tax_mon") {
				blcTotTaxMon = parseInt(parseIntCheck(sheet1.GetCellValue(Row, "fin_tot_tax_mon"))) - parseInt(parseIntCheck(sheet1.GetCellValue(Row, "gi_tot_tax_mon")));

				sheet1.SetCellValue(Row, "blc_tot_tax_mon", blcTotTaxMon);
			}
			if (colName == "curr_tot_tax_mon" || colName == "pre_tot_tax_mon") {
				giTotTaxMon = parseInt(parseIntCheck(sheet1.GetCellValue(Row, "curr_tot_tax_mon"))) + parseInt(parseIntCheck(sheet1.GetCellValue(Row, "pre_tot_tax_mon")));
				sheet1.SetCellValue(Row, "gi_tot_tax_mon", blcTotTaxMon);
			}
			if (colName == "blc_tot_tax_mon" || colName == "refund_mon") {
				refundReqMon = parseInt(Math.abs(parseIntCheck(sheet1.GetCellValue(Row, "blc_tot_tax_mMon")))) - parseInt(parseIntCheck(sheet1.GetCellValue(Row, "refund_mon")));
				sheet1.SetCellValue(Row, "refund_req_mon", refundReqMon);
			}
			*/
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
					<li class="txt">원천징수세액환급신청서</li>
					<li class="btn">
						<a href="javascript:doAction1('Search');doAction1('BankInfoSearch');"	class="button">조회</a>
						<a href="javascript:doAction1('Insert')"	class="basic authA">입력</a>
						<a href="javascript:doAction1('Copy')"		class="basic authA">복사</a>
						<a href="javascript:doAction1('Save')"		class="basic authA">저장</a>
					</li>
				</ul>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "470px"); </script>
			</td>
		</tr>
	</table>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="sheet_title outer">
					<ul>
						<li class="txt">예입처 정보</li>
						<li class="btn">
							<a href="javascript:doAction1('SaveBankInfo')"		class="basic authA">저장</a>
						</li>
					</ul>
				</div>	
			</td>
		</tr>
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="20%" />
					<col width="40%" />
					<col width="40%" />					
				</colgroup>
				<tr>
					<th>예입처</th>
					<td> <select id="bankCd" name="bankCd"></select></td>
					<th rowspan="2">
						<pre>
<b>※ 환급신청액에 금액을 입력시 환급은행 입력가능(2,000만원 초과인 경우는 환급계좌 개설로 신청)
※ 환급신청액 유의사항</b>
 1. 수정, 기한후 신고시에 환급신청서 전자신고는 받지 않습니다.
 2. 국세청 정기신고 변경으로 수정신고 입력시 최종 수정분만 표시됨(출력물에 당초분, 수정분 반영됨)</pre>
					</th>					
				</tr>
				<tr>
					<th>계좌번호</th>
					<td> <input type="text" id="accountNo" name="accountNo" class="text left" value="" style="width:200px" /> </td>
				</tr>
				</table>
			</td>
		</tr>
	</table>	
	</form>
</div>
</body>
</html>