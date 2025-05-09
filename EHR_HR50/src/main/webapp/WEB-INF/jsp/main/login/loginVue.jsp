<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>e-HR</title>
<link rel="stylesheet" href="/common/css/login.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/modal.css">

	<!--   JQUERY   -->
<%--<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>--%>
<script src="${ctx}/common/js/jquery/3.6.2/jquery-3.6.2.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.selectbox-0.2.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript" src="/common/js/lang.js" charset="utf-8"></script>
<script type="text/javascript" src="/common/js/cookie.js"></script>
<script type="text/javascript" src="/common/js/ras/script.js"></script>
<script type="text/javascript" src="/common/plugin/Login/js/loginVue.js"></script>
<script type="text/javascript">

	var clickState = null;
	var loginMsg = null;
	var _tmpLocaleCd = "ko_KR";
	var langyn = "${map.langyn}";

	$(function() {

		document.msCapsLockWarningOff = true;
		$("#companyList").selectbox();
		$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_${ssnEnterCd}.ico' />");
		$("#loginEnterCd").val("${cookie.hrSaveCompany.value}");

		if ( langyn == '1' ){
			$('#localeCd').val(("${cookie.hrSaveLocaleCd.value}")=="" ? _tmpLocaleCd:"${cookie.hrSaveLocaleCd.value}");
			loginMsg = getMessageList($('#localeCd').val());
			getLangList();
		}else{
			$('#localeCd').val("");
			loginMsg = getMessageList("ko_KR");
		}

		getEnterList();
		buttonEvent();
		setCookieChkBox();
	});

</script>

<!-- =========================================================================================================================== -->

<!--   FONT STYLE 	: 미리 캐쉬에 넣어줌 (메인화면에서 느려서) -->
<!-- <link rel="stylesheet" type="text/css" href="/common/css/nanum.css"> -->
<!-- <link rel="stylesheet" type="text/css" href="/common/css/notosans.css"> -->
</head>
<body dir="ltr" class="login" id="pagekey-uas-consumer-login-internal">
    <!-- wrap -->
    <!-- 배경 back01~back06 -->
    <div id="wrap">
		<!-- login -->
		<div id="login-wrap">
			<div class="inner-wrap">
				<form id="loginForm" name="loginForm" method="post" action="">
					<input type="hidden" id="loginEnterCd" name="loginEnterCd" />
					<input type="hidden" id="localeCd"  name="localeCd" value=""/>
					<input type="hidden" id="link" name="link" />
					<h1 class="title">
						<img class="bg" id="logo_cont" src="/common/images/login/logo.png" alt="기업로고">
					</h1>
					<div class="form-wrap">
						<div class="input-box" id="companyBox">
							<i class="mdi-ico filled">business</i>
			            	<select class="userid selectbox" id="companyList"></select>
			            </div>
			            <div class="input-box">
			            	<i class="mdi-ico filled">person</i>
			            	<input type="text" class="userid" id="loginUserId" name="loginUserId" placeholder="아이디를 입력해주세요." title="아이디를 입력해주세요.">
			            </div>
						<div class="input-box">
							<i class="mdi-ico filled">lock</i>
							<input type="password" class="userpw" id="loginPassword" name="loginPassword" placeholder="비밀번호를 입력해주세요." title="비밀번호를 입력해주세요.">
							<!-- /Capslock  -->
							<p class="capslock" style="margin-top:15px; display:none; font-size:14px;">
								<strong style="color:red;">Caps Lock</strong>이 켜져 있습니다.
							</p>
							<!-- //Capslock  -->
						</div>
						<div class="check-info">
			                <input type="checkbox" id="saveChk" checked="checked">
			                <label for="saveChk" id="idSave">아이디 저장</label>
			                <a id="findPw" class="find-pw">비밀번호찾기</a>
			            </div>
			            <div class="btn-wrap">
			            	<button type="button" class="btn-signIn" id="btnLogin">로그인</button>
			            </div>
					</div>
				</form>
			</div>
		</div>
		<!-- background -->
		<div id="bg-wrap">
		  <div class="inner-wrap">
		    <img class="bg" src="/common/images/login/login_bg02.jpg" alt="">
		  </div>
		</div>
		<!-- // background -->
	</div>
	<%@ include file="/WEB-INF/jsp/common/include/commonLayer.jsp"%>
</body>
</html>
