<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='perPayPartiAdminSta' mdef='개인별급여세부내역(관리자)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<!--
 * 개인별급여세부내역(관리자)
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {
	$(window).smartresize(sheetResize);
	sheetInit();

	if ($("#searchUserId").val() != null && $("#searchUserId").val() != "null" && $("#searchUserId").val() != "") {
		// 최근급여일자 조회
		searchLatestPaymentInfo();
	}

	setTimeout(function(){
		$("#iframeSubMain").attr("src","${ctx}/PerPayPartiAdminSta.do?cmd=viewPerPayPartiAdminStaSubMain&authPg=${authPg}");
	},100);
});

// 필수값/유효성 체크
function chkInVal() {
	if ($("#searchUserId").val() == null || $("#searchUserId").val() == "null" || $("#searchUserId").val() == "") {
		alert("<msg:txt mid='alertSepCalcBasicMgr1' mdef='대상자를 선택하십시오.'/>");
		return false;
	}
	if ($("#payActionCd").val() == null || $("#payActionCd").val() == "null" || $("#payActionCd").val() == "") {
		alert("<msg:txt mid='109681' mdef='급여일자를 선택하십시오.'/>");
		$("#payActionCd").focus();
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			$("#sabun").val($("#searchUserId").val());

			// Sub Main 호출
			//iframeSubMain.doAction1("Search");
			$('iframe')[0].contentWindow.doAction1("Search");
			break;
	}
}

// 최근급여일자 조회
function searchLatestPaymentInfo() {
	$("#sabun").val($("#searchUserId").val());

	var paymentInfo = ajaxCall("${ctx}/PerPayPartiAdminSta.do?cmd=getAdminLatestPaymentInfoMap", $("#sheet1Form").serialize(), false);

	if(paymentInfo.Map != null) {
		paymentInfo = paymentInfo.Map;

		$("#payActionCd").val(paymentInfo.payActionCd);
		$("#payActionNm").val(paymentInfo.payActionNm);
	}
}

// 급여일자 검색 팝입
function payActionSearchPopup() {

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			searchSabun : $("#sabun").val()
			, searchType : 'A'
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
					doAction1("Search");
				}
			}
		]
	});
	layerModal.show();


	// var w		= 840;
	// var h		= 520;
	// var url		= "/PayDayPopup.do?cmd=payDayPopup";
	// var args	= new Array();
	//
	// args["searchSabun"]	= $("#sabun").val();
	// args["searchType"]	= "A";	// 개인별급여세부내역(관리자)용 쿼리호출
	//
	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "payDayPopup";
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var payActionCd	= result["payActionCd"];
		var payActionNm	= result["payActionNm"];

		$("#payActionCd").val(payActionCd);
		$("#payActionNm").val(payActionNm);

		doAction1("Search");
	}
	*/
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

	if(pGubun == "payDayPopup"){

		$("#payActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);
		doAction1("Search");

	}
}
// 급여명세서 팝업
function previewPopup() {
	if (!chkInVal()) return;

	let layerModal = new window.top.document.LayerModal({
		id : 'payPartiLayer'
		, url : '/PerPayPartiUserSta.do?cmd=viewPerPayPartiLayer&authPg=R'
		, parameters : {
			sabun : $("#sabun").val()
			, payActionCd : $("#payActionCd").val()
		}
		, width : 680
		, height : 700
		, title : '<tit:txt mid='perPayPartiPopSta' mdef='급여명세서'/>'
	});
	layerModal.show();


	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "viewPerPayPartiPopSta";
	// // 필수값/유효성 체크
	// if (!chkInVal()) {
	// 	return;
	// }
	//
	// var w		= 680;
	// var h		= 700;
	// var url		= "/PerPayPartiAdminSta.do?cmd=viewPerPayPartiPopSta";
	// var args	= new Array();
	//
	// args["sabun"]		= $("#sabun").val();
	// args["payActionCd"]	= $("#payActionCd").val();
	//
	// openPopup(url+"&authPg=R", args, w, h);
}

function setEmpPage() {
	$("#sabun").val($("#searchUserId").val());
	searchLatestPaymentInfo();
	if ($("#payActionCd").val() != "") {
		doAction1("Search");
	}
}

$(function() {
	var itop = getOuterHeight()+7;
	$("#ifm").css("top", itop+"px");
});
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<!-- include 기본정보 page -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	
	<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search sheet_search_s outer">
			<div>
				<table>
					<tr>
						<th>급여일자</th>
						<td>
							<input type="hidden" id="payActionCd" name="payActionCd" value="" /><input type="hidden" id="sabun" name="sabun" class="text" value="" />
							<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" /><a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							
						</td>
						<td class="text-right">
							<btn:a href="javascript:doAction1('Search');" css="button authR" mid='search' mdef="조회"/>
							<btn:a href="javascript:previewPopup()"	css="basic authR" mid='111497' mdef="급여명세서"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<div id="ifm" class="layout_tabs">
		<iframe name="iframeSubMain" id="iframeSubMain" src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe>
	</div>
</div>
</body>
</html>
