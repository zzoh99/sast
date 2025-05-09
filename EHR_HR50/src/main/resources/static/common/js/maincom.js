

//===================================================   footer start =====================================================	
function layoutFooter(){
	
	var height1 = $(window).height();
	var height2 = $(".others_menu_wrap").height();
	var wheight = height1 -height2;
	if(wheight <=600 ) wheight = 600;

	$(".others_menu_wrap").css({
		"position" : "fixed",
		"top" : wheight +'px'
	});
}
//===================================================   footer end =====================================================	

//===================================================   페이지이동 start =====================================================	
// 서브페이지로 이동
function goSubPage(mainMenuCd,priorMenuCd,menuCd,menuSeq,prgCd) {
	var str = "mainMenuCd="+ mainMenuCd + "&menuSeq="+menuSeq+"&prgCd="+encodeURIComponent(prgCd) ;
	var result = ajaxCall("/geSubDirectMap.do",str,false).map;
	if(result==null){
		if( testMsgArray != null && testMsgArray != undefined && testMsgArray.length > 0 ) {
			alert({"msgid": "msg.alertMenuAuthNone", "defaultMsg":"해당메뉴에 대한 조회 권한이 없습니다."});
		} else {
			alert("해당메뉴에 대한 조회 권한이 없습니다.");
		}
		return;
	}

	var form = $('<form></form>');
	form.append('<input type="hidden" name="murl" value="' + result.surl + '" />');
	$('body').append(form);
	submitCall(form,"","post","/Hr.do");
}

// 서브페이지간 이동(서브페이지 -> 서브페이지)
function goOtherSubPage(mainMenuCd, priorMenuCd, menuCd, menuSeq, prgCd) {
	let str = "mainMenuCd="+ mainMenuCd + "&menuSeq="+menuSeq+"&prgCd="+encodeURIComponent(prgCd) ;
	let result = ajaxCall("/geSubDirectMap.do",str,false).map;

	if(result==null){
		alert("해당메뉴에 대한 조회 권한이 없습니다.");
		return;
	}

	$('#majorMenu').find("li").removeClass("on");
	$("#majorMenu li[mainmenucd="+result.mainMenuCd+"]").addClass('on')
	$("#subMenuUl>li").hide();

	createSubMenu();
	subMenuItemClick($("#subMenuUl>li a[menuid=" + result.menuId + "]"));
}
//===================================================   페이지이동 end =====================================================
//layout Header / 홈으로/권한설정/로그아웃 버튼설정/ 샘플
function layoutHeader(){
	//modifyCode : 20170329(yukpan) - 다국어/개발자모드
	//언어모드 클릭 이벤트
	//개발자 모드 추가 - 20170328 yukpan
	$("#devMode").change(function(){
		var formObj =$("#subForm");
		if ($("#devModeVal").length == 0) {
	        var o_hidden = $('<input type="hidden" value="L" name="devModeVal" id="devModeVal">');
	        $(formObj).append(o_hidden);
	    }

		ajaxCall("/DevMode.do","devModeVal="+	$("#devMode").val(),false);
		redirect("/",	"_top");
	});
	// 홈으로 버튼 클릭 이벤트
	$("#goHome").click(function(){
		$("#surl").val("");
		submitCall($("#subForm"),"","post","/Main.do");
	});

	// 회사 로고 클릭 이벤트
	$("#main_logo .logo").click(function(){
			submitCall($("#subForm"),"","post","/Main.do");
	});

	// 권한 레이어 클릭시 이벤트 막기
/*	$("#levelWidgetMain").click(function() {
		return false;
	});*/

	// 권한 설정 클릭 이벤트
/*	$("#authMgr").click(function(){
		$(document).click();
		$("#levelWidgetMain1").show();
		$(document).click(function() { $("#levelCancel").click(); });
		return false;
	});*/

	// 회사 선택 클릭 이벤트
/*	$("#companyMgr").click(function(){
		$(document).click();
		$("#companyWidgetMain").show();
		$(document).click(function() { $("#companyCancel").click(); });
		return false;
	});*/


	// 권한 설정 닫기 클릭 이벤트
/*	$("#levelCancel").click(function(){
		$(document).unbind("click");
		$("#levelWidgetMain1").hide();
		return false;
	});*/

	// 회사 선택 닫기 클릭 이벤트
	$("#companyCancel").click(function(){
		$(document).unbind("click");
		$("#companyWidgetMain").hide();
		return false;
	});

	// 권한 설정 닫기 클릭 이벤트
	$("#lockReset").click(function(){
		headerReSetTimer();
	});


	// 로그아웃 클릭 이벤트
	$("#logout").click(function(){
		//submitCall($("#subForm"),"","post","/logoutUser.do");
		var url = "/logoutUser.do";
		//$(location).attr('href',url);
		redirect(url, "_top");
	});

	// Camel변환 클릭 이벤트
	$("#camelSample").click(function(){
		goPOPUP("/Sample.do?cmd=viewSampleConvCamel","CamelCase변환");
	});

	// Guide 샘플 클릭 이벤트
	$("#guideSample").click(function(){
		goPOPUP("/Sample.do?cmd=viewSampleTab&authPg=A","guideSample");
	});

	// IBSheet 샘플 클릭 이벤트
	$("#ibsheetSample").click(function(){
		goPOPUP("/ibSample/index.html","ibsheetSample");
	});
}

//권한 설정 변경
function setLevelWidget() {
	// 권한 레이어 클릭시 이벤트 막기
	$("#levelWidgetMain").click(function() {return false;});
	// 권한 설정 클릭 이벤트
	$("#authMgr").click(function(){$(document).click();$("#levelWidgetMain1").show();$(document).click(function() { $("#levelCancel").click(); });return false;});
	// 권한 설정 닫기 클릭 이벤트
	$("#levelCancel").click(function(){$(document).unbind("click");$("#levelWidgetMain1").hide();return false;});
}
