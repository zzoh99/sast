var swiperTabs;
var tabIdx = 0;

// 메인 탭 메뉴
$(function () {
	//최초 메인메뉴코드로 TAB 생성
	swiperTabs = new Swiper(".swiper.main_tab_wrap", {
	    slidesPerView: "auto",
	    watchSlidesVisibility: true,
	    spaceBetween: 0,
	    navigation: {
	      nextEl: ".arrow_right_btn",
	      prevEl: ".arrow_left_btn",
	    },
	    slidesPerGroupAuto: true,
	    simulateTouch: false,
	    preventClicks: true,
	    preventClicksPropagation: true,
	    onlyExternal: true,
	    watchOverflow: true,
	    on: {
	      init: (s) => {
	        updateSlideZIndex(s);
	      },
	      slideChange: (s) => {
	        updateSlideZIndex(s);
	      }
	    },
	  });

  $(".main_tab_menu").disableSelection();
});

function createTab(obj) {
	const { title, location, menuSeq, surl } = obj;
	const onedepth = obj.url.indexOf('getSubMenuContents.do') > -1;
	const tabId = 'tab-' + lpad(tabIdx.toString(), 2, '0');
	var html = '<a class="swiper-slide active tab_menu" id="' + tabId + '"'
			 + ' location="' + location + '" '
			 + ' onedepth="' + onedepth + '" '
			 + ' menuSeq="' + menuSeq + '" '
			 + ' surl="' + surl + '">\n'
			 + '	<span>' + title + '</span>\n'
			 + '	<i class="mdi-ico">close</i>\n'
			 + '	<div class="custom_select no_style">\n'
			 + '		<div class="select_options fix_width">\n'
			 + '			<div class="option"><i class="mdi-ico">tab</i>탭고정하기</div>\n'
			 + '			<div class="option"><i class="mdi-ico">refresh</i>새로고침</div>\n'
			 + '			<div class="option"><i class="mdi-ico filled">delete_forever</i>삭제</div>\n'
			 + '			<div class="option"><i class="mdi-ico filled">tab_unselected</i>다른탭닫기</div>\n'
			 + '		</div>\n'
			 + '	</div>\n'
			 + '</a>\n';
	$('.tab_menu').removeClass('active');
	swiperTabs.appendSlide(html);
	tabIdx++;
	onTabAddEvent();
	setIFrame(obj);
}

function removeTab() {
	
}

function setIFrame(obj) {
	var form = $('<form></form>');
	var murl = $('<input type="hidden" name="murl" value="' + obj.surl + '" />');
	form.append(murl);
	$('body').append(form);
	submitCall(form, 'iframeBody', 'post', obj.url);
}

function updateSlideZIndex(s) {
	let slides = s.slides;
	for (let i = 0; i < slides.length; i++) {
		if (slides[i].classList.contains("active")) {
			slides[i].style.zIndex = 98;
		} else {
			slides[i].style.zIndex = slides.length - i;
		}
	}
}

function onTabAddEvent() {
  // tab_menu 우클릭 이벤트
  $(".main_tab_menu .tab_menu").off().on("contextmenu", function (e) {
    e.preventDefault();
    $(".main_tab_menu .select_options").css("visibility", "hidden");
    $(this).find(".select_options").css("visibility", "visible");
  });
  
  $(".main_tab_menu").sortable({
    items: ".tab_menu",
    helper: "clone",
    axis: "x",
    update: function (event, ui) {
    	swiperTabs.emit("init");
    },
  });
  
  //컨텐츠 탭 메뉴
  $(".tab_menu").on('mousedown', function (e) {
	  if (e.which == 3) return;
	  $('.tab_menu').removeClass('active');
	  $(this).addClass('active');
	  
	  const surl = $(this).attr('surl');
	  open()
  });
}

function onTabInitEvent() {
	$(document).on("click", function (e) {
		if (!$(e.target).closest(".tab_menu").length) {
			$(".main_tab_menu .select_options").css("visibility", "hidden");
		}
		
		window.parent.postMessage("iframeClicked", "*");
	});

	window.addEventListener(
		"message",
		function (event) {
			if (event.data === "iframeClicked") {
				$(".select_options").css("visibility", "hidden");
			}
		},
		false
	);
}

