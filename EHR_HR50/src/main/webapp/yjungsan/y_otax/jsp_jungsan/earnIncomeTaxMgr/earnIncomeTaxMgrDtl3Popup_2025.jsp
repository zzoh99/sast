<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <head> <head>  <title>사업소득세(2024.12.31개정)</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<!--
 * 원천징수이행상황신고서 > 사업소득세
 * @author JM
-->
<script type="text/javascript">
var p = eval("<%=popUpStatus%>");
$(function() {
	var businessPlaceCd = "";
	var taxDocNo		= "";
	// 2015-08-31 YHCHOI ADD
	var reportYmd	    = "";
	var belongYm		= "";
	// 2016-09-19 YHCHOI ADD
	var closeYn         = "";
	
	var arg = p.window.dialogArguments;

	if( arg != undefined ) {
		businessPlaceCd = arg["business_place_cd"];
		taxDocNo = arg["tax_doc_no"];
		// 2015-08-31 YHCHOI ADD
		reportYmd       = arg["report_ymd"];
		belongYm        = arg["belong_ym"];
		// 2016-09-19 YHCHOI ADD
		closeYn 		= arg["close_yn"];
	}else{
		businessPlaceCd = p.popDialogArgument("business_place_cd");
		taxDocNo        = p.popDialogArgument("tax_doc_no");
		// 2015-08-31 YHCHOI ADD
		reportYmd       = p.popDialogArgument("report_ymd");
		belongYm        = p.popDialogArgument("belong_ym");
		// 2016-09-19 YHCHOI ADD
		closeYn         = p.popDialogArgument("close_yn");
	}

	$("#businessPlaceCd").val(businessPlaceCd);
	$("#taxDocNo").val(taxDocNo);
	// 2015-08-31 YHCHOI ADD
	$("#reportYmd").val(reportYmd);
	$("#belongYm").val(belongYm);
	// 2016-09-19 YHCHOI ADD
	$("#closeYn").val(closeYn);

	var param = {
			cmd:'getCommonNSCodeList'
			,businessPlaceCd:businessPlaceCd
	};

	// 납세지(TSYS015)
	var locationCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?"+$.param(param), "getSaupsoseCdList") , "");
	$("#locationCd").html(locationCd[2]);


	$(window).smartresize(sheetResize);
	sheetInit();

	$(".close").click(function() {
		p.self.close();
	});

	$("#sEmpCnt").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#dEmpCnt").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#taxExpMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#taxMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#taxCalMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#taxAddMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#totTaxMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#delayDay").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	<%--
	$("#paymentAddTaxMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#regAddTaxMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	--%>
	$("#paymentDelayMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#underRegMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});
	$("#nonRegMon").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});	
	$("#ownType").bind("keyup",function(event){
		makeNumber(this, 'A');
		Num_Comma(this);
	});

	$("#locationCd").bind("change",function() {
		doAction1("Search");
	});

	$("#paymentYmd").datepicker2();
	$("#paymentYmd2d").datepicker2();

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

			var dtl3Info = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl3Map", $("#sheet1Form").serialize(), false);

			$("#sEmpCnt"		).val("");
			$("#dEmpCnt"		).val("");
			$("#taxExpMon"		).val("");
			$("#taxMon"			).val("");
			$("#taxCalMon"		).val("");
			$("#paymentYmd"		).val("");
			$("#taxAddMon"		).val("");
			$("#totTaxMon"		).val("");
			$("#paymentYmd2d"	).val("");
			$("#delayDay"		).val("");
			<%--
			$("#paymentAddTaxMon").val("");
			$("#regAddTaxMon"	).val("");
			--%>
			$("#paymentDelayMon").val("");
			$("#underRegMon"	).val("");
			$("#nonRegMon"	    ).val("");
			$("#ownType"		).val("");
			$("#tdTotMon"		).html("");
			$("#headOfficeAddr"	).val("");
			

			if(dtl3Info.Data != null) {
				dtl3Info = dtl3Info.Data;
				$("#sEmpCnt"		).val(dtl3Info.s_emp_cnt			);
				$("#dEmpCnt"		).val(dtl3Info.d_emp_cnt			);
				$("#taxExpMon"		).val(dtl3Info.tax_exp_mon		);
				$("#taxMon"			).val(dtl3Info.tax_mon			);
				$("#taxCalMon"		).val(dtl3Info.tax_cal_mon		);
				$("#paymentYmd"		).val(dtl3Info.payment_ymd		);
				$("#taxAddMon"		).val(dtl3Info.tax_add_mon		);
				$("#totTaxMon"		).val(dtl3Info.tot_tax_mon		);
				$("#paymentYmd2d"	).val(dtl3Info.payment_ymd_2d		);
				$("#delayDay"		).val(dtl3Info.delay_day			);
				<%--
				$("#paymentAddTaxMon").val(dtl3Info.payment_add_tax_mon);
				$("#regAddTaxMon"	).val(dtl3Info.reg_add_tax_mon		);
				--%>
				$("#paymentDelayMon").val(dtl3Info.payment_delay_mon);
				$("#underRegMon"	).val(dtl3Info.under_reg_mon	);
				$("#nonRegMon"	    ).val(dtl3Info.non_reg_mon		);
				$("#ownType"		).val(dtl3Info.own_type			);
				$("#tdTotMon"		).html(dtl3Info.tot_mon			);
				$("#headOfficeAddr"	).val(dtl3Info.head_office_addr );
				addComma($("#sEmpCnt")[0]);
				addComma($("#dEmpCnt")[0]);
				addComma($("#taxExpMon")[0]);
				addComma($("#taxMon")[0]);
				addComma($("#taxCalMon")[0]);
				addComma($("#taxAddMon")[0]);
				addComma($("#totTaxMon")[0]);
				addComma($("#delayDay")[0]);
				<%--
				addComma($("#paymentAddTaxMon")[0]);
				addComma($("#regAddTaxMon")[0]);
				--%>
				addComma($("#paymentDelayMon")[0]);
				addComma($("#underRegMon")[0]);
				addComma($("#nonRegMon")[0]);
				addComma($("#tdTotMon")[0]);
			}
			break;

		case "Save":
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

			if (confirm("수정사항을 반영하시겠습니까?")) {

				var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgrDtl3_2025",$("#sheet1Form").serialize(),false);

				if (result && result.Result) {
					if (result.Result.Code > 0) {
						doAction1("Search");
					}
				}
			}
			break;

		case "PrcP_CPN_ORIGIN_OFFICE_TAX_INS":
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
				var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=prcP_CPN_ORIGIN_OFFICE_TAX_INS", "taxDocNo="+taxDocNo+"&businessPlaceCd="+businessPlaceCd+"&locationCd="+locationCd, false);

				if (result && result.Result) {
					if (result.Result.Code > 0) {
						doAction1("Search");
					}
				}
			}
			break;

		case "PrcP_CPN_ORIGIN_OFFICE_TAX_INS_ALL":
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
				var locationCd		= "ALL"

				if ( businessPlaceCd == "%") businessPlaceCd = "ALL";

				// 자료생성
				var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=prcP_CPN_ORIGIN_OFFICE_TAX_INS", "taxDocNo="+taxDocNo+"&businessPlaceCd="+businessPlaceCd+"&locationCd="+locationCd, false);

				if (result && result.Result) {
					if (result.Result.Code > 0) {
						doAction1("Search");
					}
				}
			}
			break;
	}
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
	
	var imgPath = "<%=rdStempImgUrl%>";

	var yyyy = $("#reportYmd").val();
	yyyy = yyyy.substr(0, 4);
	
	if (reportGb == "1") {

		if (yyyy < 2015)
		    reportFileNm = "BusinessTaxDeclaration.mrd";
		else if (yyyy < 2025) 
			reportFileNm = "BusinessTaxDeclaration_2015.mrd";
		else 
			reportFileNm = "BusinessTaxDeclaration_2025.mrd";
		
		rdTitle = "사업소득세신고서";
	} else  {

		if (yyyy < 2015)
		    reportFileNm = "BusinessTaxReceipt.mrd";
		else 
			reportFileNm = "BusinessTaxReceipt_2015.mrd";
		
		rdTitle = "사업소득세지로영수증";
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

	if(pGb == "ALL"){
		args["rdParam"] = "P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_TAX_DOC_NO["+$("#taxDocNo").val()+"] P_BIZ_CD["+$("#businessPlaceCd").val()+"] P_LOCATION_CD["+vals+"] P_IMG_URL["+imgPath+"]";
	}else{
		args["rdParam"] = "P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_TAX_DOC_NO["+$("#taxDocNo").val()+"] P_BIZ_CD["+$("#businessPlaceCd").val()+"] P_LOCATION_CD['"+$("#locationCd").val()+"'] P_IMG_URL["+imgPath+"]";
	}

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

function addComma(obj) {
    str = obj.value;
    /*4자리 미만 컨마 안함*/
    if(str == null || str.length < 4) return ;
    
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

//대상자 팝업
function openEarnIncomeTaxMgrDtl3EmpPopup() {
	var w	= 700;
	var h	= 800;
	var url	= "";
	var args= new Array();

	url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl3EmpPopup.jsp";
	
	args["tax_doc_no"] 			= $("#taxDocNo").val();
	args["business_place_cd"] 	= $("#businessPlaceCd").val();
	args["location_cd"] 		= $("#locationCd").val();

	openPopup(url+"?authPg=<%=authPg%>", args, w, h);
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>사업소득세</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="taxDocNo" name="taxDocNo" value="" />
		<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" class="text" value="" />
		<input type="hidden" id="reportYmd" name="reportYmd" value="" />
		<input type="hidden" id="belongYm" name="belongYm" value="" />
		<input type="hidden" id="closeYn" name="closeYn" value="" />
		
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>납세지</span> <select id="locationCd" name="locationCd"> </select> </td>
						<td> <a href="javascript:doAction1('Search');"	class="button authR">조회</a> </td>
						<td style="width:100%;" class="right"> <a href="javascript:doAction1('PrcP_CPN_ORIGIN_OFFICE_TAX_INS_ALL')"	class="button authA">전체자료생성</a> </td>
					</tr>
				</table>
			</div>
		</div>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="outer">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"></li>
							<li class="btn">
							<select id="reportGb" name="reportGb">
								<option value="1">신고서</option>
								<option value="2">지로영수증</option>
							</select>
							<a href="javascript:callRd('ALL')"								class="basic authA">전체출력</a>
							<a href="javascript:callRd('NO')"										class="basic authA">출력</a>
							<a href="javascript:doAction1('Save')"								class="basic authA">저장</a>
							<a href="javascript:doAction1('PrcP_CPN_ORIGIN_OFFICE_TAX_INS')"	class="basic authA">자료생성</a>
							</li>
						</ul>
						</div>
					</div>
					<table border="0" cellpadding="0" cellspacing="0" class="default outer">
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
					</colgroup>
					<tr>
						<th class="center" colspan="2">사업소인원
							&nbsp;<a href="javascript:openEarnIncomeTaxMgrDtl3EmpPopup();" class="basic">대상자 확인</a>
						</th>
						<th class="center" colspan="3">과세표준액</th>
					</tr>
					<tr>
						<th class="center">상용직</th>
						<th class="center">일용직</th>
						<th class="center">계</th>
						<th class="center">과세제외급여</th>
						<th class="center">과세급여</th>
					</tr>
					<tr>
						<td class="center"> <input type="text" id="sEmpCnt" name="sEmpCnt" class="text right" value="" style="width:130px"/> </td>
						<td class="center"> <input type="text" id="dEmpCnt" name="dEmpCnt" class="text right" value="" style="width:130px" /> </td>
						<td class="text right" id="tdTotMon"> </td>
						<td class="center"> <input type="text" id="taxExpMon" name="taxExpMon" class="text right" value="" style="width:130px" /> </td>
						<td class="center"> <input type="text" id="taxMon" name="taxMon" class="text right" value="" style="width:130px" /> </td>
					</tr>
					<tr>
						<th class="center" colspan="5">납부할세액</th>
					</tr>
					<tr>
						<th class="center" colspan="2">산출세액(과세급액 * 0.5%)</th>
						<td class="center"> <input type="text" id="taxCalMon" name="taxCalMon" class="text right" value="" style="width:130px" /> </td>
						<th class="center">납부기한</th>
						<td class="center"> <input type="text" id="paymentYmd" name="paymentYmd" class="text date2" value="" /> </td>
					</tr>
					<tr>
						<th class="center" colspan="2">가산세</th>
						<td class="center"> <input type="text" id="taxAddMon" name="taxAddMon" class="text right" value="" style="width:130px" /> </td>
						<th class="center">신고세액합계</th>
						<td class="center"> <input type="text" id="totTaxMon" name="totTaxMon" class="text right" value="" style="width:130px" /> </td>
					</tr>
					<tr>
						<th class="center" colspan="5">2D(자동화기기 수납)로 납부시 입력필수 항목 - 2D로 납부하지 않는 경우 입력하지 않습니다.</th>
					</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
					</colgroup>
					<tr>
					    <th class="center">당초납부기한</th>
						<th class="center">납부지연일수</th>
						<%--
						<th class="center">납부설성실가산세</th>
						<th class="center">신고불성실가산세</th>
						 --%>
						<th class="center">납부지연가산세</th>
						<th class="center">과소신고가산세</th>
						<th class="center">무신고가산세</th>						
						<th class="center">소유구분</th>
					</tr>
					<tr>
						<td class="center"> <input type="text" id="paymentYmd2d" name="paymentYmd2d" class="text date2" value="" /> </td>
						<td class="center"> <input type="text" id="delayDay" name="delayDay" class="text right" value="" style="width:130px" /> </td>
						<%--						
						<td class="center"> <input type="text" id="paymentAddTaxMon" name="paymentAddTaxMon" class="text right" value="" style="width:130px" /> </td>
						<td class="center"> <input type="text" id="regAddTaxMon" name="regAddTaxMon" class="text right" value="" style="width:130px" /> </td>
						--%>
						<td class="center"> <input type="text" id="paymentDelayMon" name="paymentDelayMon" class="text right" value="" style="width:130px" /> </td>
						<td class="center"> <input type="text" id="underRegMon" name="underRegMon" class="text right" value="" style="width:130px" /> </td>
						<td class="center"> <input type="text" id="nonRegMon" name="nonRegMon" class="text right" value="" style="width:130px" /> </td>
						
						<td class="center"> <select id="ownType" name="ownType"><option value=""></option><option value="1">자가</option><option value="2">임대</option></select> </td>
					</tr>
					<tr>
					    <th class="center">본점주소</th>
						<td class="Left" colspan="5"> <input type="text" id="headOfficeAddr" name="headOfficeAddr" class="text left" value="" style="width:100%" /> </td>
					</tr>
					</table>
					<center><a href="javascript:p.self.close();" class="gray large">닫기</a></center>
				</td>
			</tr>
		</table>
		</form>
	</div>
</div>
</body>
</html>