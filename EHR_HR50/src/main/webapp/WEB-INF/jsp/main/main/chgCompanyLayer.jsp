<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script src="${ctx}/common/js/ras/jsbn.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ras/prng4.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ras/rng.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ras/rsa.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	//var layerId = '';
	$(function() {
		$("#company").change(function(){
			$("#confirmPass").focus();
		});
		$("#confirmPass").keyup(function(e){
			if( e.keyCode == 13) {changeCompany();}
		});

		$("#confirmPass").focus();
		
		$(".selectbox").selectbox();
	});

	
	function changeCompany(){
		try {
			
			if( $("#company").val() == null || $("#company").val() == "" ){
				alert("<msg:txt mid='110478' mdef='회사를 선택 해주세요.'/>");
				return;
			}
			if( $("#confirmPass").val() == "" ){
				$("#confirmPass").focus();
				alert("<msg:txt mid='109422' mdef='로그인 비밀번호을 입력 해주세요.'/>");
				return;
			}
			
			//RSA 암호화 생성
			var rsa = new RSAKey();
			rsa.setPublic($("#RSAModulus").val(), $("#RSAExponent").val());

			//사용자 계정정보를 암호화 처리
			var pwd = rsa.encrypt($("#confirmPass").val());

			$("#chgEnterCd").val($("#company").val());
			$("#confirmPwd").val(pwd);

			if(confirm("선택된 회사로 로그인 하시 겠습니까?")){
				submitCall($("#submitForm"), "_self", "POST", "${ctx}/loginUser.do");
			
			}

	    } catch (ex) { alert("changeCompany Error " + ex); }
	}
</script>
<div class="wrapper modal_layer">
	<form id="submitForm" name="submitForm">
		<input id="chgEnterCd" name="chgEnterCd" 	type="hidden" />
		<input id="confirmPwd" name="confirmPwd" 	type="hidden" />
	</form>
	<div class="modal_body">
		<form id="sheetForm" name="sheetForm">
		    <input type="hidden" id="RSAModulus" value="${RSAModulus}" />
		    <input type="hidden" id="RSAExponent" value="${RSAExponent}" />
			<div class="form-wrap">
				<c:choose>
					<c:when test="${Message}!=''">
						${Message}
					</c:when>
					<c:otherwise>
						<select id="company" name="company" class="selectbox">
						<c:forEach items="${DATA}" var="forData">
							<option value="${forData.enterCd}" >${forData.enterNm}</option>
						</c:forEach>
						</select>
					</c:otherwise>
				</c:choose>
			</div>
			<table class="default">
				<colgroup>
					<col width="30%">
					<col width="70%">
				</colgroup>
				<tbody>
					<tr>
						<th><tit:txt mid='103915' mdef='이름'/></th>
						<td>${ssnAdminName}</td>
					</tr>
					<tr>
						<th><tit:txt mid='103975' mdef='사번'/></th>
						<td>${ssnAdminSabun}</td>
					</tr>
					<tr>
						<th><tit:txt mid='113098' mdef='비밀번호'/></th>
						<td><input type="password" name="confirmPass" id="confirmPass" class="required"></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('changeCompanyLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		<btn:a href="javascript:changeCompany();" css="btn filled" mid='110716' mdef="확인"/>
	</div>
</div>
