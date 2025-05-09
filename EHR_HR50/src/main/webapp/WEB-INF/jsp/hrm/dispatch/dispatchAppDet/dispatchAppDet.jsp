<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<title><tit:txt mid='104500' mdef='파견신청 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	/*

	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var searchApplSabun = "${searchApplSabun}";
	var searchSabun = "${searchSabun}";
	var searchApplYmd = "${searchApplYmd}";
	*/
	var searchApplSeq = "${searchApplSeq}";
	var applStatusCd = parent.$("#applStatusCd").val();

$(function(){

	// 신청 상태가 없을 경우
	if(applStatusCd == ""){
		//무조건 임시정장으로 본다.
		applStatusCd = "11";
	}

	parent.iframeOnLoad("200px");
/*
	saveData= ajaxCall("${ctx}/GetDataMap.do?cmd=getTimeOffAppPatDetSaveMap",$("#sheetForm").serialize(),false);
	if(saveData.DATA){
		$("#sdate").val(saveData.DATA.refSdate);
		$("#edate").val(saveData.DATA.refEdate);
		$("#reason").val(saveData.DATA.refReason);
		$("#etc").val(saveData.DATA.etc);
	}
	*/
	var data = ajaxCall("${ctx}/GetDataMap.do?cmd=getDispatchAppDet","&searchApplSeq="+searchApplSeq,false);
	if(data.DATA){
		/*
		var dispatchSymd = data.map['dispatchSymd'];
		var dispatchEymd = data.map['dispatchEymd'];
		var dispatchOrgCd = data.map['dispatchOrgCd'];
		var dispatchReason = data.map['dispatchReason'];
		*/

		$("#dispatchSymd").val(data.DATA.dispatchSymd);
		$("#dispatchEymd").val(data.DATA.dispatchEymd);
		$("#dispatchOrgCd").val(data.DATA.dispatchOrgCd);
		$("#dispatchOrgNm").val(data.DATA.dispatchOrgNm);
		$("#dispatchReason").val(data.DATA.dispatchReason);

	}


	if("${authPg}"=="R"){
		$("#dispatchReason").addClass("readonly").attr("readOnly","readOnly");
		$("#etc").addClass("readonly").attr("readOnly","readOnly");
		$("#dispatchSymd").addClass("readonly").attr("readOnly","readOnly");
		$("#dispatchEymd").addClass("readonly").attr("readOnly","readOnly");
		$("#dispatchOrgBtn").hide();

	}else{
		$("#dispatchSymd").datepicker2({
			startdate:"dispatchEymd",
			onReturn: function(date) {
				var num = getDaysBetween(date.replace(/-/g,""),$("#dispatchEymd").val().replace(/-/g,""));
				//$("#day").text(num+"일");
				tDay = num;
			}
		});
		$("#dispatchEymd").datepicker2({
			enddate:"dispatchSymd",
			onReturn: function(date) {
				var num = getDaysBetween($("#dispatchSymd").val().replace(/-/g,""),date.replace(/-/g,""));
				//$("#day").text(num+"일");
				tDay = num;
			}
		});
	}


	// 파견지코드
	var dispatchOrgCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getLoanAppDetLoanCd&applYmd="+searchApplYmd , false).codeList, "선택");
	$("#dispatchOrgCd").html(dispatchOrgCd[2]);

	//Cancel 버튼 처리
	$(".close").click(function(){
		self.close();
	});

});

function setValue(status){

	if($("#authPg").val() == "A") {
		var limitTerm = $("#limitTerm").val();
		var applTitle = $("#applTitle", parent.document).val();

		if($("#dispatchSymd").val() == "") {
			alert("<msg:txt mid='109726' mdef='파견 시작일을 선택해 주세요.'/>");
			return false;
		}
		if($("#dispatchEymd").val() == "") {
			alert("<msg:txt mid='110451' mdef='파견 종료일을 선택해 주세요.'/>");
			return false;
		}
		if($("#dispatchOrgCd").val() == "") {
			alert("<msg:txt mid='110451' mdef='파견지를 선택해 주세요.'/>");
			return false;
		}

		var num = getDaysBetween(formatDate($("#dispatchSymd").val(),""),formatDate($("#dispatchEymd").val(),""));
		if(formatDate($("#dispatchSymd").val(),"") != "" && formatDate($("#dispatchEymd").val(),"") != "") {
			if(num <= 0) {
				alert("<msg:txt mid='109757' mdef='종료일이 시작일보다 작습니다.'/>");
				$("#dispatchEymd").val("");
				num = "";
				return false;
			}
		}
		
		var validCnt = ajaxCall("${ctx}/GetDataMap.do?cmd=getTimeOffAppDateValideCnt",$("#sheetForm").serialize(),false);
		if(validCnt.DATA){
			if(validCnt.DATA.cnt && validCnt.DATA.cnt > 0) {
				alert("<msg:txt mid='109569' mdef='신청한 기간에 중복된 휴직이 존재합니다.'/>");
				return false;
			}
		}

		var rtn = ajaxCall("${ctx}/SaveFormData.do?cmd=saveDispatchAppDet",$("#sheetForm").serialize(),false);
		if(rtn.Result.Code < 1) {
			alert(rtn.Result.Message);
			return false;
		}
	}

	return true;
}

// 소속 팝입
/*
function orgSearchPopup() {
	var w		= 680;
	var h		= 520;
	var url		= "/Popup.do?cmd=orgBasicPopup";
	var args	= new Array();

	var result = openPopup(url+"&authPg=R", args, w, h);

	if (result) {
		var orgCd	= result["orgCd"];
		var orgNm	= result["orgNm"];

		$("#dispatchOrgCd").val(orgCd);
		$("#dispatchOrgNm").val(orgNm);
	}
}
*/

//  소속 팝입
function orgSearchPopup(){
	try{
		var args    = new Array();
		pGubun = "orgPopup";
		openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","720");

	}catch(ex){alert("Open Popup Event Error : " + ex);}
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

	if(pGubun == "orgPopup")  {
		$("#dispatchOrgCd").val(rv["orgCd"]);
		$("#dispatchOrgNm").val(rv["orgNm"]);
	}
}

//날짜 포맷을 적용한다..
function formatDate(strDate, saper) {
	if(strDate == "" || strDate == null) {
		return "";
	}

	if(strDate.length == 10) {
		return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
	} else if(strDate.length == 8) {
		return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
	}
}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div>
		<form id="sheetForm" name="sheetForm" >
			<input id="searchApplCd" 	name="searchApplCd" 	type="hidden" value="${searchApplCd}"/>
			<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden" value="${searchApplSeq}"/>
			<input id="searchApplSabun" name="searchApplSabun" 	type="hidden" value="${searchApplSabun}"/>
			<input id="adminYn" 		name="adminYn" 			type="hidden" value="${adminYn}"/>
			<input id="authPg" 			name="authPg" 			type="hidden" value="${authPg}"/>
			<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden" value="${searchApplYmd}"/>
			<input id="searchSabun" 	name="searchSabun" 		type="hidden" value="${searchSabun}"/>

			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
					</ul>
				</div>
			</div>
			<table class="table">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='103909' mdef='파견기간'/></th>
					<td>
						<input id="dispatchSymd" name="dispatchSymd" type="text" class="date2" readonly/> ~
						<input id="dispatchEymd" name="dispatchEymd" type="text" class="date2" readonly/>
						<span id="day" style="margin-left:10px;"></span>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='202005200000045' mdef='파견지'/></th>
					<td> <input type="hidden" id="dispatchOrgCd" name="dispatchOrgCd" class="text" value="" />
						<input type="text" id="dispatchOrgNm" name="dispatchOrgNm" class="text readonly" value="" readonly style="width:120px" />
						<span id="dispatchOrgBtn">
						<a onclick="javascript:orgSearchPopup();" href="#" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a onclick="$('#dispatchOrgCd,#dispatchOrgNm').val('');" href="#" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</span>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='202005200000046' mdef='파견사유'/></th>
					<td><textarea id="dispatchReason" name="dispatchReason" rows="3" class="w100p"></textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>

</body>
</html>
