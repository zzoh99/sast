<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금기본내역 기본사항</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직금기본내역
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {

	$("input[type='text']").keydown(function(event){
		if(event.keyCode == 27){
			return false;
		}
	});

	$(window).smartresize(sheetResize);
	sheetInit();

/* 	if (parent.$("#searchKeyword").val() != null && parent.$("#searchKeyword").val() != "") {
		$("#irpName").val(parent.$("#searchKeyword").val());
	} */
/* 	if (parent.$("#tdSabun").val() != null && parent.$("#tdSabun").val() != "" &&
		parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
		doAction1("Search");
	} */
	setEmpPage();
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if (sAction == "Search") {
		if ($("#sabun").val() == "") {
			return false;
		}
		if ($("#payActionCd").val() == "") {
			return false;
		}
	} else if ("Save") {
		if ($("#sabun").val() == "") {
			alert("대상자를 선택하십시오.");
			return false;
		}
		if ($("#irpBankCd").val() == "") {
			alert("은행(IRP)을 선택하십시오.");
			return false;
		}
		if ($("#irpAccountNo").val().trim() == "") {
			alert("계좌번호(IRP)를 입력하십시오.");
			return false;
		}
	}
/* 	if (sAction == "Search") {
		if (parent.$("#tdSabun").val() == "") {
			parent.$("#tdSabun").focus();
			return false;
		}
		if (parent.$("#payActionCd").val() == "") {
			parent.$("#payActionCd").focus();
			return false;
		}
	} else if ("Save") {
		if (parent.$("#tdSabun").val() == "") {
			alert("대상자를 선택하십시오.");
			parent.$("#tdSabun").focus();
			return false;
		}
		if ($("#irpBankCd").val() == "") {
			alert("은행(IRP)을 선택하십시오.");
			return false;
		}
		if ($("#irpAccountNo").val().trim() == "") {
			alert("계좌번호(IRP)를 입력하십시오.");
			return false;
		}
	} */

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
/* 			if (!chkInVal(sAction)) {
				break;
			} */

			doAction1("Clear");

			var basicInfo = ajaxCall("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrBasicMap", $("#sheet1Form").serialize(), false);

			if (basicInfo.Map != null) {
				basicInfo = basicInfo.Map;

				$("#tdEmpYmd"	).html(basicInfo.empYmd);
				$("#tdRetYmd"	).html(basicInfo.retYmd);
				$("#tdRmidYmd"	).html(basicInfo.rmidYmd);
				$("#tdSepSymd"	).html(basicInfo.sepSymd);
				$("#tdSepEymd"	).html(basicInfo.sepEymd);

				$("#paymentYmd"	).val(basicInfo.paymentYmd);
				$("#sepSymd"	).val(basicInfo.sepSymd);
				$("#sepEymd"	).val(basicInfo.sepEymd);

				$("#wkpExMCnt"	).val(basicInfo.wkpExMCnt);
				$("#wkpAddMCnt"	).val(basicInfo.wkpAddMCnt);

				$("#wkpYCnt"	).val(basicInfo.wkpYCnt);
				$("#wkpMCnt"	).val(basicInfo.wkpMCnt);

				$("#twkpDCnt"	).val(basicInfo.twkpDCnt);
				$("#twkpMCnt"	).val(basicInfo.twkpMCnt);


				if (basicInfo.payGubun == "2") {
					$(':radio[name="payGubun"]').eq(0).attr("checked", "checked");
				} else if (basicInfo.payGubun == "1") {
					$(':radio[name="payGubun"]').eq(1).attr("checked", "checked");
				}

				if (basicInfo.residencyType == "1") {
					$(':radio[name="residencyType"]').eq(0).attr("checked", "checked");
				} else if (basicInfo.residencyType == "2") {
					$(':radio[name="residencyType"]').eq(1).attr("checked", "checked");
				}

				if (basicInfo.citizenType == "1") {
					$(':radio[name="citizenType"]').eq(0).attr("checked", "checked");
				} else if (basicInfo.citizenType == "9") {
					$(':radio[name="citizenType"]').eq(1).attr("checked", "checked");
				}


				if (basicInfo.retGubun == "1") {
					$(':radio[name="retGubun"]').eq(0).attr("checked", "checked");
				} else if (basicInfo.retGubun == "2") {
					$(':radio[name="retGubun"]').eq(1).attr("checked", "checked");
				} else if (basicInfo.retGubun == "3") {
					$(':radio[name="retGubun"]').eq(2).attr("checked", "checked");
				} else if (basicInfo.retGubun == "4") {
					$(':radio[name="retGubun"]').eq(3).attr("checked", "checked");
				} else if (basicInfo.retGubun == "5") {
					$(':radio[name="retGubun"]').eq(4).attr("checked", "checked");
				}


				if (basicInfo.retCorp == "1") {
					$(':radio[name="retCorp"]').eq(0).attr("checked", "checked");
				} else if (basicInfo.retCorp == "2") {
					$(':radio[name="retCorp"]').eq(1).attr("checked", "checked");
				} else if (basicInfo.retCorp == "3") {
					$(':radio[name="retCorp"]').eq(2).attr("checked", "checked");
				}



				$("#residenceCd").val(basicInfo.residenceCd);
				$("#residenceNm").val(basicInfo.residenceNm);

				$("#bankCd").val(basicInfo.bankCd);
				$("#bankNm").val(basicInfo.bankNm);
				$("#name").val(basicInfo.name);
				$("#accountNo").val(basicInfo.accountNo);

				$("#irpBankCd").val(basicInfo.irpBankCd);
				$("#irpBankNm").val(basicInfo.irpBankNm);
				if (basicInfo.irpName != null && basicInfo.irpName != "") {
					$("#irpName").val(basicInfo.irpName);
				}
				$("#irpAccountNo").val(basicInfo.irpAccountNo);

			} else if (basicInfo.Message != null && basicInfo.Message != "") {
				alert(basicInfo.Message);
			}
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if (confirm("IRP정보를 저장하시겠습니까?")) {

				//$("#sabun").val(parent.$("#tdSabun").val());

				var result = ajaxCall("${ctx}/SepEmpRsMgr.do?cmd=saveSepEmpRsMgrIrpInfo", $("#sheet1Form").serialize(), false);

				if (result != null && result["Result"] != null && result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
					alert(result["Result"]["Message"]);
				} else {
					alert("저장 중 오류입니다.");
				}

			}
			break;

		case "Clear":


			$("#paymentYmd"	).val("");
			$("#wkpExMCnt"	).val("");
			$("#wkpAddMCnt"	).val("");
			$("#twkpDCnt"	).val("");
			$("#twkpMCnt"	).val("");
			$("#twkpDCnt"	).val("");
			$("#twkpMCnt"	).val("");
			$("#irpName"	).val("");
			$("#irpAccountNo"	).val("");

			$("#sepSymd"	).val("");
			$("#sepEymd"	).val("");
			$("#wkpYCnt"	).val("");
			$("#wkpMCnt"	).val("");


			$("#tdEmpYmd"	).html("");
			$("#tdRetYmd"	).html("");
			$("#tdRmidYmd"	).html("");
			$("#tdSepSymd"	).html("");
			$("#tdSepEymd"	).html("");
			$(':radio[name="residencyType"]').eq(0).attr("checked", false);
			$(':radio[name="residencyType"]').eq(1).attr("checked", false);
			$(':radio[name="citizenType"]').eq(0).attr("checked", false);
			$(':radio[name="citizenType"]').eq(1).attr("checked", false);
			$("#residenceCd").val("");
			$("#residenceNm").val("");
			$("#irpBankCd").val("");
			$("#irpBankNm").val("");
/* 			if (parent.$("#searchKeyword").val() != null && parent.$("#searchKeyword").val() != "") {
				$("#irpName").val(parent.$("#searchKeyword").val());
			} else {
				$("#irpName").val("");
			} */
			$("#irpAccountNo").val("");
			break;
	}
}

// 은행검색 팝업
function bankSearchPopup() {
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "commonCodePopup";

	var w		= 440;
	var h		= 520;
	var url		= "/Popup.do?cmd=commonCodePopup";
	var args	= new Array();
	args["grpCd"] = "H30001";

	var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var bankLeader		= result["code"];
		var bankLeaderNm	= result["codeNm"];

		$("#irpBankCd").val(bankLeader);
		$("#irpBankNm").val(bankLeaderNm);
	}
	*/
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "commonCodePopup"){
		var bankLeader		= rv["code"];
		var bankLeaderNm	= rv["codeNm"];

		$("#irpBankCd").val(bankLeader);
		$("#irpBankNm").val(bankLeaderNm);

    }
}

function setEmpPage() {

	var selectRow = parent.sheetLeft.GetSelectRow();

	if ( selectRow > 0 ){
		var tdSabun = parent.sheetLeft.GetCellValue(selectRow, "sabun");
		var payActionCd = parent.sheetLeft.GetCellValue(selectRow, "payActionCd");
		var closeYn = parent.sheetLeft.GetCellValue(selectRow, "closeYn");

		$("#sabun").val(tdSabun);
		$("#payActionCd").val(payActionCd);

		if ( closeYn == "Y" ){
			$(".closeBtn").hide();
			$(".button6").hide();
			$(".button7").hide();
			$("#irpName").addClass("readonly");
			$("#irpAccountNo").addClass("readonly");
			$("#irpName").attr("readonly", true);
			$("#irpAccountNo").attr("readonly", true);
		}else{
			$(".closeBtn").show();
			$(".button6").show();
			$(".button7").show();
			$("#irpName").removeClass("readonly");
			$("#irpAccountNo").removeClass("readonly");
			$("#irpName").attr("readonly", false);
			$("#irpAccountNo").attr("readonly", false);
		}

		doAction1("Search");
	}else{
		$(".closeBtn").hide();
		$(".button6").hide();
		$(".button7").hide();
		$("#irpName").addClass("readonly");
		$("#irpAccountNo").addClass("readonly");
		$("#irpName").attr("readonly", true);
		$("#irpAccountNo").attr("readonly", true);
	}
}
</script>
</head>
<body class="hidden">
<!-- <div class="wrapper" id="tableDiv" style="overflow:auto;overflow-x:hidden;border:0px;margin-bottom:0px"> -->
<div class="wrapper" id="tableDiv" style="overflow: auto;">
<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="sabun" name="sabun" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">기본사항</li>
				<li class="btn">
					<a href="javascript:doAction1('Save')"	class="basic authA closeBtn">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th>입사일</th>
			<td id="tdEmpYmd" class="center"> </td>
			<th>퇴사일</th>
			<td id="tdRetYmd" class="center"> </td>
		</tr>
		<tr>
			<th>최종중간정산일</th>
			<td colspan="3" id="tdRmidYmd" class="center"> </td>
		</tr>
		<tr>
			<th>퇴직기산시작일</th>
			<td id="tdSepSymd" class="center"> </td>
			<th>퇴직기산종료일</th>
			<td id="tdSepEymd" class="center"> </td>
		</tr>
	</table>

	<table border="0" cellpadding="0" cellspacing="0" class="default outer hide">
		<colgroup>
			<col width="24%" />
			<col width="24%" />
			<col width="24%" />
			<col width="24%" />
		</colgroup>
		<tr>
			<th>일련번호</th>
			<td> <input type="text" id="" name="" class="text readonly" style="width:60px;" readonly /> </td>
			<th>정산구분</th>
			<td> <input type="radio" id="payGubun" name="payGubun" class="radio" value="" disabled /> 중간정산
				 <input type="radio" id="payGubun" name="payGubun" class="radio" value="" disabled /> 퇴직정산 </td>
		</tr>
		<tr>
			<th>작업일자</th>
			<td> <input type="text" id="paymentYmd" name="paymentYmd" class="date2 readonly center" style="width: 60px;" readonly /> </td>
			<th>법정제외기간</th>
			<td> <input type="text" id="" name="" class="date2 readonly" style="width: 60px;" readonly /> ~ <input type="text" id="" name="" class="date2 readonly" style="width: 60px;" readonly /> </td>

		</tr>
		<tr>
			<th>법정제외일수</th>
			<td> <input type="text" id="" name="" class="text readonly" style="width:60px;" readonly /> </td>
			<th>법정제외월수</th>
			<td> <input type="text" id="wkpExMCnt" name="wkpExMCnt" class="text readonly" style="width:60px;" readonly /> </td>
		</tr>
		<tr>
			<th>법정외제외기간</th>
			<td> <input type="text" id="" name="" class="date2 readonly" style="width: 60px;" readonly /> ~ <input type="text" id="" name="" class="date2 readonly" style="width: 60px;" readonly /> </td>
			<th>법정외제외일수</th>
			<td> <input type="text" id="" name="" class="text readonly" style="width:60px;" readonly /> </td>
		</tr>
		<tr>
			<th>법정외제외월수</th>
			<td> <input type="text" id="" name="" class="text readonly" style="width:60px;" readonly /> </td>
			<th>정산기간</th>
			<td> <input type="text" id="sepSymd" name="sepSymd" class="date2 readonly center" style="width: 60px;" readonly /> ~ <input type="text" id="sepEymd" name="sepEymd" class="date2 readonly center" style="width: 60px;" readonly /> </td>
		</tr>
		<tr>
			<th>법정가산월수</th>
			<td> <input type="text" id="wkpAddMCnt" name="wkpAddMCnt" class="text readonly" style="width:60px;" readonly /> </td>
			<th>전체가산월수</th>
			<td> <input type="text" id="wkpAddMCnt" name="wkpAddMCnt" class="text readonly" style="width:60px;" readonly /> </td>
		</tr>
		<tr>
			<th>거주구분</th>
			<td> <input type="radio" id="residencyType" name="residencyType" class="radio" value="1" disabled /> 거주자
				 <input type="radio" id="residencyType" name="residencyType" class="radio" value="2" disabled /> 비거주자 </td>
			<th>내외국인</th>
			<td> <input type="radio" id="citizenType" name="citizenType" class="radio" value="1" disabled /> 내국인
				 <input type="radio" id="citizenType" name="citizenType" class="radio" value="9" disabled /> 외국인 </td>
		</tr>
		<tr>
			<th>근속년수</th>
			<td> <input type="text" id="wkpYCnt" name="wkpYCnt" class="text readonly" style="width:60px;text-align:right;" readonly /> </td>
			<th>근속월수</th>
			<td> <input type="text" id="wkpMCnt" name="wkpMCnt" class="text readonly" style="width:60px;text-align:right;" readonly /> </td>
		</tr>
		<tr>
			<th>거주지국코드</th>
			<td> <input type="text" id="residenceCd" name="residenceCd" class="text readonly" style="width:60px;" readonly /> </td>
			<th>거주지국</th>
			<td> <input type="text" id="residenceNm" name="residenceNm" class="text readonly" style="width:120px;" readonly /> </td>
		</tr>
		<tr>
			<th>퇴직금산정일수</th>
			<td> <input type="text" id="twkpDCnt" name="twkpDCnt" class="text readonly" style="width:60px;color:#FF0000;text-align:right;" readonly /> </td>
			<th>산정월수</th>
			<td> <input type="text" id="twkpMCnt" name="twkpMCnt" class="text readonly" style="width:60px;color:#FF0000;text-align:right;" readonly /> </td>
		</tr>
		<tr>
			<th>퇴직사유</th>
			<td colspan="3"> <input type="radio" id="retGubun" name="retGubun" class="radio" value="" disabled /> 정년퇴직
							 <input type="radio" id="retGubun" name="retGubun" class="radio" value="" disabled /> 정리해고
							 <input type="radio" id="retGubun" name="retGubun" class="radio" value="" disabled /> 중간정산
							 <input type="radio" id="retGubun" name="retGubun" class="radio" value="" disabled /> 임원퇴직
							 <input type="radio" id="retGubun" name="retGubun" class="radio" value="" disabled /> 기타 </td>
		</tr>
		<tr>
			<th>수령구분</th>
			<td colspan="3"> <input type="radio" id="retCorp" name="retCorp" class="radio" value="" disabled /> 본인수령
							 <input type="radio" id="retCorp" name="retCorp" class="radio" value="" disabled /> 본인수령(IRP)
							 <input type="radio" id="retCorp" name="retCorp" class="radio" value="" disabled /> 계열이체 </td>
		</tr>
		<tr>
			<th>은행명</th>
			<td colspan="3"> <input type="text" id="bankCd" name="bankCd" class="text readonly" style="width:60px;" readonly /> <input type="text" id="bankNm" name="bankNm" class="text readonly" style="width:200px;" readonly /> </td>
		</tr>
		<tr>
			<th>예금주</th>
			<td> <input type="text" id="name" name="name" class="text readonly" style="width:60px;" readonly /> </td>
			<th>계좌번호</th>
			<td> <input type="text" id="accountNo" name="accountNo" class="text readonly" style="width:110px;" readonly /> </td>
		</tr>
		<tr>
			<th>은행명(IRP)</th>
			<td colspan="3"> <input type="text" id="irpBankCd" name="irpBankCd" class="text center required readonly" style="width:60px;" readonly />
							 <a onclick="javascript:bankSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							 <a onclick="$('#irpBankCd,#irpBankNm').val('');return false;" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
							 <input type="text" id="irpBankNm" name="irpBankNm" class="text readonly" style="width:200px;" readonly /> </td>
		</tr>
		<tr>
			<th>예금주(IRP)</th>
			<td> <input type="text" id="irpName" name="irpName" class="text" style="width:60px;" /> </td>
			<th>계좌번호(IRP)</th>
			<td> <input type="text" id="irpAccountNo" name="irpAccountNo" class="text required" style="width:110px;" /> </td>
		</tr>
		<tr>
			<th>과세이연계좌<br>입금일</th>
			<td> <input type="text" id="" name="" class="date2 readonly" readonly /> </td>
			<th>과세이연계좌<br>최초가입일자</th>
			<td> <input type="text" id="" name="" class="date2 readonly" readonly /> </td>
		</tr>
		<tr>
			<th>과세이연<br>사업자등록번호</th>
			<td colspan="3"> <input type="text" id="" name="" class="text readonly" style="width:200px;" readonly /> </td>
		</tr>
		<tr>
			<th rowspan="2">특이사항</th>
			<td colspan="3" rowspan="2"> <textarea disabled="disabled" class="readonly" style="width:280px;height:40px"> </textarea> </td>
		</tr>
	</table>
</form>
</div>
</body>
</html>