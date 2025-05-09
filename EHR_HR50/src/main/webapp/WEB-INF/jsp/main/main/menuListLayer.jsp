<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<link rel="preload" href="/assets/fonts/font.css" as="style">
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,1,0" />
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
	var menuListLayer = { id: 'menuListLayer' };

	// 전체 즐겨찾기 버튼 토글
	$(".all-bookmarks").click(function(e){
		e.preventDefault();
		$(this).toggleClass('on');

		if ($(this).hasClass('on')) {
			$(this).html('<i class="mdi-ico d-flex align-items-center"></i>전체보기');
			for(let i=0; i<$(".toggle-btn.bookmark-btn").length; i++){
				if(!$($(".toggle-btn.bookmark-btn")[i]).hasClass('on'))
					$($(".toggle-btn.bookmark-btn")[i]).parent().parent().hide();
			}
			doAction("SearchBookMark");
		} else {
			$(this).html('<i class="mdi-ico d-flex align-items-center"></i>즐겨찾기');
			for(let i=0; i<$(".toggle-btn.bookmark-btn").length; i++){
				$($(".toggle-btn.bookmark-btn")[i]).parent().parent().show();
			}
			doAction("Search");
		}
	});

	$(function() {
		doAction("Search");
	});

	function doAction(sAction) {
		// 입력 폼 값 셋팅
		let data = ajaxCall( "${ctx}/SearchMenuAllLayer.do?cmd=getSearchMenuAllLayerList", "",false);
		const list = data.DATA;
		let tabCnt = 0, colCnt = 0, subCnt = 0, tableHtml = "", ulHtml = "";
		$("#menuTab").empty();
		$("#menuContent").empty();
		switch (sAction) {
			case "Search": //조회
				if ( data != null && data.DATA != null ) {
					for (let i = 0; i < list.length; i++) {
						let map = list[i];

						if(map.lev == "1"){
							tabCnt++;
							colCnt = 0;
							subCnt = 0;

							let active = '';
							if(tabCnt == 1) active = 'active';

							// 상단 탭 생성
							let menuTabHtml = '<li class="nav-item"><a href="#menu'+ tabCnt + '" class="nav-link '+active+'" data-toggle="tab">' +map.menuNm+ '</a></li>';
							$("#menuTab").append(menuTabHtml);

							if(tabCnt == 1) active = 'active show';
							let menuContentHtml = '<div class="tab-pane fade '+active+'" id="menu'+ tabCnt + '"><div class="menu-sect" id="menuSect'+ tabCnt + '"></div></div>';
							$("#menuContent").append(menuContentHtml);
						} else if(map.lev == "2") {
							colCnt++;
							let bookmarkYn = map.bookmarkYn == 'Y' ? 'on' : '';
							// 중메뉴 생성
							let menuColHtml = `<div class="col" data-menuCd="${'${map.mainMenuCd + "" + map.menuCd}'}">
									            <div class="d-flex justify-content-between align-items-center pr-2">
									              <p>${'${map.menuNm}'}</p>
									              	<button type="button" class="bookmark-btn no-style toggle-btn bookmark-all-btn ${'${bookmarkYn}'}"
															onclick="saveBookmarkAll(this)">
														<i class="mdi-ico filled"></i>
													</button>
									            </div>
									            <ul class="menu-sect-list" id="menu${'${tabCnt}'}Col${'${colCnt}'}"></ul>
									          </div>` ;

							$("#menuSect"+tabCnt).append(menuColHtml);
						} else {
							// 소메뉴 생성
							let bookmarkYn = map.bookmarkYn == 'Y' ? 'on' : '';
							if(map.type == "P") {
								let menuHtml = `<div class="list-outer">
													<li class="pointer" onclick="goSubPage('${'${map.mainMenuCd}'}', '', '', '', '${'${map.prgCd}'}')"
														data-mainMenuCd = "${'${map.mainMenuCd}'}" data-priorMenuCd="${'${map.priorMenuCd}'}" data-menuCd="${'${map.menuCd}'}" data-menuSeq = "${'${map.menuSeq}'}" data-prgCd="${'${map.prgCd}'}">
														${'${map.menuNm}'}
													</li>
													<button type="button" class="bookmark-btn no-style toggle-btn ${'${bookmarkYn}'}"
															onclick="saveBookmark('${'${map.mainMenuCd}'}', '${'${map.priorMenuCd}'}', '${'${map.menuCd}'}', '${'${map.menuSeq}'}', '${'${map.prgCd}'}')">
														<i class="mdi-ico filled"></i>
													</button>
												</div>
												`
								$("#menu"+tabCnt+"Col"+colCnt).append(menuHtml);
							}
						}
					}
				}
				break;
			case "SearchBookMark": //조회
				if(tabCnt == 1) active = 'active show';
				let menuContentHtml = '<div class="tab-pane fade active show" id="allBookMarks"><div class="menu-sect" id="menuSect"></div></div>';
				$("#menuContent").append(menuContentHtml);
				for (let i = 0; i < list.length; i++) {
					let map = list[i];

					if(map.lev == "1"){
						// tabCnt++;
						// colCnt = 0;
						// subCnt = 0;
						//
						// let active = '';
						// if(tabCnt == 1) active = 'active';
						//
						// // 상단 탭 생성
						// let menuTabHtml = '<li class="nav-item"><a href="#menu'+ tabCnt + '" class="nav-link '+active+'" data-toggle="tab">' +map.menuNm+ '</a></li>';
						// $("#menuTab").append(menuTabHtml);
						//
						// if(tabCnt == 1) active = 'active show';
						// let menuContentHtml = '<div class="tab-pane fade '+active+'" id="menu'+ tabCnt + '"><div class="menu-sect" id="menuSect'+ tabCnt + '"></div></div>';
						// $("#menuContent").append(menuContentHtml);
					} else if(map.lev == "2") {
						colCnt++;
						let bookmarkYn = map.bookmarkYn == 'Y' ? 'on' : '';
						// 중메뉴 생성
						let menuColHtml = `<div class="col" style="display:none">
											<div class="d-flex justify-content-between align-items-center pr-2">
											  <p>${'${map.menuNm}'}</p>
												<button type="button" class="bookmark-btn no-style toggle-btn bookmark-all-btn ${'${bookmarkYn}'}"
														onclick="saveBookmarkAll(this)">
													<i class="mdi-ico filled"></i>
												</button>
											</div>
											<ul class="menu-sect-list" id="menuCol${'${colCnt}'}"></ul>
										  </div>` ;

						$("#menuSect").append(menuColHtml);
					} else {
						// 소메뉴 생성
						let bookmarkYn = map.bookmarkYn === 'Y' ? 'on' : '';
						if(map.type === "P" && map.bookmarkYn === 'Y') {
							let menuHtml = `<div class="list-outer">
												<li class="pointer" onclick="goSubPage('${'${map.mainMenuCd}'}', '', '', '', '${'${map.prgCd}'}')"
													data-mainMenuCd = "${'${map.mainMenuCd}'}" data-priorMenuCd="${'${map.priorMenuCd}'}" data-menuCd="${'${map.menuCd}'}" data-menuSeq = "${'${map.menuSeq}'}" data-prgCd="${'${map.prgCd}'}">
													${'${map.menuNm}'}
												</li>
												<button type="button" class="bookmark-btn no-style toggle-btn ${'${bookmarkYn}'}"
														onclick="saveBookmark('${'${map.mainMenuCd}'}', '${'${map.priorMenuCd}'}', '${'${map.menuCd}'}', '${'${map.menuSeq}'}', '${'${map.prgCd}'}')">
													<i class="mdi-ico filled"></i>
												</button>
											<div>
												`
							$("#menuCol"+colCnt).append(menuHtml);
							$("#menuCol"+colCnt).closest('.col').show();
						}
					}
				}

				break;
		}

		$('.col').each(function() {
			let $col = $(this);
			if ($col.find('ul .bookmark-btn').length === $col.find('ul .bookmark-btn.on').length) {
				$col.find('.bookmark-all-btn').addClass('on');
			} else {
				$col.find('.bookmark-all-btn').removeClass('on');
			}
		});

		$(".toggle-btn.bookmark-btn").click(function(e){
			e.preventDefault();
			$(this).toggleClass('on');

			let $col = $(this).closest('.col');
			if ($col.find('ul .bookmark-btn').length === $col.find('ul .bookmark-btn.on').length) {
				$col.find('.bookmark-all-btn').addClass('on');
			} else {
				$col.find('.bookmark-all-btn').removeClass('on');
			}
		});
	}

	function showMenu(id) {
		$("#"+id).toggleClass("hide");
	}
</script>
<style>
	.modal {top:50%; left:50%; transform: translate(-50%, -50%); right:0; bottom:0; max-width:1170px; width:100% !important;}
	/* width:100% !important; 임시  */
</style>
</head>

<body class="bodywrap">
	<div class="wrapper">
		<div class="modal-body">
			<div class="search-wrap">
				<button type="button" class="all-bookmarks no-style toggle-btn"><i class="mdi-ico d-flex align-items-center"></i>즐겨찾기</button>
<%--				사용 안함--%>
<%--				<div class="search-box">--%>
<%--					<label>--%>
<%--						<input type="text" placeholder="인사정보, 업무 검색이 가능합니다.">--%>
<%--						<button type="submit" class="no-style"><i class="mdi-ico">search</i></button>--%>
<%--					</label>--%>
<%--				</div>--%>
			</div>
			<ul class="nav nav-tabs modal-tabs" id="menuTab"></ul>
			<div class="tab-content" id="menuContent"></div>
		</div>
		<!-- <div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('menuListLayer');" css="btn outline_gray" mid='110881' mdef="닫기" />
		</div> -->
	</div>
</body>
</html>
