// 탭 설정
var tabs;
var full = false;
var ssnDataRwType = "";  //20140102 적용
var isLog = false; //콘솔 로그 출력 여부
var pageLocation;

// 초기 매뉴 오픈을 위한 최소 기준 갯수를 가져옴
// sub.jsp에서 정의한 menuOpenCnt 변수로 사용함에 따라 주석 처리.
//var openMenuCnt = ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=LEFT_MENU_OPEN_CNT", "queryId=getSystemStdData", false) ;

// 현재 탭 메뉴 정보
var menuInfo = new Array();

// 탭 설정
function setTab() {
	if(isLog) console.log("setTab()");
	tabs = $( "#mainMenuTabs" ).tabs();
	// 탭 메뉴 활성화시에 이벤트
	tabs.on( "tabsactivate", function( event, ui ) {
		var ssnErrorAccYn = $("#ssnErrorAccYn").val();
		var appString = "";

		//임시로 ssnErrorAccYn Y로 넣음
		ssnErrorAccYn = 'Y';
		if ( ssnErrorAccYn == "Y" ){
			$("#header .header_wrap h1").css("left", "-430px");
			pageLocation = ui.newTab.attr("location");
		}else{
			$("#header .header_wrap h1").css("left", "0px");
		}	
		// 탭 활성화시에 로케이션값을 설정한다.
		$("#surl").val(ui.newTab.attr("surl"));

		// 도움말 버튼 숨김 여부
		$("#helpPopup").hide();
		$("#devTabUrl").val("");
		if($("#surl").val() != ""){
			// 지정 메뉴의 도움말 정보 세팅
			// setMenuHelp();
			showHelpModalIcon();
		}

		// 선택된 탭으로 스크롤 이동. 탭이 생성되는 경우에서는 ui.newTab이 다 생성되기 전에 해당 function을 돌아 timeout을 줌.
		setTimeout(function() {
			const tabgroup = $('#mainMenuTabGroup');
			if (tabgroup && tabgroup.scrollTo && typeof tabgroup.scrollTo == 'function') {
				tabgroup.scrollTo(ui.newTab);
			}
		}, 300);

		reverseOpenContent(ui.newTab.attr("surl"), ui.newTab.attr("location"),ui.newTab.attr("murl"),ui.newTab.attr("menuid"));

		// ibsheet의 sheet merge 다시 적용. -> 탭을 여러번 이동하면서 헤더 merge 가 해제되는 케이스가 존재하여 추가함
		function resetSheetMerge($iframe) {
			var obj = $iframe.contents().find("div[name=IBSheet]");
			obj.each(function() {
				if(this.id != null && this.id.length > 4) {
					var sheetNm = this.id.substr(4);
					try {
						// iframe의 window 객체에서 직접 시트 객체 참조
						var iframeWindow = $iframe.get(0).defaultView || $iframe.get(0).contentWindow;
						var sheet = iframeWindow[sheetNm];

						if (sheet && sheet.Version) {
							sheet.SetMergeSheet(sheet.GetMergeSheet());
						}
					} catch (e) {
						console.log("Sheet 처리 중 오류:", sheetNm, e);
					}
				}
			})
		}

		var panelId = ui.newTab.attr("aria-controls");
		var str = "iframe_"+panelId;
		var $iframe = $('iframe[name='+ str + ']');

		if ($iframe && $iframe.length > 0) {
			// dom 생성 이후에 실행되도록 지연 처리
			setTimeout(function() {
				resetSheetMerge($iframe);

				var $nestedIframe = $iframe.contents().find('.ui-tabs .ui-tabs-panel:visible').find('iframe');
				if ($nestedIframe.length > 0) {
					var $iframe_tab = $nestedIframe.contents();
					if ($iframe_tab && $iframe_tab.length > 0) {
						setTimeout(function() {
							resetSheetMerge($iframe_tab);
						}, 300);
					}
				}
			}, 300);
		}

		// 메인메뉴 위젯 새로고침
		if(ui.newTab.attr("onedepth") && $iframe && $iframe.length > 0) {
			const $vueIframe = $iframe.contents().find("iframe[name='mainMenuWidget']");

			if ($vueIframe.length > 0) {
				const src = $vueIframe.attr('src');
				if (src) {
					$vueIframe.attr('src', ''); // src를 비워서 초기화
					setTimeout(() => {
						$vueIframe.attr('src', src) // 원래 src로 다시 설정
					}, 50); // 짧은 지연 시간 후 다시 설정
				}
			}
		}
	});

	// 탭 닫기 버튼 클릭 이벤트
	tabs.delegate( "a.tab_close", "click", function(event) {
		event.stopPropagation();
		// 탭이 1개일경우 탭이 닫히지 않는다.
		if( tabs.find( "ul.tab_group li" ).length < 2 ) return;

		/**
		추가된 소스 부분
		panelId를 가져오고 해당탭의 ibsheet div를 찾아 상태값이 I|U|D(추가,수정,삭제)인것을 찾는다.
		( sheet div에 ibsheet name 을 주기 위해 ibsheetinfo.js 값을 조금 변경했다.
		25번 라인에  name='IBSheet' 부분이 추가됨(ibsheetinfo.js)
		있으면 confirm 메시지를 띄우고 확인을 누르면 탭 닫기, 취소를 누르면 탭닫기 취소가 된다.
		*/
		var panelId = $( this ).closest( "li" ).attr( "aria-controls" );
		var str = "iframe_"+panelId;
		var obj = $('iframe[name='+ str + ']').contents().find("div[name=IBSheet]");
		for(var i=0, max=obj.length;max > i;i++){
			if(obj[i].id != null && obj[i].id.length > 4){
				var sheetNm = obj[i].id.substr(4);
				var objSheet = document.getElementsByName(str)[0].contentWindow.eval(sheetNm);
				var retData = objSheet.FindStatusRow("I|U|D");
				if(retData != ""){
					if(!(confirm("저장하지 않은 내용이 있습니다."))){
						return;
					}
				}
			}
		}

		//if(!tabcolse) return;
		// 탭을 제거한다.
		tabRemove($( this ).closest( "li" ));

		// 탭을 재정렬한다.F
		tabs.tabs( "refresh" );

		// 화면 높이값 재설정
		setIframeHeight();
	});
}

function showHelpModalIcon() {
	$(".helpModal").hide();
	const helpData = ajaxCall("/HelpPopup.do?cmd=getHelpPopupMap", $("#subForm").serialize(), false).map;

	if (helpData !== null && helpData !== "") {
		if (dataRwType === "A" ) {
			if (helpData !== null && helpData.mgrHelpYn === "Y") {
				$(".helpModal").show();
			}
		} else {
			if (helpData !== null && helpData.empHelpYn === "Y") {
				$(".helpModal").show();
			}
		}
	}
}

// 상단 메뉴 이벤트 설정
function setTopButton() {
	if(isLog) console.log("setTopButton()");
	// 쿠키에 화면 전체사이즈 값이 없을 경우 false 설정
	if( getCookie("setFullSize") == null ) setCookie("setFullSize","true",1000);

	// 쿠키에 탭 자동닫기 값이 없을 경우 true 설정
	if( getCookie("setTabAutoClose") == null ) setCookie("setTabAutoClose","true",1000);

	// 화면 전체사이즈 값을 쿠키에서 가져온다.
	setFullSize = getCookie("setFullSize");

	// 탭 자동닫기 값을 쿠키에서 가져온다.
	setTabAutoClose = getCookie("setTabAutoClose");

	// 탭 자동닫기 아이콘을 설정한다.
	/*if( setTabAutoClose == "true" ) {
		$("#btnTabSett").removeClass("btn_tab_sett");
		$("#btnTabSett").addClass("btn_tab_sett_on");
	}
	else {
		$("#btnTabSett").removeClass("btn_tab_sett_on");
		$("#btnTabSett").addClass("btn_tab_sett");
	}*/

	$("#tabWidgetMain").click(function() {
		return false;
	});

	// 탭 상단설정 아이콘을 클릭시에 위젯을 보여준다.
	$("#btnTabSett").click(function() {
/*		$(document).click();
		$("#setTabAutoCloseCheck").attr("checked", getCookie("setTabAutoClose")=="true"?true:false);
		$("#tabWidgetMain").show();
		$(document).click(function() { $("#tabCancel").click();return false; });
		return false;*/
		
		var isShown = false;
		if($("#tabWidgetMain").is(":visible"))
			isShown = true;
		$(document).click();
		$("#setTabAutoCloseCheck").attr("checked", getCookie("setTabAutoClose")=="true"?true:false);
		$(document).unbind("click");
		if(isShown) {
			$("#tabWidgetMain").hide();
		} else {
			$("#tabWidgetMain").show();
		}
		$(document).click(function(e) {
			$("#tabWidgetMain").hide();
		});
		return false;
		
	});

	$("#setTabAutoCloseCheck").click(function(e) {
		e.stopImmediatePropagation();
		e.stopPropagation();
		return true;
	});

	$("#tabWidgetMain .content li").click(function() {
		var check = true;
		if( $("#setTabAutoCloseCheck").attr("checked") == "checked" ) check = false;
		$("#setTabAutoCloseCheck").attr("checked",check );
		return false;
	});

	// 탭 상단설정 위젯에서 확인 클릭시 이벤트
	$("#tabOk").click(function() {
		// 쿠키에 선택된 값을 저장한다.
		setCookie("setTabAutoClose",$("#setTabAutoCloseCheck").is(':checked')?'true':'false',1000);
		setTabAutoClose = getCookie("setTabAutoClose");

		// 선택된 값에 따라서 아이콘을 설정한다.
		//if( setTabAutoClose == "true" ) $(".topTab").addClass("active");
		//else $(".topTab").removeClass("active");

		// 탭 상단설정 위젯을 숨긴다.
		$("#tabCancel").click();
	});

	// 탭 상단설정 위젯에서 취소 클릭시 이벤트
	$("#tabCancel").click(function() {
		$("#tabWidgetMain").hide();
		$(document).unbind("click");
	});

	// 유틸메뉴의 좌측메뉴 토클 아이콘 클릭 이벤트
	$("#btnLayoutSett01").click(function() {
		// 좌측 메뉴를 보여짐/숨김처리를 한다.
		//$(".layout_content").hasClass("menu_close")?$("#left_open").click():$("#left_close").click();
		if($("#subMenu").is(":visible")) {
			$("#subMenu").hide("slide", null, 200, function() {
				$(".sub_content").addClass("no_sub_menu");
				subResize();
			});
			$(this).addClass("btn_layout_sett01_on");

			if($("#btnLayoutSett02").hasClass("btn_layout_sett02_on") && !$("#btnLayoutSett03").hasClass("btn_layout_sett03_on")) {
				$("#btnLayoutSett03").addClass("btn_layout_sett03_on");
			}
			$("#gapLink").removeClass("gapbarhide").addClass("gapbarshow"); //2020.02.05
		} else {
			$("#subMenu").show("slide", null, 200, function() {
				$(".sub_content").removeClass("no_sub_menu");
				subResize();
			});
			$(this).removeClass("btn_layout_sett01_on");
			$("#btnLayoutSett03").removeClass("btn_layout_sett03_on");
			$("#gapLink").removeClass("gapbarshow").addClass("gapbarhide"); //2020.02.05
		}
	});

	// 유틸메뉴의 탑메뉴 토클 아이콘 클릭 이벤트
	$("#btnLayoutSett02").click(function() {
		if($("#header").is(":visible")) {
			$("#header").slideUp();
			$("#container").addClass("no_header");
			subResize();
			/*$("#header").hide("blind", null, 200, function() {
				$("#container").addClass("no_header");
				subResize();
			});*/
			$(this).addClass("btn_layout_sett02_on");

			if($("#btnLayoutSett01").hasClass("btn_layout_sett01_on") && !$("#btnLayoutSett03").hasClass("btn_layout_sett03_on")) {
				$("#btnLayoutSett03").addClass("btn_layout_sett03_on");
			}
			
			// [2021.06.22] ibsheet 마지막 라인의 마지막 컬럼에서 엔터 혹은 탭 키 입력 시 iframe이 화면 위로 밀려올려가는 현상으로 sub_wrap 영역에 position:fixed 속성 부여됨에 top 값 변경
			$(".sub_wrap").css("top", "0px");
			
			// 도움말 버튼 위치 변경
			$("#btnHelpBox").css("top", "8px");
		} else {
			$("#header").slideDown();
			$("#container").removeClass("no_header");
			subResize();
/*			$("#header").show("blind", null, 200, function() {
				$("#container").removeClass("no_header");
				subResize();
			});*/
			$(this).removeClass("btn_layout_sett02_on");
			
			// [2021.06.22] ibsheet 마지막 라인의 마지막 컬럼에서 엔터 혹은 탭 키 입력 시 iframe이 화면 위로 밀려올려가는 현상으로 sub_wrap 영역에 position:fixed 속성 부여됨에 top 값 변경
			$(".sub_wrap").css("top", "50px");
			$("#btnLayoutSett03").removeClass("btn_layout_sett03_on");
			
			// 도움말 버튼 위치 변경
			$("#btnHelpBox").css("top", "58px");
		}
	});

	// 유틸메뉴의 좌탑아이콘 클릭 이벤트
	$("#btnLayoutSett03").click(function() {
		if($(this).hasClass("btn_layout_sett03_on")) {
			if(!$("#header").is(":visible")) {
/*				$("#header").show("blind", null, 200, function() {
					$("#container").removeClass("no_header");
					subResize();
				});*/
				
				$("#header").slideDown();
				$("#container").removeClass("no_header");
				subResize();
			}

			if(!$("#subMenu").is(":visible")) {
				$("#subMenu").show("slide", null, 200, function() {
					$(".sub_content").removeClass("no_sub_menu");
					subResize();
				});
				$("#gapLink").removeClass("gapbarshow").addClass("gapbarhide");//2020.02.05
			}

			$(this).removeClass("btn_layout_sett03_on");
			// 좌우 또는 상하 확대 버튼도 클릭 된 상태로 변경.
			$("#btnLayoutSett02").removeClass("btn_layout_sett02_on");
			$("#btnLayoutSett01").removeClass("btn_layout_sett01_on");
			
			// [2021.06.22] ibsheet 마지막 라인의 마지막 컬럼에서 엔터 혹은 탭 키 입력 시 iframe이 화면 위로 밀려올려가는 현상으로 sub_wrap 영역에 position:fixed 속성 부여됨에 top 값 변경
			$(".sub_wrap").css("top", "50px");

			setFullSize = "false";
			
			// 도움말 버튼 위치 변경
			$("#btnHelpBox").css("top", "58px");
		} else {
			if($("#header").is(":visible")) {
/*				$("#header").hide("blind", null, 200, function() {
					$("#container").addClass("no_header");
					subResize();
				});*/
				$("#header").slideUp();
				$("#container").addClass("no_header");
				subResize();
			}

			if($("#subMenu").is(":visible")) {
				$("#subMenu").hide("slide", null, 200, function() {
					$(".sub_content").addClass("no_sub_menu");
					subResize();
				});
				$("#gapLink").removeClass("gapbarhide").addClass("gapbarshow");//2020.02.05
			}

			$(this).addClass("btn_layout_sett03_on");
			if(!$("#btnLayoutSett02").hasClass("btn_layout_sett02_on")) {
				$("#btnLayoutSett02").addClass("btn_layout_sett02_on");
			}
			if(!$("#btnLayoutSett01").hasClass("btn_layout_sett01_on")) {
				$("#btnLayoutSett01").addClass("btn_layout_sett01_on");
			}
			
			// [2021.06.22] ibsheet 마지막 라인의 마지막 컬럼에서 엔터 혹은 탭 키 입력 시 iframe이 화면 위로 밀려올려가는 현상으로 sub_wrap 영역에 position:fixed 속성 부여됨에 top 값 변경
			$(".sub_wrap").css("top", "0px");
			
			setFullSize = "true";
			
			// 도움말 버튼 위치 변경
			$("#btnHelpBox").css("top", "8px");
		}

	});

	// 나의 메뉴 추가 버튼 클릭 이벤트
	/*$("#addMyMenu").click(function() {
		if($("#addMyMenu").html() == " 나의메뉴  ") {
			return;
		}

		//등록
		if($("#addMyMenu").hasClass("btn_mymenu_minus")) {
			var myMenuResult = ajaxCall("/getMymenu.do?status=D",$("#subForm").serialize(),false).result;
			alert(myMenuResult. Message);
			if(myMenuResult.Code != -1) {
				$("#addMyMenu").addClass("btn_mymenu").removeClass("btn_mymenu_minus").html(" 나의메뉴 추가 ");
			}
		} else {
			var myMenuResult = ajaxCall("/getMymenu.do?status=I",$("#subForm").serialize(),false).result;
			alert(myMenuResult. Message);
			if(myMenuResult.Code != -1) {
				$("#addMyMenu").html(" 나의메뉴 제거 ").addClass("btn_mymenu_minus").removeClass("btn_mymenu");
			}
		}
	});*/

	// 도움말 버튼 클릭 이벤트
	$("#helpPopup").click(function() {
		openHelpPopup($("#surl").val());
	});

	// 탭 좌측 이동 버튼 클릭 이벤트
	$("#btnTabPrev").click(function(e) {
		var scr = $("#mainMenuTabGroup").scrollLeft();
		if(!$("#mainMenuTabGroup").is(":animated")) {
			$("#mainMenuTabGroup").animate({
				scrollLeft: (scr - 150)
			}, 200);
		}
	});

	// 탭 우측 이동 버튼 클릭 이벤트
	$("#btnTabNext").click(function(e) {
		var scr = $("#mainMenuTabGroup").scrollLeft();
		if(!$("#mainMenuTabGroup").is(":animated")) {
			$("#mainMenuTabGroup").animate({
				scrollLeft: (scr + 150)
			}, 200);
		}
	});
}

function openHelpPopup(surl) {
	if(isLog) console.log("openHelpPopup()");
	if(!isPopup()) {return;}

	var args = new Array();
	args["surl"]	= surl;
	openPopup("/HelpPopup.do?cmd=viewHelpPopup", args, "940","680");
}

// 탭의 기본 속성
var tabTitle = $( "#tab_title" ),
tabContent = $( "#tab_content" ),
//tabTemplate = "<li location='#[location]' onedepth='#[onedepth]' mainMenuCd='#[mainMenuCd]' priorMenuCd='#[priorMenuCd]' menuCd='#[menuCd]' menuSeq='#[menuSeq]'><a href='#[href]'>#[label] <span class='btn_close'>&nbsp;</span></a></li>",
//tabTemplate = "<li location='#[location]' menuId='#[menuId]' onedepth='#[onedepth]' surl='#[surl]' fixed='N'><a href='#[href]'>#[label]</a><a class='tab_close'></a></li>",
tabTemplate = "<li location='#[location]' onedepth='#[onedepth]' menuSeq='#[menuSeq]' surl='#[surl]' murl='#[murl]' menuid='#[menuid]' fixed='N'><a href='#[href]'>#[label]</a><a class='tab_close'><i class='mdi-ico'>close</i></a></li>",
//tabTemplate = "<li location='#[location]' onedepth='#[onedepth]' menuSeq='#[menuSeq]' surl='#[surl]' fixed='N'><span class='icon_help fas fa-question-circle'/><a href='#[href]'>#[label]</a><a class='tab_close'></a></li>",
tabCounter = 0;


// 탭 생성
//function openContent(title,url,location,dataRwType,cnt,dataPrgType,mainMenuCd,priorMenuCd,menuCd,menuSeq,prgCd,srchSeq,popupUseYn,helpUseYn,myMenu,workflowYn) {
//프로세스 맵 추가 2023.10.16 송은선
function openContent(title, url, location, surl, murl, menuId, procMapLinkBarInfo) {
	if(isLog) console.log("openContent()-->"+title+","+url);
	//$("#surl").val(surl);
	$("#subForm").find("#surl").val(surl);
	var data = ajaxCall("/getDecryptUrl.do",$("#subForm").serialize(),false).map;

	if( data.type == "L" ){ //링크추가 2020.11.16
		window.open(data.url, "_blank", "");
		return;
	}

	data.title=title;
	//data.url=url;
	if (typeof data.url =="undefined") data.url=url;
	data.location=location;
	data.surl=surl;
	data.murl=murl;
	data.menuid=menuId;
	data.procMapLinkBarInfo = procMapLinkBarInfo;

	/*
	 * 초기 화면 TAB 지우는 로직 제거
	tabs.find("ul.tab_group li").each(function() {
		if( $(this).attr("onedepth") == "true" ) {
			tabRemove($( this ));
		}
	});
	*/

	var duplication = -1;
	// 동일한 iframe 여부 확인
	tabs.tabs( "refresh" ); // 탭 순서가 변경되었을 가능성이 있으므로, 탭 갱신 후 작업한다.
	tabs.find("ul.tab_group li").each(function() {
		//if( $(this).attr("menuSeq") == data.menuSeq ) {
		if( $(this).attr("location") == location ) {     //게시판은 모두 같은 탭으로 인식하는 오류 수정 2020.05.28
			duplication = $(this).index();
			data.duplication=duplication;
		}
	});

	if( duplication > -1) {
		if( confirm(getMsgLanguage({"msgid": "msg.confirmChkTab", "defaultMsg":"이미 해당탭이 존재합니다.\n새로고침하시겠습니까?"}))) {
			let tabName = window.frames[duplication].name;
			const matchTabName = tabName.match(/_(.*)/);
			data.tabId = matchTabName[1];
			tabRefresh(data);
		}
		else {
			//tabRefresh(data);
			// 선택된 탭을 활성화 시킴 2020.05.28  jylee
			tabs.tabs( "option", "active", duplication);
		}
		return;
	}
	var ssnTabsLimitCnt = $("#ssnTabsLimitCnt").val() == "" ? "10" : $("#ssnTabsLimitCnt").val();
	if( tabs.find("div ul.tab_group li").length > parseInt(ssnTabsLimitCnt,10)-1 ) {
		if(tabs.find("ul.tab_group li[fixed='Y']").length > parseInt(ssnTabsLimitCnt,10)-1 ) {
			alert(getMsgLanguage({"msgid": "msg.201706290000003", "defaultMsg":"고정된 창(TAB)이 {0}개 입니다.\n불필요한 탭을 종료하여 주십시오.", "arg": ssnTabsLimitCnt}));
			return;
		}
		// if( url.indexOf(".html") > -1 ) return;
		if( setTabAutoClose == "true" ) {
			tabRemove(tabs.find( "ul.tab_group li[fixed='N']:eq(0)" ));
			tabCreate(data);
		} else {
			if( confirm(getMsgLanguage({"msgid": "msg.201706290000005", "defaultMsg":"동시에 열수 있는 창(TAB)은 {1}개 입니다.\n{0}탭을 종료합니다.\n계속하시겠습니까?", "arg":"["+tabs.find( "ul.tab_group li[fixed='N']:eq(0)" ).text()+"],"+ ssnTabsLimitCnt})) ) {
				tabRemove(tabs.find( "ul.tab_group li[fixed='N']:eq(0)" ));
				tabCreate(data);
			}
		}
		return;
	}

	tabCreate(data);
}


/**상단 탭 눌렀을 시 좌측 탭 해당 탭메뉴로 변경 */
function reverseOpenContent(surl, location, murl, menuid){
	// 오픈된 모듈과 동일 모듈의 프로그램인 경우 탭 이동 필요 없음.
	let isSameSub = $("#subForm").find("#murl").val() == murl ? true : false;
	if(!isSameSub) {
		$('#majorMenu').find("li").removeClass("on");
		$("#subMenuUl>li").hide();
	}

	// 좌측 메인메뉴
	$("#majorMenu>li").each(function(){
		if($(this).attr("murl") == murl){
			$(this).addClass("on");
			// 상단탭 클릭해서 좌측탭 변경 후에 좌측탭에서 새로운 subMenu 클릭해서 tabCreate할 때 murl이 일치하지 않는 것 수정
			$("#subForm").find("#murl").val($("#majorMenu").find("li.on").attr("murl"));

			if(!isSameSub) {
				createSubMenu();
				$(".sub_menu_body").scrollTop(0);
			}

			// 선택한 탭메뉴 좌측 메뉴바에 활성화 표시
			let a = $("#subMenuUl [menuid="+menuid+"]");
			if ($(a).attr('url') && $(a).attr('url') != 'null') {
				$(".sub_menu .sub_menu_body dt > a").removeClass("open");
				$(".sub_menu .sub_menu_body dd > a").removeClass("open");
				$(a).addClass("open");
			}

			let dl = a.parent().parent();
			if(dl.children().length > 1) {
				dl.children().show();
				dl.addClass('open');
			}

			let li = a.parent().parent().parent();
			li.children().show();
			li.addClass('on open');
		}
	})
}
// 탭 리프레쉬
function tabRefresh(a) {
	if(isLog) console.log("tabRefresh()-->"+a.url);

	// 선택된 탭을 활성화 시킴
	tabs.tabs( "option", "active", a.duplication);

	if (a.tabId == undefined) {
		a.tabId = "mainMenuTabs-" + a.duplication;
	}
	// 선택된 탭을 리로드 시킴
	if(a.url) {
		// 메뉴별 권한 셋팅
		var authPg = "R";
		if(a.dataPrgType=='') authPg='R';
		if( a.dataPrgType == 'U' ) authPg= ssnDataRwType ;
		else authPg = a.dataRwType;

		$("#surl").val(a.surl);
		//프로세스 맵 추가 2023.10.16 송은선
		submitCall($("#subForm"), "iframe_" + a.tabId,"post",a.url,null,a.procMapLinkBarInfo);

		if(a.menuCd != ""){
			// 지정 메뉴의 도움말 정보 세팅
			setMenuHelp();
		}
	} 
	//main menu one depth refresh 기능 추가
	else if (a.surl) {
		$("#surl").val(a.surl);
		$("#murl").val(a.surl);

		submitCall($("#subForm"), "iframe_" + a.tabId, "post", '/getSubMenuContents.do', null, a.procMapLinkBarInfo);
	}
}

// 아이디로 탭 제거
function tabRemove(obj) {
	if(isLog) console.log("tabRemove()-->");
	var panelId = $(obj).attr( "aria-controls" );

	//contextmenu 삭제
	$.contextMenu( 'destroy', "a[href='#"+panelId+"']" );

	//tab 삭제
	$(obj).remove();
	$( "#" + panelId ).remove();

	var totWidth = 0;

	tabs.find("li").each(function() {
//		totWidth = totWidth + $(this).width();
		totWidth += $(this).outerWidth(true) + 2; // 231017 김기용: 마진 포함 width로 수정
	});
	//console.log('tabRemove totWidth', totWidth);

	$("ul.tab_group").css("width", totWidth);
	
	// 231017 김기용: 탭 스크롤 버튼 보임 처리
	if($('#mainMenuTabs').width() < totWidth){
		$('.sub_top .btn_sub_tab').css('display', 'flex');
	} else {
		$('.sub_top .btn_sub_tab').css('display', 'none');
	}

}

// 새로운 탭을 생성
function tabCreate(b) {
	if(isLog) console.log("tabCreate()-->");

	var onedepth = "";
	//if( b.url.indexOf(".html") > -1 ) onedepth = "true";
	if( b.url.indexOf("getSubMenuContents.do") > -1 ) onedepth = "true";

	// 대분류 메뉴를 빠르게 더블클릭 시 새창을 띄워버리는 오류 수정.
	// common.js의 submitCall function에서 '202006 Chrome 최신버전업데이트 오류발생으로 timeout추가' 때문에 발생.
	// target의 id가 아래처럼 tabCounter변수에 의해 지속적으로 바뀌기 때문에 해당 target을 찾지 못하여 새창에서 띄워버림.
	// 따라서 대분류일 경우에는 id를 아래와 같이 고정하여 target을 잡도록 변경.
	var label = b.title,location = b.location, menuSeq = b.menuSeq;
	var id = "mainMenuTabs-" + tabCounter;
	
	/*
	 * 첫 기본DEPTH 를 무조건 동일한 '00' SEQ로 생성하는 부분을 수정
	if (onedepth == "true") {
		id = "mainMenuTabs-00";
	}
	*/
	var li = $( tabTemplate.replace( /#\[href\]/g, "#" + id ).
			replace( /#\[label\]/g, label ).
			replace( /#\[location\]/g, location ).
			replace( /#\[onedepth\]/g, onedepth ).
			replace( /#\[menuSeq\]/g, menuSeq ).
			replace( /#\[murl\]/g, b.murl ).
			replace( /#\[menuid\]/g, b.menuid ).
			replace( /#\[surl\]/g, b.surl )),
	tabContentHtml = tabContent.val() || "Tab " + tabCounter + " content.";
	

	$("#surl").val(b.surl);

	//탭컨텍스트 메뉴 생성.
	setTabContextMenu(id);

	tabs.find( ".ui-tabs-nav" ).append( li );
	
	// [2022.12.15] 도움말 아이콘 삽입 처리
	/*if( menuSeq == undefined || menuSeq == null || b.helpUseYn != "1" ) {
		li.find(".icon_help").hide();
	} else {
		if( b.surl && b.surl != null && b.surl != "" ) {
			li.find(".icon_help").next().addClass("padl5");
			li.find(".icon_help").attr("title", "도움말").on("click", function(e) {
				e.stopPropagation();
				openHelpPopup($($(this).parent()).attr("surl"));
			});
		}
	}*/
	// END [2022.12.15] 도움말 아이콘 삽입 처리
	
	// 탭의 상위 태그에 컨텐츠 추가
	tabs.append("<div id='" + id + "' class='contents'><iframe name='iframe_" + id + "' frameborder='0' class='tab_iframes'></iframe></div>");
	tabs.tabs( "refresh" );
	tabs.tabs( "option", "active", tabs.find( "ul.tab_group>li" ).length-1 );

	// tab group의 길이 세팅.
	var totWidth = 0;

	tabs.find("ul.tab_group li").each(function(idx, obj) {
		totWidth += $(this).outerWidth(true) + 2; // 230926 김기용 : 마진 포함 width로 수정
		//totWidth += $(this).width() + 2;
	});
	//totWidth = totWidth + 20;
	$("ul.tab_group").css("width", totWidth);
	
	// 231017 김기용: 탭 스크롤 버튼 보임 처리
	if($('#mainMenuTabs').width() < totWidth){
		$('.sub_top .btn_sub_tab').css('display', 'flex');
	} else {
		$('.sub_top .btn_sub_tab').css('display', 'none');
	}

	initLeftScroll();
	tabCounter++;

	// 탭 생성시에 메뉴권한 및 페이지 값을 post로 iframe 내부로 보낸다.
	if(b.url.indexOf(".html") < 0) {
		var authPg = "R";
		if(b.dataPrgType=='') authPg='R';
		//if( dataPrgType == 'U' ) authPg="A";
		if( b.dataPrgType == 'U' ) authPg= ssnDataRwType ;
		else authPg = b.dataRwType;
	}
	
	//프로세스 맵 추가 2023.10.16 송은선
	submitCall($("#subForm"),"iframe_"+id,"post",b.url,null,b.procMapLinkBarInfo);
	setIframeHeight();
	callsortAbleTab();
}

//Low Menu생성
function makeLowMenu(lowMenu) {
	if(isLog) console.log("makeLowMenu()-->");
	if( menuOpenCnt != null && menuOpenCnt != undefined && menuOpenCnt != "null" && parseInt( menuOpenCnt ) >= lowMenu.length ) {
		setAllMenuMode();
	}
}

// 탭 높이 변경
function setIframeHeight() {
	if(isLog) console.log("setIframeHeight()-->");
	
	//.sub_wrap의 크기를 전체 
	var subWrapH = $('#container').outerHeight(true) - $('#header').height();
	$('.sub_wrap').css('height', subWrapH);
	
	var conHeight = $(".sub_wrap").outerHeight(true) - $("#mainMenuTabGroup").height();
	// iframe의 폭은 좌측 메인메뉴의 폭, 좌측 서브메뉴의 폭 또는 좌측 나의메뉴의 폭, 그리고 해당 iframe의 padding 값을 뺀 값이 됨.
	//var conWidth = $(".sub_wrap").outerWidth(true) - $("#majorTop").outerWidth(true) - ($("#subMenu").is(":visible") ? $("#subMenu").outerWidth(true) : 0) /*- ($("#myMenu").is(":visible") ? $("#myMenu").outerWidth(true) : 0)*/ - 30;
	var conWidth = $(".sub_wrap").outerWidth(true) - $("#majorTop").outerWidth(true) - ($(".sub_content").hasClass("no_sub_menu") ? 0 : $("#subMenu").outerWidth(true)) /*- ($("#myMenu").is(":visible") ? $("#myMenu").outerWidth(true) : 0)*/ - 10;
	
	$(".contents").each(function() {
		//$(this).css("top",iframeTop);
		$(this).find("iframe").css("height", conHeight);
		$(this).find("iframe").css("width", conWidth);
	});
}

// 브라우저 높이 변경 시 탭 높이 수정 23.10.31 snow2
window.addEventListener("resize", setIframeHeight);

// 좌측 유틸메뉴 이벤트 설정
function setLeftMenu() {
	if(isLog) console.log("setLeftMenu()-->");

	$("#viewAll").unbind("click");
	$("#view1Lvl").unbind("click");
	$("#view2Lvl").unbind("click");
	$("#view3Lvl").unbind("click");
	
	$("#viewAll").click(function() {
		if( $("#subMenu").css('display') == "none" ) return;

		$(this).toggleClass("btn_lnb_close");
		$(this).hasClass("btn_lnb_close")?$("#view3Lvl").click():$("#view1Lvl").click();
	});

	// 좌측 유틸메뉴의 - 클릭 이벤트
	$("#view1Lvl").click(function() {
		if( $("#subMenu").css('display') == "none" ) return;

		$("#subMenuCont li a").removeClass("menu2_on");

		$("#subMenuCont li dl").each(function(idx, obj) {
			$(obj).hide();
			$(obj).find("dd").each(function(idxDd, objDd) {
				$(objDd).hide();
				if($(objDd).parent().find("a").hasClass("minus")) {
					$(objDd).parent().find("a").removeClass("minus").addClass("plus");
				}
			});
		});
		
		if ($("#viewAll").hasClass("btn_lnb_close")) { $("#viewAll").removeClass("btn_lnb_close"); }

		// 좌측 메뉴 스크롤을 재설정한다.
		initLeftScroll();
	});

	// 좌측 유틸메뉴의 = 클릭 이벤트
	$("#view2Lvl").click(function() {
		if( $("#subMenu").css('display') == "none" ) return;

		$("#subMenuCont li a").addClass("menu2_on");

		$("#subMenuCont li dl").each(function(idx, obj) {
			$(obj).show();
			$(obj).find("dt").each(function(idxDt, objDt) {
				$(objDt).show();
				if($(objDt).find("a").hasClass("minus")) {
					$(objDt).find("a").removeClass("minus").addClass("plus");
				}
				$(objDt).find("dd").each(function(idxDd, objDd) {
					$(objDd).hide();
				});
			});
		});
		
		if (!$("#viewAll").hasClass("btn_lnb_close")) { $("#viewAll").addClass("btn_lnb_close"); }

		// 좌측 메뉴 스크롤을 재설정한다.
		initLeftScroll();
	});

	// 좌측 유틸메뉴의 Ξ 클릭 이벤트
	$("#view3Lvl").click(function() {
		if( $("#subMenu").css('display') == "none" ) return;

		$("#subMenuCont li a").addClass("menu2_on");

		$("#subMenuCont li dl").each(function(idx, obj) {
			$(obj).show();
			$(obj).find("dt").each(function(idx1, objDt) {
				$(objDt).show();
				if($(objDt).find("a").hasClass("plus")) {
					$(objDt).find("a").removeClass("plus").addClass("minus");
				}
				$(objDt).find("dd").each(function(idxDd, objDd) {
					$(objDd).show();
				});
			});
		});
		
		if (!$("#viewAll").hasClass("btn_lnb_close")) { $("#viewAll").addClass("btn_lnb_close"); }

		// 좌측 메뉴 스크롤을 재설정한다.
		initLeftScroll();
	});
}

//좌측 네비 이벤트 설정
function addLeftEvent() {
	if(isLog) console.log("addLeftEvent()-->");
	// 2뎁스 메뉴
	
	
	
	
	
}
function removeMenuOn() {
	if(isLog) console.log("removeMenuOn()-->");
	$("#subMenuCont li").find("a.menu3_on").removeClass("menu3_on");
	$("#subMenuCont li").find("a.menu4_on").removeClass("menu4_on");
}

// 좌측 네비 이벤트 제거
function removeLeftEvent() {
	if(isLog) console.log("removeLeftEvent()-->");
/*	$("#subMenuCont li").unbind("click");
	$("#subMenuCont li dl dt").unbind("click");
	$("#subMenuCont li dl dt dd").unbind("click");*/

}

// 화면 리사이즈 설정
function subResize() {
	if(isLog) console.log("subResize()-->");

	if( !full ) {
		if( $(window).width() >= 1240 ) $("#wrap").removeClass("min");
		else $("#wrap").addClass("min");

		/*$(".twodepth_group.scroll-pane").height(1);
		$(".twodepth_group.scroll-pane").height($(".layout_content").height() - 50);*/
	}

	/*var majorMenuHeight = $("#wrap").height() - 15;
	$("#lnb").find("#majorTop").css("height", majorMenuHeight);*/

	var tabsHeight = $("#mainMenuTabs").parent().height() - $("#header").height();
	$("#mainMenuTabs").css("height", tabsHeight);

	setIframeHeight();
	
//	var tabMaxWidth = $("#mainMenuTabs").width() - $("ul.btn_sub_tab").width() - $("div.top_btn_group").width(); // 231017 김기용: 우측 버튼들 없어졌으므로 사이즈 계산에서 삭제
//	var tabMaxWidth = $("#mainMenuTabs").width();
//	$("#tabGroup").css("width", tabMaxWidth+"px");
//	$("ul.tab_group").css("min-width", tabMaxWidth+"px");

	// 좌측 메뉴 스크롤을 재설정한다.
	initLeftScroll();
}


// 좌측 스크롤 재생성
function initLeftScroll() {
	//if(isLog) console.log("initLeftScroll()-->");
	/*
	var api = $(".scroll-pane").data('jsp');
	api.reinitialise();

	if($("#subMenu .jspContainer").outerHeight(true) > $("#subMenu .jspPane").outerHeight(true)) {
		$("#subMenu .jspPane").css("top", "0");
	}
	*/
}


function goPOPUP(url,name) {
	if(isLog) console.log("goPOPUP()-->");
	// scrollbars = yes	:: 스크롤바 사용 (미사용 no)
	// resizeable = yes :: 좌우스크롤바 사용 (미사용 no)
	// menubar = yes    :: 메뉴바 사용 (미사용 no)
	// toolbar = yes	:: 툴바사용 (미사용 no)
	// width = 100     	:: 팝업창의 가로사이즈
	// height = 100   	:: 팝업창의 세로사이즈
	// left = 10       	:: 좌측에서 10픽셀을 띄운다.
	// top = 10       	:: 상단에서 10픽셀을 띄운다.
	window.open(url,name,"location=0,scrollbars=1,resizable=1,menubar=0,toolbar=0,width=1300,height=900,left=0,top=0");
}

//Major Menu click
//s: param.menuSeq
//p: param.prgCd
function majorMenuAction(s, p){
	if(isLog) console.log("majorMenuAction()-->");

	// 메인 메뉴 클릭시
	$("#majorMenu1>li:not(#sampleMenu,#IBSheetMenu), #etcMenu>li:not(#liMyMenu)").click(function(){
		if(isLog) console.log("majorMenuAction()-->메인 메뉴 클릭시");

		// 혹시 서브메뉴 숨김 모드가 되어 있다면 해제해준다.
		$("div.sub_content").removeClass("no_sub_menu");

		if($("#btnLayoutSett01").hasClass("btn_layout_sett01_on")) {
			$("#btnLayoutSett01").removeClass("btn_layout_sett01_on");
		}

		// 좌측 메뉴 리스트를 보여준다
		$("#subMenu").show("blind");
		$("#gapLink").removeClass("gapbarshow").addClass("gapbarhide");//2020.02.05

		// 마이 메뉴 리스트를 숨겨준다.
		$("#myMenu").hide();
		
		//전체보기 아이콘을 초기화 한다.
		$("#viewAll").removeClass("btn_lnb_close");

		//Low Menu 조회 및 생성
		$("#majorMenu1, #etcMenu").find("li").removeClass("lnb_selected");
		$("#majorMenu1>li>a").removeClass("lnb_selected");
		$(this).addClass("lnb_selected");
		if($(this).attr("mainmenucd") != "20" &&
				$(this).attr("mainmenucd") != "21") {
			$(this).find("a").addClass("lnb_selected");
		} else {
			$("#etcSub").hide();
		}

		var mainMenuCd = $(this).attr("mainMenuCd") ;
		var menuSeq = $(this).attr("menuSeq") ;

		// 1뎁스 좌측 아이콘 설정
		$("#subMenuIcon").attr("class","");
		$("#subMenuIcon").addClass("lnb_title"+mainMenuCd);

		var menuTitle = $(this).text();
		alert(1);
		// 서브 메뉴 이벤트를 등록
		createLowMenu();

		$("#subMenu .jspPane").css("top", "0");
		
		// 좌측 메뉴 스크롤을 재설정한다.
		initLeftScroll();

		// mainMenuCd,priorMenuCd,menuCd,menuSeq,prgCd로 서브메뉴 열기
		var  prgCd = "";

		if( p != ""){
			prgCd = getDirectMenuMap(s,p);
		}
		if(prgCd != ""){
			eval(prgCd);
			s="";
			p="";
		}
		else{
			if(isLog) console.log("majorMenuAction()-->메인 메뉴 클릭시--> openContent() 호출 전 :"+menuTitle);
			openContent(
					menuTitle,
					"getSubMenuContents.do", //"/html/contents/base"+mainMenuCd+".html",
					"<span>"+menuTitle+"</span>",
					$("#murl").val()
					);
			
		}
	});

	// 나의메뉴 클릭시 이벤트
	$("#etcMenu>li#liMyMenu").click(function(){
		$("#etcSub").hide();
		if($("#myMenu").is(":visible")) {
		} else {
			// 나의 메뉴 가져오기
			myMenuList();

			$("#subMenu").hide();
			$("#myMenu").show();

			// 혹시 서브메뉴 숨김 모드가 되어 있다면 해제해준다.
			$("div.sub_content").removeClass("no_sub_menu");
		}

		initLeftScroll();
	});

	$("#majorMenu1>li").mouseover(function(event) {
		if( $(this).attr("mainmenucd") == "20" ||
				$(this).attr("mainmenucd") == "21" ) return;

		$(this).addClass("lnb_on");
		$(this).find("a").removeClass("lnb_off").addClass("lnb_on");
	});

	$("#majorMenu1>li").mouseout(function(event) {
		if( $(this).attr("mainmenucd") == "20" ||
				$(this).attr("mainmenucd") == "21" ) return;

		$(this).removeClass("lnb_on");
		$(this).find("a").removeClass("lnb_on").addClass("lnb_off");
	});

	// 레프트 메인메뉴 위로 버튼 이벤트
	$("#btnMenuUp").click(function(event) {
		var scr = $("#majorTop").scrollTop();
		var scrolled = scr - 95;
		if(!$("#majorTop").is(':animated')) {
			$("#majorTop").animate({
				scrollTop: scrolled
			});
		}
	});

	// 레프트 메인메뉴 아래로 버튼 이벤트
	$("#btnMenuDown").click(function(event) {
		var scr = $("#majorTop").scrollTop();
		var scrolled = scr + 95;
		if(!$("#majorTop").is(':animated')) {
			$("#majorTop").animate({
				scrollTop: scrolled
			});
		}
	});

	$("#majorTop, #mainMenuTabGroup").on("mousewheel DOMMouseScroll", function(event) {
		event.preventDefault();
		var E = event.originalEvent;
		var delta = 0;
		var agent = navigator.userAgent.toLowerCase(); 

		if (agent.indexOf("firefox") != -1) { 
			if(E.detail) {
				delta = E.detail;
			} else {
				delta = E.wheelDelta;
			}
			if(delta < 0) {
				if($(this).attr("id") == "majorTop") {
					$("#btnMenuUp").click();
				} else {
					$("#btnTabPrev").click();
				}
			} else {
				if($(this).attr("id") == "majorTop") {
					$("#btnMenuDown").click();
				} else {
					$("#btnTabNext").click();
				}
			}
		}else if (agent.indexOf("chrome") != -1) { 
			if(E.detail) {
				delta = E.detail;
			} else {
				delta = E.wheelDelta;
			}
			if(delta < 0) {
				if($(this).attr("id") == "majorTop") {
					$("#btnMenuDown").click();
				} else {
					$("#btnTabNext").click();
				}
			} else {
				if($(this).attr("id") == "majorTop") {
					$("#btnMenuUp").click();
				} else {
					$("#btnTabPrev").click();
				}
			}
		}else{
			if(E.deltaY) {
				delta = E.deltaY;
			} else {
				delta = E.wheelDelta;
			}
			if(delta < 0) {
				if($(this).attr("id") == "majorTop") {
					$("#btnMenuDown").click();
				} else {
					$("#btnTabNext").click();
				}
			} else {
				if($(this).attr("id") == "majorTop") {
					$("#btnMenuUp").click();
				} else {
					$("#btnTabPrev").click();
				}
			}
		}

		event.stopPropagation();
		event.stopImmediatePropagation();
	});

	// 더보기 버튼 클릭시 이벤트
	$("#btnLnbEtc").click(function(e) {
		var isShown = false;
		if($("#etcSub").is(":visible"))
			isShown = true;
		$(document).click();
		$(document).unbind("click");
		if(isShown) {
			$("#etcSub").hide();
		} else {
			$("#etcSub").show();
		}
		$(document).click(function(e) {
			$("#etcSub").hide();
		});
		return false;
	});
}


//바로가기 없이 메뉴만 펼침 2020.02.18
function majorMenuOpen(m){
	if(isLog) console.log("majorMenuOpen()-->");

	$("#majorMenu1 li, #etcMenu li").each(function(){      
		if( $(this).attr("mainMenuCd") == m ){
			// 혹시 서브메뉴 숨김 모드가 되어 있다면 해제해준다.
			$("div.sub_content").removeClass("no_sub_menu");
			
			if($("#btnLayoutSett01").hasClass("btn_layout_sett01_on")) {
				$("#btnLayoutSett01").removeClass("btn_layout_sett01_on");
			}

			// 좌측 메뉴 리스트를 보여준다
			$("#subMenu").show("blind");
			$("#gapLink").removeClass("gapbarshow").addClass("gapbarhide");//2020.02.05
			

			// 마이 메뉴 리스트를 숨겨준다.
			$("#myMenu").hide();

			//Low Menu 조회 및 생성
			$("#majorMenu1, #etcMenu").find("li").removeClass("lnb_selected");
			$("#majorMenu1>li>a").removeClass("lnb_selected");
			$(this).addClass("lnb_selected");
			$(this).find("a").addClass("lnb_selected");
//			if($(this).attr("mainmenucd") != "20" &&
//					$(this).attr("mainmenucd") != "21") {
//				$(this).find("a").addClass("lnb_selected");
//			} else {
//				$("#etcSub").hide();
//			}

			var mainMenuCd = $(this).attr("mainMenuCd") ;

			// 1뎁스 좌측 아이콘 설정
			$("#subMenuIcon").attr("class","");
			$("#subMenuIcon").addClass("lnb_title"+mainMenuCd);

			// 서브 메뉴 이벤트를 등록
			createLowMenu();

			$("#subMenu .jspPane").css("top", "0");

			// 좌측 메뉴 스크롤을 재설정한다.
			initLeftScroll();
		}
	});
}

// mainMenuCd 로 열기
function openMainMenuCd(m) {
	if(isLog) console.log("openMainMenuCd()-->");
	$("#majorMenu1 li, #etcMenu li").each(function(){
		if( $(this).attr("mainMenuCd") == m ){
			$(this).click();
		}
	});
}

function getDirectMenuMap(menuSeq,prgCd){
	if(isLog) console.log("getDirectMenuMap()-->");
	var str = "menuSeq="+menuSeq+"&prgCd="+encodeURIComponent(prgCd) ;
	var result = ajaxCall("/getDirectSubMenu.do",str,false).map;
	return result && result.jsParam ? (result.jsParam):''; //JS_PARAM

}

// mainMenuCd,priorMenuCd,menuCd,menuSeq,prgCd로 서브메뉴 열기
//function openSubMenuCd(mainMenuCd,priorMenuCd,menuCd,menuSeq,prgCd) {
function openSubMenuCd(surl, m) {
	if(isLog) console.log("openSubMenuCd()-->");
	// 2뎁스 이후부터 열리도록 수정
	$("#subMenuCont>li, #subMenuCont>li>dl>dt, #subMenuCont>li>dl>dt>dd").each(function() {
		
		if(

			$(this).attr("menuId") == m
			) {

			if($(this).is("li")) {
				$(this).find("dt").hide();
				$(this).find("dd").hide();
			} else if($(this).is("dt")) { 
				//메뉴펼침 오루 수정 2020.02.11 jylee
				$(this).parent().parent().show(); //li
				$(this).parent().show(); //dl
				$(this).find("dd").hide();
			} else if($(this).is("dd")) { 
				$(this).parent().parent().parent().show(); //li
				$(this).parent().parent().show(); //dl
				$(this).parent().click();
				//$(this).parent().show(); //dt
			}

			// 메뉴가 2뎁스 일때 하위메뉴 화면 열리지 않도록 수정
			/*if( $(this).parent().parent().attr("id") != "subMenu")
				$(this).addClass("on");

			$(this).addClass("linkon");
			$(this).parent().parent().addClass("on");
			$(this).parent().parent().parent().parent().addClass("on");*/
			$(this).click();

			// 좌측 메뉴 스크롤을 재설정한다.
			initLeftScroll();
			return;
		}
	});
}

// 마이메뉴 이벤트 제거
function removeMymenuEvent() {
	if(isLog) console.log("removeMymenuEvent()-->");
	$("#myMenuCont dt").each(function() {
		$(this).unbind("click");
	});
}

// 마이메뉴 이벤트 추가
function addMymenuEvent() {
	if(isLog) console.log("addMymenuEvent()-->");
	$("#myMenuCont dt").each(function() {
		// 리스트 클릭 이벤트
		$(this).click(function() {
			openContent(
					$(this).text()
					,$(this).attr("url")
					,$(this).attr("location")
					,$(this).attr("myMenu")
					);
		});

		// 닫기 클릭 이벤트
		$(this).find(".close").click(function() {
			$(this).unbind("click");
			$(this).parent().unbind("click");
			$(this).parent().remove();
			return false;
		});
	});
}

// form 생성
function createAuthForm() {
	if(isLog) console.log("createAuthForm()-->");
	$("<form></form>",{id:"subForm",name:"subForm",method:"post"}).appendTo('body');
	createInput("subForm","authPg");
	createInput("subForm","murl");
	createInput("subForm","surl");
}

// Major Menu 조회 및 생성
function createMajorMenu(){
	if(isLog) console.log("createMajorMenu()-->");
	// 대분류 메뉴 조회
	var majorMenu = ajaxCall("/getMainMajorMenuList.do", "",false).result;
	var mainMenuCd = "";
	var grpCd = "";
	var mainMenuNm = "";
	var viewMenuStr = "";
	var workflowMenuStr = "";
	var murl = "";

	//대분류 메뉴 초기화
	$("#majorMenu1").html("");
	$("#etcMenu").html("");
	for ( var i = 0; i < majorMenu.length; i++) {
		mainMenuCd 	= majorMenu[i].mainMenuCd;
		grpCd 		= majorMenu[i].grpCd;
		mainMenuNm 	= majorMenu[i].mainMenuNm;
		murl        = majorMenu[i].murl;


		if(mainMenuCd =="20" ){
			workflowMenuStr +="<li murl='"+murl+"' mainMenuCd='"+mainMenuCd+"' grpCd='"+grpCd+"'><a title='" + mainMenuNm + "' class='bbs'>"+ mainMenuNm +"</a></li>";
		}
		else if(mainMenuCd =="21" ){
			workflowMenuStr +="<li murl='"+murl+"' mainMenuCd='"+mainMenuCd+"' grpCd='"+grpCd+"'><a title='" + mainMenuNm + "' class='workflow'>"+ mainMenuNm +"</a></li>";
		}
		else{
			viewMenuStr +="<li murl='"+murl+"' mainMenuCd='"+mainMenuCd+"' grpCd='"+grpCd+"' class='pointer'><a class='lnb_off lnb_icon" + mainMenuCd + "' title='"+ mainMenuNm +"'>"+ mainMenuNm +"</a></li>";
		}
	}

	$("#majorMenu1").append(viewMenuStr);

	if ( workflowMenuStr == "" ){

		$(".lnb_bott_menu").hide();
		$("#etcMenu").append(workflowMenuStr);
	}else{
		$(".lnb_bott_menu").show();
		$("#etcMenu").append(workflowMenuStr);
	}
}

//Low Menu 조회 및 생성
function createLowMenu(){
	if(isLog) console.log("createLowMenu()");
	var mainMenuCd 	= $("#majorMenu1, #etcMenu").find("li.lnb_selected").attr("mainMenuCd");
	var grpCd 		= $("#majorMenu1, #etcMenu").find("li.lnb_selected").attr("grpCd");

	$("#murl").val( $("#majorMenu1, #etcMenu").find("li.lnb_selected").attr("murl") );
	$("#surl").val( $("#majorMenu1, #etcMenu").find("li.lnb_selected").attr("surl") );
	//var lowMenu = ajaxCall("/getSubLowMenuList.do", $("#subForm").serialize(),false).result;
	var lowMenu = "";

	if(isLog) console.log("createLowMenu()-->getSubLowMenuList.do");
	$.ajax({
        url: "/getSubLowMenuList.do",
        type: "post",
        dataType: "json",
        async: true,
        data: $("#subForm").serialize() + "&searchMenuSeq=" + getMenuSeq,
        success: function(data) {

        	if(isLog) console.log("createLowMenu()-->getSubLowMenuList.do success");
        	lowMenu 		= data.result;
        	
        	var viewMenuStr 	= "";
        	var lvl 			= "";
        	var priorMenuCd 	= "";
        	var type			= "";
        	var menuNm			= "";
        	var prgCd			= "";
        	var mainMenuNm		= "";
        	var surl			= "";
        	var menuId			= "";
        	var menuSeq			= "";
        	var subMenuOn		= "";
        	
        	var ulNm1 = "";
        	var ulNm2 = "";

        	var liId = "";

        	var tabInfo = "";
        	
        	var linkCss = ""; //메뉴타입이 링크일 때 Style 적용 2020.11.16

        	removeLeftEvent();
        	$("#subMenuCont").html("");
        	if(isLog) console.log("createLowMenu()-->getSubLowMenuList.do Loop Start");
        	for ( var i = 0; i < lowMenu.length; i++) {

        		lvl 		= lowMenu[i].lvl;
        		priorMenuCd = lowMenu[i].priorMenuCd;
        		menuCd 		= lowMenu[i].menuCd;
        		type	 	= lowMenu[i].type;
        		menuNm 		= lowMenu[i].menuNm;
        		prgCd 		= replaceAll(lowMenu[i].prgCd , "#", "?");
        		mainMenuNm 	= lowMenu[i].mainMenuNm;

        		surl        = lowMenu[i].surl;
        		menuId      = lowMenu[i].menuId;
        		menuSeq     = lowMenu[i].menuSeq;
        		subMenuOn   = lowMenu[i].subMenuOn;
        		
        		 //메뉴타입이 링크일 때 Style 적용 2020.11.16
        		if( lowMenu[i].type == "L" ){
        			linkCss = " style='color:blue; text-decoration:underline;' ";
        		}else{
        			linkCss = "";
        		}

        		// 메뉴생성시에 메뉴권한, 메뉴인덱스등 정보를 셋팅한다.
        		tabInfo = "' url='"+prgCd+"' ";
        		tabInfo = tabInfo  + " menuId='"+menuId+"' ";
        		tabInfo = tabInfo  + " menuSeq='"+menuSeq+"' subMenuOn='" + subMenuOn + "' ";

        		// 2뎁스일때 메뉴 생성
        		if (lvl == "1") {
        			var dp1Str = "";
        			liId = "sm2d_" + menuCd;
        			ulNm1 = mainMenuNm + " > " + menuNm;
        			if(type == "M") {
        				dp1Str += "<li id='" + liId + "' surl='" + surl + "' location='" + ulNm1 + tabInfo + " class='on'><a id='label_1dp'>" + menuNm + "</a></li>";
        			} else {
        				dp1Str += "<li id='" + liId + "' surl='" + surl + "' location='" + ulNm1 + tabInfo + " class='on'><a id='label_1dp' "+linkCss+">" + menuNm + "</a></li>";
        			}
        			$("#subMenuCont").append(dp1Str);
        		}

        		// 3뎁스일때 메뉴 생성
        		else if (lvl == "2") {
        			ulNm2 = ulNm1 + " > " + menuNm;
        			if($("#"+liId).length != 0) {
        				if($("#"+liId+"_dl").length == 0) {
        					var dlStr = "<dl id='" + liId + "_dl'></dl>";
        					$("#" + liId).append(dlStr);
        				}

        				var dtStr = "";
        				dtStr += "<dt id='sm3d_" + menuCd + "' surl='"+ surl +"' location='"+ ulNm2 + tabInfo + "><a class='";
        				if(type == "M") {
        					dtStr += "plus";
        				}
        				dtStr += " pointer' "+linkCss+">" + menuNm + "</a></dt>";

        				$("#" + liId + "_dl").append(dtStr);
        			}
        		}

        		// 4뎁스일때 메뉴 생성
        		else if (lvl == "3") {
        			if($("#sm3d_" + priorMenuCd).length != 0) {
        				var ddStr = "<dd id='sm4d_" + menuCd + "' surl='" + surl + "' location='" + ulNm2 + " > " + menuNm + tabInfo + "><a class='pointer' "+linkCss+">" + menuNm + "</a></dd>";
        				$("#sm3d_" + priorMenuCd).append(ddStr);
        			}
        		}
        	}
        	
        	if(isLog) console.log("createLowMenu()-->getSubLowMenuList.do Loop End");
        },
        error: function(jqXHR, ajaxSettings, thrownError) {
            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
        },
        complete : function() {
        	
        	$("#subMenuCont li").off().on("click",function(event) {  
        		if(isLog) console.log("createLowMenu()-->subMenuCont li Click");
        		event.stopPropagation();
        		if($(this).has("dl").length > 0) {
        			if($(this).find("dl").is(":visible")) {
        				$(this).find("dl").hide("blind", null, 400, function(){
        					$(this).find("dd").hide();
        					$(this).parent().find("a#label_1dp").removeClass("menu2_on");
        					initLeftScroll();
        				});
        			} else {
        				$(this).find("dl").show("blind", null, 400, function(){initLeftScroll();});
        				$(this).find("a#label_1dp").addClass("menu2_on");
        				//if($(this).find("dl>dt>a").hasClass("minus")) {
        				//	$(this).find("dl>dt>a").removeClass("minus").addClass("plus");
        				//}
        				// 접었다 펼쳤을 때 하위메뉴가 없는데도 [+]로 표시되는 오류 수정 2020.05.28 jylee
        				$(this).find("dt").each(function() {	
        					if($(this).has("dd").length > 0 && $(this).find("a").hasClass("minus") ) {
        						$(this).find("a").removeClass("minus").addClass("plus");
        					}
    					});
        			}
        		} else { 
        			$("#subMenuCont li").find("a.menu3_on").removeClass("menu3_on");
        			$("#subMenuCont li").find("a.menu4_on").removeClass("menu4_on");

        			$("#subMenuCont").find(".menu_on").removeClass("menu_on");
        			$(this).find("a").addClass("menu_on");
        			if( $(this).attr("url") != undefined ) {
        				openContent(
        						$(this).text()
        						,$(this).attr("url")
        						,$(this).attr("location")
        						,$(this).attr("surl")
        						);
        			}
        		}
        		//좌측 메뉴 스크롤을 재설정한다.
        		initLeftScroll();
        	});

        	$("#subMenuCont li dl dt").off().on("click",function(event) {

        		if(isLog) console.log("createLowMenu()-->subMenuCont li dl dt Click");
        		event.stopPropagation();

        		if($(this).has("dd").length > 0) {
        			if($(this).find("dd").is(":visible")) {
        				$(this).find("a").addClass("plus").removeClass("minus");
        				$(this).find("dd").hide("blind", null, 400, function(){initLeftScroll();});
        			} else {
        				$(this).find("a").addClass("minus").removeClass("plus");
        				$(this).find("dd").show("blind", null, 400, function(){initLeftScroll();});
        			}
        		} else {
        			$("#subMenuCont li").find("a.menu3_on").removeClass("menu3_on");
        			$("#subMenuCont li").find("a.menu4_on").removeClass("menu4_on");
        			$(this).find("a").addClass("menu3_on");
        			if( $(this).attr("url") != undefined ) {
        				openContent(
        						$(this).text()
        						,$(this).attr("url")
        						,$(this).attr("location")
        						,$(this).attr("surl")
        						);
        			}
        		}
        		//좌측 메뉴 스크롤을 재설정한다.
        		initLeftScroll();
        	});

        	$("#subMenuCont li dl dt dd").off().on("click",function(event) {
        		if(isLog) console.log("createLowMenu()-->subMenuCont li dl dt dd Click");
        		event.stopPropagation();

        		if( $(this).attr("url") != undefined ) {
        			$("#subMenuCont li").find("a.menu3_on").removeClass("menu3_on");
        			$("#subMenuCont li").find("a.menu4_on").removeClass("menu4_on");
        			$(this).find("a").addClass("menu4_on");
        			openContent(
        					$(this).text()
        					,$(this).attr("url")
        					,$(this).attr("location")
        					,$(this).attr("surl")
        					);
        		}

        		//좌측 메뉴 스크롤을 재설정한다.
        		initLeftScroll();
        	});

        	if ( getMenuSeq != "" ){
        		
        		//if( $("#subMenu").css('display') == "none" ) return;

        		$("#subMenuCont li dl dt dd").each(function() {
            		if(isLog) console.log("createLowMenu()-->getMenuSeq!='' --> subMenuCont li dl dt dd Click");
        			if ( $(this).attr("menuSeq") != getMenuSeq ){
        				
        				if ( $(this).parent().parent().parent().attr("subMenuOn") != 1 ){
        					
        					$(this).parent().parent().parent().children("a").removeClass("menu2_on");
        					$(this).parent().parent().hide();
        					//alert($(this).parent().children("dd").html());
        					
        					if ( $(this).parent().attr("subMenuOn") == 1 ){
        						$(this).parent().children("dd").each(function(idxDd, objDd) {
        							$(objDd).hide();
        							if($(objDd).parent().find("a").hasClass("plus")) {
        								$(objDd).parent().find("a").removeClass("plus").addClass("minus");
        							}
        						});
        					}else{
        						$(this).parent().children("dd").each(function(idxDd, objDd) {
        							$(objDd).hide();
        							if($(objDd).parent().find("a").hasClass("minus")) {
        								$(objDd).parent().find("a").removeClass("minus").addClass("plus");
        							}
        						});
        					}
        					
        				}else{
        					if ( $(this).parent().attr("subMenuOn") == 1 ){
        						$(this).parent().children("dd").each(function(idxDd, objDd) {
        							$(objDd).show();
        							if($(objDd).parent().find("a").hasClass("plus")) {
        								$(objDd).parent().find("a").removeClass("plus").addClass("minus");
        							}
        						});
        					}else{
        						$(this).parent().children("dd").each(function(idxDd, objDd) {
        							$(objDd).hide();
        							if($(objDd).parent().find("a").hasClass("minus")) {
        								$(objDd).parent().find("a").removeClass("minus").addClass("plus");
        							}
        						});
        					}
        				}
        			}else{
        				$(this).parent().parent().parent().children("a").addClass("menu2_on");
        				$(this).click();
        			}
        		});
        		
        		$("#subMenuCont li dl dt").each(function() {
            		if(isLog) console.log("createLowMenu()-->getMenuSeq!='' --> subMenuCont li dl dt Click");
        			if ( $(this).attr("menuSeq") != getMenuSeq ){
        				
        				if ( $(this).parent().parent().attr("subMenuOn") != 1 ){
        					$(this).parent().parent().children("a").removeClass("menu2_on");
        					$(this).parent().hide();
        				}
        				
        			}else{
        				$(this).parent().parent().children("a").addClass("menu2_on");
        				$(this).click();
        			}
        		});
        		
        		/*$("#subMenuCont li dl dt dd").each(function() {
        			if ( $(this).attr("menuSeq") == getMenuSeq ){
        				$(this).click();
        				$(this).parent().parent().parent().children("a").click();
        				$(this).parent().children("a").click();
        			}
        		});
        		$("#subMenuCont li dl dt").each(function() {
        			if ( $(this).attr("menuSeq") == getMenuSeq ){
        				$(this).click();
        				$(this).parent().parent().children("a").click();
        			}
        		});*/
        		initLeftScroll();
        		getMenuSeq = "";
        	}else{
        		$("#view1Lvl").click();
        		initLeftScroll();
        	}
        	
        	//메뉴 자동 펼치기 2020.09.18
        	makeLowMenu(lowMenu);
        	
		}
        
    });
	
}

//마이메뉴 List
function myMenuList(){
	if(isLog) console.log("myMenuList()-->");
	var list = ajaxCall("/getMyMenuList.do","",false).result;
	//console.log(list);
	var tmp = "<dt #LOCATION# #MYMENU# ><a class='pointer'>#MENUNM#</a><span class='close' #MYMENU# >&nbsp;</span></dt>";
	var str = "";
	var tabInfo = "";
	$("#myMenuCont dl").empty(); //클리어

	for(var i=0; i<list.length; i++){

		grpCd 		= list[i].grpCd;
		menuNm 		= list[i].menuNm;
		prgCd 		= list[i].prgCd;
		mainMenuNm 	= list[i].mainMenuNm;
		myMenu      = list[i].myMenu;
		surl      = list[i].surl;

		// 메뉴생성시에 메뉴권한, 메뉴인덱스등 정보를 셋팅한다.
		tabInfo = "url='"+prgCd+"' ";
		tabInfo += "myMenu='"+myMenu+"' ";
		tabInfo += "surl='"+surl+"' ";



		str += tmp.replace(/#MENUNM#/g,list[i].menuNm)
				.replace(/#MYMENU#/g,tabInfo)
				.replace(/#LOCATION#/g, "location='"+mainMenuNm+" &gt; &lt;span&gt;"+menuNm+"&lt;/span&gt;'")
				.replace(/#MENUSEQ#/g,list[i].menuSeq)
				.replace(/#PRGCD#/g,list[i].prgCd);
	}

	$("#myMenuCont dl").append(str);

	$("#myMenuCont dt .close").click(function(event) {

		$("#surl").val($(this).attr("surl") );
		var myMenuResult = ajaxCall("/getMymenu.do?status=D",$("#subForm").serialize(),false).result;

		$(this).parent().remove();
		return false;
	});

	$("#myMenuCont dt").click(function(event) {	// 마이메뉴 클릭
			openContent(
					 $(this).text()
					,$(this).attr("url")
					,$(this).attr("location")
					,$(this).attr("surl")
					);
	});


}

//해당 Left대매뉴 안의 중,소매뉴를 모두 펼침
function setAllMenuMode() {
	if(isLog) console.log("setAllMenuMode()-->");
	if( $("#subMenu").css('display') == "none" ) return;
	//$("#btnPlus").addClass("minus");
	//$("#btnPlus").hasClass("minus")?$("#viewAll").click():$("#btnStep1").click();
	$("#viewAll").click();
}

function getMainSurl() {
	if(isLog) console.log("getMainSurl()-->");
	var that = window.top;
	if(that.parent) {
		if(that.parent.$("#surl").length > 0) {
			return that.parent.$("#surl").val();
		} else {
			if(that.parent.opener) {
				return that.parent.opener.getMainSurl();
			} else {
				return that.parent.getMainSurl();
			}
		}
	}
}

// 탭 새로고침 클릭시 이벤트
function tabReload(id, index) {
	if(isLog) console.log("tabReload()-->");
	var tabSurl = tabs.find("ul.tab_group li[aria-controls='" + id + "']").attr("surl");

	$("#surl").val(tabSurl);
	var data = ajaxCall("/getDecryptUrl.do",$("#subForm").serialize(),false).map;

	data.surl = tabSurl;
	data.duplication = index;
	data.tabId=id;
	tabRefresh(data);
}

function setTabContextMenu(id) {
	if(isLog) console.log("setTabContextMenu()-->");
    $.contextMenu({
        selector: "a[href='#"+id+"']",
        autoHide: true,
        callback: function(key, options) {
        	//console.log(options);
        	if(key == "quit") {
        		var this_index = $("div[id='mainMenuTabs'] ul.tab_group li a.ui-tabs-anchor").index($(options.selector));
        		
        		if ( tabs.find("ul.tab_group li").length > 1 ){
        			tabs.find("ul.tab_group li").each(function(idx) {
        				if ( idx == this_index ){
        					tabRemove($( this ));
        				}
        			});
        		}
        		//$(options.selector).find(".tab_close").click();
        	} else if(key == "reload") {
        		var index = $("div[id='mainMenuTabs'] ul.tab_group li a.ui-tabs-anchor").index($(options.selector));

        		tabReload(id, index);
        	} else if(key == "tabfixed") {
				//$("div[id='mainMenuTabs'] ul.tab_group li a.ui-tabs-anchor").addClass("ui-tabs-lock");
        		if($(options.selector).closest("ul.tab_group li").attr("onedepth") == "true") {
        			alert(getMsgLanguage({"msgid": "msg.201706280000042", "defaultMsg":"고정할수 없는 탭입니다."}));
        		} else {
            		//$(options.selector).closest("ul.tab_group li").css("background-color", "#FFD9FA");
            		$(options.selector).closest("ul.tab_group li").addClass("ui-tabs-lock").children("a:first").prepend("<i class='mdi-ico lock'>lock</i>");
            		$(options.selector).closest("ul.tab_group li").attr("fixed","Y");
            		options.items["tabfixed"].visible = false;
            		options.items["tabunfixed"].visible = true;
        		}
        	} else if(key == "tabunfixed") {
        		//$(options.selector).closest("ul.tab_group li").css("background-color", "");
        		$(options.selector).closest("ul.tab_group li").removeClass("ui-tabs-lock").find("i.mdi-ico.lock").remove();
        		$(options.selector).closest("ul.tab_group li").attr("fixed","N");
        		options.items["tabfixed"].visible = true;
        		options.items["tabunfixed"].visible = false;
        	} else if(key == "help") {
        		if($(options.selector).closest("ul.tab_group li").attr("onedepth") == "true") {
        			alert(getMsgLanguage({"msgid": "msg.201706280000044", "defaultMsg":"도움말이 없는 탭입니다."}));
        		} else {
            		openHelpPopup($(options.selector).closest("ul.tab_group li").attr("surl"));
        		}
        	} else if ( key == "close-all" ){
        		tabs.find("ul.tab_group li").each(function() {
        			tabRemove($( this ));
        		});
        	} else if ( key == "close-other" ){

        		var this_index = $("div[id='mainMenuTabs'] ul.tab_group li a.ui-tabs-anchor").index($(options.selector));

        		tabs.find("ul.tab_group li").each(function(idx) {
        			if ( idx != this_index ){
        				tabRemove($( this ));
        			}
        		});

				//탭을 재정렬
				tabs.tabs( "refresh" );
				// tabReload(id, this_index);
			}
        },
        items: {
        	"tabfixed": {
        		name: getMsgLanguage({"msgid": "msg.201706280000049", "defaultMsg":"탭고정하기"}),
//        		icon: "fa-square-o",
        		icon: function(opt, $itemElement, itemKey, item){
//        			console.log("items opt", opt);
//        			console.log("items $itemElement", $itemElement);
//        			console.log("items itemKey", itemKey);
//        			console.log("items item", item);
                    // Set the content to the menu trigger selector and add an bootstrap icon to the item.
                    $itemElement.html('<i class="mdi-ico">tab</i>' + item.name);

                    // Add the context-menu-icon-updated class to the item
//                    return 'context-menu-icon-updated';
                },
        		visible:true
        	},
        	"tabunfixed": {name: getMsgLanguage({"msgid": "msg.201706280000050", "defaultMsg":"탭고정해제하기"}), icon: "fa-check-square-o", visible:false,
        		icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="mdi-ico">refresh</i>' + item.name);
                },

        	},
            /*"help": {name: getMsgLanguage({"msgid": "msg.201706280000051", "defaultMsg":"도움말"}), icon: "fa-question"},*/
        	"reload": {name: getMsgLanguage({"msgid": "msg.201706280000052", "defaultMsg":"새로고침"}), icon: "fa-refresh",
        		icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="mdi-ico">refresh</i>' + item.name);
                },	
        	},
        	"quit": {name: getMsgLanguage({"msgid": "msg.201706280000053", "defaultMsg":"삭제"}), icon: "fa-trash-o",
        		icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="mdi-ico">delete_forever</i>' + item.name);
                },	
            },
            /*"close-all": {name: "전체닫기", icon: "fa-close"},*/
        	"close-other": {name: getMsgLanguage({"msgid": "msg.2019061300074", "defaultMsg":"다른탭닫기"}), icon: "fa-puzzle-piece",
        		icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="mdi-ico">tab_unselected</i>' + item.name);
                },	
            }
        },
        events: {
            show: function(opt) {
                var $this = this;
                $.contextMenu.setInputValues(opt, $this.data());
            },
            hide: function(opt) {
                var $this = this;
                $.contextMenu.getInputValues(opt, $this.data());
            }
        }
    });
}

function subMenuAction() {
	if(isLog) console.log("subMenuAction()-->");
	$("#subMenu").jScrollPane();
}

function getPopupList() {
	if(isLog) console.log("getPopupList()-->");
	$.each(_pageObj, function(idx, obj) {
		if(obj.obj.closed) {
			_pageObj.splice(idx, 1);
		}
	});

	return _pageObj;
}

function sysTestOpen(obj){
	
	if(!isPopup()) {return;}
	
	
	var surl = obj.attr("surl");
	var location = obj.attr("location");
	
	var param = "surl="+surl
				+"&location="+location;

	var url ="/ReqDefinitionPop.do?cmd=viewReqDefinitionPop";

	var args = new Array(2);

	args["surl"]     = surl;
	args["location"] = location;

	gPRow = "";
	pGubun = "viewApprovalMgr";

	openPopup(url,args,1150,400);
}

// 지정 메뉴의 도움말 정보 세팅
function setMenuHelp() {
	var btnShow = false;
	var boxEle = $("#area_helpBox"), relateMenuEle = boxEle.find("#_relateMenu"), relateMenuListEle = relateMenuEle.find(".list");
	var surl = $("#surl").val();
	
	if( surl != "" && surl.length > 100 ) {
		//$("#addMyMenu").removeClass("btn_mymenu_minus").addClass("btn_mymenu").html(" 나의메뉴 추가 ").attr("title", "나의메뉴 추가");
		
		var hdata = ajaxCall("/HelpPopup.do?cmd=getHelpPopupMap",$("#subForm").serialize(),false);
		if(hdata && hdata != null){
			// 도움말 박스 초기화
			resetHelpBox();
			
			if( hdata.map && hdata.map != null ) {
				// 개발자모드가 활성화된 경우 선택 탭 URL 출력.
				$("#devTabUrl").val(hdata.map.prgCd);
				// 메뉴명 삽입
				boxEle.find("._header .menuNm").html("<span class='mal5'>" + hdata.map.menuNm + "</span>");
				// 도움말 사용중인 경우 버튼 활성화
				boxEle.find("#_helpPopup").hide();
				if( hdata.map.mgrHelpYn == "Y" || hdata.map.empHelpYn == "Y" ) {
					// 도움말 박스 출력 버튼 화면 출력 여부 설정
					btnShow = true;
					
					// 도움말 팝업 영역 화면 출력
					boxEle.find("#_helpPopup").show();
					boxEle.find("#btnOpenHelpPop").attr("surl", surl);
					boxEle.find("#btnOpenHelpPop").off("click.help").on("click.help", function(e) {
						e.stopPropagation();
						openHelpPopup($(this).attr("surl"));
					});
				}
			}
			
			if( hdata.relateMenuList && hdata.relateMenuList != null && hdata.relateMenuList.length > 0 ) {
				// 도움말 박스 출력 버튼 화면 출력 여부 설정
				btnShow = true;
				
				// 연관 메뉴 추가
				hdata.relateMenuList.forEach(function(item, idx, arr) {
					//console.log(item, idx, arr);
					
					var menuWrapEle = $("<div/>");
					var menuPathEle = $("<a/>", {
						"class"  : "pointer",
						"menuId" : item.menuId,
						"title"  : item.menuPathNm
					});
					var link = $("<a />", {
						"class" : "fas fa-external-link-alt f_white mal10 pointer",
						"title" : "'" + item.menuPathNm + "' Open"
					});
					
					// 링크 텍스트 세팅
					item.menuPathNm.split(">").forEach(function(item, idx, arr) {
						if( idx > 0 ) {
							menuPathEle.append(
								$("<e/>", {
									"class" : "fas fa-chevron-right f_gray_a ma-x-1"
								})
							);
						}
						
						// 마지막 배열인 경우
						if( idx == (arr.length - 1) ) {
							menuPathEle.append($("<span/>", {
								"class" : "f_orange"
							}).text(item));
						} else {
							menuPathEle.append($("<span/>", {
								"class" : "f_gray_e"
							}).text(item));
						}
					});
					
					// 링크 텍스트 클릭시 이벤트 추가
					menuPathEle.on("click", function(){
						var menuId = $(this).attr("menuId"), boxEle = $("#area_helpBox #_relateMenu li[menuId='" + menuId + "'] .description");
						if( !boxEle.hasClass("view") ) {
							boxEle.removeClass("hide");
							boxEle.animate({
								"height" : "125px"
							}, 500, function(){
								boxEle.addClass("view");
							});
						} else {
							boxEle.animate({
								"height" : "0px"
							}, 300, function(){
								boxEle.removeClass("view");
								boxEle.addClass("hide");
							});
						}
					});
					
					// 링크 클릭시 이벤트 추가
					link.on("click", function(){
						openContent(item.menuNm, item.prgCd, "<span>" + item.menuPathNm + "</span>", item.surl);
					});
					
					// 링크 텍스트 삽입
					menuWrapEle.append(
						$("<span/>", {
							"class" : "mainMenuNm"
						}).text(item.mainMenuNm)
					).append(menuPathEle);
					
					// 추가
					relateMenuListEle.append(
						$("<li/>", {
							"class"  : "item",
							"menuId" : item.menuId
						}).append(
							$("<div/>", {
								"class" : "disp_flex alignItem_center justify_between"
							})
							.append(menuWrapEle)
							.append(link)
						).append(
							$("<div/>", {
								"class" : "description hide"
							}).html(
								(item.relMenuDescription && item.relMenuDescription != null) ? "<p>" + item.relMenuDescription.replace(/\n/gi, "</p><p>") + "</p>" : ""
							)
						)
					);
				});
			} else {
				// 추가
				relateMenuListEle.append(
					$("<li/>", {
						"class" : "item"
					}).append(
						$("<span/>", {
							"class" : "alignC f_white"
						}).text("등록된 연관 메뉴가 없습니다.")
					)
				);
			}

			
			/*
			if ( ssnDataRwType == "A" ) {
				$("#helpPopup").show();
				$("#helpPopup").removeClass("tPink");
				
				if ( hdata.mgrHelpYn != "Y" ) {
					$("#helpPopup").hide();
					$("#helpPopup").addClass("tPink");
				}
			} else {
				if ( hdata.empHelpYn == "Y" ) {
					$("#helpPopup").show();
				}
			}
			
			if(hdata.myMenu == "Y") {
				$("#addMyMenu").html(" 나의메뉴 제거 ").removeClass("btn_mymenu").addClass("btn_mymenu_minus").attr("title", "나의메뉴 제거");
			}
			*/
		}
	}
	
	// 도움말 박스 출력 버튼 화면 출력
	if( btnShow ) {
		$("#btnHelpBox").removeClass("hide");
	} else {
		if( $("#area_helpBox").hasClass("on") ) {
			toggleHelpBox(false);
			// 도움말 박스 초기화
			resetHelpBox();
		}
		$("#btnHelpBox").addClass("hide");
	}
}

// 도움말 박스 초기화
function resetHelpBox() {
	var boxEle = $("#area_helpBox");
	// 도움말 박스 타이틀 초기화
	boxEle.find("._header .menuNm").empty();
	// 연관 메뉴 세팅
	boxEle.find("#_relateMenu .list").empty();
}

// 도움말 박스 출력 토글
function toggleHelpBox(flag) {
	var boxEle = $("#area_helpBox");
	
	if( flag == undefined ) {
		if( boxEle.hasClass("on") ) {
			flag = false;
		} else {
			flag = true;
		}
	}
	
	if( flag && boxEle.find("._header .menuNm").html() == "" ) {
		alert("선택 및 열람중인 메뉴가 없습니다.");
		flag = false;
	}
	
	if( flag ) {	// open
		boxEle.animate({
			"right" : "0px"
		}, 500, function(){
			boxEle.removeClass("off").addClass("on");
		});
	} else {		// close
		boxEle.animate({
			"right" : "-525px"
		}, 300, function(){
			boxEle.removeClass("on").addClass("off");
		});
	}
}