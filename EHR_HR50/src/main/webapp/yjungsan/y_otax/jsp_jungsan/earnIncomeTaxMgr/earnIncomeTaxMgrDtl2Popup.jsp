<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head> <head> <head> <title>지방세</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<!--
 * 원천징수이행상황신고서
 * @author JM
-->
<script type="text/javascript">
var p = eval("<%=popUpStatus%>");
$(function() {
	var businessPlaceCd	= "";
	var taxDocNo		= "";
	// 2015-08-31 YHCHOI ADD
	var reportYmd	    = "";
	var belongYm		= "";
	// 2016-09-19 YHCHOI ADD
	var closeYn         = "";
	// 2018-06-29 ADD
	var paymentYm		= "";
	var paymentYmd		= "";

	var arg = p.window.dialogArguments;

	if( arg != undefined ) {
		businessPlaceCd  = arg["business_place_cd"];
		taxDocNo         = arg["tax_doc_no"];
		// 2015-08-31 YHCHOI ADD
		reportYmd        = arg["report_ymd"];
		belongYm         = arg["belong_ym"];
		// 2016-09-19 YHCHOI ADD
		closeYn 		 = arg["close_yn"];
		// 2018-06-29 ADD
		paymentYm		 = arg["payment_ym"];
	}else{
		businessPlaceCd  = p.popDialogArgument("business_place_cd")||"";
		taxDocNo         = p.popDialogArgument("tax_doc_no");
		// 2015-08-31 YHCHOI ADD
		reportYmd        = p.popDialogArgument("report_ymd");
		belongYm         = p.popDialogArgument("belong_ym");
		// 2016-09-19 YHCHOI ADD
		closeYn          = p.popDialogArgument("close_yn");
		// 2018-06-29 ADD
		paymentYm        = p.popDialogArgument("payment_ym");
	}

	$("#businessPlaceCd").val(businessPlaceCd);
	$("#taxDocNo").val(taxDocNo);
	// 2015-08-31 YHCHOI ADD
	$("#reportYmd").val(reportYmd);
	$("#belongYm").val(belongYm);
	// 2016-09-19 YHCHOI ADD
	$("#closeYn").val(closeYn);
	/*
	 	2018-06-29 ADD
	 	급여지급일 = 지급시작월의 1일
	*/
	paymentYmd = paymentYm + "01";
	$("#paymentYmd").val(paymentYmd);
	if(paymentYm.length == 6){
		$("#paymentY").val(paymentYm.substring(0,4));
		$("#paymentM").val(paymentYm.substring(4,6));
	}

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:0, ColMove:1, ColResize:1, HeaderCheck:0, Hidden:1};
	initdata1.Cols = [
		{Header:"No",		Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
		{Header:"삭제",		Type:"<%=sDelTy%>",	Hidden:1,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",		Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"문서번호",	Type:"Text",		Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"tax_doc_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"사업장",		Type:"Text",		Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"납세지",		Type:"Text",		Hidden:1,	Width:60,			Align:"Left",	ColMerge:0,	SaveName:"location_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"sq",		Type:"Int",			Hidden:1,	Width:60,			Align:"Right",	ColMerge:0,	SaveName:"sq",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"seq",		Type:"Int",			Hidden:1,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"소득종류코드",	Type:"Text",		Hidden:1,	Width:80,			Align:"Left",	ColMerge:0,	SaveName:"earn_cd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"소득종류",	Type:"Text",		Hidden:0,	Width:100,			Align:"Left",	ColMerge:0,	SaveName:"code_nm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
		{Header:"인원",		Type:"Int",			Hidden:0,	Width:70,			Align:"Right",	ColMerge:0,	SaveName:"emp_cnt",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"과세표준액",	Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"tax_std_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"지방소득세",	Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"rtax_mon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"대상자\n확인",	Type:"Image",	Hidden:0,	Width:30,			Align:"Center",	ColMerge:0,	SaveName:"detail_list",		Cursor:"Pointer",		UpdateEdit:0,	EditLen:1 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	sheet1.SetDataLinkMouse("detail_list", 1);
	sheet1.SetImageList(0,"<%=imagePath%>/icon/icon_popup.png");

	var param = {
			cmd:'getCommonNSCodeList'
			,businessPlaceCd:businessPlaceCd
	};

	// 납세지(TSYS015)
	var locationCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?"+$.param(param), "getLocationCdList") , "");
	$("#locationCd").html(locationCd[2]);

	$(window).smartresize(sheetResize);
	sheetInit();

	$(".close").click(function() {
		p.self.close();
	});

	// 2018-06-29 환급액 필드 계산 start	/////////////////////////////////////////////////////////////////////////////////
	$(".tblCalc").find("input:not('.date')").bind("keyup", function(event){

		var eleNm = $(this).attr("name");

		// 환급합계금액 = 당월기타환급액 + 연말정산환급액 + 중도퇴사자환급액
		if("addMmRtn" == eleNm || "addYyTrtn" == eleNm || "addEtcRtn" == eleNm){
			var addMmRtn = Number($("#addMmRtn").val().replace(/,/g, ''));
			var addYyTrtn = Number($("#addYyTrtn").val().replace(/,/g, ''));
			var addEtcRtn = Number($("#addEtcRtn").val().replace(/,/g, ''));
			var addSumRtn = addMmRtn + addYyTrtn + addEtcRtn;

			$("#addSumRtn").val(addSumRtn);
			makeNum($("#addSumRtn")[0], 'B');
			addComma($("#addSumRtn")[0]);
// 			Num_Comma($("#addSumRtn")[0]);
		}

		// 추가납부합계금액 = 당월추가납부액 + 연말정산추가납부액 + 가산세대상추가납부액 + 가산세대상추가가산세
		if("addMmAamt" == eleNm || "addYyTamt" == eleNm || "addRdtAdtx" == eleNm || "addRdtAadd" == eleNm){
			var addMmAamt = Number($("#addMmAamt").val().replace(/,/g, ''));
			var addYyTamt = Number($("#addYyTamt").val().replace(/,/g, ''));
			var addRdtAdtx = Number($("#addRdtAdtx").val().replace(/,/g, ''));
			var addRdtAadd = Number($("#addRdtAadd").val().replace(/,/g, ''));

			// 가산세대상추가납부액 가산세 계산
			
			if("addRdtAdtx" == eleNm){
				addRdtAadd = calcPayAdtx(addRdtAdtx, true);

				$("#addRdtAadd").val(addRdtAadd);
				makeNum($("#addRdtAadd")[0], 'B');
				addComma($("#addRdtAadd")[0]);
			}


			var addSumAamt = addMmAamt + addYyTamt + addRdtAdtx + addRdtAadd;
			$("#addSumAamt").val(addSumAamt);
			makeNum($("#addSumAamt")[0], 'B');
			addComma($("#addSumAamt")[0]);
// 			Num_Comma($("#addSumAamt")[0]);
		}

		makeNum($(this)[0], 'B');
		addComma($(this)[0]);
// 		Num_Comma($(this)[0]);

		// 총납부세액 계산
		calcTotAmt();
		// 환급액 계산
		calcRefund(0);
	});
	// 2018-06-29 필드 계산	end /////////////////////////////////////////////////////////////////////////////////

	// 납세지 변경
	$("#locationCd").bind("change",function() {
		doAction1("Search");
		doAction1("RefundMonSearch");
		doAction1("getAdmCd");
		initData();
	});

	// 신고구분 변경
	$("[name='reqDiv']").bind("change",function() {
		var rst = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=updateReqDiv",$("#sheet1Form").serialize(),false);
	});
	
	/*
		23.10.17 지방세 가감조정내역 추가납부액 로직 수정
		지급년월 수정시 추가납부액에 대한 가산세 계산 로직 추가
	*/
	$("#paymentM").bind("change",function() {
		var paymentY = $("#paymentY").val();
		var paymentM = $("#paymentM").val();
		
		if(paymentY != undefined && paymentM != undefined) {
			$("#paymentYmd").val($("#paymentY").val() + $("#paymentM").val() + "01");
			initData();
			
			var addRdtAdtx = Number($("#addRdtAdtx").val().replace(/,/g, ''));
			
			addRdtAadd = calcPayAdtx(addRdtAdtx, true);
			$("#addRdtAadd").val(addRdtAadd);
			makeNum($("#addRdtAadd")[0], 'B');
			addComma($("#addRdtAadd")[0]);
		}
	});

	doAction1("Search");
	doAction1("RefundMonSearch");
	doAction1("getAdmCd");
	initData();

	// 2018-06-29 차감후환급잔액 = 0
	// $("#addOutSamt").val(0).attr("title", "사업장 개별 단건 신고시에는 해당 금액은 무조건 0이 됩니다.");

});

// 데이터 초기화
function initData(){
	// 지연일수 계산
	calcDlqCnt();
	// 가산세 계산
	/*var rtaxMonSum = Number($("#rtaxMonSum").val().replace(/,/g, '')); // 지방소득세합계
	var payAdtx = calcPayAdtx(rtaxMonSum, false);
	$("#payAdtx").val(payAdtx);
	makeNum($("#payAdtx")[0], 'B');*/
	
	addComma($("#payAdtx")[0]);
	// 총납부세액 계산
	calcTotAmt();
	// 환급액 계산
	calcRefund(0);
}

//2018-06-29 필드 계산 start /////////////////////////////////////////////////////////////////////////////////
// 환급액 계산
function calcRefund(gb){

	// 가감조정금액(차감액) = 추가납부합계금액 - 환급합계금액 (원단위절사)
	var addSumAamt = Number($("#addSumAamt").val().replace(/,/g, ''));
	var addSumRtn = Number($("#addSumRtn").val().replace(/,/g, ''));
	var addOutAmt = addSumAamt - addSumRtn;
	// 원 단위 절사
	addOutAmt = Math.floor(addOutAmt/10) * 10;
	$("#addOutAmt").val(addOutAmt);
	makeNum($("#addOutAmt")[0], 'B');
	addComma($("#addOutAmt")[0]);
// 	Num_Comma($("#addOutAmt")[0]);

	// 납부총금액 = 가감조정금액(차감액) + 총납부세액 (0보다 작을경우 0) = 납입세액
	// 납부총금액이 음수일 경우 : 차감후환급잔액 (절대값)
	var totAmt = Number($("#totAmt").val().replace(/,/g, ''));		    // 총납부세액
	var addTotAmt = totAmt + addOutAmt;
	var addOutSamt = 0;

	if(addTotAmt < 0){
		addOutSamt = Math.abs(addTotAmt);
		addTotAmt = 0;
	}else{
		addOutSamt = 0;
	}

	$("#addOutSamt").val(addOutSamt);
	makeNum($("#addOutSamt")[0], 'A');
	addComma($("#addOutSamt")[0]);
	$("#addTotAmt").val(addTotAmt);
	makeNum($("#addTotAmt")[0], 'B');
	addComma($("#addTotAmt")[0]);
// 	Num_Comma($("#addTotAmt")[0]);
	$("#addTotAmtView").val(addTotAmt);
	makeNum($("#addTotAmtView")[0], 'B');
	addComma($("#addTotAmtView")[0]);
// 	Num_Comma($("#addTotAmtView")[0]);


	// 납부할지방소득세 = 납부총금액 - (가산세 + 가산세대상추가가산세)
	var payAdtx = Number($("#payAdtx").val().replace(/,/g, ''));
	var addRdtAadd = Number($("#addRdtAadd").val().replace(/,/g, ''));
	var intx = addTotAmt - (payAdtx + addRdtAadd);
	$("#intx").val(intx);

	//  납부할가산세 = 납부총금액 - 납부할지방소득세
	var totAdtx = addTotAmt - intx;
	$("#totAdtx").val(totAdtx);

	if(gb == "1"){
		//환급금 저장
		if(confirm("가감 조정내역을 저장하시겠습니까?")){
			var rst = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl2RefundMon",$("#sheet1Form").serialize(),false);

			if(rst && rst.Result) {
				if(rst.Result.Code == "1") {
					if(sheet1.RowCount("U") > 0) {
						// 지방소득세신고서 저장
						sheet1.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl2","",-1,0);
					}
					alert("저장되었습니다.");
				}
			}
		}

	}


}

// 가산세 계산 (지급액, 추가여부)
function calcPayAdtx(rtax, addYn){
	var paymentYmd = Number($("#paymentYmd").val()); // 급여지급일
	var dlqCnt = Number($("#dlqCnt").val().replace(/,/g, '')); // 지연일수
	var rtax10per = Number(rtax) * 0.1;	// * 0.1
	var payAdtx = "";	// 가산세
	var adtxAm = "";	// 가산세1정액
	var dlqAdtx = "";	// 가산세2지연기간

	if(20160101 <= paymentYmd){			/* 20160101 이후 : (지급액 * 0.03) + 지급액 * 지연일수 * (3/10000) */

		adtxAm = Number(rtax) * 0.03;
		dlqAdtx = (Number(dlqCnt) > 0) ? Number(rtax) * Number(dlqCnt) * (2.2/10000) : 0;

		// 원 단위 절사
		adtxAm  = Math.floor(adtxAm/10) * 10;
		dlqAdtx = Math.floor(dlqAdtx/10) * 10;

		payAdtx = adtxAm + dlqAdtx;

		if(payAdtx > rtax10per){
			payAdtx = rtax10per;
		}

	}else if(20130101 < paymentYmd){ 	/* 20130101 전 : 지급액 * 0.1 */

		adtxAm = rtax10per;
		dlqAdtx = 0;

		// 원 단위 절사
		adtxAm  = Math.floor(adtxAm/10) * 10;

		payAdtx = adtxAm + dlqAdtx;

	}else if(20130101 <= paymentYmd){	/* 20130101 이후 : (지급액 * 0.05) + 지급액 * 지연일수 * (3/10000) */

		adtxAm = Number(rtax) * 0.05;
		dlqAdtx = (Number(dlqCnt) > 0) ? Number(rtax) * Number(dlqCnt) * (3/10000) : 0;

		// 원 단위 절사
		adtxAm  = Math.floor(adtxAm/10) * 10;
		dlqAdtx = Math.floor(dlqAdtx/10) * 10;

		payAdtx = adtxAm + dlqAdtx;

		if(payAdtx > rtax10per){
			payAdtx = rtax10per;
		}

	}

	// 가산세대상추가가산세 일 경우 가산세1정액, 가산세2지연기간 저장 없음
	if(!addYn){
		// 원 단위 절사
		//payAdtx = Math.floor(payAdtx/10) * 10;
		$("#adtxAm").val(adtxAm);
		$("#dlqAdtx").val(dlqAdtx);
	}

	return payAdtx;
}

// 총납부세액 계산
function calcTotAmt(){
	var rtaxMonSum = Number($("#rtaxMonSum").val().replace(/,/g, '')); // 지방소득세
	var payAdtx = Number($("#payAdtx").val().replace(/,/g, '')); // 가산세
	var totAmt = rtaxMonSum + payAdtx;

	$("#totAmt").val(totAmt);
	makeNum($("#totAmt")[0], "B");
	addComma($("#totAmt")[0]);
	//Num_Comma($("#totAmt")[0]);
}


function addComma(obj) {
	if(obj != null && obj != 'undefinded') {
		str = obj.value;
	     /*4자리 미만 컨마 안함*/
	     if(str.length < 4) return ;

	     s = new String(str);
	     mark = '';

	     if(s.substr(0,1) == '-' ) {
	    	 mark = s.substr(0,1);
	    	 s = s.substr(1);
	     }

	     s=s.replace(/\D/g,"");

	     l=s.length-3;
	     while(l>0) {
		     s=s.substr(0,l)+","+s.substr(l);
		     l-=3;
	     }

	     obj.value = (mark != '')? mark + s : s;
	}
}

// 지연일수 계산
function calcDlqCnt(){
	var today = new Date();
	var dueDate = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getDueDate", $("#sheet1Form").serialize(), false);

	dueDate = dueDate.Data.due_date;

	if(dueDate.length == 8){
		var dueDateY = dueDate.substring(0,4);
		var dueDateM = dueDate.substring(4,6);
		var dueDateD = dueDate.substring(6,8);
		dueDate = new Date(dueDateY, Number(dueDateM) -1, dueDateD);

		var betweenDay = Math.floor((today.getTime() - dueDate.getTime()) / (1000*60*60*24));
		if(betweenDay > 0){
			$("#dlqCnt").val(betweenDay);
		}else{
			$("#dlqCnt").val(0);
		}
	}else{
		alert("지연일수를 계산할 수 없습니다.");
		return;
	}

}

// 2018-06-29 필드 계산 end	/////////////////////////////////////////////////////////////////////////////////

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
	if ($("#locationCd").val() == "") {
		alert("납세지를 확인하십시오.");
		return false;
	}

	return true;
}

//2016-09-19 YHCHOI ADD START
//마감여부 체크
function chkClose(sAction) {
	if ($("#closeYn").val() == "Y" || $("#closeYn").val() == "1") {
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

			// 지방소득세신고서 조회
			sheet1.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl2List", $("#sheet1Form").serialize());

			<%--
			// 2018-06-29 지방소득세(합계) 조회
			var rtaxMonSum = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getRtaxMonSum", $("#sheet1Form").serialize(), false);
			$("#rtaxMonSum").val("");
			if(rtaxMonSum.Data.rtax_mon_sum != null) {
				$("#rtaxMonSum").val(rtaxMonSum.Data.rtax_mon_sum);
			}
			 --%>
			break;

		case "RefundMonSearch":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 환급액 조회
			var refundMonInfo = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl2RefundMonMap", $("#sheet1Form").serialize(), false);

			$("#payAdtx").val("");
			$("#adtxAm").val("");
			$("#dlqAdtx").val("");
			$("#addMmRtn").val("");
			$("#addMmAamt").val("");
			$("#addYyTrtn").val("");
			$("#addYyTamt").val("");
			$("#addRtcRtn").val("");
			$("#addRdtAdtx").val("");
			$("#addRdtAadd").val("");
			$("#addSumRtn").val("");
			$("#addSumAamt").val("");
			$("#addOutAmt").val("");
			$("#addTotAmt").val("");
			$("#addTotAmtView").val("");
			$("#intx").val("");
			$("#totAdtx").val("");
			$("#addOutSamt").val("");
			$("#dlqCnt").val("");
			$("[name='reqDiv']"	).attr("checked", false);

			if(refundMonInfo.Data != null) {
				refundMonInfo = refundMonInfo.Data;
				$("#payAdtx"	).val(refundMonInfo.pay_adtx);
				$("#adtxAm"		).val(refundMonInfo.adtx_am);
				$("#dlqAdtx"	).val(refundMonInfo.dlq_adtx);
				$("#addMmRtn"	).val(refundMonInfo.add_mm_rtn);
				$("#addMmAamt"	).val(refundMonInfo.add_mm_aamt);
				$("#addYyTrtn"	).val(refundMonInfo.add_yy_trtn);
				$("#addYyTamt"	).val(refundMonInfo.add_yy_tamt);
				$("#addEtcRtn"	).val(refundMonInfo.add_etc_rtn);
				$("#addRdtAdtx"	).val(refundMonInfo.add_rdt_adtx);
				$("#addRdtAadd"	).val(refundMonInfo.add_rdt_aadd);
				$("#addSumRtn"	).val(refundMonInfo.add_sum_rtn);
				$("#addSumAamt"	).val(refundMonInfo.add_sum_aamt);
				$("#addOutAmt"	).val(refundMonInfo.add_out_amt);
				$("#addTotAmt"	).val(refundMonInfo.add_tot_amt);
				$("#addTotAmView").val(refundMonInfo.add_tot_amt);
				$("#intx"		).val(refundMonInfo.intx);
				$("#totAdtx"	).val(refundMonInfo.tot_adtx);
				$("#addOutSamt"	).val(refundMonInfo.add_out_samt);
				$("#dlqCnt"		).val(refundMonInfo.dlq_cnt);
				addComma($("#payAdtx")[0]);
				addComma($("#adtxAm")[0]);
				addComma($("#dlqAdtx")[0]);
				addComma($("#addMmRtn")[0]);
				addComma($("#addMmAamt")[0]);
				addComma($("#addYyTrtn")[0]);
				addComma($("#addYyTamt")[0]);
				addComma($("#addEtcRtn")[0]);
				addComma($("#addRdtAdtx")[0]);
				addComma($("#addRdtAadd")[0]);
				addComma($("#addSumRtn")[0]);
				addComma($("#addSumAamt")[0]);
				addComma($("#addOutAmt")[0]);
				addComma($("#addTotAmt")[0]);
				addComma($("#addTotAmView")[0]);
				addComma($("#intx")[0]);
				addComma($("#totAdtx")[0]);
				addComma($("#addOutSamt")[0]);
				addComma($("#dlqCnt")[0]);
				$("[name='reqDiv'][value='" + refundMonInfo.req_div +"']").attr("checked", true);
			}

			break;

		case "getAdmCd":

			// 법정동코드 조회
			var admCd = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getAdmCd", $("#sheet1Form").serialize(), false);

			$("#admCd").val("");

			if(admCd.Data.adm_cd != null) {
				$("#admCd").val(admCd.Data.adm_cd);
			}
			break;

		case "Save":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END

			if(!confirm("저장하시겠습니까?")) {
				return;
			}

			//환급금 저장
			var rst = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl2RefundMon",$("#sheet1Form").serialize(),false);

			if(rst && rst.Result) {
				if(rst.Result.Code == "1") {
					if(sheet1.RowCount("U") > 0) {
						// 지방소득세신고서 저장
						sheet1.DoSave("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl2","",-1,0);
					} else {
						alert("저장되었습니다.");
					}
				}
			}

			break;

		case "PrcP_CPN_ORIGIN_RTAX_INS":
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

				var taxDocNo		= $("#taxDocNo").val();
				var businessPlaceCd	= $("#businessPlaceCd").val();
				var locationCd		= $("#locationCd").val();

				if ( businessPlaceCd == "%") businessPlaceCd = "ALL";

				// 자료생성
				var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=prcP_CPN_ORIGIN_RTAX_INS", "taxDocNo="+taxDocNo+"&businessPlaceCd="+businessPlaceCd+"&locationCd="+locationCd, false);
				/*
				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "0") {
						alert("자료생성 되었습니다.");
						// 프로시저 호출 후 재조회
						doAction1("Search");
						doAction1("RefundMonSearch");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("자료생성 오류입니다.");
				}
				*/
				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "1") {
						doAction1("Search");
						doAction1("RefundMonSearch");
						doAction1("getAdmCd");
						initData();
					}
				}

				var addMmRtn = Number($("#addMmRtn").val().replace(/,/g, ''));
				var addYyTrtn = Number($("#addYyTrtn").val().replace(/,/g, ''));
				var addEtcRtn = Number($("#addEtcRtn").val().replace(/,/g, ''));
				var addSumRtn = addMmRtn + addYyTrtn + addEtcRtn;

				$("#addSumRtn").val(addSumRtn);
				makeNum($("#addSumRtn")[0], 'B');
				addComma($("#addSumRtn")[0]);

				var addMmAamt = Number($("#addMmAamt").val().replace(/,/g, ''));
				var addYyTamt = Number($("#addYyTamt").val().replace(/,/g, ''));
				var addRdtAdtx = Number($("#addRdtAdtx").val().replace(/,/g, ''));
				var addRdtAadd = Number($("#addRdtAadd").val().replace(/,/g, ''));
				var addSumAamt = addMmAamt + addYyTamt + addRdtAdtx + addRdtAadd;
				$("#addSumAamt").val(addSumAamt);
				makeNum($("#addSumAamt")[0], 'B');
				addComma($("#addSumAamt")[0]);


				// 총납부세액 계산
				calcTotAmt();
				// 환급액 계산
				calcRefund(1);

			}
			break;

		case "PrcP_CPN_ORIGIN_RTAX_INS_ALL":
			// 2016-09-19 YHCHOI ADD START
			// 마감여부 체크
			if (!chkClose(sAction)) {
				break;
			}
			// 2016-09-19 YHCHOI ADD END

			// 필수값/유효성 체크
			if (parent.$("#taxDocNo").val() == "") {
				alert("문서번호를 확인하십시오.");
				return false;
			}
			if (parent.$("#businessPlaceCd").val() == "") {
				alert("급여사업장코드를 확인하십시오.");
				return false;
			}

			if (confirm("자료생성시 기존 자료는 모두 삭제됩니다. \n전체자료생성을 하시겠습니까?")) {

				var taxDocNo		= $("#taxDocNo").val();
				var businessPlaceCd	= $("#businessPlaceCd").val();
				var locationCd		= "ALL";

				if ( businessPlaceCd == "%") businessPlaceCd = "ALL";

				// 자료생성
				var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=prcP_CPN_ORIGIN_RTAX_INS", "taxDocNo="+taxDocNo+"&businessPlaceCd="+businessPlaceCd+"&locationCd="+locationCd, false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "1") {
						doAction1("Search");
						doAction1("RefundMonSearch");
						doAction1("getAdmCd");
						initData();
					}
				}
			}
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		var rowCnt = sheet1.RowCount();
		if (rowCnt > 0) {
			for (var i=1; i<=rowCnt; i++) {
				if (sheet1.GetCellValue(i, "seq").toString() == "0") {
					sheet1.SetCellBackColor(i,"emp_cnt","#F4F4F4");
					sheet1.SetCellBackColor(i,"tax_std_mon","#F4F4F4");
					sheet1.SetCellBackColor(i,"rtax_mon","#F4F4F4");
					sheet1.SetCellEditable(i,"emp_cnt", 0);
					sheet1.SetCellEditable(i,"tax_std_mon", 0);
					sheet1.SetCellEditable(i,"rtax_mon", 0);
				}
			}
		}

		calcRtaxMonSum();

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
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 보고서 출력
function callRd(pGb) {
	var w 		= 1000;
	var h 		= 800;
	var url 	= "<%=jspPath%>/common/rdPopup.jsp";
	var args 	= new Array();
	// args의 Y/N 구분자는 없으면 N과 같음

	var rdTitle = "";
	var reportFileNm = "";
	var reportGb = $("#reportGb").val();

	var yyyy = $("#reportYmd").val();
	yyyy = yyyy.substr(0, 4);

	if (reportGb == "1") {
		if (yyyy < 2015)
		    reportFileNm = "ResidenceDeclaration.mrd";
		else
			reportFileNm = "ResidenceDeclaration_2015.mrd";

		rdTitle = "지방세신고서";
	} else  {
		if (yyyy < 2015)
		    reportFileNm = "ResidenceReceipt.mrd";
		else
			reportFileNm = "ResidenceReceipt_2015.mrd";

		rdTitle = "지방세지로영수증";
	}

	if(pGb == "ALL"){
		var sSize = $("#locationCd option").size();
		//alert($("#locationCd option:eq(1)").val());
		var vals = "";

		if (sSize > 0) {
			for(var i=0; i<sSize; i++){
				vals += "'" + $("#locationCd option:eq("+i+")").val() + "',";
			}
			vals = vals.substr(0,vals.length-1);
		} else {
			alert("납세지가 없습니다.");
			return;
		}
	}

	args["rdTitle"] = rdTitle;
	args["rdMrd"] = "cpn/origintax/" + reportFileNm;
	//args["rdParam"] = "['${ssnEnterCd}'] ['"+$("#taxDocNo").val()+"'] ['"+$("#businessPlaceCd").val()+"'] ['"+$("#locationCd").val()+"']";

	if(pGb == "ALL"){
		args["rdParam"] = "P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_TAX_DOC_NO["+$("#taxDocNo").val()+"] P_BIZ_CD["+$("#businessPlaceCd").val()+"] P_LOCATION_CD["+vals+"]";
	}else{
		args["rdParam"] = "P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_TAX_DOC_NO["+$("#taxDocNo").val()+"] P_BIZ_CD["+$("#businessPlaceCd").val()+"] P_LOCATION_CD['"+$("#locationCd").val()+"']";
	}
	//args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] ["+$("#taxDocNo").val()+"] ["+$("#businessPlaceCd").val()+"] ["+$("#locationCd").val()+"]";
	//args["rdParamGubun"]= "rp";	//파라매터구분(rp/rv)
	args["rdParamGubun"]= "rv";	//파라매터구분(rp/rv)
	args["rdToolBarYn"]	= "Y";	//툴바여부
	args["rdZoomRatio"]	= "100";//확대축소비율
	args["rdSaveYn"]	= "Y" ;	//기능컨트롤_저장
	args["rdPrintYn"]	= "Y" ;	//기능컨트롤_인쇄
	args["rdExcelYn"]	= "Y" ;	//기능컨트롤_엑셀
	args["rdWordYn"]	= "Y" ;	//기능컨트롤_워드
	args["rdPptYn"]		= "Y" ;	//기능컨트롤_파워포인트
	args["rdHwpYn"]		= "Y" ;	//기능컨트롤_한글
	args["rdPdfYn"]		= "Y" ;	//기능컨트롤_PDF

	if(!isPopup()) {return;}
	openPopup(url,args,w,h);
}

// 시트 값 수정
function sheet1_OnChange(Row, Col, Value) {
	try {
		var resultMap = calcRtaxMonSum();

		var rowCnt = sheet1.RowCount();
		if (rowCnt > 0) {
			for (var i=1; i<=rowCnt; i++) {
				if (sheet1.GetCellValue(i, "seq").toString() == "0") {
					if(sheet1.GetCellValue(i, "earn_cd").toString() == "합계"){
						sheet1.SetCellValue(i,"emp_cnt", resultMap.empCntSum);
						sheet1.SetCellValue(i,"tax_std_mon", resultMap.taxStdMonSum);
						sheet1.SetCellValue(i,"rtax_mon", resultMap.rtaxMonSum);
					}else if(sheet1.GetCellValue(i, "earn_cd").toString() == "납부세액"){
						sheet1.SetCellValue(i,"emp_cnt", resultMap.empCntSum2);
						sheet1.SetCellValue(i,"tax_std_mon", resultMap.taxStdMonSum2);
						sheet1.SetCellValue(i,"rtax_mon", resultMap.rtaxMonSum2);
					}
				}
			}
		}
	} catch (ex) {
		alert("OnChange Event Error : " + ex);
	}
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if(colName == "detail_list" && sheet1.GetCellValue(Row, "detail_list") != "") {
				// 상세대상자 팝업
				openEarnIncomeTaxMgrDtl2EmpPopup(Row);
			}
		}
	} catch (ex) {
		alert("OnClick Event Error : " + ex);
	}
}

//대상자 팝업
function openEarnIncomeTaxMgrDtl2EmpPopup(Row) {
	var w	= 700;
	var h	= 800;
	var url	= "";
	var args= new Array();

	url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl2EmpPopup.jsp";

	args["tax_doc_no"] 			= sheet1.GetCellValue(Row, "tax_doc_no");
	args["business_place_cd"] 	= sheet1.GetCellValue(Row, "business_place_cd");
	args["location_cd"] 		= sheet1.GetCellValue(Row, "location_cd");
	args["earn_cd"] 			= sheet1.GetCellValue(Row, "earn_cd");

	openPopup(url+"?authPg=<%=authPg%>", args, w, h);
}

// sheet1의 합계 계산
function calcRtaxMonSum(){
	// 합계
	var empCntSum = 0;
	var taxStdMonSum = 0;
	var rtaxMonSum = 0;

	// 조정액
	var adjEmpCnt = 0;
	var adjTaxStdMon = 0;
	var adjRtaxMon = 0;

	var rowCnt = sheet1.RowCount();
	if (rowCnt > 0) {
		for (var i=1; i<=rowCnt; i++) {
			if (sheet1.GetCellValue(i, "seq").toString() != "0") {

				if(sheet1.GetCellValue(i, "earn_cd").toString() == "99"){
					adjEmpCnt = sheet1.GetCellValue(i, "emp_cnt").toString();
					adjTaxStdMon = sheet1.GetCellValue(i, "tax_std_mon").toString();
					adjRtaxMon = sheet1.GetCellValue(i, "rtax_mon").toString();
				}else{
					var emp_cnt = sheet1.GetCellValue(i, "emp_cnt").toString();
					empCntSum += Number(emp_cnt);

					var tax_std_mon = sheet1.GetCellValue(i, "tax_std_mon").toString();
					taxStdMonSum += Number(tax_std_mon);

					var rtax_mon = sheet1.GetCellValue(i, "rtax_mon").toString();
					rtaxMonSum += Number(rtax_mon);
				}
			}
		}
	}

	var empCntSum2 		= Number(empCntSum) + Number(adjEmpCnt);
	var taxStdMonSum2 	= Number(taxStdMonSum) + Number(adjTaxStdMon);
	var rtaxMonSum2 	= Number(rtaxMonSum) + Number(adjRtaxMon);
	$("#rtaxMonSum").val(rtaxMonSum2);

	// 가산세 계산
	/*
	var payAdtx = calcPayAdtx(rtaxMonSum, false);
	$("#payAdtx").val(payAdtx);
	makeNum($("#payAdtx")[0], 'B');
	addComma($("#payAdtx")[0]);
	*/
	// 총납부세액 계산
	calcTotAmt();
	// 환급액 계산
	calcRefund(0);

	var resultMap = { "rtaxMonSum": rtaxMonSum, "taxStdMonSum": taxStdMonSum, "empCntSum": empCntSum,
					  "rtaxMonSum2": rtaxMonSum2, "taxStdMonSum2": taxStdMonSum2, "empCntSum2": empCntSum2,
					};
	return resultMap;
}

// 2018-06-29 전자신고서
function createDeclaration() {
	var w		= 500;
	var h		= 260;
	var url		= "";
	var args	= new Array();

	url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDeclaration2Popup.jsp";

	// 법정동코드, 신고구분 입력확인
	var admCd = $("#admCd").val();

	if(admCd == "") {
		alert("법정동코드를 입력하십시오.");
		return;
	}

	if(!$("[name='reqDiv']").is(":checked")) {
		alert("신고구분을 선택하십시오.");
		return;
	}

	args["taxDocNo"] = $("#taxDocNo").val();
	args["businessPlaceCd"] = $("#businessPlaceCd").val();
	args["admCd"] = admCd;
	args["reqDiv"] = $("[name='reqDiv']:checked").val();
	args["locationCd"] = $("#locationCd").val();

	if(!isPopup()) {return;}

	openPopup(url+"?authPg=<%=authPg%>", args, w, h);
}

var pGubun = "";

//우편번호 팝업 호출
function openZipCode(){
	if(!isPopup()) {return;}
	pGubun = "zipCodePopup";
	var rst = openPopup("<%=jspPath%>/common/newZipCodePopup.jsp", "", "740","620");
}

function getReturnValue(returnValue) {
	var rst = $.parseJSON('{'+ returnValue+'}');
	if ( pGubun == "zipCodePopup" ){

		// 우편번호 팝업에서 법정동코드 선택 시 법정동코드 수정
		var admCd = rst.admCd;
		$("#admCd").val(admCd);

		var rst = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=updateAdmCd",$("#sheet1Form").serialize(),false);
	}
}

function callCalcPayAdtxUsingBtn() {
	var rtaxMonSum = Number($("#rtaxMonSum").val().replace(/,/g, '')); // 지방소득세합계
	var payAdtx = calcPayAdtx(rtaxMonSum, false);
	$("#payAdtx").val(payAdtx);
	makeNum($("#payAdtx")[0], 'B');
	addComma($("#payAdtx")[0]);
}


//숫자(','제외) FORMAT처리
function makeNum(obj,type) {

	var ls_amt1 = obj.value;
	var ls_amt2 = "";

	switch (type) {
		case "A":
			// 숫자만
			for(var i=0; i<ls_amt1.length+1; i++) {
			    if (ls_amt1.substring(i,i+1) >= "0" &&
			        ls_amt1.substring(i,i+1) <= "9") {

			        ls_amt2 = ls_amt2 + ls_amt1.substring(i,i+1);
				}
			}
			break;
		case "B":
			// 숫자(-부호 포함)
			for(var i=0; i<ls_amt1.length+1; i++) {
			    if (ls_amt1.substring(i,i+1) >= "0" &&
			        ls_amt1.substring(i,i+1) <= "9" ||
			        ls_amt1.substring(i,i+1) == "-") {

			        ls_amt2 = ls_amt2 + ls_amt1.substring(i,i+1);
				}
			}
			break;
		case "C":
			// 숫자(소수점 포함)
			for(var i=0; i<ls_amt1.length+1; i++) {
			    if (ls_amt1.substring(i,i+1) >= "0" &&
			        ls_amt1.substring(i,i+1) <= "9" ||
			        ls_amt1.substring(i,i+1) == ".") {

			        ls_amt2 = ls_amt2 + ls_amt1.substring(i,i+1);
				}
			}
			break;
		case "D":
			// 숫자(-부호/소수점 포함)
			for(var i=0; i<ls_amt1.length+1; i++) {
			    if (ls_amt1.substring(i,i+1) >= "0" &&
			        ls_amt1.substring(i,i+1) <= "9" ||
			        ls_amt1.substring(i,i+1) == "." ||
			        ls_amt1.substring(i,i+1) == "-") {

			        ls_amt2 = ls_amt2 + ls_amt1.substring(i,i+1);
				}
			}
			break;
	}

	obj.value = ls_amt2;
	return(true);
}
</script>
</head>
<body class="bodywrap" style="overflow:auto">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>지방세</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="taxDocNo" name="taxDocNo" value="" />
		<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" value="" />
		<input type="hidden" id="reportYmd" name="reportYmd" value="" />
		<input type="hidden" id="belongYm" name="belongYm" value="" />
		<input type="hidden" id="closeYn" name="closeYn" value="" />

		<input type="hidden" id="paymentYmd" name="paymentYmd" value="" />
		<input type="hidden" id="rtaxMonSum" name="rtaxMonSum" value="" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>납세지</span> <select id="locationCd" name="locationCd"> </select> </td>
						<td> <a href="javascript:doAction1('Search'); doAction1('RefundMonSearch');"	class="button authR">조회</a> </td>
						<td> <span>법정동코드</span> <input type="text" id="admCd" name="admCd" class="text readonly" value="" /> </td>
						<td> <a href="javascript:openZipCode();"	class="basic authA">코드찾기</a> </td>
						<td style="width:100%;" class="right">
							<span>신고구분</span>
							<input name="reqDiv" id="reqDiv" type="radio" class="radio" value="1" />&nbsp;매월
							<input name="reqDiv" id="reqDiv" type="radio" class="radio" value="2" />&nbsp;반기
						</td>
						<td style="width:100%;" class="right">
							<a href="javascript:doAction1('PrcP_CPN_ORIGIN_RTAX_INS_ALL')"	class="button authA">전체자료생성</a>
							<a href="javascript:createDeclaration();"	class="basic authA">전자신고서</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="sheet_title outer">
					<ul>
						<li class="txt">납소속 및 영수필통지서</li>
						<li class="btn">
							<select id="reportGb" name="reportGb">
								<option value="1">신고서</option>
								<option value="2">지로영수증</option>
							</select>
							<a href="javascript:callRd('ALL')"								class="basic authA">전체출력</a>
							<a href="javascript:callRd('NO')"								class="basic authA">출력</a>
							<a href="javascript:doAction1('Save')"						class="basic authA">저장</a>
							<a href="javascript:doAction1('PrcP_CPN_ORIGIN_RTAX_INS')"	class="basic authA">자료생성</a>
							<a href="javascript:doAction1('Down2Excel')"				class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "410px"); </script>
				</td>
			</tr>
		</table>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<table border="0" cellpadding="0" cellspacing="0" class="default outer tblCalc">
					<colgroup>
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
						<col width="30%" />
					</colgroup>
					<tr>
						<th>가산세</th>
						<td class="right">
							<input type="text" id="payAdtx" name="payAdtx" class="text right" value="" style="width:130px"/>
							<a href="javascript:callCalcPayAdtxUsingBtn();"	class="button authA">계산</a>
							<input type="hidden" id="adtxAm"  name="adtxAm"  class="text right" value="" style="width:130px" />
							<input type="hidden" id="dlqAdtx" name="dlqAdtx" class="text right" value="" style="width:130px" />
						</td>
						<th>총납부세액</th>
						<td class="right"> <input type="text" id="totAmt" name="totAmt" class="text right readonly" value="" style="width:130px" readonly/> </td>
					</tr>
					</table>
				</td>
			</tr>
		</table>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="outer">
						<div class="sheet_title">
						<ul>

							<li id="txt" class="txt">가감 조정 내역</li>
						</ul>
						</div>
					</div>
					<table border="0" cellpadding="0" cellspacing="0" class="default outer tblCalc">
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="10%" />
						<col width="10%" />
						<col width="20%" />
						<col width="10%" />
						<col width="10%" />
					</colgroup>
					<tr>
						<th class="center" colspan="2">환급액</th>
						<th class="center" colspan="5">추가납부액</th>
					</tr>
					<tr>
						<th>당월기타환급액</th>
						<td> <input type="text" id="addMmRtn" name="addMmRtn" class="text right" value="" style="width:130px" /> </td>
						<th colspan="2">당월추가납부액</th>
						<td colspan="3"> <input type="text" id="addMmAamt" name="addMmAamt" class="text right" value="" style="width:130px" /> </td>
					</tr>
					<tr>
						<th>연말정산환급액</th>
						<td> <input type="text" id="addYyTrtn" name="addYyTrtn" class="text right" value="" style="width:130px" /> </td>
						<th colspan="2">연말정산추가납부액</th>
						<td colspan="3"> <input type="text" id="addYyTamt" name="addYyTamt" class="text right" value="" style="width:130px" /> </td>
					</tr>
					<tr>
						<th rowspan="3">중도퇴사자환급액</th>
						<td rowspan="3"> <input type="text" id="addEtcRtn" name="addEtcRtn" class="text right" value="" style="width:130px" /> </td>
						<th rowspan="3">가산세대상<br/>추가납부액</th>
						<th>급여지급년월</th>
						<td>
							<input type="text" id="paymentY" name="paymentYm" class="text right date" value="" style="width:50px"/> 년
							<!-- <input type="text" id="paymentM" name="paymentM" class="text right date" value="" style="width:40px"/> -->
							<select id="paymentM" name="paymentM">
								<option value='01'>1</option>
								<option value='02'>2</option>
								<option value='03'>3</option>
								<option value='04'>4</option>
								<option value='05'>5</option>
								<option value='06'>6</option>
								<option value='07'>7</option>
								<option value='08'>8</option>
								<option value='09'>9</option>
								<option value='10'>10</option>
								<option value='11'>11</option>
								<option value='12'>12</option>
							</select>
							 월
						</td>
						<th>납부지연일수</th>
						<td>
							<input type="text" id="dlqCnt" name="dlqCnt" class="text right date" value="" style="width:50px"/>
						</td>
					</tr>
					<tr>
						<th>납부액</th>
						<td colspan="3"> <input type="text" id="addRdtAdtx" name="addRdtAdtx" class="text right" value="" style="width:130px" /> </td>
					</tr>
					<tr>
						<th>가산세</th>
						<td colspan="3"> <input type="text" id="addRdtAadd" name="addRdtAadd" class="text right readonly" value="" style="width:130px" readonly/> </td>
					</tr>
					<tr>
						<th>환급합계금액</th>
						<td> <input type="text" id="addSumRtn" name="addSumRtn" class="text right readonly" value="" style="width:130px" readonly/> </td>
						<th colspan="2">추가납부합계금액</th>
						<td colspan="3"> <input type="text" id="addSumAamt" name="addSumAamt" class="text right readonly" value="" style="width:130px" readonly/> </td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="right">
					<table border="0" cellpadding="0" cellspacing="0" class="default outer tblCalc" style="width:60%; float: right; ">
						<colgroup>
							<col width="30%" />
							<col width="60%" />
						</colgroup>
						<tr>
							<th>가감조정금액(차감액)</th>
							<td> <input type="text" id="addOutAmt" name="addOutAmt" class="text right readonly" value="" style="width:130px" readonly/> </td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="outer">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">가감 조정 결과액</li>
						</ul>
						</div>
					</div>
					<table border="0" cellpadding="0" cellspacing="0" class="default outer tblCalc">
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="40%" />
					</colgroup>
					<tr>
						<th>납부총금액</th>
						<td> <input type="text" id="addTotAmt" name="addTotAmt" class="text right readonly" value="" style="width:130px" readonly/> </td>
						<th>차감후환급잔액</th>
						<td> <input type="text" id="addOutSamt" name="addOutSamt" class="text right readonly" value="" style="width:130px" readonly/> </td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="right">
					<table border="0" cellpadding="0" cellspacing="0" class="default outer tblCalc" style="width:60%; float: right; ">
						<colgroup>
							<col width="30%" />
							<col width="60%" />
						</colgroup>
						<tr>
							<th>납입세액</th>
							<td> <input type="text" id="addTotAmtView" name="addTotAmtView" class="text right readonly" value="" style="width:130px" readonly/> </td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<input type="hidden" id="intx" name="intx" class="text right" value="0" /> <!-- 납부할지방소득세 -->
		<input type="hidden" id="totAdtx" name="totAdtx" class="text right" value="0" /> <!-- 납부할가산세 -->
		</form>
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