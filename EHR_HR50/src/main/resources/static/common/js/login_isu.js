

if (top.location != location) {
top.location.href = document.location.href ;
}


///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
var	msgData		=	ajaxCall("/LangId.do?cmd=getMessage&","keyLevel=login",false);
var	msgJson		=	msgData.msg;
var	msgArray	=	[];

$(msgJson).each(function(idx,obj){
	msgArray[obj.keyId]	=	obj.keyText	;
});

///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

//validation
function doLogin() {
 	if ($("#loginEnterCd").val() == "") {
 		alert("회사를 선택하세요");
 		document.getElementsByName("companyList")[0].focus();
   		return false;
	}

 	if ($("#loginUserId").val() == "") {
 		alert("login.alertLoginIdNull");
  		return $("#loginUserId").focus();
	}

 	if ($("#loginPassword").val() == "") {
 		alert("login.alertLoginPasswordNull");
  		return $("#loginPassword").focus();
	}



	isExistUser();
}



/**
 * 공통 ajax 호출
 *
 * @param url
 * @param params
 * @param async
 * @returns Object
 */
function ajaxCall(url, params, async) {
    var obj = new Object();
    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        async: async,
        data: params,
        success: function(data) {
            obj = data;
        },
        error: function(jqXHR, ajaxSettings, thrownError) {
            alert(jqXHR +"\n"+ ajaxSettings+"\n"+ thrownError);
        }
    });

    return obj;
}




//쿠키에서 회사정보 설정
function setCookieCompany(){
	// 회사 선택
	$("#companyList li").each(function() {

		if ( getCookie("pantechSaveCompany") == $(this).text())
			$("#company").text($(this).text());
	});

	// 회사 리스트 나타냄
	$("#company").click(function() {
		$("#companyList").show();
	});

	// 회사 클릭시 회사 선택
	$("#companyList li").click(function() {
		$("#loginEnterCd").val($(this).attr("value"));
		$("#company").text($(this).text());
		setCookie("pantechSaveCompany",$(this).text(),1000);
		//$.cookie("pantechSaveCompany", $(this).text());
		$("#companyList").hide();
	});
}

//쿠키에서 체크상태에 따른 설정
function setCookieChkBox(){
	// 체크상태 불러 오기
	if( getCookie("pantechSaveChk") == "true" ){
		$("#loginUserId").val( getCookie("pantechSaveId") );
		$("#loginPassword").focus();
	}else{
		$("#loginLoginId").focus();
	}

	// 체크상태 저장
	if ( getCookie("pantechSaveChk") == null) {
		setCookie("pantechSaveChk","true",1000);
	}

	$("#saveChk")
		// 체크상태 셋팅
		.attr("checked", getCookie("pantechSaveChk") != "" ? true : false)
		// 아이디 저장 클릭시 쿠키 저장
		.click( function() {
			setCookie("pantechSaveChk",$("#saveChk").is(":checked") ? "true" : "",1000);
	});
}
//회사 가져오기
function getEnterMap() {
	/* hidden으로 처리  */
	$("#loginEnterCd").val("${map.enterCd}");

	$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_${map.enterCd}.ico' />");
	$(document).attr("title","${map.enterNm} ${map.alias}");
	$("#copyrightEng").text("${map.enterEngNm}");
	$("#title").text("${map.alias}");
	$(".title").html("${map.alias}");



}


//회사 조회
function getEnterList(c) {

  var enterList = ajaxCall("/getLoginEnterList.do", "",false).enterList;
  var str = "";

  if(enterList == null || enterList == "" || enterList == "undefine"){
    //alert("정상적인 접근이 아닙니다.");
    return;
  }

	/*1개의 회사만 있을경우 고정값으로 처리함*/
	if(enterList.length == 1) {
		$("#loginEnterCd").val(enterList[0].enterCd);
		$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_"+enterList[0].enterCd+".ico' />");
		//$("#companyList").hide();
		//$("#companyDiv").hide();
	}
	else {
		$("#company").text(enterList[0].enterNm);
		for ( var i = 0; i < enterList.length; i++) {
			var strchkk ="";
			if (enterList[i].enterCd == getCookie("hrSaveCompany")) {
				$("#loginEnterCd").val(enterList[i].enterCd);
			}
			strchkk = c == enterList[i].enterCd ? "selected" : "";
			$('#companyList').append('<option value="'+enterList[i].enterCd+'" '+strchkk+'>'+ enterList[i].enterNm +'</option>');
		}
	}
}






//사용언어 조회
function getLocaleList(e,l) {
	var localeList = ajaxCall("/LangId.do?cmd=getLocaleList", "enterCd="+ e ,false).list;

	for ( var i = 0; i < localeList.length; i++) {
		$('#localeCd').append('<option value="'+localeList[i].localeCd+'">'+ localeList[i].langNm +'</option>');
	}

}


//쿠키에서 체크상태에 따른 설정
function setCookieChkBox(){
// 체크상태 불러 오기
if( getCookie("hrSaveChk") == "true" ){
  $("#loginUserId").val( getCookie("hrSaveId") );
  $("#loginPassword").focus();
}else{
  $("#loginLoginId").focus();
}

// 체크상태 저장
if ( getCookie("hrSaveChk") == null) {
  setCookie("hrSaveChk","true",1000);
}

$("#saveChk")
  // 체크상태 셋팅
  .attr("checked", getCookie("hrSaveChk") != "" ? true : false)
  // 아이디 저장 클릭시 쿠키 저장
  .click( function() {
   setCookie("hrSaveChk",$("#saveChk").is(":checked") ? "true" : "",1000);
});
}


//회사 조회
function getEnterList(c) {

var enterList = ajaxCall("/getLoginEnterList.do", "",false).enterList;
var str = "";

if(enterList == null || enterList == "" || enterList == "undefine"){
  //alert("정상적인 접근이 아닙니다.");
  return;
}

	/*1개의 회사만 있을경우 고정값으로 처리함*/
	if(enterList.length == 1) {
		$("#loginEnterCd").val(enterList[0].enterCd);
		$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_"+enterList[0].enterCd+".ico' />");
		//$("#companyList").hide();
		//$("#companyDiv").hide();
	}
	else {
		$("#company").text(enterList[0].enterNm);
		for ( var i = 0; i < enterList.length; i++) {
			var strchkk ="";
			if (enterList[i].enterCd == getCookie("hrSaveCompany")) {
				$("#loginEnterCd").val(enterList[i].enterCd);
			}
			strchkk = c == enterList[i].enterCd ? "selected" : "";
			$('#companyList').append('<option value="'+enterList[i].enterCd+'" '+strchkk+'>'+ enterList[i].enterNm +'</option>');
		}
	}
}


//로그인 체크
function isExistUser() {

	//사용자 계정정보 암호화전 평문
	var luid = $("#loginUserId").val();
	var lpwd = $("#loginPassword").val();

	var lcmp = $("#loginEnterCd").val();
	var lang = $("#localeCd").val();
	var link = $("#link").val();

	//RSA 암호화 생성
	var rsa = new RSAKey();
	rsa.setPublic($("#RSAModulus").val(), $("#RSAExponent").val());

	//사용자 계정정보를 암호화 처리
	uid = rsa.encrypt(luid);
	pwd = rsa.encrypt(lpwd);




	$.ajax({
		url: "/loginUserCheck.do",
		type: "post",
		data: {user_id:uid, user_pwd: pwd, user_comp: lcmp, user_url: link, user_lang: lang },
		dataType: "json",
		async: false,
		success  : function(rv) {
			//에러 코드 메시지
			var errMessage = {

				//secFail : "인증값이 없습니다. \n\n관리자에게 문의 하세요!"
				secFail : "새로고침후 다시 시도하여 주십시오. \n지속적으로 발생할경우 관리자에게 문의 하세요!"
				,noLogin : "로그인 할 수 없습니다. \n\n관리자에게 문의 하세요!"
				,rocking : "사용자 계정이 잠겨 있습니다. \n\n관리자에게 문의 하세요!"
				,cntOver : "비밀번호 실패 횟수가 초과 하여 로그인 할 수 없습니다.  \n\n관리자에게 문의 하세요!"
				,notMatch : "ID, Password가 틀립니다."+"\n\n실패횟수 : "+rv.loginFailCnt+"회, "+rv.loginFailCntStd+"회 이상 실패시 시스템에 로그인 할수 없습니다."
				,notExist : "ID, Password가 틀립니다."
				,loginFail : "로그인 할 수 없습니다."+"\n\n이유 :"+rv.failRev
			};

			if(rv.isUser != "exist") {
				//ShowHidePassword('ShowHidePassword');
				alert(errMessage[rv.isUser]);
				if(rv.isUser =="secFail" || rv.isUser == "loginFail"){
					window.location.reload(true);
				}

			}else {
				if( $("#saveChk").is(":checked") ){
					//조회가 정상인경우 아이디 저장
					setCookie("hrSaveId",$("#loginUserId").val(),1000);
					setCookie("hrSaveCompany",$("#loginEnterCd").val(),1000);
				}

				if( rv.loginDup == "Y"){
					alert("동일한 계정으로 타 사용자가 접속 중입니다.\n\n[경고창 발생원인]\n1. 정상적인 로그아웃을 하지 않았을 경우 발생(30분 이내)\n2. 타 사용자가 접속시도 중인 계정으로 로그인한 경우\n\n※해킹 의심 시 패스워드 변경을 권고 드립니다.");
				}

				//로그인

				location.href = "/loginUser.do";
			}
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			alert(jqXHR);
			alert(ajaxSettings);
			alert(thrownError);
			//ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}






function pwdfind(){
	frm = document.forms[0];

	//var args = new Array();
	if ($("#loginEnterCd").val() == "") {
		alert("회사를 먼저 선택하셔야 합니다.");
		return;
	}
	url ="/PwdFindForm.do";
	var width	= 584;
	var height	= 449;

	var winHeight = document.body.clientHeight;	// 현재창의 높이
	var winWidth = document.body.clientWidth;	// 현재창의 너비

	var winX = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
	var winY = window.screenY || window.screenTop || 0;	// 현재창의 y좌표

	var popX = winX + (winWidth - width)/2;
	var popY = winY + (winHeight - height)/2;
	var target = escape(url);
	target  = target.replace(/[^(a-zA-Z0-9)]/gi, "");

	var win = window.open("",target,"width="+width+"px,height="+height+"px,top="+popY+",left="+popX+",scrollbars=no,resizable=yes,menubar=no" );

	frm.target = target;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}
