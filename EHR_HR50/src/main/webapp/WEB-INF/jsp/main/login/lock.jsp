<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 			prefix="c" %>
		
	<c:choose>
		<c:when test="${ssnAdmin=='Y' && ssnAdminFncYn == 'Y'}">
			<c:set var="lockName"		value="${sessionScope.ssnAdminName}" />
			<c:set var="lockSabun"		value="${sessionScope.ssnAdminSabun}" />
			<c:set var="lockEnterCd"	value="${sessionScope.ssnAdminEnterCd}" />
		</c:when>
		<c:otherwise>
			<c:set var="lockName"		value="${sessionScope.ssnName}" />
			<c:set var="lockSabun"		value="${sessionScope.ssnSabun}" />
			<c:set var="lockEnterCd"	value="${sessionScope.ssnEnterCd}" />
		</c:otherwise>
	</c:choose>		

<!DOCTYPE html>
<html>
<head>
	<title>Lock Screen</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
</head>
<style>
	@font-face{
		font-family:'NanumGothic';
		src: url('NanumGothic.eot');
		src: url('NanumGothic.eot?#iefix') format('embedded-opentype'), url('NanumGothic.woff') format('woff'), url('NanumGothic.ttf') format('truetype');
		font-weight: normal;
		font-style: normal;
	}
	.panel {
		text-align: center;
	}
	.company-logo{
		display:inline-block;
		width: 100%;
		height: 40px;
		margin-top: 0px;
		margin-bottom: 15px;
		background: url('/OrgPhotoOut.do?logoCd=7&orgCd=0&t=') scroll no-repeat top center transparent;
		background-size: auto 40px;
		text-indent: -119988px;
		overflow: hidden;
		text-align: left;
	}
	.user-img {
		width: 100px;
		height: 100px;
		border-radius: 50%;
		border: 2px solid #D2DDE1;
		padding: 3px;
		margin-top:25px;
	}
	.name-div {
		margin-top:25px;
		margin-bottom:20px;
		font-size: 20px;
	}
	.mb30 {
		margin-bottom: 30px;
	}
	.input-group {
	  position: relative;
	  display: inline-block;
	  width: 100%;
	  border-collapse: separate;
	}
	.h40 {
		height: 40px;
	}
	.pwd-input {
		width: 65%;
		height:32px;
		padding: 0 10px;
		border:1px solid #b2c0c6;
		vertical-align:middle;
		font-size: 13px;
		color: #555555;
	}
	
	.pwd-input:hover,.pwd-input:active  {
		border:1px solid #45A3E6;
		transition:all 0.4s cubic-bezier(0.445, 0.05, 0.55, 0.95);
	}
	
	.login-btn {
		height:34px;
		padding: 7px 16px 10px;
		border:0px none;
		margin-left:-3px;
		background-color: #F44336;
		vertical-align:middle;
		color: #ffffff;
		font-size: 15px;
		cursor: pointer;
	}
</style>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<script type="text/javascript" src="/common/js/ras/script.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		
		$(".login-btn").click(function(e) {
			var pwd = $("#pwd").val();
			
			if(pwd === null || pwd === "") {
				alert("<msg:txt mid='110051' mdef='비밀번호를 입력하세요.'/>");
				$("#pwd").focus();
				return false;
			}
			
			var rsa = new RSAKey();
			rsa.setPublic("${sessionScope.RSAModulus}", "${sessionScope.RSAExponent}");
			
			$.ajax({
				url: "/EnablePage.do",
				type: "post",
				data: {pwd: rsa.encrypt(pwd)},
				dataType: "json",
				async: false,
				success  : function(rv) {
					var errMessage = {
							 secFail : "새로고침후 다시 시도하여 주십시오. \n지속적으로 발생할경우 관리자에게 문의 하세요!"
							,noLogin : "로그인 할 수 없습니다. \n\n관리자에게 문의 하세요!"
							,rocking : "사용자 계정이 잠겨 있습니다. \n\n관리자에게 문의 하세요!"
							,cntOver : "비밀번호 실패 횟수가 초과 하여 로그인 할 수 없습니다.  \n\n관리자에게 문의 하세요!"
							,notMatch : "ID, Password가 틀립니다."+"\n\n실패횟수 : "+rv.loginFailCnt+"회, "+rv.loginFailCntStd+"회 이상 실패시 로그인 페이지로 이동합니다."
							,notExist : "ID, Password가 틀립니다."
							,loginFail : "로그인 할 수 없습니다."+"\n\n이유 :"+rv.failRev+" \n지속적으로 발생할경우 관리자에게 문의 하세요!"
							,sesOut : "세션이 만료되었습니다. 로그인화면으로 이동합니다."
						};
					if(rv.isUser != "exist") {
						alert(errMessage[rv.isUser]);
						// top.redirect("/logoutUser.do", "_top");
						if(rv.isUser =="secFail"){
							// location.href = "/";
						} else if(rv.isUser == "cntOver") {
							var url = "/logoutUser.do";
							redirect(url, "_top");
						} else if(rv.isUser == "sesOut") {
							var url = "/logoutUser.do";
							redirect(url, "_top");
						}
					} else {
						top.enableTop();
					}
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});
		});
		
		$(".pwd-input").focus().on("keydown keypress", function(e) {
			if(e.which == 9 || e.which == 13) {
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
			}
		}).on("keyup", function(e) {
			if(e.which == 9 || e.which == 13) {
				if(e.which == 13) {
					$("#btnLogin").click();
				}
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
			}
		});	
				
		
		$(window.document).on("contextmenu", function(event){return false;}); //우클릭방지
		$(window.document).on("selectstart", function(event){return false;}); //더블클릭을 통한 선택방지
		$(window.document).on("dragstart" , function(event){return false;}); //드래그
		$(document).bind('keydown',function(e){if ( e.keyCode == 123 /* F12 */) {e.preventDefault();e.returnValue = false;}});
		
	});
</script>

<body style="overflow-x:hidden; overflow-y:hidden;" >

	<div class="panel screen_lock">
		<div class="company-logo"></div>
		<div class="photo">
			<img class="user-img" src="/EmpPhotoOut.do?enterCd=${lockEnterCd}&searchKeyword=${lockSabun}">
		</div>
		<div class="name-div">
			<b>${lockName}</b><span style="color:#666666; font-size:15px;">(${lockSabun})</span>
		</div>
		<div class="input-group">
			<input type="password" id="pwd" name="pwd" class="pwd-input">
			<button id="btnLogin" class="login-btn">login</button>
		</div>
	</div>
</body>
</html>
