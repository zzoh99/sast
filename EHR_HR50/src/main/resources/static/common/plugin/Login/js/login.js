
if (top.location != location) {
	top.location.href = document.location.href ;
}

//validation
function doLogin() {
	if ($("#loginUserId").val() == "") {
		alert(loginMsg["alertLoginIdNull"]);
		return $("#loginUserId").focus();
	}

	if ($("#loginPassword").val() == "") {
		alert(loginMsg["alertLoginPasswordNull"]);
		return $("#loginUserId").focus();
	}
	isExistUser();
}


//로그인 체크
function isExistUser() {

	//사용자 계정정보 암호화전 평문
	var luid = $("#loginUserId").val();
	var lpwd = $("#loginPassword").val();

	var lcmp = $("#loginEnterCd").val();
	var lang = $("#localeCd").val();
	var link = $("#link").val();

	var rsadata = ajaxCall('/getRsaKey.do', '', false);
	//RSA 암호화 생성
	var rsa = new RSAKey();
	rsa.setPublic(rsadata.modulus, rsadata.exponent);

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
			if(rv.isUser != "exist") {
				//ShowHidePassword('ShowHidePassword');
				alert(loginMsg[rv.isUser]);
				if(rv.isUser =="secFail" || rv.isUser == "loginFail"){
					window.location.reload(true);
				}

			}else {
				if( $("#saveChk").is(":checked") ){
					//조회가 정상인경우 아이디 저장
					setCookie("hrSaveId",$("#loginUserId").val(),1000);
					setCookie("hrSaveCompany",$("#loginEnterCd").val(),1000);
					setCookie("hrSaveLocaleCd",$("#localeCd").val(),1000);

				}

				if( rv.loginDup == "Y"){
					alert(loginMsg["dupUser"]);
				}

				//로그인

				location.href = "/loginUser.do";
			}
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			console.log(thrownError);
			if(rv.isUser =="secFail" || rv.isUser == "loginFail"){
				window.location.reload(true);
			}
			//alert(jqXHR);
			//alert(ajaxSettings);
			//alert(thrownError);
			//ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
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
			console.log(jqXHR);
			//alert(jqXHR +"\n"+ ajaxSettings+"\n"+ thrownError);
		}
	});

	return obj;
}

var enterCdImgObj = {};

function setCompanyImg(enterCd){

	//var baseSrc = "/common/images/login/logo1.png";
	var baseSrc = "";
	var logoSrc;
	let bgImgSrc;

	if( enterCd == "" ){
		logoSrc = baseSrc;
		bgImgSrc = "/common/images/login/login_bg02.jpg";
	}else{

		var logoImg = enterCdImgObj[enterCd+"_logoImg"];
		if( logoImg == "" || logoImg == "undefined" ){
			logoSrc = baseSrc;
		}else{
			//logoSrc = "/hrfile/"+enterCd+"/company/"+logoImg;
			logoSrc = "/OrgPhotoOut.do?enterCd="+enterCd+"&logoCd=1&orgCd=0";
		}

		bgImgSrc = "/OrgPhotoOut.do?enterCd=" + enterCd + "&logoCd=8";
	}

	var img = new Image();
	img.src = logoSrc;

	img.onload = function(){
		$("#logo_cont").attr("src", logoSrc);
	}

	img.onerror = function(){
		//$("#logo_cont").attr("src", "/common/images/login/logo.png");	
		$("#logo_cont").attr("src", "");
	}

	let bgImg = new Image();
	bgImg.src = bgImgSrc;

	bgImg.onload = function(){
		$("#bg-wrap img.bg").attr("src", bgImgSrc);
	}

	bgImg.onerror = function(){
		$("#bg-wrap img.bg").attr("src", "/common/images/login/login_bg02.jpg");
	}
}

//회사 조회
function getEnterList() {
	var enterList = ajaxCall("/getLoginEnterList.do", $("#loginForm").serialize(),false).enterList;
	var str = "";

	if(enterList == null || enterList == "" || enterList == "undefine"){
		//alert("정상적인 접근이 아닙니다.");
		return;
	}
	$('#companyList').html("");
	$('#company').text("");

	$('#companyList').remove();
	$("#companyBox").append('<select class="selectbox" id="companyList"></select>');

	if (enterList.length >  1) {
		$('#companyList').append('<option value="">'+loginMsg["companySelect"]+'</option>');
	}

	/*1개의 회사만 있을경우 고정값으로 처리함*/
	if(enterList.length == 1) {
		$("#company").text(enterList[0].copyright);
		$("#loginEnterCd").val(enterList[0].enterCd);
		$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_"+enterList[0].enterCd+".ico' />");
		enterCdImgObj[enterList[0].enterCd+"_logoImg"] = enterList[0].logoImg;
		setCompanyImg($("#loginEnterCd").val());
		$("#companyBox").hide();

		setCookie("hrSaveCompany",$("#loginEnterCd").val(),1000);
		setCookie("hrSaveLocaleCd",getCookie("hrSaveLocaleCd")=="" ? _tmpLocaleCd : getCookie("hrSaveLocaleCd"),1000);

		if ( langyn == '1' ){
			loginMsg=getMessageList($('#localeCd').val());
			getLangList();
			$("#loginUserId").attr("placeholder",loginMsg["alertLoginIdNull"]);
			$("#loginPassword").attr("placeholder",loginMsg["alertLoginPasswordNull"]);
			$("#findPw").text(loginMsg["passwordSearch"]);
			$("#idSave").text(loginMsg["idSave"]);
			//$("#companySelectH2").text(loginMsg["companySelect"]);
			$("#btnLogin").text(loginMsg["loginlogin"]);
		}

	}
	else {
		$("div .sbHolder").remove();
		for ( var i = 0; i < enterList.length; i++) {
			var strchkk ="";
			if (enterList[i].enterCd == getCookie("hrSaveCompany")) {
				$("#loginEnterCd").val(enterList[i].enterCd);
				$("#company").text(enterList[i].copyright);
			}
			strchkk = $("#loginEnterCd").val() == enterList[i].enterCd ? "selected" : "";
			$('#companyList').append('<option value="'+enterList[i].enterCd+'" '+strchkk+'>'+ enterList[i].enterNm +'</option>');
			enterCdImgObj[enterList[i].enterCd+"_logoImg"] = enterList[i].logoImg;
		}
		$("#companyList").selectbox();
	}
	if($("#loginEnterCd").val() != "" ){
		setCompanyImg($("#loginEnterCd").val());
	}

	// 회사 클릭시 회사 선택
	$("#companyList").change(function() {

		const val = $(this).val();
		this.querySelectorAll("option").forEach((opt) => { if (val !== opt.value) opt.removeAttribute("selected", ""); });

		if ( langyn == '1' ){
			loginMsg=getMessageList("ko_KR");
			getLangList();
			$("#loginUserId").attr("placeholder",loginMsg["alertLoginIdNull"]);
			$("#loginPassword").attr("placeholder",loginMsg["alertLoginPasswordNull"]);
			$("#findPw").text(loginMsg["passwordSearch"]);
			$("#idSave").text(loginMsg["idSave"]);
			//$("#companySelectH2").text(loginMsg["companySelect"]);
			$("#btnLogin").text(loginMsg["loginlogin"]);
		}

		setCompanyImg($("#companyList option:selected").val());
		$("#loginEnterCd").val($("#companyList option:selected").val());
		setCookie("hrSaveCompany",$("#companyList option:selected").val(),1000);
		setCookie("hrSaveLocaleCd","",1000);

		//getEnterMap($("#companyList option:selected").val());
		//getEnterList();

		$("head").find("link[rel='shortcut icon']").remove();
		$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_"+$("#companyList option:selected").val()+".ico' />");

	});

}

//회사 조회
function getEnterMap(selectEnterCd) {

	var enterMap = ajaxCall("/getLoginEnterMap.do","enterCd="+selectEnterCd,false).enterMap;
	var str = "";

	if(enterMap == null || enterMap == "" || enterMap == "undefine"){
		$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_MCR.ico' />");
		return;
	}
	else{
		$("head").attr("loginFavi","<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_"+enterMap.enterCd+".ico' />");
		$(document).attr("title",enterMap.alias);
		$("#title").text(enterMap.alias);
		$(".title").html(enterMap.alias);
	}
}

function getLangList(){

	$('#langList').empty();
	var c = $("#loginEnterCd").val();
	if(c.length==0){
		$("#localeCd").val(_tmpLocaleCd); //디폴트 어휘코드를 넣어줌 2020.05.28 jylee
		$("#selectLangNm").css("display","none");
		return;
	}
	$.ajax({
		url 	: "/LangId.do?cmd=getLocaleList",
		type 	: "post",
		data : {enterCd:c },
		dataType : "json",
		async: false,
		success : function(rv) {

			var langList = rv.list;
			var grpCd		= "";
			var grpNm		= "";
			var viewAuthStr	= "";
			var className	= "";
			//권한 조회 및 초기화

			if(langList.length>0){
				$("#selectLangNm").show();
				$("#localeCd").val(getCookie("hrSaveLocaleCd"));
			}else{
				$("#selectLangNm").hide();
				$("#localeCd").val(_tmpLocaleCd);  //디폴트 어휘코드를 넣어줌 2020.05.28 jylee
				setCookie("hrSaveLocaleCd",$("#localeCd").val(),1000);
			}
			var langCnt = 0;
			$(langList).each(function(idx,	str)	{
				if(($("#localeCd").val()) == (str.localeCd)) {
					langCnt++;
				}
			});
			$(langList).each(function(idx,	str)	{
				/* 					if(idx==0){
                                    $("#localeCd").val(str.localeCd);
                                    $("#selectLangNm").html(str.langNm);alert(str.langNm);
                                } */

				if ( langCnt > 0 ){
					if(($("#localeCd").val()) == (str.localeCd)) {
						$(".pop_level_lst").append("<a href='javascript:;' class='level_on'>"+str.langNm + "</a>");
						$("#selectLangNm").html(str.langNm);
					}else{
						$(".pop_level_lst").append("<a href='javascript:;' data-locale="+str.localeCd+">"+str.langNm + "</a>");
					}
				}else{
					/*if ( idx==0 ){*/
					if( str.localeCd == 'ko_KR') {
						$("#localeCd").val(str.localeCd);
						$(".pop_level_lst").append("<a href='javascript:;' class='level_on'>"+str.langNm + "</a>");
						$("#selectLangNm").html(str.langNm);
					}else{
						$(".pop_level_lst").append("<a href='javascript:;' data-locale="+str.localeCd+">"+str.langNm + "</a>");
					}
				}

			});
			// click event
			$("#langList a").click(function() {

				if ( $(this).hasClass("level_on") == false )	{
					var beflcd = $("#localeCd").val();
					var beflnm = $(".level_on").html();
					$("#localeCd").val($(this).attr("data-locale"));
					setCookie("hrSaveLocaleCd",$("#localeCd").val(),1000);
					$("#selectLangNm").html($(this).html());
					//change
					$("#langList a.level_on").removeClass("level_on").attr("data-locale", beflcd);
					$(this).addClass("level_on").removeAttr("data-locale");

					if ( langyn == '1' ){
						loginMsg=getMessageList($("#localeCd").val());
						getLangList();
					}
					getEnterList();

				}else{
					$("#langeCancel").click();
				}
			});
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		},complete : function() {

			if ( langyn == "1" ){

				$("#loginUserId").attr("placeholder",loginMsg["alertLoginIdNull"]);
				$("#loginPassword").attr("placeholder",loginMsg["alertLoginPasswordNull"]);
				$("#findPw").text(loginMsg["passwordSearch"]);
				$("#idSave").text(loginMsg["idSave"]);
				//$("#companySelectH2").text(loginMsg["companySelect"]);
				$("#btnLogin").text(loginMsg["loginlogin"]);
			}
		}
	});
	//getEnterList();
}

//메시지 조회
function getMessageList(localeCd) {
	var msgJson = ajaxCall("/LangId.do?cmd=getLoinMessageMap","keyLevel=login&localeCd="+localeCd,false).msg;
	var	msgArray = [];
	$(msgJson).each(function(idx,obj){
		msgArray[obj.keyId]	=	(obj.keyText).split("\\n").join("\n"); //메세지 개행처리가 안되서 추가함 2020.05.28 jylee
	});
	return msgArray;
}


//쿠키에서 체크상태에 따른 설정
function setCookieChkBox(){
	if(getCookie("hrSaveId")==""){
		$("#loginUserId").focus();
	}
	// 체크상태 불러 오기
	if( getCookie("hrSaveChk") == "true" ){
		$("#loginUserId").val( getCookie("hrSaveId") );
		$("#loginPassword").focus();
	}else{
		$("#loginUserId").focus();
	}

	// 체크상태 저장
	if ( getCookie("hrSaveChk") == null) {
		setCookie("hrSaveChk","true",1000);
	}

	if ( getCookie("wrapColor") == null) {
		setCookie("wrapColor", "01" ,1000);
	}else{

		$("#wrap").addClass("back" + getCookie("wrapColor"));
		$("#bg" + getCookie("wrapColor")).after("<span class=\"back_check\"></span>");

	}

	$("#saveChk")
		// 체크상태 셋팅
		.attr("checked", getCookie("hrSaveChk") != "" ? true : false)
		// 아이디 저장 클릭시 쿠키 저장
		.click( function() {
			setCookie("hrSaveChk",$("#saveChk").is(":checked") ? "true" : "",1000);
		});

}

/**
 * capslock이 눌러 있는지 확인 처리
 */
var _locale;
var _isCache = false;
var _cacheInfo = "";
function fnKeyPress(ev)
{
	//_locale = document.loginForm.login_locale.value;
	var e = $.event.fix(ev);
	var keyCode = 0;
	var shiftKey = false;
	keyCode = e.which;
	shiftKey = e.shiftKey;
	//var passwdObj = document.getElementById("password");
	if ((keyCode >= 65 && keyCode <= 90) && !shiftKey){
		$.validationEngine.buildPrompt($("#password"), loginMsg["alertLoginCapsLock"], "error");
	}else{
		$.validationEngine.closePrompt(passwdObj, false);

	}
}

function pwdfind(){
	if ($("#loginEnterCd").val() == "") return;
	var url ="/viewPwdFindLayer.do";
	var p = { enterCd: $("#loginEnterCd").val() };
	var title = "비밀번호 찾기";
	var width	= 730;
	var height	= 480;

	var layer = new window.top.document.LayerModal({
		id: 'pwdFindLayer',
		url: url,
		parameters: p,
		width: width,
		height: height,
		title: title
	});
	layer.show();
}

// 쿠키 전체 삭제
function deleteCookies(){
	var count = 0; // 쿠키 개수
	if(document.cookie != ""){ // 저장된 쿠키가 있다면
		var cookies = document.cookie.split("; ");
		count = cookies.length;

		// 쿠키에 대한 날짜를 -1로 설정하면 쿠키 바로 소멸됨.
		var expireDate = new Date();
		expireDate.setDate(expireDate.getDate() -1); // -1 쿠키 삭제

		for(var i =0; i < count; i++){
			var cookieName = cookies[i].split("=")[0];
			// 쿠키이름을 아무것도 설정하지 않고, 소멸시기를 -1로 설정하면 쿠키삭제됨.
			document.cookie = cookieName + "=; path=/; expires=" + expireDate.toGMTString() +";";
		}
	}
	return count; // 삭제된 쿠키 개수 반환
}

function btnDeleteCookies_Click(){
	alert(deleteCookies() + " 개의 쿠키가 제거되었습니다.");
}

function clearAllCookies(domain, path) {
	var doc = document,
		domain = domain || doc.domain,
		path = path || '/',
		cookies = doc.cookie.split(';'),
		now = +(new Date);
	for (var i = cookies.length - 1; i >= 0; i--) {
		doc.cookie = cookies[i].split('=')[0] + '=; expires=' + now + '; domain=' + domain + '; path=' + path;
	}
}

function showBackType() {
	$('.back_type_group').fadeToggle('slow');
}
function showCloseBtn(obj) {
	// close클래스 변경
	var tmp = obj.parent();
	var idx = tmp.attr("class").indexOf("_close");
	if(idx > -1) {
		tmp.attr("class", tmp.attr("class").substring(0, idx));
	} else {
		tmp.attr("class", tmp.attr("class") + "_close");
	}
}

function buttonEvent(){
	//로그인 버튼 클릭
	$("#btnLogin").click(function() {
		// 더블클릭 방지
		if(clickState == null){
			clickState = setTimeout(function(){ //0.2초 뒤에 클리어
				clearTimeout(clickState);
				clickState = null;
			}, 200);
			doLogin();
		}
	});

	// 패스워드 엔터키 입력 이벤트
	/* $("#loginPassword").bind("keyup",function(event){
      if( event.keyCode == 13 ){
        doLogin();
      }
    }); */

	$("#loginPassword").keypress(function(e) {
		var is_shift_pressed = false;
		if (e.shiftKey)
			is_shift_pressed = e.shiftKey;
		else if (e.modifiers)
			is_shift_pressed = !!(e.modifiers & 4);

		//var isIE = (window.navigator.userAgent.indexOf('MSIE') > -1 || window.navigator.userAgent.indexOf('Trident') > -1) ? true : false;

		// if( !isIE ) {
		if (((e.which >= 65 && e.which <=  90) && !is_shift_pressed) || ((e.which >= 97 && e.which <= 122) && is_shift_pressed)) {
			$(".capslock").show();
		} else {
			$(".capslock").hide();
		}
		//}

		if( event.keyCode == 13 ){
			doLogin();
		}
	});

	$("#findPw").click(function() {
		pwdfind();
	});

	$("#bg01, #bg02, #bg03, #bg04, #bg05, #bg06").click(function(){

		$(".back_type_group > li > span").remove();
		var val = $(this).attr("class").substring(2,4);
		$("#wrap").removeAttr("class");
		$("#wrap").addClass("back" + val);
		$("#bg" + val).after("<span class=\"back_check\"></span>");
		setCookie("wrapColor", val, 1000);
	});

	$("#selectLangNm").click(function(e) {
		var isShown = false;
		if($("#chglanguageMain").is(":visible"))
			isShown = true;
		$(document).click();
		$(document).unbind("click");
		if(isShown) {
			$("#chglanguageMain").hide();
		} else {
			$("#chglanguageMain").show();
		}
		$(document).click(function(e) {
			$("#chglanguageMain").hide();
		});
		return false;
	});
}