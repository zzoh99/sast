<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	var cmTabObj;
	var cmTabData;
	var cmTabNewIframe;
	var cmTabOldIframe;
	var cmTabIframeIdx;

	$(function() {
		cmTabObj = $( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				cmTabIframeIdx = ui.newTab.index();
				cmTabNewIframe = $(ui.newPanel).find('iframe');
				cmTabOldIframe = $(ui.oldPanel).find('iframe');
				showCommonTab(cmTabIframeIdx);
			}
		});

		cmTabObj.find("a#conTabPrev").click(function(e) {
			var tabBar = $(this).parent().find("#tabBar");
			var scr = tabBar.scrollLeft();
			if(!$(tabBar).is(":animated")) {
				tabBar.animate({
					scrollLeft: (scr - 100)
				}, 200);
			}
		});

		cmTabObj.find("a#conTabNext").click(function(e) {
			var tabBar = $(this).parent().find("#tabBar");
			var scr = tabBar.scrollLeft();
			if(!$(tabBar).is(":animated")) {
				tabBar.animate({
					scrollLeft: (scr + 100)
				}, 200);
			}
		});

		$("#tabBar").on("mousewheel DOMMouseScroll", function(event) {
			var E = event.originalEvent;
			var delta = 0;
			if(E.detail) {
				delta = E.detail;
			} else {
				delta = E.wheelDelta;
			}

			if(delta < 0) {
				cmTabObj.find("a#conTabNext").click();
			} else {
				cmTabObj.find("a#conTabPrev").click();
			}
			event.preventDefault();
			event.stopPropagation();
			event.stopImmediatePropagation();
		});

		createCmTabData();

		// 화면 리사이즈
		$(window).resize(setIframeHeight);
		setIframeHeight();
	});

	//탭 높이 변경
	function setIframeHeight() {
		var par = cmTabObj.parent();

		var tabsHeight = par.height() - par.find(".popup_main > .header_table").outerHeight(true) - 50; // 가장 외부의 padding과 margin도 빼줌.
		cmTabObj.css("height", tabsHeight);

		var wrpHeight = par.height() - par.find(".popup_main > .header_table").height() - cmTabObj.find(".popup_main > #tabBar").height() - 60; // 마지막 60은 margin 및 padding
		cmTabObj.find(".layout_tabs").each(function() {
			$(this).css("height", wrpHeight);
			$(this).find("body").css("height", "97%");
		});

		setTabBarBtn();
	}

	// 탭 생성
	function createCmTabData() {
		//var param = "mainMenuCd=${param.mainMenuCd}"
		//				+ "&grpCd=${param.grpCd}"
		//				+ "&menuCd=${param.menuCd}";
		//var param = "surl=${param.surl}"

		//인사기본 탭을 팝업에서 보여주는 화면도 있어서  parent -> getTopWindow()로 바꿈.
		//cmTabData = ajaxCall("/CommonTabInfo.do?cmd=getCommonTabInfoList", parent.$("#subForm").serialize(),false);
		cmTabData = ajaxCall("/CommonTabInfo.do?cmd=getCommonTabInfoList", getTopWindow().$("#subForm").serialize(),false);

		addTabData(cmTabData);

		if(cmTabData.Message == "") {
			$(cmTabData.DATA).each(function(index) {
				//cmTabObj.find(".ui-tabs-nav").append("<li><a href='#tabs-"+index+"'>"+this.menuNm+"</a></li>");
				cmTabObj.find(".ui-tabs-nav").append("<li style='display:"+ viewTab(this.menuNm) +";'><a href='#tabs-"+index+"'>"+this.menuNm+"</a></li>");
			});

			$(cmTabData.DATA).each(function(index) {
				cmTabObj.append("<div id='tabs-"+index+"'><div class='layout_tabs'><iframe id='iframe-"+index+"' name='iframe-"+index+"' src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div></div>");
			});

			cmTabObj.tabs( "refresh" );
			cmTabObj.tabs( "option", "active", 0 );

			setTabBarBtn();

		} else {
			alert(cmTabData.Message);
		}
	}

	// iframe 호출.
	function showCommonTab(index) {
		headerReSetTimer();
		index = cmTabIframeIdx;
		if(typeof cmTabOldIframe != 'undefined') {
			cmTabOldIframe.attr("src","${ctx}/common/hidden.html");
		}
		var token = "";

		if(typeof index != 'undefined') {
			if(cmTabIframeIdx == index) {
				var obj = cmTabData.DATA[cmTabIframeIdx];
				$("#dataPrgType").val(obj.dataPrgType);
				$("#dataRwType").val(obj.dataRwType);
				$("#surl").val(obj.surl);

				//링크에 토큰 추가
				var map = ajaxCall("/SecurityToken.do","prgCd="+obj.prgCd,false);
				if( typeof map != 'undefined' ) token = encodeURIComponent(map.map.token);

				if( $("#token").length == 0 ){
					var o_hidden = $('<input type="hidden" value="'+token+'" name="token" id="token">');
					$(".popup_main > #cmTabForm").append(o_hidden);
				}else{
					$("#token").val(token);
				}


				$(".popup_main > #cmTabForm").attr("action",obj.prgCd)
								.attr("method","post")
								.attr("target",cmTabNewIframe.attr("id"))
								.submit();
			} else {
				cmTabObj.tabs( "option", "active", index );
			}
		} else {
			var obj = cmTabData.DATA[cmTabIframeIdx];
			$("#dataPrgType").val(obj.dataPrgType);
			$("#dataRwType").val(obj.dataRwType);
			$("#surl").val(obj.surl);

			//링크에 토큰 추가
			var map = ajaxCall("/SecurityToken.do","prgCd="+obj.prgCd,false);
			if( typeof map != 'undefined' ) token = encodeURIComponent(map.map.token);

			if( $("#token").length == 0 ){
				var o_hidden = $('<input type="hidden" value="'+token+'" name="token" id="token">');
				$("#cmTabForm").append(o_hidden);
			}else{
				$("#token").val(token);
			}
			$(".popup_main > #cmTabForm").attr("action",obj.prgCd)
							.attr("method","post")
							.attr("target",cmTabNewIframe.attr("id"))
							.submit();
		}
	}

	var getTopWindow = function () {
	    var win = window.top;

	    return win;

	    while (win.parent.opener) {

	    	if( $(win)[0].prgCd != undefined && $(win)[0].prgCd == "/GrpCdMgr.do?cmd=viewGrpCdMgr" ) {
    			return win;
    		}

	        win = win.parent.opener.top;
	    }
	    return win;
	};

	/* bar의 사이즈와 화면의 사이즈를 비교해서 탭 사이즈가 작을경우 옆으로 넘기는 버튼을 감춰주는 메소드. */
	function setTabBarBtn() {
		// 스크롤을 위해서 내부 ul width의 길이를 조정해야 한다. 조정하지 않으면 부모태그의 사이즈 때문에 탭이 두줄로 나뉜다.
		var liTotWidth = 0;
		cmTabObj.find(".popup_main > #tabGroup li").each(function(idx, obj) {
			liTotWidth += $(obj).width() + 3;		// 사이즈가 소수점 자리일 때 사이즈가 안맞는 경우가 생겨, 각 li마다 3정도를 더 해서 사이즈 측정해줌.
		});

		var tabBar = cmTabObj.find(".popup_main > #tabBar");
		if(tabBar.width() > liTotWidth) {
			cmTabObj.find(".popup_main > a#conTabPrev, .popup_main > a#conTabNext").hide();
			tabBar.removeClass("ma30");
		} else {
			cmTabObj.find(".popup_main > a#conTabPrev, .popup_main > a#conTabNext").show();
			if(!tabBar.hasClass("ma30"))
				tabBar.addClass("ma30");
		}
		cmTabObj.find(".popup_main > #tabGroup").css("width", liTotWidth);
	}

</script>
	<form id="cmTabForm" name="cmTabForm" action="" method="post">
		<input id="surl" name="surl" type="hidden" />
		<input id="dataPrgType" name="dataPrgType" type="hidden" />
		<input id="dataRwType" name="dataRwType" type="hidden" />
		<input id="authPg" name="authPg" type="hidden" value="${authPg}" />
	</form>

	<div id="tabs" class="mat30">
		<a id="conTabPrev" class="con_tab_prev"><tit:txt mid='113564' mdef='이전'/></a>
		<div id="tabBar" class="con_tab_bar ma30">
			<ul id="tabGroup"></ul>
		</div>
		<a id="conTabNext" class="con_tab_next"><tit:txt mid='112495' mdef='다음'/></a>
	</div>
