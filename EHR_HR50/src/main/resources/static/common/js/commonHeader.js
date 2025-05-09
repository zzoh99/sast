
var timerCnt = 0;
var timerId;
$(function() {

//	$("#devMode").val("${sessionScope.devMode}");
//	if("${sessionScope.devMode}" == "A"){
//
//	}

	$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_" + _connect_E_ + ".ico' />");
	//$("#logo").attr("src", "/OrgPhotoOut.do?logoCd=7&orgCd=0&t=" + (new Date()).getTime());
	$("#logo").css("text-indent" , "0px").html("<img id='companyLogo1' />");
	$("#companyLogo1").attr("src", "/OrgPhotoOut.do?logoCd=7&orgCd=0&t=" + (new Date()).getTime());

	$("#chgUser").click(function(){
		if(!isPopup()) {return;}

		if (!confirm(getMsgLanguage({"msgid": "msg.201707120000007", "defaultMsg":"관리자 권한으로 접근 하였습니다.\n관리자가 아닌 경우 접근경로를 확인가능하며,\n인사상 불이익이 있을 수 있습니다.\n\n본인의 아이디와 비밀번호를 사용 바랍니다."}))){
			return;
		}

		var url 	= "/chgUesrPopup.do";
		var args 	= new Array();

		gPRow = "";
		pGubun = "chgUserPopup";

		openPopup(url,args,900,750);
	});
	$("#chgGrp").click(function(e) {
		var isShown = false;
		if($("#levelWidgetMain").is(":visible"))
			isShown = true;
		$(document).click();
		$(document).unbind("click");
		if(isShown) {
			$("#levelWidgetMain").hide();
		} else {
			$("#levelWidgetMain").show();
		}
		$(document).click(function(e) {
			$("#levelWidgetMain").hide();
		});
		return false;
	});
	$("#chgAuth").click(function(e) {
		var isShown = false;
		if($("#chgAuthMain").is(":visible"))
			isShown = true;
		$(document).click();
		$(document).unbind("click");
		if(isShown) {
			$("#chgAuthMain").hide();
		} else {
			$("#chgAuthMain").show();
		}
		$(document).click(function(e) {
			$("#chgAuthMain").hide();
		});
		return false;
	});
	$("#chgCompany").click(function(){
		if(!isPopup()) {return;}

		var url 	= "/chgCompanyPopup.do";
		var args 	= new Array();

		pGubun = "chgCompanyPopup";
		openPopup(url, args, "450", "370");

	});
	$("#chgComp").click(function(e) {
		var isShown = false;
		if($("#chgCompMain").is(":visible"))
			isShown = true;
		$(document).click();
		$(document).unbind("click");
		if(isShown) {
			$("#chgCompMain").hide();
		} else {
			$("#chgCompMain").show();
		}
		$(document).click(function(e) {
			$("#chgCompMain").hide();
		});
		return false;
	});
	$("#logout").click(function(e) {
		var url = "/logoutUser.do";
		redirect(url, "_top");
	});


 //개발자 가이드 추가 - 2018-10-25  -->
	$("#goDevGuide").click(function(){
		if(!isPopup()) {return;}

		var url 	= "/Sample.do?cmd=viewSampleTab";
		var args 	= new Array();

		pGubun = "goDevGuide";
		openPopup(url, args, "1500", "800");
	});

	$("#lockScreen").click(disableTop);

	$("#searchUser").click(function(){
		showEmployeePopup();
	});

	$("#topKeyword").keydown(function(event){
		if( event.keyCode == 13){
			if($("#topKeyword").val() != "") showEmployeePopup();
		}
	});

/*	$("#devMode").change(function(){
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
	});*/

	// 개인별 알림 2020.06.09
	getPanalAlertList2(_connect_I_);

	// 오늘 하루 그만 보기  2020.06.09
	$("#panalAlertTodayClose").click(function() {
		closePanalAlert(_connect_I_);
	});

 //그룹코드관리 링크  -->
	$("#goGrcode").click(function(){
		//goSubPage("","","","","GrpCdMgr.do?cmd=viewGrpCdMgr");

    	var str = "mainMenuCd=11&prgCd="+encodeURIComponent("GrpCdMgr.do?cmd=viewGrpCdMgr") ;
    	var result = ajaxCall("/geSubDirectMap.do",str,false).map;

    	$("#murl").val( result.surl );
    	$("#surl").val( result.surl );

    	openContent("공통코드관리",result.prgCd,"<span>시스템 > 코드관리 > 공통코드관리</span>",result.surl);
	});

 //쿼리자동생성 링크  -->
	$("#goQuery").click(function(){
		//goSubPage("","","","","GrpCdMgr.do?cmd=viewGrpCdMgr");

    	var str = "mainMenuCd=11&prgCd="+encodeURIComponent("CreQueryMgr.do?cmd=viewCreQueryMgr");
    	var result = ajaxCall("/geSubDirectMap.do",str,false).map;

    	$("#murl").val( result.surl );
    	$("#surl").val( result.surl );

    	openContent("쿼리자동생성",result.prgCd,"<span>시스템 > 기타 > 쿼리자동생성</span>",result.surl);
	});



});

function enableTop() {
	$.each(getPopupList(), function(idx, obj) {
		obj.obj.enablePage();
	});

	$("div.lock").remove();

	//scroller
	$('html, body').removeClass('lock-size');
	$('#element').off('scroll touchmove mousewheel');

	timerInit();
}

function disableTop() {
	var pageCnt = _pageObj.length, thar = this;
	$.each(getPopupList(), function(idx, obj) {
		obj.obj.disablePage(pageCnt === idx+1 ? true : false);
	});

	clearInterval(timerId);
	timerId = null;

	var disableDiv = $("<div>").addClass("lock lockDiv"),

	lockDiv = $("<div>")
		.addClass("lock lock-panel")
		.css({"border-radius":"30px", "padding":"30px"})
		.html("<iframe name='iframePopLayer' id='iframePopLayer' src='/Lock.do' frameborder='0' width='100%' height='100%'></iframe>");
	$('html, body').addClass('lock-size');
	window.scrollTo(0, 0);
	$("body").append(disableDiv).append(lockDiv);

	$('#element').on('scroll touchmove mousewheel', function(e) {
		e.preventDefault();
		e.stopPropagation();
		return false;
	});
	$(document).bind('keydown',function(e){if ( e.keyCode == 123 /* F12 */) {e.preventDefault();e.returnValue = false;}});

}

//===================================================   권한 조회 및 변경 start =====================================================
function createAuthList(gCd){
	$.ajax({
		url 	: "getCollectAuthGroupList.do",
		type 	: "post", dataType : "json", async : true, data : "",
		success : function(rv) {
			var authList = rv.result;
			var grpCd		= "";
			var grpNm		= "";
			var viewAuthStr	= "";
			var className	= "";
			//권한 조회 및 초기화
			$("#authList1").html("");
			for ( var i = 0; i < authList.length; i++) {
				grpCd		= authList[i].ssnGrpCd;
				grpNm		= authList[i].ssnGrpNm;
				rurl		= authList[i].rurl;

				if( grpCd == gCd ) className = "level_on";
				else className = "";
				viewAuthStr += "<a href='javascript:;' rurl='"+ rurl +"' class='"+className+"'>"+ grpNm +"</a>";
			}
			$("#authList1").append(viewAuthStr);
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		},complete : function() {
			// 권한 변경리스트 클릭  이벤트
			$("#authList1 a").click(function() {
				createForm("ssnChangeForm");
				createInput("ssnChangeForm","rurl");
				$("#rurl").val($(this).attr("rurl"));
				var j = ajaxCall("/ChangeSession.do",$("#ssnChangeForm").serialize(),false);
				redirect("/", "_top");
			});
		}
	});
}
//===================================================   권한 조회 및 변경 start =====================================================
//===================================================   테마설정 start =====================================================
// 스킨 설정
function setThemeFont(t,f,m) {
	var cTint= 0;
	var cFint= 0;
	var cMain= 0;

	if(t=="theme1") cTint=0;
	if(t=="theme2") cTint=1;
	if(t=="theme3") cTint=2;
	if(t=="theme4") cTint=3;
	if(t=="theme5") cTint=4;
	if(t=="theme6") cTint=5;

	if(f=="nanum")        cFint=0;
	if(f=="notosans")     cFint=1;
	if(f=="malgun")        cFint=2;

	if(m=="M")     cMain=0;
	if(m=="W")     cMain=1;

	var currentSkin = cTint;
	var currentFont = cFint;
	var currentMain = cMain;

	// 테마 설정 레이어 이벤트 막기
	$("#themeWidgetMain").click(function(){
		return false;
	});
	// 테마 설정 아이콘 클릭 이벤트
	$("#themeWidget").click(function(e) {
		var isShown = false;
		if($("#themeWidgetMain").is(":visible"))
			isShown = true;
		$(document).click();
		$(document).unbind("click");

		$("#themeWidgetMain .pop_theme_lst li").each(function() {

			if( $(this).index() == currentSkin ) {
				$(this).find("p").addClass("theme_on");
			}else {
				$(this).find("p").removeClass("theme_on");
			}
		});

		$("#themeWidgetMain .pop_theme_font input").each(function() {
			if( $(this).parent().index() == currentFont ) {
				$(this).attr("checked",true);
			}else{
				$(this).attr("checked",false);
			}
		});

		$("#themeWidgetMain .pop_main_type input").each(function() {
			if( $(this).parent().index() == currentMain ) {
				$(this).attr("checked",true);
			}else{
				$(this).attr("checked",false);
			}
		});

		if(isShown) {
			$("#themeWidgetMain").hide();
		} else {
			$("#themeWidgetMain").show();
		}
		$(document).click(function(e) {
			$("#themeWidgetMain").hide();
		});
		return false;
	});


/*	$("#themeWidget").click(function() {
		$(document).click();
		// 활성화 된 테마를 설정한다.
		$("#themeWidgetMain .pop_theme_lst li").each(function() {

			if( $(this).index() == currentSkin ) {
				$(this).find("p").addClass("theme_on");
			}else {
				$(this).find("p").removeClass("theme_on");
			}
		});

		$("#themeWidgetMain .pop_theme_font input").each(function() {
			if( $(this).parent().index() == currentFont ) {
				$(this).attr("checked",true);
			}else{
				$(this).attr("checked",false);
			}
		});

		$("#themeWidgetMain").show();
		$(document).click(function() { $("#themeCancel").click(); });
		return false;
	});*/

	// 테마 리스트 클릭시 이벤트
	$("#themeWidgetMain .pop_theme_lst li").click(function() {
		// 테마 리스트의 체크박스를 선택안된 상태로 만든다.
		$("#themeWidgetMain .pop_theme_lst li").each(function() {
			$(this).find("p").removeClass("theme_on");
		});
		// 선택된 테마의 체크박스만 체크 상태로 만든다.
		$(this).find("p").addClass("theme_on");
	});

	// 폰트 리스트 클릭 이벤트
	$("#themeWidgetMain .pop_theme_font li").click(function() {
		// 폰트 리스트의 체크박스를 선택안된 상태로 만든다.
		$("#themeWidgetMain .pop_theme_font input").each(function() {
			$(this).attr("checked",false);
		});

		// 선택된 폰트의 체크박스만 체크 상태로 만든다.
		$(this).find("input").attr("checked",true);
		return false;
	});

	// 폰트 리스트 클릭 이벤트
	$("#themeWidgetMain .pop_main_type li").click(function() {
		// 폰트 리스트의 체크박스를 선택안된 상태로 만든다.
		$("#themeWidgetMain .pop_main_type input").each(function() {
			$(this).attr("checked",false);
		});
		console.log($(this).find("input"));

		// 선택된 폰트의 체크박스만 체크 상태로 만든다.
		$(this).find("input").attr("checked",true);
		return false;
	});

	$("#themeWidgetMain .pop_theme_font li").click(function(e) {
		e.stopPropagation();
		$("#themeWidgetMain .pop_theme_font li:eq(" + $(this).parent().index() + ")").click();
	});

	$("#themeWidgetMain .pop_main_type li").click(function(e) {
		e.stopPropagation();
		$("#themeWidgetMain .pop_main_type li:eq(" + $(this).parent().index() + ")").click();
	});

	// 테마 설정 레이어의 확인 클릭시 이벤트
	$("#themeOk").click(function() {
		var valueChanged = false;
		var selectTheme = "";
		var selectFont = "";
		var selectMain = "";

		// 현재 선택된 테마를 저장한다.
		$("#themeWidgetMain .pop_theme_lst li").each(function() {
			if( $(this).find("p").hasClass("theme_on") ) {
				if( currentSkin != $(this).index() ) valueChanged = true;
				currentSkin = $(this).index();
				selectTheme = $(this).attr("theme");
			}
		});

		// 현재 선택된 폰트를 저장한다.
		$("#themeWidgetMain .pop_theme_font li").each(function() {
			if( $(this).find("input").attr("checked") ) {
				if( currentFont != $(this).index() ) valueChanged = true;
				currentFont = $(this).index();
				selectFont = $(this).find("input").val();
			}
		});

		// 현재 선택된 메인을 저장한다.
		$("#themeWidgetMain .pop_main_type li").each(function() {
			if( $(this).find("input").attr("checked") ) {
				if( currentMain != $(this).index() ) valueChanged = true;
				currentMain = $(this).index();
				selectMain = $(this).find("input").val();
			}
		});

		// 스킨이나 폰트 값이 변경되었을 경우 변수에 저장후 home으로 이동
		if( valueChanged ) {

			$("#subThemeType").val(selectTheme);
			$("#subFontType").val(selectFont);
			$("#subMainType").val(selectMain);

			//저장
			ajaxCall("/UserMgr.do?cmd=userTheme",$("#ssnChangeForm").serialize(),false);
			redirect("/", "_top");
		}
		$("#themeCancel").click();
	});

	// 테마 설정 레이어의 취소 클릭시 이벤트
	$("#themeCancel").click(function() {
		// 테마 설정 레이어를 숨겨준다.
		$("#themeWidgetMain").hide();
		$(document).unbind("click");
	});
}
//===================================================   테마설정 end =====================================================
//===================================================   시간관련 start =====================================================

function timerInit() {
	if(defaultTime !== "" && defaultTime > 0) {
		$('#txtTimer').show();
		timerCnt = parseInt(defaultTime, 10);
		timerId = setInterval(timerRun, 1000);
	} else {

	}
}

function timerRun() {
	$('#txtTimer').html(timeFormat(timerCnt));
	timerCnt--;

	$.each(_pageObj, function(idx, obj) {
		if(obj.obj.closed) {
			_pageObj.splice(idx, 1);
		}
	});

	if(timerCnt < 0) {
		disableTop();
		//$("#logout").click();
		//logOut();
	}
}

function timeFormat(s) {
	var nH = 0;
	var nM = 0;
	var nS = 0;

	if(s > 0) {
		nM = parseInt(s/60,10);
		nS = s%60;

		if(nM > 60) {
			nH = parseInt(nM/60,10);
			nM = nM%60;
		}
	}

	if(nS < 10) nS = '0'+nS;
	if(nM < 10) nM = '0'+nM;
	return ''+nH+':'+nM+':'+nS;
}


function resetTimer() {
	timerCnt = parseInt(defaultTime, 10);
}
//===================================================   시간관련 end =====================================================
function setPageObj(key, obj) {
	var isExist = false;
	$.each(_pageObj, function(idx, obj) {
		if(obj.key === key) {
			return isExist = true;
		}
	});

	if(!isExist) {
		_pageObj[_pageObj.length] = {"key": key, "obj": obj};
	}
}
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

	if(pGubun == "chgUserPopup"){
		chgUser(rv["sabun"]);
		return;
	}
//} else if(pGubun == "chgCompanyPopup") {
//	chgCompany(rv["company"]);
	if(pGubun == "viewApprovalMgrResult") {
		mainBox19loadApp();  //main_listBox19.jsp
	} else if (pGubun == "employeePopup") {

	// 메인화면 > 임직원검색 (팝업)
		if(rv != null && rv.length != 0 ){
			var url2 	= "/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=" + _connect_A_;
			var args2 	= new Array();
			args2["sabun"] = rv["sabun"];

			pGubun = "viewEmpProfile";
			var rv2 = openPopup(url2,args2,610,300);
			if(rv!=null){}
		}

	} else if(pGubun == "widjetPopup") {
		goMain();
	}
}
//modifyCode : 20170329(yukpan) - 다국어/개발자모드
function openLocalePop(){
var url = "/DictMgr.do?cmd=viewDict";
var args = new Array();
//	args["is"] = "_popup";
openPopup(url,args,"740","520");
}
//메인으로이동
goMain = function(){
	redirect("/Main.do", "_top");
};

function showEmployeePopup() {
	if(!isPopup()) {return;}

	var args 	= new Array();
	args["sType"] 		= "T";
	args["topKeyword"] 	= $("#topKeyword").val();
	args["searchEnterCdView"] 	= "Y";
	args["profileView"] 	= "Y";

	var url = "/Popup.do?cmd=employeePopupMain&authPg=R";

	gPRow = "";
	pGubun = "employeePopup";
	openPopup(url,args,"840","620");
};


// 개인별 알림 2020.06.09
function getPanalAlertList(sabun) {
	//$("#alertInfo").hide();

	var isPop = true;

	// 오늘 하루 그만보기  체크
	if (getCookie("panalAlertClose") != null) {
		var today = new Date();

		var tMonth = today.getMonth() + 1
		tMonth = tMonth < 10 ? "0" + tMonth : tMonth;
		var tDay = today.getDate()
		tDay = tDay < 10 ? "0" + tDay : tDay;

		var cookieValue = sabun + "|" + today.getFullYear() + tMonth + tDay;

		if (getCookie("panalAlertClose") == cookieValue) {
			// 오늘 하루 그만 보기 이미 체크된 경우면 알림 화면 열지 않게 하기 위함
			isPop = false;
		}
	}
	if(isPop){
		getPsnalAlertList(sabun);
	}
}
function getPsnalAlertList(sabun) {
	$.ajax({
		url 		: "/getPanalAlertList.do",
		type 		: "post",dataType: "json",async: true,data:"",
		success : function(rv) {

			var lst = rv.result;
			var str = "";
			for ( var i = 0; i < lst.length; i++) {  //
				str += "<li><a class='mdi-ico'>check</a>"+lst[i].title+"&nbsp;<a class='li_link' url='"+lst[i].linkUrl+"'>[바로가기]</a></li>";
			}
			if( str != "") {
				$("#panalAlert").html(str);
				$("#panalAlertDiv").draggable();

				//if (isPop){
					setTimeout(function(){
						// 개인 알림 데이터 조회
						loadToastMsg();
						$(".panalAlert").show();
					},50);
				//}

				$(".li_link").click(function(){
					if(location.href.indexOf("/Hr.do") > -1){
						var str = "menuSeq=&prgCd="+$(this).attr("url") ;
						var result = ajaxCall("/geSubDirectMap.do",str,false).map;
						var mainMenuCd  =  result.mainMenuCd;
						$("#majorMenu1 li", parent.document).each(function(){
							if( $(this).attr("mainMenuCd") == mainMenuCd && $(this).hasClass("lnb_selected") == false ){
								parent.majorMenuOpen( $(this).attr("mainMenuCd") );
							}
						});

						setTimeout(function(){
							parent.openSubMenuCd( result.surl,result.menuId);
						},300);

					}else{
						goSubPage('','','','',$(this).attr("url"));
					}

				});

				setTimeout(function(){$("#alertInfo").show();},50);
			}else{
				$("#panalAlert").html($("<li/>", {
					"class" : "mat10 mab10"
				}).text("등록된 알림사항이 없습니다."));
			}
		
			$(".title_close").click(function(){
				$(".panalAlert").hide();
			});
			$("#alertInfo").click(function() {
				if( $(".panalAlert").css("display") == "none" ) {
					$(".panalAlert").show();
					// 개인 알림 데이터 조회
					loadToastMsg();
				}else{
					$(".panalAlert").hide();
				}
			});
		}
	});
}

// 개인 알림 데이터 조회
function loadToastMsg() {
	var _li, _listEle = $(".toastMsgList", "#panalAlertDiv");
	if( _listEle.length > 0 ) {
		$.ajax({
			url     : "/getAlertInfoList.do",
			type    : "post",
			dataType: "json",
			async   : true,
			data    : "",
			success : function(data) {
				//console.log('data', data);
				
				if(data){
					_listEle.empty();
					var list = data.DATA;
					
					if(list.length == 0) {
						_listEle.html($("<li/>", {}).text("새로운 알림이 없습니다."));
						$(".toastMsgBox", "#panalAlertDiv").css({
							"height" : "35px"
						});
						
					} else {
						for(var i = 0 ; i < list.length;i++){
							var ob = list[i];
							
							_li = $("<li/>", {
								"seq" : ob.seq
							});
							_li.append(
								$("<div/>", {
									"class" : "nTitle",
									"seq"   : ob.seq
								})
								.append($("<a/>", {
									"class" : "btn_show"
								}))
								.append($("<span/>", {
									"class" : "date"
								}).text("[" + ob.regDate + "]"))
								.append(ob.nTitle)
							);
							_li.append(
								$("<div/>", {
									"class" : "nContent"
								})
								.html(ob.nContent)
								.append(
									$("<p/>", {
										"class" : "manage"
									})
									.append(
										$("<a />", {
											"class" : "link hide",
											"href" : "javascript:goDirectRecentToastMsg('" + ob.nLink + "', '" + ob.seq + "');"
										}).text("[바로가기]")
									)
									.append(
										$("<a />", {
											"class" : "remove",
											"href" : "javascript:deleteToastMsg('" + ob.seq + "');"
										}).text("[지우기]")
									)
								)
							);
							
							_li.find(".nTitle").addClass((ob.readYn == "Y") ? "readY" : "readN");
							
							if( ob.nLink && ob.nLink != null && ob.nLink != "" ) {
								_li.find(".link").removeclass("hide");
							}
							
							_listEle.append(_li);
						};
						
						$(".nTitle", _listEle).on("click", function(e){
							var _seq = $(this).attr("seq");
							
							if( $("li[seq='" + _seq + "']", _listEle).hasClass("active") ) {
								$("li[seq='" + _seq + "']", _listEle).removeClass("active");
								$("li[seq='" + _seq + "'] .nContent", _listEle).slideUp();
							} else {
								$("li[seq='" + _seq + "']", _listEle).addClass("active");
								$("li[seq='" + _seq + "'] .nContent", _listEle).slideDown();
								
								// 읽지 않은 알림인 경우
								if( $("li[seq='" + _seq + "'] .nTitle", _listEle).hasClass("readN") ) {
									updateAlertInfoReadYn(_seq);
								}
							}
						});
						$(".remove", _listEle).on("click", function(e){
						});
					}
				}
			},
			error:function(e){
				alert("[개인 알림 데이터 조회 오류] messge : " + e.responseText);
			}
		});
	}
}

// 개인 알림 메시지 읽은 경우 처리
function updateAlertInfoReadYn(_seq) {
	var _listEle = $(".toastMsgList", "#panalAlertDiv");
	if( _listEle.length > 0 ) {
		$.ajax({
			url :"/updateAlertInfoReadYn.do",
			dateType : "json",
			type:"post",
			data: {seq:_seq},
			success: function( data ) {
				if (data.Message !== "") {
					alert(data.Message);
				}else{
					$("li[seq='" + _seq + "'] .nTitle", _listEle).removeClass("readN").addClass("readY");
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
}

// 알림 지움
function deleteToastMsg(seq) {
	var _listEle = $(".toastMsgList", "#panalAlertDiv");
	if( _listEle.length > 0 ) {
		$.ajax({
			url :"/deleteAllAlert.do",
			dateType : "json",
			type:"post",
			data: {seq:seq},
			success: function( data ) {
				if (data.Message !== "") {
					alert(data.Message);
				}else{
					loadToastMsg()
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
}

// 알림 바로가기
function goDirectRecentToastMsg(link, seq) {
	openPopup(link,"",900,600);
	
	if (seq !== undefined && seq !== null) {
		readRecentAlert(seq);
	}
}


// 오늘 하루 그만 보기 2020.06.09
function closePanalAlert(sabun){
	$("#alertInfo").show();
	$(".panalAlert").hide();

	var today = new Date();

    var tMonth = today.getMonth() + 1
    tMonth     = tMonth< 10 ? "0"+tMonth : tMonth;
    var tDay   = today.getDate()
    tDay       = tDay < 10 ? "0" + tDay : tDay;

	var cookieValue = sabun +"|"+ today.getFullYear() + tMonth + tDay;

	setCookie("panalAlertClose", cookieValue, 1000);

}
