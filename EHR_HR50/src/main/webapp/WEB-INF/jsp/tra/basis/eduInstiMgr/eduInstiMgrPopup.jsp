<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>교육기관관리 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var pGubun = "";
	$(function(){
		var nationalCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), "<tit:txt mid='111914' mdef='선택'/>");	//소재국가
		var bankCd		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "<tit:txt mid='111914' mdef='선택'/>");	//은행명
	
		$("#nationalCd").html(nationalCd[2]);
		$("#bankCd").html(bankCd[2]);

		const modal = window.top.document.LayerModalUtility.getModal('eduInstiMgrLayer');
		var eduOrgCd         = modal.parameters.eduOrgCd        ;
		var eduOrgNm         = modal.parameters.eduOrgNm        ;
		var nationalCd       = modal.parameters.nationalCd      ;
		var zip              = modal.parameters.zip             ;
		var curAddr1         = modal.parameters.curAddr1        ;
		var curAddr2         = modal.parameters.curAddr2        ;
		var bigo             = modal.parameters.bigo            ;
		var chargeName       = modal.parameters.chargeName      ;
		var orgNm            = modal.parameters.orgNm           ;
		var jikweeNm         = modal.parameters.jikweeNm        ;
		var telNo            = modal.parameters.telNo           ;
		var telHp            = modal.parameters.telHp           ;
		var faxNo            = modal.parameters.faxNo           ;
		var email            = modal.parameters.email           ;
		var companyNum       = modal.parameters.companyNum      ;
		var companyHead      = modal.parameters.companyHead     ;
		var businessPart     = modal.parameters.businessPart    ;
		var businessType     = modal.parameters.businessType    ;
		var bankNum          = modal.parameters.bankNum         ;
		var bankCd           = modal.parameters.bankCd          ;
		//var fileSeq 		 = arg["fileSeq"];
	
		$("#eduOrgCd").val(eduOrgCd) ;
		$("#eduOrgNm").val(eduOrgNm) ;
		$("#nationalCd").val(nationalCd) ;
		$("#zip").val(zip) ;
		$("#curAddr1").html(curAddr1) ;
		$("#curAddr2").val(curAddr2) ;
		$("#bigo").val(bigo) ;
		$("#chargeName").val(chargeName) ;
		$("#orgNm").val(orgNm) ;
		$("#jikweeNm").val(jikweeNm) ;
		$("#telNo").val(telNo) ;
		$("#telHp").val(telHp) ;
		$("#faxNo").val(faxNo) ;
		$("#email").val(email) ;
		$("#companyNum").val(companyNum) ;
		$("#companyHead").val(companyHead) ;
		$("#businessPart").val(businessPart) ;
		$("#businessType").val(businessType) ;
		$("#bankNum").val(bankNum) ;
		$("#bankCd").val(bankCd) ;
		
		// 숫자만 입력
		$("#bankNum,#companyNum,#faxNo,#telNo,#telHp").keyup(function() {
		     makeNumber(this,'A') ;
		 });
	
		if($("#nationalCd").val()!="") $("#nationalCd").val("KR").prop("selected",true);
	
	});

	function closeLayerModal(){
		const modal = window.top.document.LayerModalUtility.getModal('eduInstiMgrLayer');
		modal.hide();
	}

	function setValue() {
		const modal = window.top.document.LayerModalUtility.getModal('eduInstiMgrLayer');
		modal.fire('eduInstiMgrTrigger', {
			eduOrgCd        : $("#eduOrgCd").val() ,
			eduOrgNm        : $("#eduOrgNm").val() ,
			nationalCd      : $("#nationalCd").val() ,
			zip             : $("#zip").val() ,
			curAddr1        : $("#curAddr1").html() ,
			curAddr2        : $("#curAddr2").val() ,
			bigo            : $("#bigo").val() ,
			chargeName      : $("#chargeName").val() ,
			orgNm           : $("#orgNm").val() ,
			jikweeNm        : $("#jikweeNm").val() ,
			telNo           : $("#telNo").val() ,
			telHp           : $("#telHp").val() ,
			faxNo           : $("#faxNo").val() ,
			email           : $("#email").val() ,
			companyNum      : $("#companyNum").val() ,
			companyHead     : $("#companyHead").val() ,
			businessPart    : $("#businessPart").val() ,
			businessType    : $("#businessType").val() ,
			bankNum         : $("#bankNum").val() ,
			bankCd          : $("#bankCd").val()
		}).hide();
	}
	
	// 팝업 클릭시 발생
	function zipCodePopup() {
		if(!isPopup()) {return;}
		pGubun = "viewZipCodePopup";

		var zipCodeLayer = new window.top.document.LayerModal({
			id: 'zipCodeLayer',
			url: '/ZipCodePopup.do?cmd=viewZipCodeLayer&authPg=${authPg}',
			parameters: {},
			width: 740,
			height: 620,
			title: '<tit:txt mid='zipCode' mdef='우편번호검색'/>',
			trigger :[
				{
					name : 'zipCodeLayerTrigger',
					callback : function(result){
						const rv = {
							zip : result.zip,
							doroAddr : result.doroAddr,
							detailAddr : result.detailAddr,
							resDoroFullAddrEng	 : result.resDoroFullAddrEng,
							doroFullAddr : result.doroFullAddr
						};
						getReturnValue(rv);
					}
				}
			]
		});
		zipCodeLayer.show();
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = returnValue;
	
	    if(pGubun == "viewZipCodePopup"){
	    	$("#zip").val(rv["zip"]);
	    	$("#curAddr1").html(rv["doroFullAddr"]);
	    }
	}

</script>
</head>
<body class="bodywrap">
<form id="mySheetForm" name="mySheetForm" method="post">
<input type=hidden id="fileSeq" name="fileSeq">
</form>
<div class="wrapper modal_layer">
	<div class="modal_body">
		<table class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="30%" />
			</colgroup>
			<tr>
				<th><tit:txt mid='113426' mdef='교육기관명'/></th>
				<td>
					<input id="eduOrgCd" name="eduOrgCd" type="hidden" class="text" style="width:50%;"/>
					<input id="eduOrgNm" name="eduOrgNm" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112055' mdef='우편번호'/></th>
				<td colspan="3">
					<input id="zip" name="zip" type="text" class="text w50"/>
					<a href="javascript:zipCodePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<span id="curAddr1"> </span>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='113463' mdef='상세주소'/></th>
				<td colspan="3">
					<input id="curAddr2" name="curAddr2" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='bigoV1' mdef='교육기관특성'/></th>
				<td colspan="3">
					<textarea id="bigo" name="bigo" rows="3" class="text w100p"></textarea>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='nationalCdV1' mdef='국가코드'/></th>
				<td>
					<select id="nationalCd" name="nationalCd">
					</select>
				</td>
				<th><tit:txt mid='manager' mdef='담당자'/></th>
				<td>
					<input id="chargeName" name="chargeName" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104471' mdef='직급'/></th>
				<td>
					<input id="jikweeNm" name="jikweeNm" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='104550' mdef='핸드폰'/></th>
				<td>
					<input id="telHp" name="telHp" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='201705240000058' mdef='전화'/></th>
				<td>
					<input id="telNo" name="telNo" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='112914' mdef='팩스'/></th>
				<td>
					<input id="faxNo" name="faxNo" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th>E-mail</th>
				<td colspan="3">
					<input id="email" name="email" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104479' mdef='사업자등록번호'/></th>
				<td>
					<input id="companyNum" name="companyNum" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='companyHead' mdef='대표자명'/></th>
				<td>
					<input id="companyHead" name="companyHead" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='113119' mdef='업태'/></th>
				<td>
					<input id="businessPart" name="businessPart" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='112066' mdef='종목'/></th>
				<td>
					<input id="businessType" name="businessType" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104465' mdef='계좌번호'/></th>
				<td>
					<input id="bankNum" name="bankNum" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='104277' mdef='은행명'/></th>
				<td>
					<select id="bankCd" name="bankCd">
					</select>
				</td>
			</tr>
		</table>
	</div>

	<div class="modal_footer">
		<c:if test="${authPg == 'A'}">
		<btn:a href="javascript:setValue();" css="btn outline_gray" mid='110716' mdef="확인"/>
		</c:if>

		<btn:a href="javascript:closeLayerModal();" css="btn filled" mid='110881' mdef="닫기"/>
	</div>
</div>

</body>
</html>
