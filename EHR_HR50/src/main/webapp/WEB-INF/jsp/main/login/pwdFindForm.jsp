<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%//@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 			prefix="c" %>
<%@ taglib prefix="btn" tagdir="/WEB-INF/tags/button" %>
<%@ taglib prefix="tit" tagdir="/WEB-INF/tags/title" %>
<%@ taglib prefix="msg" tagdir="/WEB-INF/tags/message" %>
<c:set var="sessionScope"	scope="session" />
<c:set var="ctx" 			value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113218' mdef='e-HR 비밀번호찾기'/></title>
<base target="_self" />
<link rel="stylesheet" href="/common//css/dotum.css" />
<link rel="stylesheet" href="/common/blue/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<script type="text/javascript" src="/common/js/jquery/jquery.defaultvalue.js"></script>

<script type="text/javascript">
	var loginMsg = null;
	$(function() {
		$(".pass_info").hide();
		$("input[name=type]").eq(0).attr("checked", true);
		$('input:radio').click(function() {
			if( $(this).attr("value") == 0 ) {
				$("#email").show();
				$("#phone").hide();
				$("#loginphone").val("");
			}
			else {
				$("#email").hide();
				$("#phone").show();
				$("#loginEmail").val("");
			}
		});

		$("#name").bind("keyup",function(event){
			$(".pass_info").hide();
		});

		$("#sabun").bind("keyup",function(event){
			$(".pass_info").hide();
		});

		$("#loginEmail").bind("keyup",function(event){
			$(".pass_info").hide();
		});

		$("#loginphone").bind("keyup",function(event){
			$(".pass_info").hide();
		});
		
		loginMsg = getMessageList("${map.localeCd == '' ? 'ko_KR' : map.localeCd}");
		
		$("#passwordSearch"         ).text(loginMsg["passwordSearch"]);
		$("#pwdFindFormPop1"        ).text(loginMsg["pwdFindFormPop1"]);
		$("#pwdFindFormPopName"     ).text(loginMsg["pwdFindFormPopName"]);
		$("#pwdFindFormPopEmpId"    ).text(loginMsg["pwdFindFormPopEmpId"]);
		$("#pwdFindFormPopEmail"    ).text(loginMsg["pwdFindFormPopEmail"]);
		$("#pwdFindFormPopPhone"    ).text(loginMsg["pwdFindFormPopPhone"]);
		$("#pwdFindFormPopblank"    ).text(loginMsg["pwdFindFormPopblank"]);
		$("#pwdFindFormPopTempPwd"  ).text(loginMsg["pwdFindFormPopTempPwd"]);
		$("#pwdFindFormPopCancel"   ).text(loginMsg["pwdFindFormPopCancel"]);
		$("#pwdFindFormPopHelp"     ).text(loginMsg["pwdFindFormPopHelp"]);
		$("#pwdFindFormPopRegiEmail").text(loginMsg["pwdFindFormPopRegiEmail"]);
	});
	
	function getMessageList(localeCd) {
		var msgJson = ajaxCall("/LangId.do?cmd=getLoinMessageMap","keyLevel=login&localeCd="+localeCd, false).msg;
		var	msgArray = [];
		$(msgJson).each(function(idx,obj){
			msgArray[obj.keyId]	=	obj.keyText	;
		});
		return msgArray;
	}

	function formCheck() {
		if ($("#name").val() == "") {
			alert(loginMsg["alertName"]);
			$("#name").focus();
			return false;
		}
		if ($("#sabun").val() == "") {
			alert(loginMsg["alertEnterEmployee"]);
			$("#sabun").focus();
			return false;
		}
		if($(':radio[name="type"]:checked').val()=="0" && $("#loginEmail").val() == ""){
			alert(loginMsg["alertEnterEmail"]);
			$("#loginEmail").focus();
			return false;
		}

		if($(':radio[name="type"]:checked').val()=="1" && $("#loginphone").val() == ""){
			alert(loginMsg["alertEnterPhone"]);
			$("#loginphone").focus();
			return false;
		}

		return true;

	}

	function findDw(){
		if(formCheck()){
			$.ajax({
				url     : "${ctx}/PwdFindAction.do",
				type     : "post", dataType   : "json", async     : false, data     : $("#srchForm").serialize(),
				success : function(rv) {
					if(rv.result == "success") { //성공
						alert(loginMsg["alertFindPwd"]);
						$.ajax({
							url     : "${ctx}/Send.do?cmd=callMailPwd",
							type     : "post",
							dataType   : "json",
							async     : false,
							data     : $("#srchForm").serialize(),
							success : function(rv) {
								alert(loginMsg["alertImsiPwd"]);
								opener.location.href = "/Login.do";
							},
							error : function(jqXHR, ajaxSettings, thrownError) {
								ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
							}
						});
						return;
					}else {
						//실패
						alert(loginMsg["alertPwdFail"]);
						$(".pass_info").show();
						return;
					}

				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});
		}
	}

	//다음에 변경 하기
	function goLogin(){
		opener.location.href = "${ctx}/Login.do";
		self.close();
	}
</script>

</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li id="passwordSearch"><tit:txt mid='pwdFindPop' mdef='비밀번호 찾기'/></li>
	</ul>
	</div>

	<div class="popup_main">
		<div class="pass_info tPink" id="pwdFindFormPop1"><tit:txt mid='112847' mdef='- 인사시스템에 등록된 E-mail 주소, 핸드폰번호로 임시비밀번호를 발급 받으실 수 있습니다.'/></div>


		<form id="srchForm" name="srchForm" method="post" action="">

		<!-- mail post input start -->
		<input type="hidden" id="sender" 		name="sender" /><!-- x -->
		<input type="hidden" id="receiveType" 	name="receiveType" /><!-- x -->
		<input type="hidden" id="fromMail" 		name="fromMail" /><!-- x -->
		<input type="hidden" id="receverStr" 	name="receverStr" /><!-- x -->
		<!-- mail post input end -->
		<input type="hidden" id="encPwd"   name="encPwd" />
		<input type="hidden" id="enterCd"  name="enterCd"  value="${param.enterCd}"/>
		<table border="0" cellpadding="0" cellspacing="0" class="table none">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<tr>
			<th class="center tGray" id="pwdFindFormPopName"><tit:txt mid='103880' mdef='성명'/></th>
			<td>
				<input id="name" name="name" type="text" class="text required" style="width:150px;"/>
			</td>
		</tr>
		<tr>
			<th class="center tGray" id="pwdFindFormPopEmpId"><com:msg mlevel='login' mid='pwdFindFormPopEmpId' mdef='사번(접속ID)' /></th>
			<td>
				<input id="sabun" name="sabun" type="text" class="text required" style="width:150px;"/>
			</td>
		</tr>
		</table>

		<table class="find_pass">
		<colgroup>
			<col width="" />
			<col width="" />
			<col width="" />
		</colgroup>
		<tr>
			<td><input id="type" name="type" type="radio" value="0" class="radio" checked /> E-mail</td>
			<!-- <td><input id="type" name="type" type="radio" value="1" class="radio" /> 핸드폰</td>  -->
			<td>
				<div class="pass_info tPink" id="pwdFindFormPopEmail"><tit:txt mid='113219' mdef='- E-mail 주소와 일치하는 자료가 없습니다.'/></div>
			</td>
		</tr>
		</table>

		<table id="email" border="0" cellpadding="0" cellspacing="0" class="table none">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<tr>
			<th class="center tGray">E-mail</th>
			<td>
				<input id="loginEmail" name="loginEmail" type="text" class="text required" style="width:150px;"/>
			</td>
		</tr>
		</table>

		<table id="phone" border="0" cellpadding="0" cellspacing="0" class="table none" style="display:none;">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<tr>
			<th class="center tGray" id="pwdFindFormPopPhone"><tit:txt mid='112168' mdef='핸드폰 번호'/></th>
			<td id="pwdFindFormPopblank">
				<input id="loginphone" name="loginphone" type="text" class="text required" style="width:150px;"/> 공백없이 입력 해 주세요
			</td>
		</tr>
		</table>
		</form>

		<div class="popup_button">
		<ul>
			<li>
				<btn:a href="javascript:findDw();" css="pink large" mid='findDw' mdef="임시비밀번호 생성" id="pwdFindFormPopTempPwd" />
				<btn:a href="javascript:goLogin();" css="gray large" mid='110778' mdef="취소" id="pwdFindFormPopCancel" />
			</li>
		</ul>
		</div>

		<div class="explain">
			<div class="title" id="pwdFindFormPopHelp"><tit:txt mid='114264' mdef='도움말'/></div>
			<div class="txt">
			<ul>
				<li id="pwdFindFormPopRegiEmail"><tit:txt mid='114265' mdef='인사시스템에 등록된 E-mail 주소가 맞지 않을 경우 인사담당자에게 연락바랍니다.'/></li>
				<!-- li>내선1234</li-->
			</ul>
			</div>
		</div>

	</div>
</div>

</body>
</html>
