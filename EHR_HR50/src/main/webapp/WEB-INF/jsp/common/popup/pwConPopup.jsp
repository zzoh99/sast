<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='pwdConfirmPop' mdef='비밀번호 확인'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		$(".close").click(function() {
			p.self.close();
		});
		//레이어 숨김
		$(".returnDiv").hide();

		//로그인 아이디 패스워드 엔터 체크
		$("#confirmPwd").bind("keyup",function(event){
			if( event.keyCode == 13 ){
				goConfirm();
			}
		});

		//입력할때 레이어 숨김
		$("#confirmPwd").keypress(function(e) {
			$(".returnDiv").hide();
		});


	});


	function goConfirm(){

		if($("#confirmPwd").val() == "") {
			$("#confirmPwd").focus();
			return;
		}

		var returnValue = new Array(0);
		var count = ajaxCall("${ctx}/UserMgr.do?cmd=pwdConfirm",$("#srchFrm").serialize(),false);
		if(count.result != null && count.result != "undefine") count = count.result[0].cnt;

		if(count == 0){
	        //alert("<msg:txt mid='109673' mdef='비밀번호가 일치하지 않습니다.'/>");
	        $(".returnDiv").show();
	    	$("#confirmPwd").focus();
	    	return;
		} else if(count > 0){
			returnValue["result"] = "Y";
			p.popReturnValue(returnValue);
	 		p.window.close();
		} else {
			alert("결과가 존재하지 않습니다.");
			return;
		}
	}
</script>

<body>

<div class="popup_widget">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='pwdConfirmPop' mdef='비밀번호 확인'/></li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">

		<div class="popup_password">
			<form id="srchFrm" name="srchFrm" >
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<th><span><tit:txt mid='103915' mdef='이름'/></span></th>
				<td><span>${ssnName}</span></td>
			</tr>

			<tr>
				<th><span><tit:txt mid='103975' mdef='사번'/></span></th>
				<td><span>${ssnSabun}</span></td>
			</tr>
			<tr>
				<th><span><tit:txt mid='113098' mdef='비밀번호'/></span></th>
				<td><input type="password" name="confirmPwd" id="confirmPwd"></td>
			</tr>
			</table>
			</form>

			<div class="returnDiv">
				<img src="/common/images/icon/icon_excla.png" />비밀번호가 일치하지 않습니다.
			</div>

			<div class="popup_button">
			<ul>
				<li class="center">
					<a href="javascript:goConfirm();" class="pink large"><tit:txt mid='pwdConfirmPop' mdef='비밀번호 확인'/></a>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
			</div>
		</div>

	</div>
</div>

</body>
</html>
