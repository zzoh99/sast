/*
$(function(){
		
		var localeCd = "${ssnLocaleCd}";
	
		var tmpFrm = $("<form id=\"tmpFrm\" name=\"tmpFrm\"></form>");
		tmpFrm.appendTo("body");
		isOpenSearchMenu = false;
		isOpenSearchUser = false;
		isOpenAlertInfo  = false;

		var _menuTitle = localeCd == "ko_KR" ? "메뉴 검색" : "Menu Search";
		var _empTitle  = localeCd == "ko_KR" ? "임직원 검색" : "Employee Search";
		var _noticeTitle = localeCd == "ko_KR" ? "알림" : "Notifications";
		
		//알림 클릭시 DIALOG
		$("#dialogAlertInfo").dialog({
			height:380,
			width:500,
			modal:true,
			closeText:"",
			closeOnEscape: true,
			hideCloseButton: false,
			draggable: false,
	        position: {
	            my : 'center top',
	            at : 'left bottom',
	            of : '#alertInfo'
	        },
			title: _noticeTitle,
			open : function(){
				//$('.ui-dialog-titlebar-close',$(this).parent()).hide();
				$('.ui-widget-overlay').bind('click', function() { $('#dialogAlertInfo').dialog('close'); });
				if($("iframe#iframeAlertInfo").get(0).contentWindow.doActionAlertInfo){
					$("iframe#iframeAlertInfo").get(0).contentWindow.doActionAlertInfo();
				}else{
					$("iframe#iframeAlertInfo").load(function(){
						$("iframe#iframeAlertInfo").get(0).contentWindow.doActionAlertInfo();
					});
				}
				if(!isOpenAlertInfo){
					submitCall(tmpFrm,"iframeAlertInfo","post","/viewAlertInfo.do");
					isOpenAlertInfo = true;
				}
				setAlertInfoCnt();
			},
			close:function(){
				setAlertInfoCnt();
			},
			autoOpen:false
		});
		
		$("#alertInfo").on("click",function(){
			$("#dialogAlertInfo").dialog("open");
		});
	});
*/
/* main sub 공통 */

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


//권한 설정 변경
function setLevelWidget() {
	// 권한 레이어 클릭시 이벤트 막기
	$("#levelWidgetMain1").click(function() {return false;});
	// 권한 설정 클릭 이벤트
	$("#authMgr").click(function(){
		$(document).click();
		$(document).unbind("click");
		$("#levelWidgetMain1").show();
		$(document).click(function() { 
			$("#levelWidgetMain1").hide();
		});
		return false;
	});
	// 권한 설정 닫기 클릭 이벤트
	$("#levelCancel").click(function(){$(document).unbind("click");$("#levelWidgetMain1").hide();return false;});
}

//링크설정 변경
function setDevWidget() {
	// 링크 레이어 클릭시 이벤트 막기
	$("#devWidgetMain").click(function() {return false;});
	// 링크 설정 클릭 이벤트

	$("#tmpTemplet").click(function(){
		//alert(123123);

	});
	$("#tmpTemplet #linkMgr").click(function(){
		//alert("==>"+ 12123123);
		//$(document).click();
		//$("#devWidgetMain").show();
		//$(document).click(function() { $("#devCancel").click(); });return false;
	});
	// 링크설정 닫기 클릭 이벤트
	$("#devCancel").click(function(){$(document).unbind("click");$("#devWidgetMain").hide();return false;});
}

//언어설정
function setLangeWidget() {
	$("#chgCompMain").click(function() {return false;});
	//$("#langeMgr").click(function(){$(document).click();$("#chgCompMain").show();$(document).click(function() { $("#langeCancel").click(); });return false;});
	$("#langeCancel").click(function(){$(document).unbind("click");$("#chgCompMain").hide();return false;});
}



//권한 조회 및 변경
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

				if( grpCd == gCd ) className = "on";
				else className = "";
				viewAuthStr +="<li rurl='"+ rurl +"'><a class='"+className+" pointer'>"+ grpNm +"</a></li>";
			}
			$("#authList1").append(viewAuthStr);

			// 권한 변경리스트 클릭  이벤트
			$("#authList1 li").click(function() {
				createForm("ssnChangeForm");
				createInput("ssnChangeForm","rurl");
				$("#rurl").val($(this).attr("rurl"));
				var j = ajaxCall("/ChangeSession.do",$("#ssnChangeForm").serialize(),false);
				redirect("/", "_top");
			});
		},
		error : function(jqXHR, ajaxSettings, thrownError) {

			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}


//회사변경 콤보 
function createCompanyAuthList(gCd){
	$.ajax({
		url 	: "getCompanyAuthList.do",
		type 	: "post", dataType : "json", async : true, data : "",
		success : function(rv) {
			var authList = rv.result;
			var enterCd		= "";
			var enterNm		= "";
			var toSabun		= "";
			var viewAuthStr	= "";
			//권한 조회 및 초기화
			$("#companyList").html("");
			for ( var i = 0; i < authList.length; i++) {
				enterCd		= authList[i].enterCd;
				enterNm		= authList[i].enterNm;
				toSabun		= authList[i].sabun;

				if( enterCd == gCd ) {
					viewAuthStr +="<li enterCd='"+ enterCd +"' toSabun='"+ toSabun +"' class='on'><span>"+ enterNm +"</span></li>";
				}else{
					viewAuthStr +="<li enterCd='"+ enterCd +"' toSabun='"+ toSabun +"' class='pointer'><span>"+ enterNm +"</span></li>";
				}
				
			}
			$("#companyList").append(viewAuthStr);

			// 권한 변경리스트 클릭  이벤트
			$("#companyList li").click(function() {
				if( $(this).hasClass("on") == true ) return;
				
				createForm("ssnChangeForm");
				createInput("ssnChangeForm","chgEnterCd");
				createInput("ssnChangeForm","chgSabun");
				createInput("ssnChangeForm","confirmPwd");
				$("#chgEnterCd").val($(this).attr("enterCd"));
				$("#chgSabun").val($(this).attr("toSabun"));
				$("#confirmPwd").val("");
				if(confirm("선택된 회사로 로그인 하시 겠습니까?")){
					submitCall($("#ssnChangeForm"), "_self", "POST", "/loginUser.do");
				
				}
				
			});
		},
		error : function(jqXHR, ajaxSettings, thrownError) {

			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}

/**
 * 회사 변경 관련
 * @param cCd
 * @param grpCd
 * @returns
 * 사용안함
function createCompanyAuth(cCd, grpCd) {
	$.ajax({
		url 	: "getCompanyAuthList.do",
		type 	: "post", dataType : "json", async : true, data : "",
		success : function(rv) {
			var authList = rv.result;
			var enterCd		= "";
			var enterNm		= "";
			var viewAuthStr	= "";
			var className	= "";
			//권한 조회 및 초기화
			$("#companyList").html("");
			for ( var i = 0; i < authList.length; i++) {
				enterCd = authList[i].enterCd;
				enterNm = authList[i].enterNm;
				if( enterCd == cCd ) { className = "on"; $("#companyMgr").html(enterNm)}
				else className = "";
				viewAuthStr +="<li ccd='"+enterCd+"' class="+className+" ><span>"+ enterNm +"</span></li>";
			}
			//console.log(viewAuthStr);
			$("#companyList").append(viewAuthStr);
			// 권한 변경리스트 클릭  이벤트
			$("#companyList li").click(function() {
				//<input type="hidden" id="RSAModulus" value="${RSAModulus}" />
			    //<input type="hidden" id="RSAExponent" value="${RSAExponent}" />

				if(!confirm("회사를 변경 하시겠습니까?")) return;
				createForm("companyChangeForm");
				createInput("companyChangeForm","confirmPwd");

				createInput("companyChangeForm","chgEnterCd");
				$("#chgEnterCd").val($(this).attr("ccd"));

				createInput("companyChangeForm","RSAModulus");
				createInput("companyChangeForm","RSAExponent");
				createInput("companyChangeForm","chgCombo");

				$("#confirmPwd").val("1231234");
				$("#chgCombo").val("Y");

				createInput("companyChangeForm","grpCd");
				$("#grpCd").val(grpCd);

				var ingmenu = "";
				var ingsys  = "";
				var _surl = "";

				// 열려있는 텝중 선택되어있는 텝의 surl을 가져온다.
				$.each($("#tabs").find("li"), function (idx) {
					var cnm = $(this).attr("class");
					if(cnm != null && cnm != undefined && cnm.indexOf("ui-tabs-active ui-state-active") > -1) {
						_surl = $(this).attr("surl");
					}
				});
				// url정보를 가져와 열려있는 텝의 url과 mainnenucd를 가져온다.
				var ingPageInfo = ajaxCall("/getDecryptUrl.do",$("#subForm").serialize(),false).map;
				ingsys = ingPageInfo.mainMenuCd;
				ingmenu = ingPageInfo.url;

				createInput("companyChangeForm","ingSysMenuId");
				createInput("companyChangeForm","ingPrgMenuId");
				$("#ingSysMenuId").val(ingsys);
				$("#ingPrgMenuId").val(ingmenu);

				submitCall($("#companyChangeForm"), "_self", "POST", "/loginUser.do");
				
				//$("#rurl").val($(this).attr("rurl"));
				//var j = ajaxCall("/ChangeSession.do",$("#ssnChangeForm").serialize(),false);
				//redirect("/", "_top");
				
			});
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}
*/


// layout Header / 홈으로/권한설정/로그아웃 버튼설정/ 샘플
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
/*
	// 권한 레이어 클릭시 이벤트 막기
	$("#levelWidgetMain1").click(function() {
		return false;
	});

	// 권한 설정 클릭 이벤트
	$("#authMgr").click(function(){
		$(document).click();
		$("#levelWidgetMain1").show();
		$(document).click(function() { $("#levelCancel").click(); });
		return false;
	});*/

	// 회사 선택 클릭 이벤트
	$("#companyMgr").click(function(){
		$(document).click();
		$("#companyWidgetMain").show();
		$(document).click(function() { $("#companyCancel").click(); });
		return false;
	});


	// 권한 설정 닫기 클릭 이벤트
	$("#levelCancel").click(function(){
		$(document).unbind("click");
		$("#levelWidgetMain1").hide();
		return false;
	});

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


