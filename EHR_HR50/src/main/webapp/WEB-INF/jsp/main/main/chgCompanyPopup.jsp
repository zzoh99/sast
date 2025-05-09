<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
	.popup_main .sbOptions {z-index:5;}
</style>
<script type="text/javascript" src="/common/js/ras/script.js"></script>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		//close 처리 
		$(".close").click(function(){
			p.self.close(); 
		});
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
</head>
<body class="bodywrap">
<div class="wrapper modal_layer"> 
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='113568' mdef='회사변경'/></li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="modal_body">
		<form id="sheetForm" name="sheetForm">
		    <input type="hidden" id="RSAModulus" value="${RSAModulus}" />
		    <input type="hidden" id="RSAExponent" value="${RSAExponent}" />
			<div class="pop_form01">
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
			</div>
		</form>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:p.self.close();" css="btn outline_gray" mid='110881' mdef="닫기"/>
		<btn:a href="javascript:changeCompany();" css="btn filled" mid='110716' mdef="확인"/>
	</div>
</div>

<%-- <div class="wrapper"> 
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='113568' mdef='회사변경'/></li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="sheetForm" name="sheetForm">
	    <input type="hidden" id="RSAModulus" value="${RSAModulus}" />
	    <input type="hidden" id="RSAExponent" value="${RSAExponent}" />
		<div class="popup_password pwd_confirm">
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<th><span><tit:txt mid='104306' mdef='회사선택'/></span></th>
				<td colspan="3"><span>
					<c:choose>
						<c:when test="${Message}!=''">
							${Message}
						</c:when>
						<c:otherwise>
							<select id="company" name="company">
							<c:forEach items="${DATA}" var="forData">
								<option value="${forData.enterCd}" >${forData.enterNm}</option>
							</c:forEach>
							</select>
						</c:otherwise>
					</c:choose></span>
				</td>
			</tr>
			<tr>
				<th><span><tit:txt mid='103915' mdef='이름'/></span></th>
				<td><span>${ssnAdminName}</span></td>
				<th><span><tit:txt mid='103975' mdef='사번'/></span></th>
				<td><span>${ssnAdminSabun}</span></td>
			</tr>
			<tr>
				<th><span><tit:txt mid='113098' mdef='비밀번호'/></span></th>
				<td colspan="3"><span><input type="password" name="confirmPass" id="confirmPass" class="required"></span></td>
			</tr>
			</table>
		</div>
		</form>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:changeCompany();" css="pink large" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div> --%>

<form id="submitForm" name="submitForm">
	<input id="chgEnterCd" name="chgEnterCd" 	type="hidden" />
	<input id="confirmPwd" name="confirmPwd" 	type="hidden" />
</form>	
</body>
</html>
