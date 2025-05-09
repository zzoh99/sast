<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114347' mdef='협력업체관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var tLocationCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20045"), " ");	//통합소속_근무지
	var tJikweeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20050"), " ");	//통합소속_직위
	var tJikchakCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20040"), " ");	//통합소속_직책
	var enterCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getEnterCdAllList&enterCd=",false).codeList, "");	//LOCATION
	var jikgubCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), " ");	//직급
	var jikchakCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), " ");	//직책
	var jikweeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), " ");	//직위
	var manageCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), " ");	//사원구분
	var locationCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, " ");	//LOCATION

	$("#enterCd").html(enterCdList[2]);
	$("#locationCd").html(locationCdList[2]);
	$("#tLocationCd").html(tLocationCdList[2]);
	$("#jikchakCd").html(jikchakCdList[2]);
	$("#tJikchakCd").html(tJikchakCdList[2]);
	$("#jikweeCd").html(jikweeCdList[2]);
	$("#tJikweeCd").html(tJikweeCdList[2]);
	$("#manageCd").html(manageCdList[2]);

	$("#birYmd").datepicker2();
	$("#empYmd").datepicker2();
	$("#fpromYmd").datepicker2();
	$("#retYmd").datepicker2();

	var arg = p.window.dialogArguments;
	var enterCd		= arg["enterCd"]	;
	var sabun		= arg["sabun"]		;
	var name		= arg["name"]		;
	var ename1		= arg["ename1"]		;
	var locationCd	= arg["locationCd"]	;
	var tLocationCd	= arg["tLocationCd"]	;
	var orgCd		= arg["orgCd"]		;
	var orgNm		= arg["orgNm"]		;
	var resNo		= arg["resNo"]		;
	var mailId		= arg["mailId"]		;
	var jikweeCd	= arg["jikweeCd"]	;
	var tJikweeCd	= arg["tJikweeCd"]	;
	var jikchakCd	= arg["jikchakCd"]	;
	var tJikchakCd	= arg["tJikchakCd"]	;
	var birYmd		= arg["birYmd"]		;
	var lunType		= arg["lunType"]	;
	var manageCd	= arg["manageCd"] 	;
	var empYmd		= arg["empYmd"]		;
	var fpromYmd	= arg["fpromYmd"]	;
	var retYmd		= arg["retYmd"]		;
	var pwareYn		= arg["pwareYn"]	;
	var pwareIdYn	= arg["pwareIdYn"]	;
	var outlookYn	= arg["outlookYn"]	;
	var officeTel	= arg["officeTel"]	;
	var homeTel		= arg["homeTel"]	;
	var faxNo		= arg["faxNo"]		;
	var handPhone	= arg["handPhone"]	;
	var zip			= arg["zip"]		;
	var addr1		= arg["addr1"]		;
	var addr2		= arg["addr2"]		;

	$("#enterCd").val(enterCd)   ;
	$("#sabun").val(sabun)     ;
	$("#name").val(name)      ;
	$("#ename1").val(ename1)    ;
	$("#locationCd").val(locationCd);
	$("#tLocationCd").val(tLocationCd);
	$("#orgCd").val(orgCd)     ;
	$("#orgNm").val(orgNm)     ;
	$("#resNo").val(resNo)     ;
	$("#mailId").val(mailId)    ;
	$("#jikweeCd").val(jikweeCd)  ;
	$("#tJikweeCd").val(tJikweeCd)  ;
	$("#jikchakCd").val(jikchakCd) ;
	$("#tJikchakCd").val(tJikchakCd) ;
	$("#birYmd").val(birYmd)    ;
	//$("#lunType").val(lunType)   ;
	if( lunType == "1" ) {
		$("input:radio[name='lunType']").filter("input[value='0']").attr("checked", false);
		$("input:radio[name='lunType']").filter("input[value='1']").attr("checked", true);
	} else if( lunType == "0" ){
		$("input:radio[name='lunType']").filter("input[value='0']").attr("checked", true);
		$("input:radio[name='lunType']").filter("input[value='1']").attr("checked", false);
	} else {
		$("input:radio[name='lunType']").filter("input[value='0']").attr("checked", false);
		$("input:radio[name='lunType']").filter("input[value='1']").attr("checked", true);
	}
	$("#manageCd").val(manageCd)  ;
	$("#empYmd").val(empYmd)    ;
	$("#fpromYmd").val(fpromYmd)  ;
	$("#retYmd").val(retYmd)    ;
	pwareYn == "Y" ? $(':checkbox[name=pwareYn]').attr('checked', true) : $(':checkbox[name=pwareYn]').attr('checked', false);
	pwareIdYn == "Y" ? $(':checkbox[name=pwareIdYn]').attr('checked', true) : $(':checkbox[name=pwareIdYn]').attr('checked', false);
	outlookYn == "Y" ? $(':checkbox[name=outlookYn]').attr('checked', true) : $(':checkbox[name=outlookYn]').attr('checked', false);
	$("#officeTel").val(officeTel) ;
	$("#homeTel").val(homeTel)   ;
	$("#faxNo").val(faxNo)     ;
	$("#handPhone").val(handPhone) ;
	$("#zip").val(zip)       ;
	$("#addr1").val(addr1)	  ;
	$("#addr2").val(addr2)	  ;

	if($("#sabun").val() != null && $("#sabun").val() != "") {
		$("#sabun").attr("disabled", true) ;
		$("#enterCd").attr("disabled", true) ;
	}
	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
});

function setValue() {
	var rv = new Array();
	if( $("#sabun").val() == "") { alert("<msg:txt mid='110517' mdef='사번은 필수 값 입니다.'/>") ; return ; }

	rv["enterCd"]	  = $("#enterCd").val();
	rv["sabun"]       = $("#sabun").val();
	rv["name"]        = $("#name").val();
	rv["ename1"]	  = $("#ename1").val();
	rv["locationCd"]  = $("#locationCd").val();
	rv["tLocationCd"]  = $("#tLocationCd").val();
	rv["orgCd"]		  = $("#orgCd").val();
	rv["orgNm"]		  = $("#orgNm").val();
	rv["resNo"]		  = $("#resNo").val();
	rv["mailId"]	  = $("#mailId").val();
	rv["tJikweeCd"]	  = $("#tJikweeCd").val();
	rv["jikweeCd"]	  = $("#jikweeCd").val();
	rv["tJikchakCd"]	  = $("#tJikchakCd").val();
	rv["jikchakCd"]	  = $("#jikchakCd").val();
	rv["birYmd"]	  = $("#birYmd").val();
	rv["lunType"]	  =	$(':radio[name="lunType"]:checked').val() ;
	rv["manageCd"]	  = "ZZ" ;//협력업체 fixed
	rv["empYmd"]	  = $("#empYmd").val();
	rv["fpromYmd"]	  = $("#fpromYmd").val();
	rv["retYmd"]	  = $("#retYmd").val();
	var temp = "N";
	$("#pwareYn").is(":checked") == true ? temp = "Y" : temp = "N" ;
	rv["pwareYn"]	  = temp ; temp = "N" ;
	$("#pwareIdYn").is(":checked") == true ? temp = "Y" : temp = "N" ;
	rv["pwareIdYn"]	  = temp ; temp = "N" ;
	$("#outlookYn").is(":checked") == true ? temp = "Y" : temp = "N" ;
	rv["outlookYn"]	  = temp ; temp = "N" ;

	rv["officeTel"]	  = $("#officeTel").val();
	rv["homeTel"]	  = $("#homeTel").val();
	rv["faxNo"]		  = $("#faxNo").val();
	rv["handPhone"]	  = $("#handPhone").val();
	rv["zip"]		  = $("#zip").val();
	rv["addr1"]		  = $("#addr1").val();
	rv["addr2"]		  = $("#addr2").val();

	p.window.returnValue = rv;
	p.window.close();
}

// 팝업 클릭시 발생
function zipCodePopup() {
    var rst = openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
    if(rst != null){
    	$("#zip").val(rst["zip"]);
    	$("#addr1").val(rst["sido"]+ " "+ rst["gugun"] +" " + rst["dong"]);
    	$("#addr2").val(rst["bunji"]);
    }
}

//  소속 팝입
function orgSearchPopup(){
    try{
		var args    = new Array();
		args["enterCd"]	        = $("#enterCd").val();
		var rv = openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
        if(rv!=null){
			$("#orgCd").val(rv["orgCd"]);
			$("#orgNm").val(rv["orgNm"]);
		}
    }catch(ex){alert("Open Popup Event Error : " + ex);}
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form name="srchFrm">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='113661' mdef='협력업체관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th><tit:txt mid='112561' mdef='소속회사'/></th>
				<td>
					<select id="enterCd" name="enterCd" class="required">
					</select>
				</td>
				<th><tit:txt mid='104281' mdef='근무지'/></th>
				<td>
					<select id="locationCd" name="locationCd">
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103975' mdef='사번'/></th>
				<td>
					<input id="sabun" name ="sabun" type="text" class="text w70p required" maxlength="12" />
				</td>
				<th><tit:txt mid='113997' mdef='통합소속 근무지'/></th>
				<td>
					<select id="tLocationCd" name="tLocationCd">
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103880' mdef='성명'/></th>
				<td>
					<input id="name" name="name" type="text" class="text w70p" maxlength="" />
				</td>
				<th><tit:txt mid='104499' mdef='소속명'/></th>
				<td>
					<input id="orgCd" name ="orgCd" type="text" class="text hide" maxlength="" />
					<input id="orgNm" name ="orgNm" type="text" class="text w70p readonly" maxlength="" readonly/>
					<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<a onclick="$('#orgCd,#orgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104533' mdef='영문성명'/></th>
				<td>
					<input id="ename1" name="ename1" type="text" class="text w70p" maxlength="" />
				</td>
				<th><tit:txt mid='103883' mdef='주민번호'/></th>
				<td>
					<input id="resNo" name="resNo" type="text" class="text w70p center" maxlength="14" />
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103784' mdef='사원구분'/></th>
				<td>
					협력업체
				</td>
				<th>E-Mail</th>
				<td>
					<input id="mailId" name="mailId" type="text" class="text w100p" maxlength="" />
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104104' mdef='직위'/></th>
				<td>
					<select id="jikweeCd" name="jikweeCd">
					</select>
				</td>
				<th><tit:txt mid='103785' mdef='직책'/></th>
				<td>
					<select id="jikchakCd" name="jikchakCd">
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='114722' mdef='통합소속 직위'/></th>
				<td>
					<select id="tJikweeCd" name="tJikweeCd">
					</select>
				</td>
				<th><tit:txt mid='112236' mdef='통합소속 직책'/></th>
				<td>
					<select id="tJikchakCd" name="tJikchakCd">
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103881' mdef='입사일'/></th>
				<td>
					<input id="empYmd" name="empYmd" type="text" size="10" class="date2" />
				</td>
				<th><tit:txt mid='104090' mdef='퇴사일'/></th>
				<td>
					<input id="retYmd" name="retYmd" type="text" size="10" class="date2" />
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104234' mdef='직급변경일'/></th>
				<td>
					<input id="fpromYmd" name="fpromYmd" type="text" size="10" class="date2" />
				</td>
				<th><tit:txt mid='104294' mdef='생년월일'/></th>
				<td>
					<input id="birYmd" name="birYmd" type="text" size="10" class="date2" />
		            <input type="radio" name="lunType" value="0" >&nbsp;음
		            <input type="radio" name="lunType" value="1" >&nbsp;양
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112913' mdef='시스템적용여부'/></th>
				<td colspan="3">
					<input type="checkBox" class="checkBox" name="pwareYn" id="pwareYn" value="" >&nbsp;Pware &nbsp;
		            <input type="checkBox" class="checkBox" name="pwareIdYn" id="pwareIdYn" value="" >&nbsp;Pware계정여부 &nbsp;
		            <input type="checkBox" class="checkBox" name="outlookYn" id="outlookYn" value="" >&nbsp;Outlook
		        </td>
			</tr>
		</table>
		&nbsp;
		<!-- 연락처 테이블 -->
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th colspan="4" class="center">
				연락처
				</th>
			</tr>
			<tr>
				<th><tit:txt mid='113998' mdef='회사전화'/></th>
				<td>
					<input id="officeTel" name="officeTel" type="text" class="text w70p"/>
				</td>
				<th><tit:txt mid='103944' mdef='집전화'/></th>
				<td>
					<input id="homeTel" name="homeTel" type="text" class="text w70p"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112914' mdef='팩스'/></th>
				<td>
					<input id="faxNo" name="faxNo" type="text" class="text w70p"/>
				</td>
				<th><tit:txt mid='113492' mdef='이동전화'/></th>
				<td>
					<input id="handPhone" name="handPhone" type="text" class="text w70p"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112055' mdef='우편번호'/></th>
				<td colspan="3">
					<input id="zip" name="zip" type="text" class="text w25p center readonly" readonly/>
					<a href="javascript:zipCodePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='address' mdef='주소'/></th>
				<td colspan="3">
					<input id="addr1" name="addr1" type="text" class="text w100p left"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='113463' mdef='상세주소'/></th>
				<td colspan="3">
					<input id="addr2" name="addr2" type="text" class="text w100p left"/>
				</td>
			</tr>
		</table>

		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large authA" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
	</form>
</div>

</body>
</html>
