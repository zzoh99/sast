//HEADER 관련
var stime = 0;
var stimeId;
var ctime;
var ctimeId;

function lpad(s, c, n) {
	if (!s || !c || s.length >= n) {
		return s;
	}
	var max = (n - s.length) / c.length;
	for (var i = 0; i < max; i++) {
		s = c + s;
	}
	return s;
}
// yyyyMMdd -> yyyy.MM.dd
// yyyy-MM-dd -> yyyy.MM.dd
function dateParse(date) {
	var onlynum = date.replace(/[^0-9]/g, '');
	return [
		onlynum.slice(0, 4),
		onlynum.slice(4, 6),
		onlynum.slice(6),
      ].join('.');
}

function onLnbEvent() {
	$('#viewAll').on('click', function() {
		if ($('.sub_menu_body ul li').hasClass('open')) {
			$('#view1Lvl').click();
		} else {
			$('#view3Lvl').click();
		}
	});
	
	$('#view1Lvl').on('click', function() {
		$('.sub_menu_body ul li').each(function() {
			if ($(this).hasClass('open')) {
				$(this).removeClass('open');
				$(this).find('dl').hide();
			}
		});
	});
	
	$('#view2Lvl').on('click', function() {
		$('.sub_menu_body ul li').each(function() {
			if (!$(this).hasClass('open')) {
				$(this).addClass('open');
			}
			var dl = $(this).find('dl');
			if (dl.hasClass('open')) {
				dl.removeClass('open');
				dl.find('dd').hide();
			}
			dl.show();
		});
	});
	
	$('#view3Lvl').on('click', function () {
		$('.sub_menu_body ul li').each(function() {
			if (!$(this).hasClass('open')) {
				$(this).addClass('open');
			}
		});
		
		$('.sub_menu_body ul li dl').each(function() {
			var dd = $(this).find('dd');
			if (dd.length > 0) {
				$(this).addClass('open');
				dd.show();
			}
			$(this).show();
		});
	});
}

function createAuthList() {
	const auths = ajaxCall("/getCollectAuthGroupList.do", "", false).result;
	const authHtml = auths.reduce((a, c) => {
		a += '<div class="option" rurl="' + c.rurl + '" ><i class="mdi-ico filled">account_circle</i>' + c.ssnGrpNm + '</div>\n';
		return a;
	}, '<div class="header">권한 변경</div>\n');
	$('#possibleAuthList').html(authHtml);
	onDropDown();
	//onDropDownOptionClick();
	$('#possibleAuthList div.option').click(function() {
		const rurl = $(this).attr("rurl");
		const param = 'rurl=' + encodeURIComponent(rurl);
		var j = ajaxCall("/ChangeSession.do", param, false);
		redirect("/", "_top");
	});
	
}

function headerCTimeInit() {
	if (ctimeId) {
		clearInterval(ctimeId);
	}
	
	ctimeId = setInterval(headerCTimeStart, 1000);
}

function headerSTimeInit() {
	if (stimeId) {
		clearInterval(stimeId);
	}
	
	if(defaultTime && defaultTime > 0) {
		stime = parseInt(defaultTime, 10);
		stimeId = setInterval(headerSTimeStart, 1000);
	}
}

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

function headerSTimeStart() {
	$('#headerSTime').html(sTimeFormat(stime));
	if (stime <= 0) {
		disableTop();
		//logout();
	}
	stime--;
}

function headerCTimeStart() {
	ctime = new Date();
	$('#headerCTime').html(cTimeFormat(ctime));
}

function sTimeFormat(s) {
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

function cTimeFormat(date) {
	var yyyy = date.getFullYear();
	var mm = date.getMonth();
	var dd = date.getDate();
	var hh = date.getHours();
	var mi = date.getMinutes();
	
	return yyyy + '.' 
		 + lpad((mm + 1).toString(), 2, '0') + '.'
		 + lpad(dd.toString(), 2, '0') + ' '
		 + lpad(hh.toString(), 2, '0') + ':'
		 + lpad(mi.toString(), 2, '0');
}

function normalDateFormat(date, seperator) {
	var yyyy = date.getFullYear();
	var mm = date.getMonth();
	var dd = date.getDate();
	return yyyy + seperator
		 + lpad((mm + 1).toString(), 2, '0') + seperator
		 + lpad(dd.toString(), 2, '0');
}

// 테마 옵션 정의
const supportedThemes = ['blue', 'navy', 'green', 'red', 'scarlet', 'white'];
function setThemeEvent() {
	applyTheme(session_theme) // 최초 설정

	// 테마 선택 옵션 그리기
	$('div#themeList div.option').remove()
	supportedThemes.forEach(theme => {
		const themeName = theme.charAt(0).toUpperCase() + theme.slice(1);
		$('div#themeList').append(`<div class="option" theme="${theme}"><span class="circle ${theme}"></span>${themeName}</div>`)
	})

	// 테마 선택 옵션 클릭 이벤트
	$('div#themeList div.option').click(function () {
		var selectTheme = $(this).attr('theme');
		var param = {
				subThemeType: selectTheme,
				subFontType: session_font,
				subMainType: session_mainT
		};
		ajaxCall("/UserMgr.do?cmd=userTheme", queryStringToJson(param), false);
		applyTheme(selectTheme)
	});
}

// 테마 적용
function applyTheme(themeName) {
	if (!supportedThemes.includes(themeName)) {
		themeName = 'blue';
	}

	const root = document.documentElement;
	const colorLevels = ['10', '20', '30', '40', '50', '60', '70', '80', '90', '95', '98', 'tab', 'lnb-back', 'lnb-text', 'lnb-on', 'lnb-icon', 'lnb-text-hover'];

	colorLevels.forEach(level => {
		const themeColor = getComputedStyle(root).getPropertyValue(`--hr-${themeName}-${level}`).trim();

		if (themeColor) {
			root.style.setProperty(`--primary-${level}`, themeColor);
		}
	});
	document.documentElement.style.visibility = 'visible';

	// vueLayout 클래스를 가진 모든 iframe에 테마 변경 메시지 전달
	$('iframe.vueLayout').each(function() {
		try {
			this.contentWindow.postMessage({ type: 'setThemeColor', theme: themeName }, '*');
		} catch (e) {
			console.error('테마 변경 메시지 전달 실패:', e);
		}
	});
}

// 화면 로드시 테마 색상 적용
document.documentElement.style.visibility = 'hidden';
document.addEventListener('DOMContentLoaded', function() {
	if (typeof session_theme !== 'undefined') {
		applyTheme(session_theme);
		document.documentElement.style.visibility = 'visible';
	}
});

function goMain() {
	redirect('/Main.do', "_top");
}

function logout() {
	redirect('/logoutUser.do', "_top");
}

function enableTop() {
	$.each(getPopupList(), function(idx, obj) {
		obj.obj.enablePage();
	});

	$("div.lock").remove();

	//scroller
	$('html, body').removeClass('lock-size');
	$('#element').off('scroll touchmove mousewheel');

	headerSTimeInit();
}

function disableTop() {
	var pageCnt = _pageObj.length, thar = this;
	$.each(getPopupList(), function(idx, obj) {
		obj.obj.disablePage(pageCnt === idx+1 ? true : false);
	});

	clearInterval(stimeId);
	stimeId = null;

	var disableDiv = $("<div>").addClass("lock lockDiv"),

		lockDiv = $("<div>")
			.addClass("lock lock-panel")
			.css({"border-radius":"30px", "padding":"15px"})
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

function headerSearch() {
	var searchWord = $('#mainHeaderSearchWord').val();
	var mainSearchModal = new window.top.document.LayerModal({
		id: 'mainSearchModal',
		url: '/Popup.do?cmd=viewMainSearchLayer',
		parameters: { searchWord },
		width: 600,
		height: 635,
		title: '메인검색'
	});
	mainSearchModal.show();
	//openLayer('/Popup.do?cmd=viewMainSearchLayer', { searchWord }, 600, 635, 'initLayer')
}

//LNB 관련 
function createMainMenu() {
	const mms = ajaxCall("/getMainMajorMenuList.do", "", false).result;
	$('nav#lnb ul.main_menu').empty();
	
	const mmsHtml = mms.filter(mm => mm.mainMenuCd != '21')
					   .reduce((a, c) => {
		a += '<li class="menu_item" murl="' + c.murl + '" mainMenuCd="' + c.mainMenuCd + '" grpCd="' + c.grpCd + '" >\n'
		   + '	<a href="#" >\n'
		   + '		<span class="item_area">\n'
		   + '			<i id="mmi-comap-' + c.mainMenuCd + '" ></i>\n'
		   + '			<span class="menu_title">' + c.mainMenuNm + '</span>\n'
		   + '		</span>\n'
		   + '	</a>\n'
		   + '</li>\n';
		return a;
	}, '');
	
	$('nav#lnb ul.main_menu').html(mmsHtml);
	mainMenuIconSet();
	
	const curl = location.pathname;
	if (curl.indexOf('Main.do') > -1 || curl.indexOf('MainVue.do') > -1) {
		$(".main_menu .menu_item").off().on('click', function (e) {
			var form = $('<form></form>');
			var murl = $('<input type="hidden" name="murl" value="' + $(this).attr('murl') + '" />');
			form.append(murl);
			$('body').append(form);
			submitCall(form, '', 'post', '/Hr.do');
		});
	} else {
		$(".main_menu .menu_item").off().on('click', function (e) {
			mainMenuItemClick(this);
		});
	}
}

function openSubPage(mmcd, pmcd, mcd, mseq, prgcd, lpmseq, lpseq) {
	const param = { mainMenuCd: mmcd, menuSeq: mseq, prgCd: encodeURIComponent(prgcd) };
	const auth = ajaxCall('/geSubDirectMap.do', queryStringToJson(param), false).map;

	if (auth == null) {
		alert('해당 메뉴에 대한 조회 권한이 없습니다.');
		return;
	} else {
		var form = $('<form></form>');
		form.append('<input type="hidden" name="murl" value="' + auth.surl + '" />');
		
		if (lpmseq && lpseq) {
			form.append('<input type="hidden" name="linkedBarProcMapSeq" value="' + lpmseq + '" />');
			form.append('<input type="hidden" name="linkedBarProcSeq" value="' + lpseq + '" />');
		}
		
		$('body').append(form);
		submitCall(form, "", "post", "/Hr.do"); 
	}
}

function createSubMenu() {
	const mainMenuCode = $('nav#lnb ul.main_menu li.on').attr('mainMenuCd');
	const grpCd = $('nav#lnb ul.main_menu li.on').attr('grpCd');
	const murl = $('nav#lnb ul.main_menu li.on').attr('murl');
	const param = "murl=" + encodeURIComponent(murl);
	const smJson = ajaxCall("/getSubLowMenuList.do", param, false).result;
	
	var location = '';
	var dlopen = false;
	let locations = {};
	var smHtml = smJson.reduce((a, c) => {
		const lvl = c.lvl;
		const surl = c.surl;
		const mainManuNm = c.mainMenuNm;
		const menuNm = c.menuNm;
		const url = replaceAll(c.prgCd, '#', '?');
		const prgCd = c.prgCd;
		const menuId = c.menuId;
		const menuSeq = c.menuSeq;
		const subMenuOn = c.subMenuOn;
		const type = c.type;

		if (lvl == 1) {
			if (dlopen) {
				a += '	</dl>\n';
				dlopen = !dlopen;
			} 
			location = c.mainMenuNm + ' > ' + menuNm;
			locations[lvl] = location;
			a += a == '' ? '<li id="subMenuLi'+menuId+'">\n':'</li>\n<li id="subMenuLi'+menuId+'">\n';
			a += '	<a href="#" surl="' + surl
						   + '" murl="' + murl
						   + '" location="' + location 
						   + '" url="' + url 
						   + '" menuId="' + menuId 
						   + '" menuSeq="' + menuSeq 
						   + '" subMenuOn="' + subMenuOn 
						   + '">\n';
			a += '		<span>' + menuNm + '</span>\n';
			a += '	</a>\n';
			
			dl_first = true;
		} else if (lvl == 2) {
//			if(type == 'P') {
//				if (dlopen) {
//					a += '	</dl>\n	<dl>\n';
//				} else {
//					a += '	<dl>\n';
//					dlopen = !dlopen;
//				}
//				
//				location += ' > ' + menuNm;
//				a += '		<dt>\n';
//				a += '				<a href="#" surl="' + surl 
//				   + '" location="' + location 
//				   + '" url="' + url 
//				   + '" menuId="' + menuId 
//				   + '" menuSeq="' + menuSeq 
//				   + '" subMenuOn="' + subMenuOn 
//				   + '">';
//				a += menuNm + '</a>\n';
//				a += '		</dt>\n';
//			} else if(type == 'M') {
				if (dlopen) {
					a += '	</dl>\n	<dl>\n';
				} else {
					a += '	<dl>\n';
					dlopen = !dlopen;
				}

				location = locations[1] + ' > ' + menuNm;
				locations[lvl] = location;
//				a += '		<dt class="sub_menu">\n';
				a += type == 'M' ? '		<dt class="sub_menu">\n':'		<dt>\n';
				a += '			<a href="#" surl="' + surl
				   + '" murl="' + murl
				   + '" location="' + location 
				   + '" url="' + url 
				   + '" menuId="' + menuId 
				   + '" menuSeq="' + menuSeq 
				   + '" subMenuOn="' + subMenuOn 
				   + '">';
				a += menuNm + '</a>\n';
				a += '		</dt>\n';
//			}
		} else if (lvl == 3) {
			location = locations[2] + ' > ' + menuNm;
			locations[lvl] = location;
			a += '		<dd>\n'
			a += '			<a href="#" surl="' + surl
			   + '" murl="' + murl
			   + '" location="' + location 
			   + '" url="' + url 
			   + '" menuId="' + menuId 
			   + '" menuSeq="' + menuSeq 
			   + '" subMenuOn="' + subMenuOn 
			   + '">';
			a += menuNm + '</a>\n';
			a += '		</dd>\n';
		}
		return a;
	}, '');
	smHtml += dlopen ? '	</dl>\n</li>':'</li>\n';
	
	$('nav#lnb div.sub_menu div.sub_menu_body ul').html(smHtml);
	
	// 231031 김기용: 메인 메뉴 hover 시 타이틀 말풍선 표시 -> 240119 김도희 감춤
//	$(".main_menu .menu_item a").hover(
//	  function () {
//	    if ($("body").hasClass("main_menu_on")) {
//	      $this = $(this);
//	   // console.log("hover in $this", $this, $this.position(), $this.offset());
//	      
//	      var menu_title = $this.find(".menu_title").text();
//	      var position = $this.position();
//	
//	      $(".main_menu_hover_title")
//	        .text(menu_title)
//	        .css({ visibility: "visible", top: position.top - 31 });
//	    }
//	  },
//	  function () {
//	    if ($("body").hasClass("main_menu_on")) {
//	      $this = $(this);
//	      $(".main_menu_hover_title").css({ visibility: "hidden" });
//	    }
//	  }
//	);

	// 서브메뉴 상단 전체, 뎁스별 열고 닫기 버튼, 서브메뉴 lnb 감추기
	$(".sub_menu .sub_menu_header > a").off('click').on('click', function () {
		const $this = $(this);
		const btnIdx = $this.index();

		if (btnIdx == 0) {
			// 전체 열기 닫기
			$this.hasClass("open") ? closeSubmenuAll() : openSubmenuAll();
			$this.toggleClass("open");
		} else if (btnIdx == 1) {
			// 뎁스 3까지 열기
			openSubmenuAll();

			$this.siblings(".all").addClass("open");
		} else if (btnIdx == 2) {
			// 뎁스 2까지 열기
			openSubmenuDepth1All();
			closeSubmenuDepth2All();

			$this.siblings(".all").addClass("open");
		} else if (btnIdx == 3) {
			// 뎁스 1만 열기
			closeSubmenuAll();

			$this.siblings(".all").removeClass("open");
		} else if (btnIdx == 4) {
			$("body").toggleClass("sub_menu_off");
			$("div.sub_content").toggleClass("sub_menu_off");
		}
	});
	
	// 250313 update
	$(".main_menu_wrap .open_close_btn").off('click').on('click', function() {
	    $("body").toggleClass("sub_menu_off");
	    $("div.sub_content").toggleClass("sub_menu_off");
	    
	    // 아이콘 토글
	    const $icon = $(this).find("i.mdi-ico");
	    if ($("body").hasClass("sub_menu_off")) {
	        $icon.text("open_in_full");
	    } else {
	        $icon.text("close_fullscreen");
	    }
	});

	function openSubmenuAll() {
		openSubmenuDepth1All();
		openSubmenuDepth2All();
	}
	function closeSubmenuAll() {
		closeSubmenuDepth1All();
		closeSubmenuDepth2All();
	}

	function openSubmenuDepth1All() {
		const $elems = $(".sub_menu .sub_menu_body li > a");

		for (let index = 0; index < $elems.length; index++) {
			const $elem = $($elems[index]);
			openSubmenuDepth1($elem);
		}
	}
	function closeSubmenuDepth1All() {
		const $elems = $(".sub_menu .sub_menu_body li > a");

		for (let index = 0; index < $elems.length; index++) {
			const $elem = $($elems[index]);
			closeSubmenuDepth1($elem);
		}
	}

	function openSubmenuDepth1($elem) {
		$elem.parent().addClass("open");
		$elem.siblings().slideDown(200);
	}
	function closeSubmenuDepth1($elem) {
		$elem.parent().removeClass("open");
		$elem.siblings().slideUp(200);
	}

	function toggleSubmenuDepth1($elem) {
		$elem.parent().toggleClass("open");
		$elem.siblings().slideToggle(200);
	}

	function openSubmenuDepth2All() {
		const $elems = $(".sub_menu .sub_menu_body dl dt > a");

		for (let index = 0; index < $elems.length; index++) {
			const $elem = $($elems[index]);
			openSubmenuDepth2($elem);
		}
	}
	function closeSubmenuDepth2All() {
		const $elems = $(".sub_menu .sub_menu_body dl dt > a");

		for (let index = 0; index < $elems.length; index++) {
			const $elem = $($elems[index]);
			closeSubmenuDepth2($elem);
		}
	}

	function openSubmenuDepth2($elem) {
		const $siblings_dd = $elem.parent().siblings("dd");
		if ($siblings_dd.length > 0) {
			$elem.parent().parent().addClass("open");
			$siblings_dd.slideDown(200);
		}
	}
	function closeSubmenuDepth2($elem) {
		const $siblings_dd = $elem.parent().siblings("dd");
		if ($siblings_dd.length > 0) {
			$elem.parent().parent().removeClass("open");
			$siblings_dd.slideUp(200);
		}
	}

	function toggleSubmenuDepth2($elem) {
		const $siblings_dd = $elem.parent().siblings("dd");
		if ($siblings_dd.length > 0) {
			$elem.parent().parent().toggleClass("open");
			$siblings_dd.slideToggle(200);
		}
	}
	
	// 서브메뉴 클릭
	// depth 1
	$(".sub_menu .sub_menu_body li > a").off().on('click', function (e) {
		toggleSubmenuDepth1($(this));
	});
	
	// depth 2
	$(".sub_menu .sub_menu_body dt > a").off().on('click', function (e) {
		toggleSubmenuDepth2($(this));
		subMenuItemClick(this);
	});
	$(".sub_menu .sub_menu_body dd > a").off().on('click', function (e) {
		subMenuItemClick(this);
	});

	// 초기 메뉴 오픈을 위한 기준값보다(LEFT_MENU_OPEN_CNT) 서브메뉴 개수가 적은경우, 모든 메뉴 펼치기
	if( menuOpenCnt != null && menuOpenCnt != undefined && menuOpenCnt != "null" && parseInt( menuOpenCnt ) >= smJson.length ) {
		openSubmenuAll();
	}
}

//main-menu icon set
function mainMenuIconSet() {
	var mmicomap = {
			'02': 'assignment_ind',
			'03': 'corporate_fare',
			'05': 'school',
			'06': 'note_alt',
			'07': 'savings',
			'08': 'calendar_month',
			'09': 'volunteer_activism',
			'10': 'fact_check',
			'12': 'analytics',
			'11': 'settings',
			'20': 'assignment',
			'16': 'badge',

	  };
	  Object.keys(mmicomap).forEach((key) => {
		  $('#mmi-comap-' + key ).addClass("mdi-ico round");
		  $('#mmi-comap-' + key ).html(mmicomap[key])
	  });
}

//main-menu click
function mainMenuItemClick(target) {
	if ($(target).hasClass("on")) {
		$(target).siblings().removeClass("on");
	} else {
		//기존에 있던  on 정보들을 제거
		$('.menu_item').removeClass('on');
		$(target).addClass("on");
		$("body").addClass("main_menu_on");
		$("div.sub_content").addClass("main_menu_on");
		createSubMenu();
		
		var pcd = getDirectMenuMap(mainMenuSeq, mainPrgCd);
		if (pcd != null && pcd != '') {
			if (mainLinkedBarProcMapSeq && mainLinkedBarProcSeq) {
				$('div.sub_menu_body a').each(function() {
					var mprg = $(this).attr('url');
					var mseq = $(this).attr('menuseq');
					if (mprg == mainPrgCd && mseq == mainMenuSeq) {
						$(this).click();
					}
				});
			} else {
				mainMenuSeq = '';
				mainPrgCd = '';
				eval(pcd);
			}
		} else {
			const title = $(target).find('span.menu_title').text().trim();
			const url = 'getSubMenuContents.do';
			const murl = $(target).attr('murl').trim();
			const mainMenuCd = $(target).attr('mainmenucd').trim();
			$('#murl').val(murl);

			// openContent(title, 'getSubMenuContents.do', '<span>' + title + '</span>', murl, murl);

			// 대메뉴 컨텐츠 화면에 위젯이 없는 경우, 최상단의 프로그램을 호출한다.
			// var widgets  = ajaxCall("/getWidgetList.do", 'mainMenuCd=' + mainMenuCd, false).DATA;
			// if(widgets.length > 0) {
			// 	openContent(title, 'getSubMenuContents.do', '<span>' + title + '</span>', murl, murl);
			// } else {
			// 	var prgData = ajaxCall("/getMenuPrgMap.do",'mainMenuCd=' + mainMenuCd, false).DATA;
			// 	if (typeof window.top.goOtherSubPage == 'function') {
			// 		window.top.goOtherSubPage("", "", "", "", prgData.prgCd);
			// 	} else {
			// 		goSubPage("", "", "", "", prgData.prgCd);
			// 	}
			// }
		}
	}
}

function subMenuItemClick(target) {

	if ($(target).attr('url') && $(target).attr('url') != 'null') {
		$(".sub_menu .sub_menu_body dt > a").removeClass("open");
		$(".sub_menu .sub_menu_body dd > a").removeClass("open");
		$(target).addClass("open");

		const title = $(target).text().trim();
		const url = $(target).attr('url');
		const location = $(target).attr('location');
		const surl = $(target).attr('surl');
		const murl = $(target).attr('murl');
		const menuId = $(target).attr('menuid');
		$('#surl').val(surl);

		if (mainLinkedBarProcMapSeq && mainLinkedBarProcSeq) {
			var pminfo = { procMapSeq:mainLinkedBarProcMapSeq, procSeq:mainLinkedBarProcSeq };
			mainLinkedBarProcMapSeq = null;
			mainLinkedBarProcSeq = null;
			openContent(title, url, location, surl, murl, menuId, pminfo);
		} else {
			openContent(title, url, location, surl, murl, menuId);
		}
	}
}

function openMain(mmcd) {
	$('nav#lnb ul.main_menu li').each(function() {
		if ($(this).attr('mainMenuCd') == mmcd) {
			$(this).click();
		}
	});
}

function openSubMenuCd(surl, m) {
	$('.sub_menu .sub_menu_body a').each(function() {
		if ($(this).attr('menuid') == m ) $(this).click();
	});
}

function menuOpenByMenuSeq(seq) {
	$('.sub_menu .sub_menu_body a').each(function() {
		var mseq = $(this).attr('menuseq');
		if (mseq == seq) {
			var li = $(this).parents('li');
			var dl = $(this).parents('dl');

			if(!li.hasClass('open'))
				li.children('a').click();

			if (dl.find('dd').length > 0) {
				if(!dl.hasClass('open'))
					dl.find('dt a').click();
			}
		}
	});
}

function switchArray(array, a, b) {
	array[a] = array.splice(b, 1, array[a])[0];
	return array;
}

function onDropDown() {
  // 드롭다운 이벤트
  $(".select_toggle").off().click(function (e) {
    if ($(this).closest(".custom_select").hasClass("disabled")) return;
    e.stopPropagation(); // 이벤트 버블링 방지
    $(".select_options").not($(this).next()).css("visibility", "hidden");
    $(".select_toggle i")
      .not($(this).find("i"))
      .each(function () {
        if ($(this).text() === "keyboard_arrow_up") {
          $(this).text("keyboard_arrow_down");
        } else if ($(this).text() === "arrow_drop_up") {
          $(this).text("arrow_drop_down");
        }
      });

    let optionsVisibility = $(this).next(".select_options").css("visibility");
    $(this)
      .next(".select_options")
      .css(
        "visibility",
        optionsVisibility === "visible" ? "hidden" : "visible"
      );

    let icon = $(this).find("i");
    switch (icon.text()) {
      case "keyboard_arrow_down":
        icon.text("keyboard_arrow_up");
        break;
      case "keyboard_arrow_up":
        icon.text("keyboard_arrow_down");
        break;
      case "arrow_drop_down":
        icon.text("arrow_drop_up");
        break;
      case "arrow_drop_up":
        icon.text("arrow_drop_down");
        break;
    }
  });

  // 다른 영역 클릭 시 드롭다운 닫기
  $(document).off("click").on("click", function () {
    $(".select_options").css("visibility", "hidden");
    $(".select_toggle i").each(function () {
      if ($(this).text() === "keyboard_arrow_up") {
        $(this).text("keyboard_arrow_down");
      } else if ($(this).text() === "arrow_drop_up") {
        $(this).text("arrow_drop_down");
      }
    });
  });
}

function onDropDownOptionClick() {
	 $(".select_options .option").click(function () {
	    if ($(this).closest(".custom_select").hasClass("disabled")) return;
	    $(this).closest(".select_options").css("visibility", "hidden");
	    let icon = $(this).closest(".custom_select").find(".select_toggle i");
	    // Resetting the icon to down arrow based on its type
	    if (icon.text() === "keyboard_arrow_up") {
	      icon.text("keyboard_arrow_down");
	    } else if (icon.text() === "arrow_drop_up") {
	      icon.text("arrow_drop_down");
	    }
	  });
}

function makeVisibleToggleContent(state){
	if(state=="OPEN"){
		$(".toggle_wrap .toggle_content").slideDown(100);
//		$(".toggle_wrap .toggle_content").css('display', 'block');
		$(".toggle_menu").children("i").text("keyboard_arrow_up");	
	}else{
		$(".toggle_wrap .toggle_content").slideUp(100);
//		$(".toggle_wrap .toggle_content").css('display', 'none');
		$(".toggle_menu").children("i").text("keyboard_arrow_down");				
	}
}

function moveScrollTop(){
	$('body').animate({ scrollTop: 0 }, "fast");
}

function onTabMenuClick(){
	// 컨텐츠 탭 메뉴
	$(".tab_menu").on("click", function () {
		//$(".tab_menu").removeClass("active");
		$(this).siblings().removeClass("active");
		$(this).addClass("active");
  });
}

// no_content 이미지 랜덤
const imageUrls = [
   "/assets/images/img_no_contents01.png",
   "/assets/images/img_no_contents02.png",
];

function getRandomImageUrl() {
    const randomIndex = Math.floor(Math.random() * imageUrls.length);
    return imageUrls[randomIndex];
}

function setRandomImage() {
    const randomImageUrl = getRandomImageUrl();
    $(".no_content img").attr("src", randomImageUrl);
}