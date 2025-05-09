<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112883' mdef='Location관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<!-- <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script> -->
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var nationalCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), " ");	//소재국가
	//var businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBusinessPlaceCdList",false).codeList, "");	//사업장
	//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
	var url     = "queryId=getBusinessPlaceCdList";
	var allFlag = true;
	if ("${ssnSearchType}" != "A"){
		url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
		allFlag = false;
	}
	var businessPlaceCd = "";
	if(allFlag) {
		businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//사업장
	} else {
		businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
	}
	var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION

	$("#nationalCd").html(nationalCd[2]);
	$("#taxBpCd").html(businessPlaceCd[2]);
	$("#taxLocationCd").html(locationCd[2]);

	var arg = p.popDialogArgumentAll();
	var locationCd  	= arg["locationCd"];
	var locationNm  	= arg["locationNm"];
	var nationalCd		= arg["nationalCd"];
	var zip  			= arg["zip"];
	var addr  			= arg["addr"];
	var detailAddr  	= arg["detailAddr"];
	var engAddr  		= arg["engAddr"];
	var detailEngAddr  	= arg["detailEngAddr"];
	var taxBpCd  		= arg["taxBpCd"];
	var taxLocationCd  	= arg["taxLocationCd"];
	var taxOfficeNm  	= arg["taxOfficeNm"];
	var recOfficeNm  	= arg["recOfficeNm"];
	var officeTaxYn  	= arg["officeTaxYn"];
	var orderSeq  		= arg["orderSeq"];

	$("#locationCd").val(locationCd);
	$("#locationNm").val(locationNm);
	$("#nationalCd").val(nationalCd);
	$("#zip").val(zip);
	$("#addr").val(addr);
	$("#detailAddr").val(detailAddr);
	$("#engAddr").val(engAddr);
	$("#detailEngAddr").val(detailEngAddr);
	$("#taxBpCd").val(taxBpCd);
	$("#taxLocationCd").val(taxLocationCd);
	$("#taxOfficeNm").val(taxOfficeNm);
	$("#recOfficeNm").val(recOfficeNm);
	$("#officeTaxYn").val(officeTaxYn);
	$("#orderSeq").val(orderSeq);

	// 숫자만 입력
	$("#orderSeq").keyup(function() {
	     makeNumber(this,'A')
	 });

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
});

function setValue() {
	var rv = new Array(6);
	rv["locationCd"] 	= $("#locationCd").val();
	rv["locationNm"]	= $("#locationNm").val();
	rv["nationalCd"] 	= $("#nationalCd").val();
	rv["zip"] 			= $("#zip").val();
	rv["addr"]			= $("#addr").val();
	rv["detailAddr"]	= $("#detailAddr").val();
	rv["engAddr"]		= $("#engAddr").val();
	rv["detailEngAddr"]	= $("#detailEngAddr").val();
	rv["taxBpCd"]		= $("#taxBpCd").val();
	rv["taxLocationCd"]	= $("#taxLocationCd").val();
	rv["taxOfficeNm"]	= $("#taxOfficeNm").val();
	rv["recOfficeNm"]	= $("#recOfficeNm").val();
	rv["officeTaxYn"]	= $("#officeTaxYn").val();
	rv["orderSeq"]		= $("#orderSeq").val();

	p.popReturnValue(rv);
	p.window.close();
}

// 팝업 클릭시 발생
function zipCodePopup() {

	if(!isPopup()) {return;}

	pGubun = "ZipCodePopup";
	openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");

/* 	var postPopup = new daum.Postcode({
		oncomplete : function(data) {
			if(data.userSelectedType == "J"){
			 	addr = data.jibunAddress;
			 	engAddr = data.jibunAddressEnglish;
			}else{
				addr = data.roadAddress;
			 	engAddr = data.roadAddressEnglish;
 				if(data.buildingName !=""){
					addr = addr + " (" + data.buildingName + ")";
				}
			}

			$("#zip").val(data.zonecode);
			$("#addr").val(addr);
			$("#detailAddr").val("");
			$("#engAddr").val(engAddr);
			$("#detailEngAddr").val("");
		}
	}).open(); */
}


function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

	$("#zip").val(rv["zip"]);
	$("#addr").val(rv["doroAddr"]);
	$("#detailAddr").val(rv["detailAddr"]);
	$("#engAddr").val(rv["resDoroFullAddrEng"]);
	$("#detailEngAddr").val(rv["detailAddr"]);

}


</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='locationDetailMgr' mdef='Location관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<table class="table">
			<colgroup>
				<col width="12%" />
				<col width="10%" />
				<col width="78%" />
			</colgroup>
			<input type="hidden" id="locationCd" name="locationCd">
			<tr>
				<th colspan="2">LOCATION명칭 </th>
				<td>
					<input id="locationNm" name="locationNm" type="text" class="text" style="width:50%;"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='112199' mdef='소재국가'/></th>
				<td>
					<select id="nationalCd" name="nationalCd">
						<option value=""></option>
					</select>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='112055' mdef='우편번호'/></th>
				<td>
					<input id="zip" name="zip" type="text" class="text"/>
					<a href="javascript:zipCodePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='address' mdef='주소'/></th>
				<td>
					<input id="addr" name="addr" type="text" class="text" style="width:99%;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='113463' mdef='상세주소'/></th>
				<td>
					<input id="detailAddr" name="detailAddr" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='111915' mdef='영문주소'/></th>
				<td>
					<input id="engAddr" name="engAddr" type="text" class="text" style="width:99%;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='112745' mdef='영문상세주소'/></th>
				<td>
					<input id="detailEngAddr" name="detailEngAddr" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='114399' mdef='사업장'/></th>
				<td>
					<select id="taxBpCd" name="taxBpCd">
						<option value=""></option>
					</select>
				</td>
			</tr>
			<tr>
				<th rowspan="3" align="center"><!-- <span style="display:block;text-align:center;"> -->지방소득세<!-- </span> --></th>
				<th>LOCATION</th>
				<td>
					<select id="taxLocationCd" name="taxLocationCd">
						<option value=""></option>
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112200' mdef='관할구청'/></th>
				<td>
					<input id="taxOfficeNm" name="taxOfficeNm" type="text" class="text" style="width:50%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='114301' mdef='취급청'/></th>
				<td>
					<input id="recOfficeNm" name="recOfficeNm" type="text" class="text" style="width:50%;"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='112884' mdef='사업소세 대상여부'/></th>
				<td>
					<select id="officeTaxYn" name="officeTaxYn">
						<option value='Y'>YES</option>
						<option value='N'>NO</option>
					</select>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='111896' mdef='순서'/></th>
				<td>
					<input id="orderSeq" name="orderSeq" type="text" class="text" maxlength="3" vtxt="MaxLength Text"/>
				</td>
			</tr>
		</table>
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large authA"><tit:txt mid='104435' mdef='확인'/></a>
					<a href="javascript:p.self.close();" class="gray large authR"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
