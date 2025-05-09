<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 			prefix="c" %>

<c:set var="sessionScope"	scope="session" />
<c:set var="ctx" 			value="${pageContext.request.contextPath}"/>
<!DOCTYPE html> <html> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<title>e-HR</title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/css/base.css" />
<!--   회사선택 안함   -->
<link rel="stylesheet" href="/common/theme1/css/style.css" />

<!--   JQUERY   -->
<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">


	//$(document).ready(function() {
	var pssMsg = "";
	var p = eval("${popUpStatus}");

	var enterCd = "";
	var sabun = "";
<c:choose>
	<c:when test="${ !empty sessionScope.ssnSabun }">
		enterCd = "${ssnEnterCd}";
		sabun = "${ssnSabun}";
	</c:when>
	<c:otherwise>
		enterCd = "${ssnLoginEnterCd}";
		sabun = "${ssnLoginSabun}";
	</c:otherwise>
</c:choose>

	//에러 코드 메시지
	var errMessage = {
		notMatch   : "현재 비밀번호가 일치하지 않습니다.\n비밀번호를 확인 해 주세요."
		,errLength : "비밀번호는 8~20자로 입력하여 주세요."
		,errKor    : "비밀번호에는 한글을 사용할 수 없습니다."
		,errBlank  : "비밀번호는 빈공간 없이 입력하여 주세요."
		,errEn     : "비밀번호에 영문대소문자가 포함 되어야 합니다."
		,errNum    : "비밀번호에 숫자가 포함 되어야 합니다."
		,errEnl    : "비밀번호에 영문 [소]문자가 포함 되어야 합니다."
		,errEnu    : "비밀번호에 영문 [대]문자가 포함 되어야 합니다."
		,errSpc    : "비밀번호에 특수문자 포함 되어야 합니다."
		,errRep    : "비밀번호에 반복되는 문자는 사용할 수 없습니다."
		,errHist   : "기존에 사용되었던 비밀번호는 사용할 수 없습니다."
		,errSabun  : "사번이 포함된 비밀번호는 사용할 수 없습니다."
		,errMail   : "사내메일의 아이디가 포함된 비밀번호는 사용할 수 없습니다."
		,errCtn    : "비밀번호에 연속적인 문자열은 사용할 수 없습니다. [123, abc, qwe]"
		,fail      : "비밀번호가 변경에 실패 하였습니다."
	};

	$(function() {

		//레이어 숨김
		$(".returnDiv").hide();

		//로그인 아이디 패스워드 엔터 체크
		$("#chfirmPwd").bind("keyup",function(event){
			if( event.keyCode == 13 ){
				goConfirm();
			}
		});

		//로그인 비밀번호 레벨 체크
		$("#newPwd").bind("keyup",function(event){
			checkpwd();
		});

		//입력할때 레이어 숨김
		$("input").keypress(function(e) {
			$(".returnDiv").hide();

			var is_shift_pressed = false;
			if (e.shiftKey)
				is_shift_pressed = e.shiftKey;
			else if (e.modifiers)
				is_shift_pressed = !!(e.modifiers & 4);

			if (((e.which >= 65 && e.which <=  90) && !is_shift_pressed) || ((e.which >= 97 && e.which <= 122) && is_shift_pressed)){
				pssMsg = "<img src='/common/images/icon/icon_excla.png' />키보드에 <b>CapsLock</b>이 켜져 있습니다..";

				$("#resultMsg").html(pssMsg);
				$(".returnDiv").show();
			}else{
				$("#resultMsg").html();
				$(".returnDiv").hide();
			}
		});


	});

	/*
		비밀번호 저장
	*/
	function goConfirm(){
		var rs = fncPwdCheck(); //비밀번호 체크
		pssMsg = rs.msg;
		resultMsg("s");

		if( rs.msg != "" ){   //체크 오류
			$(rs.obj).focus();
			return;
		}

		$.ajax({
			url     : "${ctx}/pwdChgForm.do",
			type     : "post", dataType   : "json", async     : false, data     : $("#srchFrm").serialize(),
			success : function(rv) {

				if(rv.result != "success") { //실패
					pssMsg = errMessage[rv.result];
					resultMsg("s");
					$("#chfirmPwd").focus();
				}else {
					alert("비밀번호가 변경되었습니다.\n다시 로그인 해 주세요.");
					location.href = "${ctx}/Login.do";
					return;
				}

			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});
	}

	/**
	*  비밀번호 체크 결과 표시
	*/
	function resultMsg(status){
		pssMsg = "<img src='/common/images/icon/icon_quest.png' />"+ pssMsg;

		(status == "s")? $(".returnDiv").show():$(".returnDiv").hide();
		(status == "s")? $("#resultMsg").html(pssMsg):$("#resultMsg").html();
	}


	/**
	 * 새 비밀번호 Level 체크
	 */
	function checkpwd(){
		var newPass = $("#newPwd").val();

		if( newPass.length <= 0 ) {
			showhelpmsg(-1);
			return;
		}

		//사용불가 체크
		if (newPass.length > 20 || newPass.length < 8) { //비밀번호 길이가 맞지 않음
			showhelpmsg(1);
			return;
		}

		//한글이 포함됨
		if(checkKor(newPass)){
			showhelpmsg(1);
			return;
		}
		
<c:if test="${sessionScope.ssnPwChkLev == 'H'}">
		// 사번 포함됨
		if(checkContainAccount(newPass)) {
			//console.log("checkContainAccount", true);
			showhelpmsg(1);
			return;
		}
		
		// 사내메일 아이디 포함됨
		if(checkContainMail(newPass)) {
			//console.log("checkContainMail", true);
			showhelpmsg(1);
			return;
		}
		
		// 연속문자열 포함됨
		if(checkContinueWords(newPass)) {
			showhelpmsg(1);
			return;
		}
</c:if>

		//공백이 포함 됨
		if(checkSpace(newPass) !=""){
			showhelpmsg(1);
			return;
		}
		//레벨 체크
		var passLev = 2;
		var stringRegx = /[A-Z]/g;
		if (stringRegx.test(newPass)){  //영문대문자
			passLev++;
		}
		stringRegx = /[a-z]/g;
		if (stringRegx.test(newPass)){  //영문소문자
			passLev++;
		}
		stringRegx = /[0-9]/g;
		if (stringRegx.test(newPass)){  //숫자
			passLev++;
		}
		stringRegx = /[~!@\#$%<>^&*\()\-=+_\’]/gi;
		if(stringRegx.test(newPass)) { //특수문자 포함
			passLev++;
		}
		showhelpmsg(passLev);
	}



	//메시지 보기
	function showhelpmsg(pwdlevel) {

<c:choose>
<c:when test="${sessionScope.ssnPwChkLev == 'M'}">
		var pssMsg1 = " <b>사용불가</b> : 8~20자의 영문대소문자,숫자 및 특수문자 사용";
		var pssMsg2 = " 비밀번호 안전도 : <b>낮음</b> <font color='red'><b>(사용불가)</b></font>";
		var pssMsg3 = " 비밀번호 안전도 : <b>낮음</b> <font color='red'><b>(사용불가)</b></font>";
		var pssMsg4 = " 비밀번호 안전도 : <b>적정</b>";
		var pssMsg5 = " 비밀번호 안전도 : <b>적정</b>";
		var pssMsg6 = " 비밀번호 안전도 : <b>높음</b>";
</c:when>
<c:when test="${sessionScope.ssnPwChkLev == 'H'}">
		var pssMsg1 = " <b>사용불가</b> : 6~20자의 영문대소문자,숫자 및 특수문자 사용. 사번,사내메일 아이디, 연속된 문자열 미포함";
		var pssMsg2 = " 비밀번호 안전도 : <b>낮음</b> <font color='red'><b>(사용불가)</b></font>";
		var pssMsg3 = " 비밀번호 안전도 : <b>낮음</b> <font color='red'><b>(사용불가)</b></font>";
		var pssMsg4 = " 비밀번호 안전도 : <b>낮음</b> <font color='red'><b>(사용불가)</b></font>";
		var pssMsg5 = " 비밀번호 안전도 : <b>낮음</b> <font color='red'><b>(사용불가)</b></font>";
		var pssMsg6 = " 비밀번호 안전도 : <b>높음</b>";
</c:when>
<c:otherwise>
		var pssMsg1 = " <b>사용불가</b> : 8~20자의 영문대소문자,숫자 및 특수문자 사용";
		var pssMsg2 = " 비밀번호 안전도 : <b>낮음</b>";
		var pssMsg3 = " 비밀번호 안전도 : <b>낮음</b>";
		var pssMsg4 = " 비밀번호 안전도 : <b>적정</b>";
		var pssMsg5 = " 비밀번호 안전도 : <b>적정</b>";
		var pssMsg6 = " 비밀번호 안전도 : <b>높음</b>";
</c:otherwise>
</c:choose>

		if (pwdlevel==-1){
			pssMsg = "";
			resultMsg("");

		}
		else {
			pssMsg = "";
			pssMsg = eval("pssMsg" + pwdlevel);
			resultMsg("s");
		}

	}

	//다음에 변경 하기
	function goLogin(){

		//location.href = "${ctx}/Login.do";
        //로그인
		//비밀번호 변경에서 다음에 변경하기 버튼 클릭시 로그인 화면이 아니고 메인으로 로그인 하도록 변경
        //chkPwdYn 이 N 면 로그인 되도록 수정함

        location.href = "${ctx}/loginUser.do?chkPwdYn=N";
	};



	//비밀번호 체크
	var fncPwdCheck = function(){

		var confirmPwd  = $("#confirmPwd");  //현재 비밀번호
		var newPwd 		= $("#newPwd");      //새 비밀번호
		var chfirmPwd   = $("#chfirmPwd");   //새 비밀번호 확인

		var pssMsg = "";
		var rsObj = null;

		//공통 비밀번호 체크( 공백체크 )
		var pwdCheckGrp1 = function(obj){
			rsObj = obj;
			var chkLabel = $("label[for='"+$(obj).attr("id")+"']").text();

			if($(obj).val() == "") {
				pssMsg = chkLabel+"를 입력 해 주세요.";
			}else if($(obj).val().length <= 0){
				pssMsg = "공백은 허용되지 않습니다.";
			}else if(checkSpace($(obj).val()) !=""){
				pssMsg = "비밀번호는 빈공간 없이 입력하여 주세요.";
			}else if(checkKor($(obj).val())){
				pssMsg = "비밀번호는 한글 사용하실 수 없습니다.";
			}
		};

		//새 비밀번호 체크
		var pwdCheckGrp2 = function(){
			rsObj = newPwd;
			if($(newPwd).val().length < 8 || $(newPwd).val().length > 20 ){
				pssMsg = "비밀번호는 8~20자의 영문 대소문자와 숫자, 특수문자를 입력하여 주세요.";

			}else if($(confirmPwd).val() == $(newPwd).val()){
				pssMsg = "반드시 현재 비밀번호와 다르게 입력하셔야 합니다.";

			}else{

				var cnt = 0;
				var isPW = /^[A-Za-z0-9`\-=\\\[\];',\./~!@#$%\^&\*\(\)_\+|\{\}:"<>\?]{6,20}$/;

				for( var i=0;i < $(newPwd).val().length;++i){
					if( $(newPwd).val().charAt(0) == $(newPwd).val().substring( i, i+1 ) ) ++cnt;
				}
				if( cnt == $(newPwd).val().length ) {
					pssMsg = "한 문자로 연속된 비밀번호는 허용하지 않습니다.";
				}else if(!isPW.test($(newPwd).val())) {
					pssMsg = "한 문자로 연속된 비밀번호는 허용하지 않습니다..";
<c:if test="${sessionScope.ssnPwChkLev == 'H'}">
				}else if(checkContainAccount($(newPwd).val())){
					pssMsg = "사번이 포함된 비밀번호는 사용할 수 없습니다.";
				}else if(checkContainMail($(newPwd).val())){
					pssMsg = "사내메일의 아이디가 포함된 비밀번호는 사용할 수 없습니다.";
				}else if(checkContinueWords($(newPwd).val())){
					pssMsg = "비밀번호에 연속적인 문자열은 사용할 수 없습니다. [123, abc, qwe]";
</c:if>
				}
			}

		};
		//비밀번호 체크
		var pwdCheckGrp3 = function(){
			rsObj = chfirmPwd;
			if($(newPwd).val() != $(chfirmPwd).val()){
				pssMsg = "새 비밀번호와 새 비밀번호 확인의 값이 일치하지 않습니다.\n다시 입력 해 주세요.";
			}
		};


		pwdCheckGrp1(confirmPwd);
		if( pssMsg == "" ) pwdCheckGrp1(newPwd);
		if( pssMsg == "" ) pwdCheckGrp2();
		if( pssMsg == "" ) pwdCheckGrp3();


		return{
			 msg : pssMsg
			,obj : rsObj
		};
	};


	//공백체크
	var checkSpace = function( str ) {
		if(str.search(/\s/) != -1){  return 1; }
		else { return ""; }
	};

	//한글 포함 체크
	var checkKor = function(str){
		var isKor = false;
		for (var i = 0; i < str.length; i++) {
			if (escape(str.charAt(i)).length >= 4) { isKor = true;}
		}
		return isKor;
	};
	
	// 사번 포함 체크
	var checkContainAccount = function(str) {
		var isContains = false;
		//console.log('account check', str.indexOf(sabun));
		if( str.indexOf(sabun) > -1 ) {
			isContains = true;
		}
		return isContains;
	};
	
	// 사내메일 ID 포함 체크
	var checkContainMail = function(str) {
		var isContains = false;
		$.ajax({
			url      : "${ctx}/Send.do?cmd=getMailId",
			type     : "post",
			dataType : "json",
			data     : {
				"enterCd" : enterCd,
				"sabun"   : sabun
			},
			async    : false,
			success  : function(rv) {
				var mailId = "";
				if(rv != null && rv != undefined && rv.map !=null && rv.map.mail != null && rv.map.mail != undefined) {
					mailId = rv.map.mail.substring(0, rv.map.mail.indexOf("@"));
					//console.log('mail check', "id : " + mailId + ", check : "  + str.indexOf(mailId));
					if( str.indexOf(mailId) > -1 ) {
						isContains = true;
					}
				}
			},
			error    : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});
		return isContains;
	};
	
	// 연속된 문자열 포함 체크
	var checkContinueWords = function(str) {
		var isContains = false;
		var max = 3; // 3자리 이상 검사
		var i, j, k, x, y;
		var buff = ["0123456789","abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ","qwertyuiopasdfghjklzxcvbnm","QWERTYUIOPASDFGHJKLZXCVBNM"]
		var scr, src2, ptn = "";

		for(i = 0; i < buff.length; i++){
			src = buff[i];
			src2 = buff[i] + buff[i];
			for(j = 0; j < src.length; j++){
				x = src.substr(j, 1);
				y = src2.substr(j, max);
				ptn += "["+x+"]{"+max+",}|";
				ptn += y+"|";
			}
		}
		
		ptn = new RegExp(ptn.replace(/.$/, ""));
		
		if(ptn.test(str)) {
			isContains = true;
		}
		
		return isContains;
	};
</script>

<body>

<div class="popup_widget">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='112499' mdef='비밀번호 변경'/></li>
	</ul>
	</div>

	<div class="popup_main">

		<div class="popup_password">
			<form id="srchFrm" name="srchFrm" >
			<div align="Left" style="padding-bottom:3px" ><font color="Red"><span id="notice">
<c:if test="${chkCode=='NTC'}">
비밀번호만료 ${rmnDate }일 전 입니다. 비밀번호를 변경 해 주세요.
</c:if>
<c:if test="${chkCode=='BLK'}">
비밀번호가 만료 되었습니다. 비밀번호 변경 후 변경한 비밀번호로 로그인 해주세요.
</c:if>
			</span></font></div>
			<table border="0" cellpadding="0" cellspacing="0">

			<tr>
				<th><span><label for="confirmPwd">현재 비밀번호</label></span></th>
				<td><input type="password" name="confirmPwd" id="confirmPwd"></td>
			</tr>

			<tr>
				<th><span><label for="newPwd">새 비밀번호</label></span></th>
				<td><input type="password" name="newPwd" id="newPwd">
<c:choose>
	<c:when test="${sessionScope.ssnPwChkLev == 'H'}">
					숫자, 영문 대소문자, 특수문자 혼합하여 8자 이상. 사번, 사내메일 아이디, 연속된 문자열 미포함
	</c:when>
	<c:otherwise>
					숫자, 영문 대소문자, 특수문자 혼합하여 8자 이상
	</c:otherwise>
</c:choose>
				</td>
			</tr>
			<tr>
				<th><span><label for="chfirmPwd">새 비밀번호 확인</label></span></th>
				<td><input type="password" name="chfirmPwd" id="chfirmPwd"></td>
			</tr>
			</table>
			</form>
			<div class="returnDiv">
				<span id="resultMsg" name="resultMsg"></span>
			</div>


			<div class="popup_button">
			<ul>
				<li class="center">
					<a href="javascript:goConfirm();" class="btn filled"><tit:txt mid='113447' mdef='비밀번호 저장'/></a>
<c:if test="${chkCode ne 'BLK'}">
					<a href="javascript:goLogin();" class="btn outline_gray"><tit:txt mid='113097' mdef='다음에 변경하기'/></a>
</c:if>
				</li>
			</ul>
			</div>
		</div>
	</div>
</div>

</body>
</html>
